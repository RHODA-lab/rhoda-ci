*** Settings ***
Resource        ../keywords/deploy_instance_dev.resource
Resource        ../object_repo/import_yaml_obj.resource
Resource        ../object_repo/application_obj.resource
Library         String


*** Variables ***
${appname}      ${EMPTY}
${bindName}     ${EMPTY}

*** Keywords ***
User Imports Openshift ${databaseProvider} Application From YAML
    User Navigates To Import YAML Page
    Write Yaml To Textbox    ${databaseProvider}    ${elemImportTextArea}
    Element Should Be Visible    ${btnImportYamlCreate}
    Click Element    ${btnImportYamlCreate}
    Wait Until Page Contains Element    ${txtImportSuccess}     timeout=20s

User Navigates To Import YAML Page
    Element Should Be Visible    ${lnkImportYaml}
    Click Element    ${lnkImportYaml}
    Wait Until Keyword Succeeds    5x    2s    Wait Until Page Contains Element    ${hdrImportYamlPg}
    Element Should Be Visible    ${elemImportTextArea}

User Creates Service Binding Between ${databaseProvider} DBSC Instance And Imported Openshift Application
    Click Element    ${lnkTopology}
    ${appname}=     Get Import Application Name    ${databaseProvider}
    Set Test Variable    ${appname}
    ${bindName}=    Update Service Binding    ${newProject}    ${instanceUUID}    ${appname}
    Set Test Variable    ${bindName}
    Create Service Binding      ${newProject}
    Wait Until Keyword Succeeds    10x    1s     Wait Until Page Contains Element    ${elemSrvcBindArrow}
    Click Element   ${elemSrvcBindArrow}
    ${elemIconDeploymentUpd}=       Replace String    ${elemIconDeployment}    <<appname>>    ${appname}
    Instance Pan Displays   ${bindName}

User Selects Openshift Application For ${databaseProvider}
    Element Should Be Visible    ${lnkTopology}
    Click Element    ${lnkTopology}
    ${appname}=     Get Import Application Name    ${databaseProvider}
    Set Test Variable    ${appname}
    ${elemIconDeploymentUpd}=       Replace String    ${elemIconDeployment}    <<appname>>    ${appname}
    Wait Until Page Contains Element    ${elemIconDeploymentUpd}
    Click Element    ${elemIconDeploymentUpd}
    ${hdrDeploymentPanUpd}=       Replace String    ${hdrDeploymentPan}    <<appname>>    ${appname}
    Wait Until Page Contains Element    ${hdrDeploymentPanUpd}
    Wait Until Keyword Succeeds    5x    1s    Application Pod Loads With Running Status

Application Pod Loads With ${given} Status
    ${podstatus}=   Get Element Attribute    ${txtPodStatus}    innerText
    Should Match    ${given}    ${podstatus}

The Application Accesses The Connected ${database} Database Instance
    Application Pod In Running Status
    Load Data To ${database} Database From Application

Application Pod In Running Status
     Close Topology Pan
    ${txtApplicationUpd}=  Replace String    ${txtApplication}  <<appname>>    ${appname}
    Click Element    ${txtApplicationUpd}
    ${txtAppPodStatusUpd}=     Replace String    ${txtAppPodStatus}    <<appname>>    ${appname}
    Wait Until Keyword Succeeds    10x    1s    Wait Until Page Contains Element    ${txtAppPodStatusUpd}

Close Topology Pan
    ${status}=  Run Keyword And Return Status    Element Should Be Visible    ${btnClosePan}
    Run Keyword If    ${status}
    ...    Click Element    ${btnClosePan}

Load Data To ${database} Database From Application
    Run Keyword If    "Mongo" in """${database}"""
    ...    Run Keywords
    ...    Open Mongo Application
    ...    AND  Load Data To Mongo Application
    ...  ELSE
    ...    Run Keywords
    ...    Open Application
    ...    AND  Load Data To Application

Load Data To Mongo Application
    ${appStatus}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${hdrFruitApp}
    Run Keyword If    not ${appStatus}
    ...    Reload Page
    Wait Until Element Is Visible    ${hdrFruitApp}
    ${fruitname}=   Random String
    Input Text    ${txtBxFruitName}    ${fruitname}
    ${description}=     Random String
    Input Text    ${txtBxDescription}    ${description}
    Click Element    ${btnSave}
    ${txtFruitListUpd}=     Replace String    ${txtFruitList}    <<fruit>>    ${fruitname}
    ${txtFruitListUpd}=     Replace String    ${txtFruitListUpd}    <<desc>>    ${description}
    ${status}=  Run Keyword And Return Status    Wait Until Page Contains Element    ${txtFruitListUpd}  timeout=5s
    Run Keyword If  ${status}
    ...     Log   Connection Loads Data As Expected
    ...  ELSE
    ...    Log  Connection Failed! Check IP Configuration For the Mongo DB Instance on ISV   WARN

Open Mongo Application
    ${linkName}=    Catenate    SEPARATOR=-     ${appname}      ${newProject}
    ${appLink}=     Get Quarkus Application URL   ${OCP_CONSOLE_URL}      ${linkName}
    Execute Javascript      window.open("${appLink}")
    Switch Window   url:${appLink}

Open Application
    Element Should Be Visible    ${lnkAppRoute}
    ${appLink}=     Get Element Attribute    ${lnkAppRoute}    href
    Click Element    ${lnkAppRoute}
    Switch Window   url:${appLink}

Load Data To Application
    ${appStatus}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${hdrAddFruit}
    Run Keyword If    not ${appStatus}
    ...    Reload Page
    Wait Until Element Is Visible    ${hdrAddFruit}
    ${fruitname}=   Random String
    Input Text    ${txtBxFruitName}    ${fruitname}
    Click Element    ${btnSave}
    ${txtFruitUpd}=     Replace String    ${txtFruit}    <<fruit>>    ${fruitname}
    Wait Until Page Contains Element    ${txtFruitUpd}  timeout=5s
