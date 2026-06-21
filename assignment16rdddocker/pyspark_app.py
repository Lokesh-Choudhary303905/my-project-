from pyspark import SparkContext

sc = SparkContext("local[*]", "EmployeeRDD")

rdd = sc.textFile("dataset.csv")

header = rdd.first()

data = rdd.filter(lambda x: x != header)

employees = data.map(lambda x: x.split(","))

# Sort by salary descending
sorted_emp = employees.sortBy(lambda x: int(x[3]), ascending=False)

print("\nEmployees Sorted By Salary\n")

for emp in sorted_emp.collect():
    print(emp)

# Department wise salary total
dept_salary = (
    employees
    .map(lambda x: (x[2], int(x[3])))
    .reduceByKey(lambda a, b: a + b)
)

print("\nDepartment Wise Salary Total\n")

for dept in dept_salary.collect():
    print(dept)

# Top 3 highest paid employees
top3 = sorted_emp.take(3)

output = sc.parallelize([
    f"{emp[0]},{emp[1]},{emp[2]},{emp[3]}"
    for emp in top3
])

output.saveAsTextFile("output/top3_employees")

sc.stop()