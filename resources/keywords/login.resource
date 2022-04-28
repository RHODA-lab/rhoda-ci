*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Resource    ../objectrepo/login_obj.resource


*** Keywords ***
The Browser Is On Openshift Home Screen
    Open Browser    ${OCP_CONSOLE_URL}    browser=${BROWSER.NAME}    options=${BROWSER.OPTIONS}
    Select Login Authentication Type    ${OCP_ADMIN_USER.AUTH_TYPE}
    Login To Openshift

Select Login Authentication Type
    [Arguments]    ${auth_type}
    Wait Until Page Contains Element    ${titleLoginType}    timeout=15s
    Click Element    link:${auth_type}

Login To Openshift
    Element Should Be Visible    ${titleLoginPage}
    Element Should Be Visible    ${txtBxUserName}
    Element Should Be Visible    ${txtBxPassword}
    Element Should Be Visible    ${btnLogin}
    Input Text    ${txtBxUserName}    ${OCP_ADMIN_USER.USERNAME}
    Input Password    ${txtBxPassword}    ${OCP_ADMIN_USER.PASSWORD}
    Click Element    ${btnLogin}
    Page Should Not Contain Element    ${lblLoginError}    message=Login Failed
    Wait Until Keyword Succeeds    10x    2s    Page Should Contain Element    ${titleOverview}

Tear Down The Test Suite
    Log    Test Suite Test Down
