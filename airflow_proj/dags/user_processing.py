from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.http.sensors.http import HttpSensor
from airflow.providers.http.operators.http import SimpleHttpOperator
from airflow.operators.python_operator import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime
import json
from pandas import json_normalize

def _process_user(ti):
    user=ti.xcom_pull(task_ids='extract_users')
    user=user['results'][0]
    processed_user=json_normalize({
        'firstname':user['name']['first'],
        'lastname':user['name']['last'],
        'country':user['location']['country'],
        'username':user['login']['username'],
        'password':user['login']['password'],
        'email':user['email']
    })
    processed_user.to_csv('/tmp/processed_user.csv',index=None,header=False)

def _store_user():
    hook=PostgresHook(postgres_conn_id='postgres')
    hook.copy_expert(sql="COPY users from stdin WITH DELIMITER as ',' "
                     ,filename='/tmp/processed_user.csv')

with DAG('user_processing',start_date=datetime(2025, 1, 1),end_date=datetime(2025, 1, 2),
         schedule_interval='@daily',catchup=False,tags=['mydags']) as dag:
    
    create_table = PostgresOperator(
        task_id='create_table',
        postgres_conn_id='postgres',
        sql='''
        CREATE TABLE if not exists users (
            firstname TEXT NOT NULL,
            lastname TEXT NOT NULL,
            country TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            email TEXT NOT NULL
        );
        '''
    )
    # tasks
    is_api_available=HttpSensor(
        task_id='is_api_available',
        http_conn_id='user_api',
        endpoint='api/')
    
    extract_users=SimpleHttpOperator(
        task_id='extract_users',
        http_conn_id='user_api',
        endpoint='api/',
        method='GET',
        response_filter=lambda response: json.loads(response.text),
        log_response=True)
    
    process_users=PythonOperator(
        task_id='process_users',
        python_callable=_process_user
    )

    store_user=PythonOperator(
        task_id='store_user',
        python_callable=_store_user
    )

    create_table>>is_api_available>>extract_users >> process_users>>store_user