*** Settings ***
Documentation       To Verify MongoDB Provider Account Import and Instance Deployment Using CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/provision_dbinstance.resource

Suite Setup         Run Keywords
...                 Set Library Search Order    OpenShiftLibrary
...                 AND    Skip If    ${DBaaSPolicyEnabled}
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI
Test Teardown       Tear Down The Test Case
Force Tags          CLI      mongo


*** Test Cases ***
Scenario: Provision MongoDB Database Instance On Default Namespace Using OC CLI
    [Tags]    smoke    RHOD-61-adm
    When User Provisions New MongoDB Instance On Default Namespace Using OC CLI
    Then DB Instance Provisioned Successfully On Default Namespace Using OC CLI

Scenario: Provision MongoDB Database Instance On User Defined Namespace Using OC CLI
    [Tags]    smoke    RHOD-61-dev
    When User Provisions New MongoDB Instance On User Defined Namespace Using OC CLI
    Then DB Instance Provisioned Successfully On User Defined Namespace Using OC CLI
