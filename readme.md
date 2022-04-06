# About the project
The main purpose of this test automation project is to compare data stored in a database with expected results or to compare data between two databases.

The source code of this automated test project is written in Robot Framework using DatabaseLibrary and DiffLibrary.

Author: Lucie Lavickova, lucie.lavickova@tesena.com

# Disclaimer
The solution has been tested with Windows 10 OS and Microsoft SQL Database. Also, a test with MySQL worked well, you just need to use pymysql driver instead of pyodbc (replace it in requirements.txt file and in Config\config.robot). For other OS and Database engines, a few adjustments in the code might be needed. In case you decide to give it a try, I would be glad if you provide me with some feedback :)

# How to set up your Windows 10 machine to run the tests:

## 1. Install Python 3 and virtualenv
- https://www.python.org/downloads
- make sure to check the option to **add Python to PATH** during the installation
- in commandline terminal, verify python is installed correctly: `python --version` - the output should provide you with the installed version
- verify pip has been installed as well: `pip --version`
- finally, **install virtual environment** by executing `pip install --user virtualenv` in a commandline terminal

## 2. Install Robot Framework libraries
- in commandline terminal, navigate to your project root directory and create new virtual environment by executing `virtualenv venv`
- activate the newly created virtual environment: `.\venv\Scripts\activate`
- then execute `pip install -r requirements.txt` to install all required libraries for this project

## 2. Create User Environment variables
Set up your **User Environment variables** with names mentioned below (at least the ones you want to run your tests for) and fill them with your DB credentials:

DEV
* DEV_DB_USER
* DEV_DB_PASSWORD

QA
* QA_DB_USER
* QA_DB_PASSWORD

You can set these variables in Win10 commandline using setx command. Just replace "login" and "password" with your credentials:
```
setx DEV_DB_USER "login"
setx DEV_DB_PASSWORD "password"
setx QA_DB_USER "login"
setx QA_DB_PASSWORD "password"
```

## 3. Create SQL Queries and Expected Results
Create SQL queries you want to be executed in the Database and save them to **SQL_Queries** folder as **.sql files**. One query per file.

If you want to compare the query results to expected results, put these to **Environments/XX/Expected_Results** where XX is the environment. Use a filename equal to the SQL query filename, just with .csv extension. Use commas and quotes as separators: `("firstvalue","secondvalue","thirdvalue")`

## 4. Execute Tests
To compare expected and actual result for one database, use:

``robot -t "Verify data in database" -v ENV:DEV --removekeywords name:DatabaseLibrary.ConnectToDatabase -d Report .``

To compare data between two different databases (environments), use:

``robot -t "Compare data between two databases" -v ENV1:DEV -v ENV2:QA --removekeywords name:DatabaseLibrary.ConnectToDatabase -d Report .``

To run both tests with default arguments, use:
``robot --removekeywords name:DatabaseLibrary.ConnectToDatabase -d Report .``

Notes: 
- in the example project, the allowed options for ENV variables are DEV and QA. But you can modify it by adding more environments in Config/config.robot and Environments directory.
- the argument ``--removekeywords name:DatabaseLibrary.ConnectToDatabase`` hides your DB login credentials so that they do not appear in the test log file.

## 5. Interpret results
Check the **log.html** in **Report** folder

If you want to compare the CSV files visually, you can use various tools/apps, e.g.:
- PyCharm: select 2 CSV files, right-click > Compare Files
- Visual Studio Code: select 2 CSV files, right-click > Compare Selected
- Notepad++ you can use Compare plugin: https://www.makeuseof.com/tag/notepad-compare-two-files-plugin

