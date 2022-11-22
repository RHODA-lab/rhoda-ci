*** Settings ***
Resource    ../keywords/operators.resource
Resource    ../keywords/deploy_instance_dev.resource
Resource    ../object_repo/import_dbaasinventory_obj.resource
Resource    ../object_repo/database_access_obj.resource
Resource    ../object_repo/installed_operators_obj.resource
Resource    suite_and_test_teardown.resource
Library     ../../utils/scripts/util.py
Library     ../../utils/scripts/dbaas_utils.py


*** Variables ***
${provaccname}              ${EMPTY}
${INV_ORG_ID}               invalid_org_id
${INV_PUB_KEY}              invalid_pub_key
${INV_PRI_KEY}              invalid_private_key
${VALID_SECRET}             True
${INV_ACCS_KEY}             invalid_access_key_id
${INV_SEC_ACCS_KEY}         invalid_secret_access_key_id
${RESOURCE_TAGS_EMPTY}      ${EMPTY}
${ACK_LOG_LEVEL_EMPTY}      ${EMPTY}



*** Keywords ***
User Selects Invalid Namespace To Import Database Provider Account And Navigates To Database Access Page
    User Navigates To Installed Operators Under Operators
    User Filters dedicated-admin Namespace On Project Dropdown
    User Navigates To Database Access Page

User Navigates To Import Database Provider Account Screen From Database Access Page
    ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${tblDBProviderAcc}    timeout=10s
    Run Keyword If    not ${status}
    ...    Log    No Database Provider Account Imported on this Cluster
    Select Import Database Provider Account From Configuration Button DropDown
    Sleep    8s
    Comment    [known issue] Auto Page Refresh - Blind Sleep provided for mitigation
    ...        Will be replaced with intelligent wait if issue persists in near future
    ...        Will be removed once issue is fixed

Select ${option} From ${menu} Button DropDown
    ${btnMenuDropDownUpd}=    Replace String    ${btnMenuDropDown}    <<menu>>    ${menu}
    Wait Until Keyword Succeeds    10s    1s    Wait Until Element Is Visible    ${btnMenuDropDownUpd}
    Click Element    ${btnMenuDropDownUpd}
    ${btnMenuOptDropDownUpd}=    Replace String    ${btnMenuOptDropDown}    <<menuopt>>    ${option}
    Element Should Be Visible    ${btnMenuOptDropDownUpd}
    Click Element    ${btnMenuOptDropDownUpd}

Application Navigate To Create Provider Account Page And Error Message Displayed For Invalid Namespace
    Wait Until Page Contains Element    ${titleImportProviderAcc}    timeout=15s
    Wait Until Page Contains Element    ${txtInvalidNamespace}    timeout=15s
    Element Should Be Visible    ${btnImportDisabled}
    Element Should Be Visible    ${btnCancelEnabled}

User Filters Project ${PROJECT} On Project DropDown And Navigates To Database Access Page
    User Navigates To Installed Operators Under Operators
    User Filters ${PROJECT} Namespace On Project Dropdown
    User Navigates To Database Access Page

User Enters Provider Account Name And Selects Database Provider
    [Arguments]    ${invalid}=${False}
    Set Test Variable    ${invalid}
    ${dbprovider}=    Set Variable    ${isv}
    Wait Until Keyword Succeeds     5x     2s      Wait Until Page Contains Element    ${drpDwnDBProvider}
    ${paname}=    Get Provider Account Name    ${dbprovider}    ${invalid}
    Run Keyword If    ${invalid}
    ...    Set Test Variable    ${provaccname}    ${paname}
    ...  ELSE
    ...    Set Suite Variable    ${provaccname}    ${paname}
    Input Text    ${txtBxName}    ${provaccname}
    Select From List By Label    ${drpDwnDBProvider}    ${dbprovider}

User Enters An Existing Provider Account Name And Selects Database Provider
    ${dbprovider}=    Set Variable    ${isv}
    Wait Until Keyword Succeeds     5x     2s      Wait Until Page Contains Element    ${drpDwnDBProvider}
    Input Text    ${txtBxName}    ${provaccname}
    Select From List By Label    ${drpDwnDBProvider}    ${dbprovider}

User Enters Data To Import MongoDB Provider Account
    [Arguments]    ${isv}=MongoDB Atlas Cloud Database Service
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider
    Wait Until Page Contains Element    ${txtBxMongoDBOrgID}    timeout=10s
    Input Text    ${txtBxMongoDBOrgID}    ${MONGO.orgId}
    Input Text    ${txtBxMongoDBPubAPI}    ${MONGO.publicApiKey}
    Input Text    ${txtBxMongoDBPrivAPI}    ${MONGO.privateApiKey}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Invalid Data To Import MongoDB Database Provider Account
    [Arguments]    ${isv}=MongoDB Atlas Cloud Database Service
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider    True
    Wait Until Page Contains Element    ${txtBxMongoDBOrgID}    timeout=10s
    Input Text    ${txtBxMongoDBOrgID}    ${INV_ORG_ID}
    Input Text    ${txtBxMongoDBPubAPI}    ${INV_PUB_KEY}
    Input Text    ${txtBxMongoDBPrivAPI}    ${INV_PRI_KEY}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Data To Import CrunchyDB Provider Account
    [Arguments]    ${isv}=Crunchy Bridge managed PostgreSQL
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider
    Wait Until Page Contains Element    ${txtBxCrunchyPubAPI}    timeout=10s
    Input Text    ${txtBxCrunchyPubAPI}    ${CRUNCHY.publicApiKey}
    Input Text    ${txtBxCrunchyPrivAPI}    ${CRUNCHY.privateApiSecret}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Invalid Data To Import CrunchyDB Provider Account
    [Arguments]    ${isv}=Crunchy Bridge managed PostgreSQL
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider    True
    Wait Until Page Contains Element    ${txtBxCrunchyPubAPI}    timeout=10s
    Input Text    ${txtBxCrunchyPubAPI}    ${INV_PUB_KEY}
    Input Text    ${txtBxCrunchyPrivAPI}    ${INV_PRI_KEY}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Data To Import CockroachDB Provider Account
    [Arguments]    ${isv}=CockroachDB Cloud
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider
    Wait Until Page Contains Element    ${txtBxCockroachAPI}    timeout=10s
    Input Text    ${txtBxCockroachAPI}    ${COCKROACH.apiSecretKey}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Data To Import Duplicate CockroachDB Provider Account
    [Arguments]    ${isv}=CockroachDB Cloud
    Set Suite Variable    ${isv}
    User Enters An Existing Provider Account Name And Selects Database Provider
    Wait Until Page Contains Element    ${txtBxCockroachAPI}    timeout=10s
    Input Text    ${txtBxCockroachAPI}    ${COCKROACH.apiSecretKey}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Invalid Data To Import CockroachDB Provider Account
    [Arguments]    ${isv}=CockroachDB Cloud
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider    True
    Wait Until Page Contains Element    ${txtBxCockroachAPI}    timeout=10s
    Input Text    ${txtBxCockroachAPI}    ${INV_PRI_KEY}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Data To Import RDS Provider Account
    [Arguments]    ${isv}=Amazon Relational Database Service
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider
    Wait Until Page Contains Element    ${txtBxRdsAwsAccsKeyID}    timeout=10s
    Input Text    ${txtBxRdsAwsAccsKeyID}    ${RDS.AWS_ACCESS_KEY_ID}
    Input Text    ${txtBoxRdsAwsSecKeyID}    ${RDS.AWS_SECRET_ACCESS_KEY}
    Input Text    ${txtBoxRdsAwsRegion}    ${RDS.AWS_REGION}
    Input Text    ${txtBoxAckResrceTags}    ${RESOURCE_TAGS_EMPTY}
    Input Text    ${txtBoxAckLogLvl}    ${ACK_LOG_LEVEL_EMPTY}
    Click Element    ${importBtnChkbox}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

User Enters Invalid Data To Import RDS Provider Account
    [Arguments]    ${isv}=Amazon Relational Database Service
    Set Suite Variable    ${isv}
    User Enters Provider Account Name And Selects Database Provider    True
    Wait Until Page Contains Element    ${txtBxRdsAwsAccsKeyID}    timeout=10s
    Input Text    ${txtBxRdsAwsAccsKeyID}    ${INV_ACCS_KEY}
    Input Text    ${txtBoxRdsAwsSecKeyID}    ${INV_SEC_ACCS_KEY}
    Input Text    ${txtBoxRdsAwsRegion}    ${RDS.AWS_REGION}
    Click Element    ${importBtnChkbox}
    Element Should Be Visible    ${btnImportEnabled}
    Click Element    ${btnImportEnabled}

Provider Account Import Success
    ${no_dbinstance}=    Run Keyword And Return Status    Success Screen For A Provider Account With No DB Instances
    Run Keyword If    ${no_dbinstance}    Run Keywords
    ...    User Navigates To DBaaS Inventories Screen
    ...    AND    Imported Provider Account Avaialble On DBaaS Inventory Screen
    ...    ELSE
    ...    Import Success For Provider Account With Exisiting DB Instance

Import Success For Provider Account With Exisiting DB Instance
    Application Navigates To Provider Account Import Success Screen
    Imported Provider Account Avaialble On DBaaS Inventory Screen
    Imported Provider Account Available On Database Access Screen

Success Screen For A Provider Account With No DB Instances
    Provider Account Import Failure Screen
    Element Should Be Visible    ${txtProvNoDBInst}
    Element Should Be Visible    ${txtErrNoDBInst}
    Element Should Be Visible    ${btnClose}

Application Navigates To Provider Account Import Success Screen
    Wait Until Keyword Succeeds     5x     2s      Wait Until Page Contains Element    ${lblDBInstSuccess}
    Element Should Be Visible    ${btnViewProviderAcc}
    Click Element    ${btnViewProviderAcc}

Imported Provider Account Avaialble On DBaaS Inventory Screen
    Wait Until Keyword Succeeds     10x     2s      Wait Until Page Contains Element        ${titleDbaasInventories}
    Filter ${provaccname} On DBaaS Inventory
    ${elemDbaasInvStatusUpd}=    Replace String    ${elemDbaasInvStatus}    <<paname>>    ${provaccname}
    Wait Until Keyword Succeeds     10x     2s      Wait Until Page Contains Element    ${elemDbaasInvStatusUpd}
    Set Suite Variable    ${provaccname}

Imported Provider Account Available On Database Access Screen
    User Selects Administrator View
    User Navigates To Database Access Under Data Services
    Wait Until Page Contains Element    ${titleDatabaseAccess}
    ${elemProvAccUpd}=    Replace String    ${elemProvAcc}    <<paname>>    ${provaccname}
    ${updProvAcc}=    Replace String    ${elemDBProvider}    <<paname>>    ${provaccname}
    ${isvName}=    Fetch From Left    ${isv}    ${SPACE}
    ${elemDBProviderUpd}=    Replace String    ${updProvAcc}    <<isvname>>    ${isvName}
    Element Should Be Visible    ${elemProvAccUpd}
    Element Should Be Visible    ${elemDBProviderUpd}

Provider Account Import Failure
    Provider Account Import Failure Screen
    User Navigates To DBaaS Inventories Screen
    Check Status Of Invalid Provider Account

Provider Account Import Failure Screen
    Wait Until Keyword Succeeds    3x    1s    Element Should Be Visible    ${titleImportProviderAcc}
    Wait Until Keyword Succeeds    5x    1s    Element Should Be Visible    ${lblDBInstFailure}
    Page Should Contain Button    ${btnEditProvAcc}

Check Status Of Invalid Provider Account
    Wait Until Page Contains Element    ${titleDbaasInventories}    timeout=10s
    Filter ${provaccname} On DBaaS Inventory
    ${elemDbaasInvStatusUpd}=    Replace String    ${elemDbaasInvStatus}    <<paname>>    ${provaccname}
    Page Should Not Contain Element    ${elemDbaasInvStatusUpd}

User Imports Invalid ${databaseProvider} Provider Account
    Set Test Variable    ${DBProvider}    ${databaseProvider}
    User Filters Project ${operatorNamespace} On Project DropDown And Navigates To Database Access Page
    User Navigates To Import Database Provider Account Screen From Database Access Page
    Run Keyword If    "Mongo" in """${databaseProvider}"""
    ...    User Enters Invalid Data To Import MongoDB Database Provider Account
    ...  ELSE IF    "Crunchy" in """${databaseProvider}"""
    ...    User Enters Invalid Data To Import CrunchyDB Provider Account
    ...  ELSE IF    "Cockroach" in """${databaseProvider}"""
    ...    User Enters Invalid Data To Import CockroachDB Provider Account
    ...  ELSE IF    "RDS" in """${databaseProvider}"""
    ...    User Enters Invalid Data To Import RDS Provider Account
    Provider Account Import Failure

User Imports Valid ${databaseProvider} Provider Account
    Set Test Variable    ${DBProvider}    ${databaseProvider}
    Run Keyword If    "${provaccname}" == "${EMPTY}"
    ...    Import ${databaseProvider} Provider Account
    ...  ELSE
    ...    Log     Provider Account ${provaccname} Exists

Import ${databaseProvider} Provider Account
    User Filters Project ${operatorNamespace} On Project DropDown And Navigates To Database Access Page
    User Navigates To Import Database Provider Account Screen From Database Access Page
    Run Keyword If    "Mongo" in """${databaseProvider}"""
    ...    User Enters Data To Import MongoDB Provider Account
    ...  ELSE IF    "Crunchy" in """${databaseProvider}"""
    ...    User Enters Data To Import CrunchyDB Provider Account
    ...  ELSE IF    "Cockroach" in """${databaseProvider}"""
    ...    User Enters Data To Import CockroachDB Provider Account
    ...  ELSE IF    "RDS" in """${databaseProvider}"""
    ...    User Enters Data To Import RDS Provider Account
    Provider Account Import Success

User Creates ${isv} Secret Credentials
    Create Secret CLI    ${isv}    ${VALID_SECRET}
    ${cmd}    Set Variable    oc describe Secret/${SECRET_NAME}
    ${stdout} =    Execute Command    ${cmd}    True
    ${stdout_str} =    Convert To String    ${stdout}
    Should Contain    ${stdout_str}    ${SECRET_NAME}    ignore_case=True    strip_spaces=True
    Should Not Contain Any    ${stdout_str}    Error    NotFound

User Imports ${isv} Provider Account Using CLI
    Import Provider Account CLI    ${isv}

Provider Account Imported Successfully Using CLI
    Wait Until Keyword Succeeds    4x    5s    Describe Provider Account Using OC CLI

Describe Provider Account Using OC CLI
    [Arguments]     ${status}=True
    ${cmd}    Set Variable    oc describe DbaaSInventory/${provaccname}
    ${stdout} =    Execute Command    ${cmd}    True
    ${stdout_str} =    Convert To String    ${stdout}
    Should Contain X Times    ${stdout_str}    ${status} 	2    ignore_case=True    strip_spaces=True

User Creates ${isv} Secret With Invalid Credentials
    Set Test Variable   ${VALID_SECRET}     False
    User Creates ${isv} Secret Credentials

Provider Account Import Failure Using CLI
    Wait Until Keyword Succeeds    4x    5s    Describe Provider Account Using OC CLI    False

Duplicate Provider Account Name Error Message Appears
    Element Should Be Visible    ${lblDuplProvAccName}

User Navigates To Add ${databaseProvider} Topology Screen From Developer View
    User Selects Developer View
    User Filters ${operatorNamespace} Namespace On Project Dropdown
    User Navigates To Developers Catalog Add Screen
    User Clicks On Cloud Hosted Database Menu
    User Selects ${databaseProvider} Tile Under Cloud Hosted Database
    Click Element    ${btnDBProvAddTopology}

User Navigates To Import Provider Account Screen From Developer View
    Wait Until Page Contains Element    ${txtNoDBInstance}    timeout=15s
    Element Should Be Visible    ${txtNoDBInstance}     message=Imported Provider Account Available
    Element Should Be Visible    ${lnkImportProvAcc}
    Click Element    ${lnkImportProvAcc}

