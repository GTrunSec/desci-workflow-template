import time
from prefect import task, flow
from prefect.task_runners import SequentialTaskRunner

@task
def print_values(values):
    for value in values:
        time.sleep(0.5)
        print(value, end="\r")

@flow(task_runner=SequentialTaskRunner())
def my_flow():
    print_values.submit(["AAAA"] * 15)
    print_values.submit(["BBBB"] * 10)

if __name__ == "__main__":
    my_flow()
