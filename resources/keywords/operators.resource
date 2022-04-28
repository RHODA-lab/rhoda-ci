*** Settings ***
Resource    ../keywords/navigation.resource
Resource    ../objectrepo/operatorhub_obj.resource
Resource    ../objectrepo/installed_operators_obj.resource


*** Keywords ***
User Searches Openshift Database Access Operator On RHODA Installed Cluster
    The Browser Is On OperatorHub Page
    User Filters redhat-dbaas-operator Namespace On Project Dropdown
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
    Wait Until Page Contains Element    ${txtBxFilter}    timeout=15s
    Input Text    ${txtBxFilter}    ${operatorName}
    Wait Until Page Contains Element    ${elemDatabaseAccessTile}

The Operator Tile Loads With ${expected} Status
    ${actual}=    Get Element Attribute    ${elemDatabaseAccessStatus}    innerText
    Should Be Equal    ${expected}    ${actual.strip()}

Openshift Database Access Operator Filtered With Succeeded Status
    Wait Until Page Contains Element    ${elemDbaasStatus}    timeout=15s
