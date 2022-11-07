*** Settings ***
Resource    ../keywords/import_provider_account.resource
Resource    ../object_repo/developer_catalog_obj.resource
Resource    ../object_repo/provision_dbinstance_obj.resource

*** Variables ***
${newProject}        ${EMPTY}
${instanceName}      ${EMPTY}
${instanceID}        ${EMPTY}


*** Keywords ***
User Selects A Project For Database Connection
    Run Keyword If    '${newProject}'=='${EMPTY}'
    ...    Create New Project
    ...  ELSE    Run Keywords
    ...    Log    Project ${newProject} exists
    ...    AND    Set Project Namespace To ${newProject}

Create New Project
    Wait Until Page Contains Element    ${drpDwnProjectSelect}    timeout=15s
    Click Element    ${drpDwnProjectSelect}
    Wait Until Page Contains Element    ${btnCreateProject}
    Click Element    ${btnCreateProject}
    Wait Until Page Contains Element    ${hdrCreateProject}
    ${newProject}=     Get Project Name    ${TEST TAGS}
    Input Text    ${txtBxProjectName}    ${newProject}
    Click Element    ${btnConfirmCreate}
    ${lblProjectSelectUpd}=     Replace String    ${lblProjectSelect}    <<project>>    ${newProject}
    Wait Until Page Contains Element    ${lblProjectSelectUpd}
    Set Suite Variable    ${newProject}

Set Project Namespace To ${proj}
    Wait Until Page Contains Element    ${drpDwnProjectSelect}    timeout=15s
    Click Element    ${drpDwnProjectSelect}
    ${btnProjectSelectUpd}=    Replace String    ${btnProjectSelect}    <<project>>    ${proj}
    ${lblProjectSelectUpd}=    Replace String    ${lblProjectSelect}    <<project>>    ${proj}
    Wait Until Page Contains Element    ${btnProjectSelectUpd}    timeout=5s
    Click Element    ${btnProjectSelectUpd}
    Element Should Be Visible    ${lblProjectSelectUpd}

User Navigates To Add ${databaseProvider} To Topology Screen
    User Selects Developer View
    User Selects A Project For Database Connection
    User Navigates To Developers Catalog Add Screen
    User Clicks On Cloud Hosted Database Menu
    User Selects ${databaseProvider} Tile Under Cloud Hosted Database
    Click Element    ${btnDBProvAddTopology}

User Navigates To Developers Catalog Add Screen
    Wait Until Page Contains Element    ${lnkAdd}
    Click Element    ${lnkAdd}

User Clicks On Cloud Hosted Database Menu
    Wait Until Keyword Succeeds     2x      5s    Wait Until Page Contains Element    ${lnkCloudHostMenu}
    Click Element    ${lnkCloudHostMenu}
    Wait Until Page Contains Element    ${hdrCloudHostDBScreen}     timeout=15s

User Selects ${databaseProvider} Tile Under Cloud Hosted Database
    ${lnkDBProviderTileUpd}=    Replace String    ${lnkDBProviderTile}    <<dbprovider>>    ${databaseProvider}
    Wait Until Page Contains Element    ${lnkDBProviderTileUpd}    timeout=15s
    Click Element    ${lnkDBProviderTileUpd}
    ${hdrDBProviderModalUpd}=   Replace String    ${hdrDBProviderModal}    <<dbprovider>>    ${databaseProvider}
    Element Should Be Visible    ${hdrCloudHostDBScreen}

User Selects Database Instance For The Provider Account
    Wait Until Keyword Succeeds     2x      1s      Select Given Provider Account On Add Topology Screen
    ${instanceName}=    Select Database Instance    ${tblDevDBInstance}    ${btnDevDBInstanceConnect}    ${txtAlreadyExists}
    User Clicks Continue On Topoloy Binding Instructions
    Set Suite Variable    ${instanceName}

Select Given Provider Account On Add Topology Screen
    Wait Until Keyword Succeeds     5x     1s      Wait Until Page Contains Element    ${drpDwnDevProvAccount}
    Select From List By Label    ${drpDwnDevProvAccount}     ${provaccname}
    ${selected}=   Get Value    ${drpDwnDevProvAccount}
    Should Be Equal    ${selected}    ${provaccname}

User Filters And Selects The Created Database Instance
    Wait Until Keyword Succeeds    5x    2s    Instance Is Available In Selection Table
    Scroll Element Into View    ${btnAddToTplgy}
    Click Button    ${btnAddToTplgy}
    User Clicks Continue On Topoloy Binding Instructions

Instance Is Available In Selection Table
    ${instFound}=    Run Keyword And Return Status    Instance Can Be Selected
    Run Keyword If    not ${instFound}
    ...    Run Keywords
    ...    Reload Page    AND    Fail

Instance Can Be Selected
    Wait Until Keyword Succeeds     3x  1s   Select Given Provider Account On Add Topology Screen
    Element Should Be Visible    ${txtBxSearchByName}
    Input Text    ${txtBxSearchByName}    ${instanceName}
    ${elemInstanceRadioUpd}=    Replace String    ${elemInstanceRadio}    <<inst-name>>    ${instanceName}
    Element Should Be Visible    ${elemInstanceRadioUpd}
    Click Element    ${elemInstanceRadioUpd}

Set ${type} View On Topology View
    Wait Until Page Contains Element    ${btnDevTopViewSwitch}     timeout=10s
    ${currentView}=     Get Element Attribute    ${btnDevTopViewSwitch}    aria-label
    Run Keyword If    "${type}" in """${currentView}"""
    ...    Click Element    ${btnDevTopViewSwitch}
    ${btnTopologyViewUpd}=    Replace String    ${btnTopologyView}    <<type>>    ${type}
    Element Should Not Be Visible    ${btnTopologyViewUpd}

DBSC Instance Deployed On Developer Topology Graph View
    Wait Until Keyword Succeeds     10x     2s      Wait Until Page Contains Element    ${txtBxDisplayOptions}
    Set Graph View On Topology View
    ${instance}=    Get Substring    ${instanceName}    0   6
    ${elemDBInstTopologyUpd}=       Replace String    ${elemDBInstTopology}    <<instance>>    ${instance}
    Wait Until Page Contains Element    ${elemDBInstTopologyUpd}    timeout=10s
    Click Element    ${elemDBInstTopologyUpd}
    Instance Pan Displays
    Update Instance Name With Unique Identifier

DBSC Instance Deployed On Developer Topology List View
    Wait Until Keyword Succeeds     10x     2s      Wait Until Page Contains Element    ${txtBxDisplayOptions}
    Set List View On Topology View
    ${txtTopListInstanceUpd}=       Replace String    ${txtTopListInstance}    <<instance>>    ${instanceName}
    Wait Until Page Contains Element    ${txtTopListInstanceUpd}  timeout=10s
    Click Element    ${txtTopListInstanceUpd}
    Instance Pan Displays

Instance Pan Displays
    [Arguments]     ${panHeader}=${instanceName}
    ${elemTopInstancePanUpd}=     Replace String    ${elemTopInstancePan}    <<instance>>    ${panHeader}
    Wait Until Page Contains Element    ${elemTopInstancePanUpd}    timeout=10s

User Deploys ${databaseProvider} Database Instance On Developer Topology Screen
    Run Keyword If    "${instanceName}" == "${EMPTY}"
    ...    Deploy ${databaseProvider} Database Instance
    ...  ELSE    Run Keywords
    ...    Log  Database instance ${instanceName} exists
    ...    AND    User Selects Developer View
    ...    AND    User Selects A Project For Database Connection

Deploy ${databaseProvider} Database Instance
    User Imports Valid ${databaseProvider} Provider Account
    User Navigates To Add ${databaseProvider} To Topology Screen
    User Selects Database Instance For The Provider Account
    DBSC Instance Deployed On Developer Topology Graph View

User Clicks Continue On Topoloy Binding Instructions
    Wait Until Keyword Succeeds     5x     2s      Wait Until Page Contains Element    ${hdrTopBindInstr}
    Click Element    ${btnTopBindContinue}

Update Instance Name With Unique Identifier
    ${instanceUUID}=    Get Element Attribute    ${lnkPanInstance}    innerText
    Set Suite Variable    ${instanceUUID}

User Selects Provider Account With No Instances
    Wait Until Keyword Succeeds     5x     1s      Wait Until Page Contains Element    ${drpDwnDevProvAccount}
    Select From List By Label    ${drpDwnDevProvAccount}     ${provaccname}

Text Message For A provider Account With No DB Instances Appears
    Wait Until Keyword Succeeds     5x     2s      Wait Until Page Contains Element    ${txtNoDBInstExist}

User Deploys ${isv_name} Instance Using CLI
    Deploy Db Instance Cli    ${isv_name}    ${TEST TAGS}

DBSC Instance Deployed Successfully Using CLI
    Check DBSC Connection    ${newProject}      ${instanceID}
