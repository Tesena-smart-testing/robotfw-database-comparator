*** Settings ***
Documentation   Database connection parameters - DB host, DB name, username, password etc.
...             IMPORTANT: login credentials (username and password) should be stored in user environment variables, see README.md for more info

*** Variables ***
# DEV environment
${DEV_DB_HOST}         localhost\\SQLEXPRESS
${DEV_DB_NAME}         db14215456
${DEV_DB_USER}         %{DEV_DB_USER}
${DEV_DB_PASSWORD}     %{DEV_DB_PASSWORD}
${DEV_DB_API_MODULE}   pyodbc
${DEV_DB_PORT}         62693

# QA environment
${QA_DB_HOST}          localhost\\SQLEXPRESS
${QA_DB_NAME}          db65411587
${QA_DB_USER}          %{QA_DB_USER}
${QA_DB_PASSWORD}      %{QA_DB_PASSWORD}
${QA_DB_API_MODULE}    pyodbc
${QA_DB_PORT}          62693