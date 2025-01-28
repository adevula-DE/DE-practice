from airflow import DAG, Dataset
from airflow.decorators import task
from datetime import date,datetime

my_file=Dataset('/tmp/my_file.txt')

with DAG('producer',start_date=datetime(2022, 1, 1),
         schedule_interval='@daily',catchup=False) as dag:
    
    @task
    def update_dataset():
        with open('/tmp/my_file.txt','a+') as f:
            f.write('producer update')
    
    update_dataset()