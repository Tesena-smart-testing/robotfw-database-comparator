# About the project
The main purpose of this test automation project is to compare data stored in a database with expected results or to compare data between two databases.

The source code is written in Robot Framework using DatabaseLibrary and DiffLibrary.

Author: Lucie Lavickova, lucie.lavickova@tesena.com

# Disclaimer
The solution has been tested with Windows 10 OS and MySQL Database only.

# How to set up your Windows 10 machine to run the tests:

## 1. Install Python 3
- https://www.python.org/downloads
- make sure to check the option to **add Python to PATH** during the installation

## 2. Install Robot Framework libraries
- first, activate your virtual environment by executing `venv/Scripts/activate.bat` in the project root directory
- then execute `pip install -r requirements.txt` to install all required libraries

## 2. Create User Environment variables
Set up your **User Environment variables** with names mentioned below (at least the ones you want to run your tests for) and fill them with your DB credentials:

DEV
* DEV_DB_USER
* DEV_DB_PASSWORD

QA
* QA_DB_USER
* QA_DB_PASSWORD

You can set these variables in command line using setx command, see below. Just replace "login" and "password" with your credentials:
```
setx DEV_DB_USER "login"
setx DEV_DB_PASSWORD "password"
setx QA_DB_USER "login"
setx QA_DB_PASSWORD "password"
```

## 3. Add SQL Queries and/or Expected Results
Create an SQL query and save it to **SQL_Queries** folder as an **.sql file**.

If you want to compare the query results to expected results, put these to **Environments/XX/Expected_Results** where XX is the environment. Use a filename equal to the SQL query filename, just with .csv extension. Use commas and quotes as separators ("value","value").

## 4. Execute the tests
For comparing the expected and actual result for one DB, use:

``robot -t "Verify data in database" -v ENV:DEV --removekeywords name:ConnectToDatabase -d Report .``

For comparing data between two different environments, use:

``robot -t "Compare data between two databases" -v ENV1:DEV -v ENV2:QA --removekeywords name:ConnectToDatabase -d Report .``

Notes: 
- allowed options for ENV variables are DEV and QA.
- the argument ``--removekeywords name:ConnectToDatabase`` hides your login credentials so that they do not appear in the log file.
- using **pabot** to run the tests in this project in parallel is not recommended - it might cause a conflict when storing actual results. Also, as pabot is able to parallelize tests from different test files only, while here both tests are in one file, it would not parallelize them.

## 5. Interpret results
Check the **log.html** in **Report** folder

Use PyCharm to easily compare files (select 2 CSV files, right-click > Compare Files) - this will nicely highlight the differences in color ;)
