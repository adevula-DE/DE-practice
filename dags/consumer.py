from airflow import DAG,Dataset
from airflow.decorators import task
from datetime import date,datetime

my_file=Dataset('/tmp/my_file.txt')
my_file2=Dataset('/tmp/my_file2.txt')

with DAG('consumer',schedule=[my_file,my_file2],
         start_date=datetime(2025, 1, 1),
         catchup=False,tags=['mydags']) as dag:
    
    @task
    def read_dataset():
        with open(my_file.uri,'r') as f:
            print(f.read())
    
    @task
    def read_dataset2():
        with open(my_file2.uri,'r') as f:
            print(f.read())
    
    read_dataset()
    read_dataset2()