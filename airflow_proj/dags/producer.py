from airflow import DAG, Dataset
from airflow.decorators import task
from datetime import date,datetime

my_file=Dataset('/tmp/my_file.txt')
my_file2=Dataset('/tmp/my_file2.txt')

with DAG('producer',start_date=datetime(2025, 1, 1),
         schedule_interval='@daily',catchup=False , 
         tags=['mydags']) as dag:
    
    @task(outlets=[my_file])
    def update_dataset():
        with open(my_file.uri,'a+') as f:
            f.write('producer update')
    
    @task(outlets=[my_file2])
    def update_dataset2():
        with open(my_file2.uri,'a+') as f:
            f.write('producer update')

    update_dataset()
    update_dataset2()