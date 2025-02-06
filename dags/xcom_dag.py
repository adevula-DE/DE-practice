from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.operators.python import BranchPythonOperator
from datetime import datetime
 
def _t1(ti):
    ti.xcom_push(key='my_key', value = 99)
    #return 99
     
def _t2(ti):
    print(ti.xcom_pull(key='my_key', task_ids='t1'))

def _branching(ti):
    value = ti.xcom_pull(key='my_key', task_ids='t1')
    if value > 90:
        return 't2'
    return 't3'
 
with DAG("xcom_dag", start_date=datetime(2025, 1, 1), 
    schedule_interval='@daily', catchup=False , tags=['mydags']) as dag:
 
    t1 = PythonOperator(
        task_id='t1',
        python_callable=_t1
    )

    branch=BranchPythonOperator(
        task_id='branch',
        python_callable=_branching
    )
 
    t2 = PythonOperator(
        task_id='t2',
        python_callable=_t2
    )
 
    t3 = BashOperator(
        task_id='t3',
        bash_command="echo ''"
    )

    t4=BashOperator(
        task_id='t4',
        bash_command='sleep 5',
        trigger_rule='one_success'
    )

    t1 >> branch >> [t2, t3] >> t4
 