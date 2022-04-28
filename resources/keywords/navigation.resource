*** Settings ***
Library     String
Resource    ../keywords/login.resource
Resource    ../objectrepo/login_obj.resource


*** Keywords ***
User Navigates To ${subMenuOption} Under ${sideNavBarMenu}
    User Expands ${sideNavBarMenu}
    User Selects ${subMenuOption} On ${sideNavBarMenu}

User Expands ${sideNavBarMenu}
    ${elemNavMenuUpd}=    Replace String    ${elemNavMenu}    <<menu>>    ${sideNavBarMenu}
    Element Should Be Visible    ${elemNavMenuUpd}
    Click Element    ${elemNavMenuUpd}

User Selects ${subMenuOption} On ${sideNavBarMenu}
    ${elemNavChildMenuUpd}=    Replace String    ${elemNavChildMenu}    <<menu>>    ${sideNavBarMenu}
    ${elemNavChildMenuUpd}=    Replace String    ${elemNavChildMenuUpd}    <<submenu>>    ${subMenuOption}
    Element Should Be Visible    ${elemNavChildMenuUpd}
    Click Element    ${elemNavChildMenuUpd}
    ${lblChildPageHeader}=    Replace String    ${lblChildPageHeader}    <<submenu>>    ${subMenuOption}
    Wait Until Page Contains Element    ${lblChildPageHeader}    timeout=30s

The Browser Is On ${pageHeader} Page
    ${lblPageTitle}=    Replace String    ${lblPageTitle}    <<header>>    ${pageHeader}
    Element Should Be Visible    ${lblPageTitle}

User Navigates To Database Access Page
    Element Should Be Visible    ${elemDataServiceNav}
    Click Element    ${elemDataServiceNav}
    Element Should Be Visible    ${elemDataAccessNav}
    Click Element    ${elemDataAccessNav}
