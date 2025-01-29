from airflow import DAG,Dataset
from airflow.decorators import task
from datetime import date,datetime

my_file=Dataset('/tmp/my_file.txt')

with DAG('consumer',schedule=[my_file],
         start_date=datetime(2022, 1, 1),
         catchup=False,tags=['mydags']) as dag:
    
    @task
    def read_dataset():
        with open(my_file.uri,'r') as f:
            print(f.read())
    
    read_dataset()