*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     String
Library     OpenShiftLibrary
Library     ../../utils/scripts/dbaas_utils.py
Library     ../../utils/scripts/util.py
Library    OpenShiftCLI
Resource    ../object_repo/login_obj.resource
Resource    login.resource


*** Keywords ***
Tear Down The Test Suite
    Log    Test Suite Test Down
    Login To OpenShift CLI
    Remove Existing DBaaSNamespaces
    Remove Existing DBaaSProviderAccounts

Tear Down The Test
    Remove Existing DBaaSInstances
    Logout Of OpenShift CLI
    Close Browser

Remove Existing DBaaSInstances
    IF  '${instanceName}' != '${EMPTY}'
       ${cmd_instances}    Set Variable    oc delete -A DBaaSInstance/${instanceName} -n ${newProject} --wait=true
       ${stdout} =    Execute Command    ${cmd_instances}    True
    ELSE
       Log     No DB Instance ${instanceName} found
    END

Remove Existing DBaaSNamespaces
    IF  '${newProject}' != '${EMPTY}'
       ${cmd_namespaces}   Set Variable    oc delete -A Project/${newProject} --wait=true
       ${stdout} =    Execute Command    ${cmd_namespaces}    True
    ELSE
       Log     No DB Namespace ${newProject} found
    END

 Remove Existing DBaaSProviderAccounts
    IF  '${provaccname}' != '${EMPTY}'
       ${cmd_provider_account} =   Set Variable    oc delete -A DBaaSInventory/${provaccname} -n ${newProject} --wait=true
       ${stdout} =    Execute Command    ${cmd_provider_account}    True
    ELSE
       Log     No DB Provider Account ${provaccname} found
    END
