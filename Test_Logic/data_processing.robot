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
    [Documentation]    This keyword is to be used as the test setup
    [Arguments]        ${environment}
    # first, clean up the folder with actual results
    remove files         ${DATA_PATH}/${environment}/${ACTUAL_RESULTS_FOLDERNAME}/*.csv

    # get data from database
    connect to ${environment} database    
    @{sql_file_list}        list files in directory         ${SQL_FILEPATH}     pattern=*.sql
    should not be empty     ${sql_file_list}    msg=There is no SQL query to be executed. Please save the SQL query in .sql format to ${SQL_FILEPATH} directory first.
    FOR    ${sql_filename}   IN       @{sql_file_list}
       @{query_result} =    execute sql query       ${sql_filename}
       ${csv_filename} =    replace string          ${sql_filename}   .sql    .csv
       ${csv_filepath} =    set variable    ${DATA_PATH}/${environment}/${ACTUAL_RESULTS_FOLDERNAME}/${csv_filename}
       save data to CSV file    ${csv_filepath}     @{query_result}     
    END
    disconnect from database

Connect to ${environment} database
    connect to database     dbapiModuleName=${${environment}_DB_API_MODULE}  dbName=${${environment}_DB_NAME}
    ...                     dbUsername=${${environment}_DB_USER}  dbPassword=${${environment}_DB_PASSWORD}
    ...                     dbHost=${${environment}_DB_HOST}  dbPort=${${environment}_DB_PORT}

Execute SQL query
    [Documentation]     Connects to the given DB environment, executes given SQL file and saves the query result to a CSV file.
    [Arguments]         ${sql_filename}
    [Return]            @{query_result}
    # get query result from database
    ${sql_query}            get file        ${SQL_FILEPATH}/${sql_filename}
    @{query_result}         query           ${sql_query}

Save data to CSV file
    [Documentation]    Process the data from the SQL query result and save them into a CSV file
    [Arguments]    ${csv_filepath}    @{data}    
    ${csv_data}             set variable            ${EMPTY}
    ${line_nr}              set variable            1
    FOR  ${row}  IN     @{data}
       ${row_data}         process cells from row to csv format        ${row}
       ${csv_data}         set variable if         ${line_nr}>1        ${csv_data}\n${row_data}       ${row_data}  #add new line after each row
       ${line_nr}          set variable            ${line_nr}+1
    END
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
    @{expected_results_file_list}       list files in directory     ${DATA_PATH}/${environment}/${EXPECTED_RESULTS_FOLDERNAME}     pattern=*.csv
    should not be empty     ${expected_results_file_list}    msg=There is no Expected Result for ${environment} environment provided. Please save it in .csv format to ${DATA_PATH}/${environment}/${EXPECTED_RESULTS_FOLDERNAME} directory first. Use quotes and commas as separators of values.
    FOR     ${filename}   IN       @{expected_results_file_list}
            run keyword and continue on failure  diff files
            ...     ${DATA_PATH}/${environment}/${EXPECTED_RESULTS_FOLDERNAME}/${filename}
            ...     ${DATA_PATH}/${environment}/${ACTUAL_RESULTS_FOLDERNAME}/${filename}
    END

Compare results from ${environment1} and ${environment2} databases
    @{actual_results_file_list}       list files in directory     ${DATA_PATH}/${environment1}/${ACTUAL_RESULTS_FOLDERNAME}     pattern=*.csv
    FOR     ${filename}   IN       @{actual_results_file_list}
            run keyword and continue on failure  diff files
            ...     ${DATA_PATH}/${environment1}/${ACTUAL_RESULTS_FOLDERNAME}/${filename}
            ...     ${DATA_PATH}/${environment2}/${ACTUAL_RESULTS_FOLDERNAME}/${filename}
    END

