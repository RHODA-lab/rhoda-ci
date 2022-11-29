*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     String
Library     OpenShiftLibrary
Library     ../../utils/scripts/dbaas_utils.py
Library     ../../utils/scripts/util.py
Resource    ../object_repo/login_obj.resource
Resource    ../keywords/suite_and_test_setup_teardown.resource
Variables   ../../test-variables.yaml


*** Variables ***
${operatorNamespace}        ${DBAASPOLICY.NAMESPACE}
${DBaaSPolicyEnabled}       ${DBAASPOLICY.ENABLED}
${DBaaSPolicyConfigured}    ${False}
${rbacAligned}              ${False}
${DBaaSTestNS}              dbaas-test-ns

*** Keywords ***
The Browser Is On Openshift Home Screen
    Set Selenium Implicit Wait    5s
    Open Browser    ${OCP_CONSOLE_URL}    browser=${BROWSER.NAME}    options=${BROWSER.OPTIONS}
    Run Keyword If    ${DBaaSPolicyEnabled}
    ...    Select Login Authentication Type    ${OCP_LDAP_USER.AUTH_TYPE}
    ...  ELSE
    ...    Select Login Authentication Type    ${OCP_ADMIN_USER.AUTH_TYPE}
    Login To Openshift
    Login To OpenShift CLI

Login To OpenShift CLI
    Run Keyword If    ${DBaaSPolicyEnabled}
    ...    Login To OpenShift CLI As LDAP User
    ...  ELSE
    ...    Login To OpenShift CLI As Cluster Admin

Login To OpenShift CLI As Cluster Admin
    Oc Login    ${OCP_API_URL}    ${OCP_ADMIN_USER.USERNAME}     ${OCP_ADMIN_USER.PASSWORD}
    ${cmd_login}    Set Variable    oc login ${OCP_API_URL} -u ${OCP_ADMIN_USER.USERNAME} -p ${OCP_ADMIN_USER.PASSWORD}
    ${stdout} =    Execute Command    ${cmd_login}    True
    ${cmd}    Set Variable    oc project redhat-dbaas-operator
    ${stdout} =    Execute Command    ${cmd}    True

Login To OpenShift CLI As LDAP User
    [Arguments]     ${username}=${OCP_LDAP_USER.USERNAME}     ${password}=${OCP_LDAP_USER.PASSWORD}     ${ns}=${operatorNamespace}
    Oc Login    ${OCP_API_URL}    ${username}     ${password}
    ${cmd_login}    Set Variable    oc login ${OCP_API_URL} -u ${username} -p ${password}
    ${stdout} =    Execute Command    ${cmd_login}    True
    ${cmd}    Set Variable    oc project ${ns}
    ${stdout} =    Execute Command    ${cmd}    True

Select Login Authentication Type
    [Arguments]    ${auth_type}
    Wait Until Keyword Succeeds    6x    5s    Wait Until Page Contains Element    ${titleLoginType}
    Click Element    link:${auth_type}

Login To Openshift
    Wait Until Page Contains Element    ${titleLoginPage}    timeout=10s
    Element Should Be Visible    ${titleLoginPage}
    Element Should Be Visible    ${txtBxUserName}
    Element Should Be Visible    ${txtBxPassword}
    Element Should Be Visible    ${btnLogin}
    Run Keyword If    ${DBaaSPolicyEnabled}    Run Keywords
    ...    Input Text    ${txtBxUserName}    ${OCP_LDAP_USER.USERNAME}
    ...    AND    Input Password    ${txtBxPassword}    ${OCP_LDAP_USER.PASSWORD}
    ...  ELSE    Run Keywords
    ...    Input Text    ${txtBxUserName}    ${OCP_ADMIN_USER.USERNAME}
    ...    AND    Input Password    ${txtBxPassword}    ${OCP_ADMIN_USER.PASSWORD}
    Click Element    ${btnLogin}
    Page Should Not Contain Element    ${lblLoginError}    message=Login Failed
    Wait Until Keyword Succeeds    6x    5s    Wait Until Page Contains Element    ${btnPerspective}
    User Closes Welcome Message
    User Selects Administrator View

User Selects ${perspective} View
    ${elemCurPrspctvUpd} =    Replace String    ${elemCurrPerspective}    <<perspective>>    ${perspective}
    ${status} =    Run Keyword And Return Status    Element Should Be Visible    ${elemCurPrspctvUpd}
    IF    not ${status}
        Wait Until Page Contains Element    ${btnPerspective}   timeout=15s
        Click Element    ${btnPerspective}
        ${elemPrspctvOptUpd}=    Replace String    ${elemPerspectiveOpt}    <<option>>    ${perspective}
        Wait Until Keyword Succeeds    6x    2s    Wait Until Page Contains Element  ${elemPrspctvOptUpd}
        Click Element    ${elemPrspctvOptUpd}
        User Closes Welcome Message
    END
    Set Test Variable    ${perspective}

User Closes Welcome Message
    ${welcomeTile}=     Run Keyword And Return Status    Wait Until Page Contains Element    ${elemWelcomeTile}     timeout=15s
    Run Keyword If    ${welcomeTile}
    ...    Click Element    ${btnWelcomTileClose}

The User Logs In To Openshift As ${user}
    Set Selenium Implicit Wait    5s
    Open Browser    ${OCP_CONSOLE_URL}    browser=${BROWSER.NAME}    options=${BROWSER.OPTIONS}
    Select Login Authentication Type    ${${user}.AUTH_TYPE}
    Login To Openshift As ${user}
    Login To OpenShift CLI As LDAP User     ${${user}.USERNAME}     ${${user}.PASSWORD}     ${DBaaSTestNS}

Login To Openshift As ${user}
    Wait Until Page Contains Element    ${titleLoginPage}    timeout=10s
    Element Should Be Visible    ${titleLoginPage}
    Element Should Be Visible    ${txtBxUserName}
    Element Should Be Visible    ${txtBxPassword}
    Element Should Be Visible    ${btnLogin}
    Input Text    ${txtBxUserName}    ${${user}.USERNAME}
    Input Password    ${txtBxPassword}    ${${user}.PASSWORD}
    Click Element    ${btnLogin}
    Page Should Not Contain Element    ${lblLoginError}    message=Login Failed
    Wait Until Keyword Succeeds    6x    5s    Wait Until Page Contains Element    ${btnPerspective}
    User Closes Welcome Message
    User Selects Administrator View
