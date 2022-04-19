*** Settings ***
Resource    ../Keywords/Navigation.resource
Resource    ../OR/OperatorHub_OR.resource

*** Keywords ***
User Searches Openshift Database Access Operator on RHODA installed cluster
    The Browser is on OperatorHub page
    User Filters redhat-dbaas-operator On Project Dropdown
    User Filters Database Access Operator On Filter TextBox

User Filters ${projectName} On Project Dropdown
    Wait Until Page Contains Element    ${drpDwnProjectSelect}      timeout=15s
    Click Element    ${drpDwnProjectSelect}
    Element Should Be Visible    ${txtBxProjectSelect}
    Input Text    ${txtBxProjectSelect}   ${projectName}
    ${btnProjectSelect}=    Replace String    ${btnProjectSelect}   <<project>>     ${projectName}
    Element Should Be Visible    ${btnProjectSelect}
    Click Element    ${btnProjectSelect}
    ${lblProjectSelect}=    Replace String    ${lblProjectSelect}   <<project>>     ${projectName}
    Element Should Be Visible    ${lblProjectSelect}

User Filters ${operatorName} Operator On Filter TextBox
    Wait Until Page Contains Element    ${txtBxFilter}  timeout=15s
    Input Text    ${txtBxFilter}    ${operatorName}
    Wait Until Page Contains Element    ${eleDatabaseAccessTile}

The Operator tile loads with ${expected} status
    ${actual}=   Get Element Attribute    ${eleDatabaseAccessStatus}    innerText
    Should Be Equal    ${expected}    ${actual.strip()}
