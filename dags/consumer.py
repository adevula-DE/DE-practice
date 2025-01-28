from airflow import DAG, Dataset
from airflow.decorators import task
from datetime import date,datetime

my_file=dataset('/tmp/my_file.txt')