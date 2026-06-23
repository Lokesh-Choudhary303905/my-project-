from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder \
    .appName("SalesAnalysis") \
    .getOrCreate()

# Read CSV
df = spark.read.csv(
    "sales.csv",
    header=True,
    inferSchema=True
)

print("Original Data")
df.show()

# Sort by sales descending
print("Products Sorted By Sales")
sorted_df = df.orderBy(col("sales").desc())
sorted_df.show()

# Save sorted output
sorted_df.coalesce(1).write.mode("overwrite").option("header", True).csv("output/sorted")

# Top 3 products
print("Top 3 Products")
top3_df = sorted_df.limit(3)
top3_df.show()

# Save top3 output
top3_df.coalesce(1).write.mode("overwrite").option("header", True).csv("output/top3")

# Filter sales > 80000
print("Sales Greater Than 80000")
filtered_df = df.filter(col("sales") > 80000)
filtered_df.show()

# Save filtered output
filtered_df.coalesce(1).write.mode("overwrite").option("header", True).csv("output/filtered")

spark.stop()