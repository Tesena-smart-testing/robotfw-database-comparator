*** Settings ***
Library     DatabaseLibrary
Library     String
Library     Collections
Library     DiffLibrary
Library     OperatingSystem
Resource    ../Config/config.robot

*** Variables ***
#filepaths
${DATA_PATH}                        Environments
${SQL_FILEPATH}                     SQL_Queries
${EXPECTED_RESULTS_FOLDERNAME}      Expected_Results
${ACTUAL_RESULTS_FOLDERNAME}        Actual_Results

*** Keywords ***
Get data from database and store in CSV files
    [Documentation]    This keyword is to be used as the test setup to query database 
    ...     with provided SQL Queries and store their results in CSV files
    [Arguments]        ${environment}
    # clean up old actual results
    clean up actual results from previous test executions    ${environment}
    # connect to database
    connect to database     dbapiModuleName=${${environment}_DB_API_MODULE}  dbName=${${environment}_DB_NAME}
    ...                     dbUsername=${${environment}_DB_USER}  dbPassword=${${environment}_DB_PASSWORD}
    ...                     dbHost=${${environment}_DB_HOST}  dbPort=${${environment}_DB_PORT}
    # get list of SQL files with SQL queries
    @{sql_file_list}        list files in directory         ${SQL_FILEPATH}     pattern=*.sql
    should not be empty     ${sql_file_list}    
    ...     msg=There is no SQL query to be executed. Please save the SQL query in .sql format to ${SQL_FILEPATH} directory first.
    # query database and save results as CSV files
    FOR    ${sql_filename}   IN       @{sql_file_list}
       @{query_result} =    execute sql query       ${sql_filename}
       save data to CSV file    ${sql_filename}    ${environment}     @{query_result}     
    END
    # close the connection to the database
    disconnect from database

Clean up actual results from previous test executions
    [Arguments]     ${environment}
    remove files    ${DATA_PATH}/${environment}/${ACTUAL_RESULTS_FOLDERNAME}/*.csv
    
Execute SQL query
    [Arguments]         ${sql_filename}
    [Return]            @{query_result}
    # get query result from database
    ${sql_query}            get file        ${SQL_FILEPATH}/${sql_filename}
    @{query_result}         query           ${sql_query}

Save data to CSV file
    [Arguments]    ${sql_filename}    ${environment}        @{data}   
    # prepare the csv file path 
    ${csv_filename} =    replace string          ${sql_filename}   .sql    .csv
    ${csv_filepath} =    set variable    ${DATA_PATH}/${environment}/${ACTUAL_RESULTS_FOLDERNAME}/${csv_filename}
       
    # iterate through rows in data list and process them to the right format
    ${csv_data}             set variable            ${EMPTY}
    ${line_nr}              set variable            1
    FOR  ${row}  IN     @{data}
       ${row_data}         process cells from row to csv format        ${row}
       ${csv_data}         set variable if         ${line_nr}>1        ${csv_data}\n${row_data}       ${row_data}  #add new line after each row
       ${line_nr}          set variable            ${line_nr}+1
    END

    # save data in csv file
    create file            ${csv_filepath}      ${csv_data}
    
Process cells from row to csv format
    [Arguments]     ${row}
    @{row}              convert to list     ${row}  # the row comes as tuple from the SQL query result -> convert it to a list
    ${row_data}         set variable        ${EMPTY}
    ${cell_nr}          set variable        1
    FOR  ${cell_data}  IN  @{row}  #loop through cells in a row, wrap them in quotes and chain with comma
       ${row_data}     set variable if     ${cell_nr}>1    ${row_data},"${cell_data}"    "${cell_data}"
       ${cell_nr}      set variable        ${cell_nr}+1
    END
    [Return]        ${row_data}

Compare expected and actual results
    [Arguments]     ${environment}
    @{expected_results_file_list}       list files in directory     
    ...     ${DATA_PATH}/${environment}/${EXPECTED_RESULTS_FOLDERNAME}     pattern=*.csv
    
    should not be empty     ${expected_results_file_list}    
    ...     msg=There is no Expected Result for ${environment} environment provided. Please save it in .csv format to ${DATA_PATH}/${environment}/${EXPECTED_RESULTS_FOLDERNAME} directory first. Use quotes and commas as separators of values.
    
    FOR     ${filename}   IN       @{expected_results_file_list}
            run keyword and continue on failure  diff files
            ...     ${DATA_PATH}/${environment}/${EXPECTED_RESULTS_FOLDERNAME}/${filename}
            ...     ${DATA_PATH}/${environment}/${ACTUAL_RESULTS_FOLDERNAME}/${filename}
    END

Compare results from ${environment1} and ${environment2} databases
    @{actual_results_file_list}       list files in directory     
    ...     ${DATA_PATH}/${environment1}/${ACTUAL_RESULTS_FOLDERNAME}     pattern=*.csv
    FOR     ${filename}   IN       @{actual_results_file_list}
            run keyword and continue on failure  diff files
            ...     ${DATA_PATH}/${environment1}/${ACTUAL_RESULTS_FOLDERNAME}/${filename}
            ...     ${DATA_PATH}/${environment2}/${ACTUAL_RESULTS_FOLDERNAME}/${filename}
    END