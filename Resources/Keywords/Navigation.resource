*** Settings ***
Library    String
Resource    ../OR/Login_OR.resource
Resource    ../Keywords/Login.resource

*** Keywords ***
User Navigates to ${subMenuOption} under ${sideNavBarMenu}
    User Expands ${sideNavBarMenu}
    User Selects ${subMenuOption} on ${sideNavBarMenu}

User Expands ${sideNavBarMenu}
    Log To Console    ${sideNavBarMenu}
    ${eleNavMenu}=  Replace String  ${eleNavMenu}   <<menu>>    ${sideNavBarMenu}
    Element Should Be Visible    ${eleNavMenu}
    Click Element    ${eleNavMenu}

User Selects ${subMenuOption} on ${sideNavBarMenu}
    ${eleNavChildMenu}=     Replace String  ${eleNavChildMenu}  <<menu>>    ${sideNavBarMenu}
    ${eleNavChildMenu}=     Replace String  ${eleNavChildMenu}  <<submenu>>    ${subMenuOption}
    Element Should Be Visible    ${eleNavChildMenu}
    Click Element    ${eleNavChildMenu}
    ${lblChildPageHeader}=     Replace String    ${lblChildPageHeader}  <<submenu>>    ${subMenuOption}
    Wait Until Page Contains Element    ${lblChildPageHeader}    timeout=30s

The Browser is on ${pageHeader} page
    ${lblPageTitle}=     Replace String  ${lblPageTitle}  <<header>>    ${pageHeader}
    Element Should Be Visible    ${lblPageTitle}
