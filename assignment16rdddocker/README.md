# Employee Salary Analysis Using PySpark RDD

## Features
- Read employee CSV using RDD
- Sort employees by salary
- Calculate department-wise salary totals
- Save top 3 highest-paid employees

## Build Docker Image

docker build -t employee-rdd .

## Run Container

docker run --name employee-app employee-rdd