#Just a sample ( Only for Documentation )
#ETL Test Cases with script
#Create a python script to run the automated test

Inport pandas as pd
Source = pd.read_csv(“Employee.csv”,sep=“,")
Print(“Test Case 1: Following are the column names in the source file : \n”)
print(source.columns)
print(“\n”)

Print(“Test Case 2: Rows * columns in the source file \n”)
print(source.shape)
print(“\n”)

Print(“Test Case 3: Number of rows in each column \n”)
print(source.count())
print(“\n”)

Print(“Test Case 4: Duplicate records in the source \n”)
print(source.duplicated().sum())
print(“\n”)

Print(“Test Case 5: Duplicate records saved in the file below \n”)
Dupes = source[source.duplicated()].to_csv(“Duplicated.csv”)
print(“\n”)

Print(“Test Case 6: Check if NULL values exists in dept_name column \n”)
print(source[source[source[‘dept_name’].isnull()])
print(“\n”)

Print(“Test Case 7: Unique value of emp_no column in the source \n”)
print(source[‘emp_no’].unique())
print(“\n”)

Print(“Test Case 8: Unique value of emp_name column in the source \n”)
print(source[‘emp_name’].unique())
print(“\n”)

Print(“Test Case 9: Unique value of dept_name column in the source \n”)
print(source[‘dept_name’].unique())
print(“\n”)

Print(“Test Case 10: Unique value of salary column in the source \n”)
print(source[‘salary’].unique())
print(“\n”)

Print(“Test Case 11: Sample ( top 5 ) records from source file \n”)
print(source.head())

print(“\TEST COMPLETED......\n”)

Print(“Test Case 12: Sample ( bottom 5 ) records from source file \n”)

print(source.tail())

print(“\TEST COMPLETED......\n”)