*** Settings ***
Resource    ../keywords/navigation.resource
Resource    ../object_repo/create_dbaaspolicy_obj.resource


*** Keywords ***
Align RBAC For ${user}
    IF    not ${rbacAligned} and """service""" in """${user}""" or """service""" in """${DBAASPOLICY.PERSONA}"""
        Login To OpenShift CLI As Cluster Admin
        ${cmd} =    Set Variable    oc adm policy add-role-to-user edit ${user} -n ${operatorNamespace}
        ${stdout} =    Execute Command    ${cmd}    True
        ${cmd} =    Set Variable    oc adm policy remove-role-from-user admin ${user} -n ${operatorNamespace}
        ${stdout} =    Execute Command    ${cmd}    True
        Login To OpenShift CLI As LDAP User
        Set Global Variable    ${rbacAligned}    ${True}
    END

Setup RHODA Persona Namespace
    User Navigates To Projects Under Home
    ${status} =    Run Keyword And Return Status    User Filters ${operatorNamespace} Namespace On Projects Screen
    Run Keyword If    not ${status}
    ...    Create Custom Namespace    ${operatorNamespace}
    ${cmd}    Set Variable    oc project ${operatorNamespace}
    ${stdout} =    Execute Command    ${cmd}    True

Create Custom Namespace
    [Arguments]    ${custom_ns}
    User Navigates To Installed Operators Under Operators
    Wait Until Page Contains Element    ${drpDwnProjectSelect}    timeout=15s
    Click Element    ${drpDwnProjectSelect}
    Wait Until Page Contains Element    ${btnCreateProject}
    Click Element    ${btnCreateProject}
    Wait Until Page Contains Element    ${hdrCreateProject}
    Input Text    ${txtBxProjectName}    ${custom_ns}
    Click Element    ${btnConfirmCreate}
    ${lblProjectSelectUpd}=     Replace String    ${lblProjectSelect}    <<project>>    ${custom_ns}
    Wait Until Page Contains Element    ${lblProjectSelectUpd}

Setup DBaaSPolicy for ${namespace}
    User Navigates To DBaaSPolicy Screen
    Run Keyword If    """.11""" in """${CLUSTER_VERSION}"""
    ...    Click Element    ${lblOperand}
    Comment    The above step Click Element ${lblOperand} should be enabled
    ...        only for Openshift Version >= 4.11
    ...        IF statement can be removed once support for 4.10 is dropped
    ${status} =    Run Keyword And Return Status    Wait Until Page Contains Element    ${txtNoDbaaSPolicy}    timeout=7s
    Run Keyword If    ${status}
    ...    Create Custom DBaaSPolicy
    Set Global Variable    ${DBaaSPolicyChecked}    ${True}

Create Custom DBaaSPolicy
    [Arguments]    ${persona}=${DBAASPOLICY.PERSONA}
    Wait Until Page Contains Element    ${btnCreateDBaaSPolicy}
    Click Element    ${btnCreateDBaaSPolicy}
    Wait Until Element Is Visible    ${titleCreateDBaaSPolicy}    timeout=10s
    Element Should Be Visible    ${txtBxDBaaSPolicyName}
    ${policyName} =    Set Variable   ${persona}-policy
    Input Text    ${txtBxDBaaSPolicyName}    ${policyName}
    Click Element    ${btnToggleConnNS}
    Element Should Be Visible    ${btnAddConnNS}
    Click Element    ${btnAddConnNS}
    Element Should Be Visible    ${txtBxConnNS}
    Input Text    ${txtBxConnNS}    *
    Scroll Element Into View    ${btnCreateEnabled}
    Click Element    ${btnCreateEnabled}
    ${lnkDBaaSPolicyUpd} =    Replace String    ${lnkDBaaSPolicyName}    <<policyname>>   ${policyName}
    Wait Until Page Contains Element    ${lnkDBaaSPolicyUpd}    timeout=10s
