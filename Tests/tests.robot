*** Settings ***
Resource    ../Test_Logic/data_processing.robot

*** Variables ***
# To get the allowed options for environment variables, please check the Environments directory
${ENV}      DEV
${ENV1}     DEV
${ENV2}     QA

# IMPORTANT: before running these tests, please follow readme.md

*** Test Cases ***
Verify data in database
    [Tags]
    [Setup]     Get data from ${ENV} database
    Compare expected and actual results     ${ENV}

Compare data between two databases
    [Tags]
    [Setup]     Run keywords    Get data from ${ENV1} database
    ...                         Get data from ${ENV2} database
    Compare results from ${ENV1} and ${ENV2} databases