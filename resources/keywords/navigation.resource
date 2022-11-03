*** Settings ***
Library     String
Resource    ../keywords/login.resource
Resource    ../object_repo/login_obj.resource
Resource    ../object_repo/installed_operators_obj.resource


*** Keywords ***
User Navigates To ${subMenuOption} Under ${sideNavBarMenu}
    User Expands ${sideNavBarMenu}
    User Selects ${subMenuOption} On ${sideNavBarMenu}

User Expands ${sideNavBarMenu}
    ${btnNavMenuUpd}=    Replace String    ${btnNavMenu}    <<menu>>    ${sideNavBarMenu}
    Element Should Be Visible    ${btnNavMenuUpd}
    ${expanded}=    Get Element Attribute    ${btnNavMenuUpd}    aria-expanded
    Run Keyword If    '${expanded}'=='false'
    ...    Click Element    ${btnNavMenuUpd}

User Selects ${subMenuOption} On ${sideNavBarMenu}
    ${elemNavChildMenuUpd}=    Replace String    ${elemNavChildMenu}    <<menu>>    ${sideNavBarMenu}
    ${elemNavChildMenuUpd}=    Replace String    ${elemNavChildMenuUpd}    <<submenu>>    ${subMenuOption}
    Scroll Element Into View    ${elemNavChildMenuUpd}
    Wait Until Element Is Visible    ${elemNavChildMenuUpd}    timeout=3s
    Click Element    ${elemNavChildMenuUpd}
    ${lblChildPageHeader}=    Replace String    ${lblChildPageHeader}    <<submenu>>    ${subMenuOption}
    Wait Until Page Contains Element    ${lblChildPageHeader}    timeout=30s

The Browser Is On ${pageHeader} Page
    ${lblPageTitle}=    Replace String    ${lblPageTitle}    <<header>>    ${pageHeader}
    Element Should Be Visible    ${lblPageTitle}

User Navigates To Database Access Page
    ${status} =    Run Keyword And Return Status    Element Should Be Visible    ${elemDataAccessNav}
    IF    not ${status}
        Element Should Be Visible    ${elemDataServiceNav}
        Click Element    ${elemDataServiceNav}
        Element Should Be Visible    ${elemDataAccessNav}
    END
    Click Element    ${elemDataAccessNav}

User Navigates To DBaaS Inventories Screen
    [Arguments]    ${PROJECT}=${operatorNamespace}
    User Selects Administrator View
    User Navigates To Installed Operators Under Operators
    User Filters ${PROJECT} Namespace On Project Dropdown
    Wait Until Page Contains Element    ${elemDbaasStatus}    timeout=15s
    Page Should Contain Element    ${lnkProvAcc}
    Click Element    ${lnkProvAcc}
    Wait Until Page Contains Element    ${titleDbaasInventories}    timeout=10s

User Navigates To DBaaSPolicy Screen
    [Arguments]    ${project}=${operatorNamespace}
    User Selects Administrator View
    User Navigates To Installed Operators Under Operators
    User Filters ${project} Namespace On Project Dropdown
    Wait Until Page Contains Element    ${elemDbaasStatus}    timeout=15s
    Wait Until Keyword Succeeds    5x    3s    Run Keywords
    ...    User Navigates To Database Access Under Data Services
    ...    AND    User Navigates To Installed Operators Under Operators
    ...    AND    Element Should Be Visible    ${lnkDBaaSPolicy}    timeout=10s
    Click Element    ${lnkDBaaSPolicy}
    Wait Until Page Contains Element    ${titleDbaasPolicies}    timeout=10s

User Filters ${projectName} Namespace On Projects Screen
    Wait Until Page Contains Element    ${txtProjects}    timeout=10s
    Element Should Be Visible    ${txtBxSearchByName}
    Input Text    ${txtBxSearchByName}    ${projectName}
    ${lnkProjectNameUpd} =    Replace String    ${lnkProjectName}    <<project>>    ${projectName}
    Wait Until Page Contains Element    ${lnkProjectNameUpd}    timeout=5s
