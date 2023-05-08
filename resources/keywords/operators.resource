*** Settings ***
Resource    ../keywords/navigation.resource
Resource    ../object_repo/operatorhub_obj.resource
Resource    ../object_repo/installed_operators_obj.resource


*** Keywords ***
User Searches Openshift Database Access Operator On RHODA Installed Cluster
    The Browser Is On OperatorHub Page
    User Filters openshift-dbaas-operator Namespace On Project Dropdown
    User Filters Database Access Operator On Filter TextBox

User Filters ${projectName} Namespace On Project Dropdown
    Wait Until Page Contains Element    ${drpDwnProjectSelect}    timeout=15s
    Click Element    ${drpDwnProjectSelect}
    Element Should Be Visible    ${txtBxProjectSelect}
    Input Text    ${txtBxProjectSelect}    ${projectName}
    ${btnProjectSelect}=    Replace String    ${btnProjectSelect}    <<project>>    ${projectName}
    Wait Until Page Contains Element    ${btnProjectSelect}    timeout=15s
    Click Element    ${btnProjectSelect}
    ${lblProjectSelect}=    Replace String    ${lblProjectSelect}    <<project>>    ${projectName}
    Wait Until Page Contains Element    ${lblProjectSelect}    timeout=15s

User Filters ${operatorName} Operator On Filter TextBox
    Wait Until Keyword Succeeds     5x     2s      Wait Until Page Contains Element    ${txtBxFilter}    timeout=15s
    Input Text    ${txtBxFilter}    ${operatorName}
    Wait Until Page Contains Element    ${elemDatabaseAccessTile}

The Operator Tile Loads With ${expected} Status
    ${actual}=    Get Element Attribute    ${elemDatabaseAccessStatus}    innerText
    Should Be Equal    ${expected}    ${actual.strip()}

Openshift Database Access Operator Filtered With Succeeded Status
    Wait Until Page Contains Element    ${elemDbaasStatus}    timeout=15s

Filter ${provaccname} On DBaaS Inventory
    Run Keyword If    """.11""" in """${CLUSTER_VERSION}"""
    ...    Click Element    ${lblOperand}
    Comment    The above step Click Element ${lblOperand} should be enabled
    ...        only for Openshift Version >= 4.11
    ...        IF statement can be removed once support for 4.10 is dropped
    Wait Until Page Contains Element    ${btnInventoryFilterType}   timeout=10s
    Wait Until Page Contains Element    ${txtBxSearchByName}   timeout=10s
    Input Text    ${txtBxSearchByName}    ${provaccname}
