*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Resource    ../OR/Login_OR.resource

*** Keywords ***
The Browser is on Openshift Home screen
    Open Browser  ${OCP_CONSOLE_URL}  browser=${BROWSER.NAME}  options=${BROWSER.OPTIONS}
    Select Login Authentication Type    ${OCP_ADMIN_USER.AUTH_TYPE}
    Login To Openshift

Select Login Authentication Type
   [Arguments]  ${auth_type}
   Wait Until Page Contains  Log in with  timeout=30s
   Click Element  link:${auth_type}

Login To Openshift
    Element Should Be Visible    ${titleLoginPage}
    Element Should Be Visible    ${txtBxUserName}
    Element Should Be Visible    ${txtBxPassword}
    Element Should Be Visible    ${btnLogin}
    Input Text    ${txtBxUserName}     ${OCP_ADMIN_USER.USERNAME}
    Input Password    ${txtBxPassword}     ${OCP_ADMIN_USER.PASSWORD}
    Click Element    ${btnLogin}
    Wait Until Page Contains Element    ${titleOverview}    timeout=30s
