*** Settings ***
Documentation       Provision and Deploy CrunchyDB Database Instance from Developer View
Metadata            Version    0.0.1

Resource            ../resources/keywords/provision_dbinstance.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI
Test Teardown       Logout Of OpenShift CLI


*** Test Cases ***
Scenario: Provision CrunchyDB Database Instance On Default Namespace Using OC CLI
    [Tags]    smoke    RHOD-261-adm
    When User Provisions New CrunchyDB Instance On Default Namespace Using OC CLI
    Then DB Instance Provisioned Successfully On Default Namespace Using OC CLI
