*** Settings ***
Documentation   Database connection parameters - DB host, DB name, username, password etc.
...             IMPORTANT: login credentials (username and password) should be stored in user environment variables, see readme.md for more info

*** Variables ***
# DEV environment
${DEV_DB_HOST}         sql11.freemysqlhosting.net
${DEV_DB_NAME}         sql11467339
${DEV_DB_USER}         %{DEV_DB_USER}
${DEV_DB_PASSWORD}     %{DEV_DB_PASSWORD}
${DEV_DB_API_MODULE}   pymysql
${DEV_DB_PORT}         3306

# QA environment
${QA_DB_HOST}          sql11.freemysqlhosting.net
${QA_DB_NAME}          sql11467570
${QA_DB_USER}          %{QA_DB_USER}
${QA_DB_PASSWORD}      %{QA_DB_PASSWORD}
${QA_DB_API_MODULE}    pymysql
${QA_DB_PORT}          3306