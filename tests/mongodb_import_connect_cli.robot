*** Settings ***
Documentation       To Verify Importing of MongoDB Provider Account and deployment of Database Instance Using OC CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/deploy_application.resource

Suite Setup         Run Keywords
...                 Set Library Search Order    OpenShiftLibrary
...                 AND    Skip If    ${DBaaSPolicyEnabled}
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI
Test Teardown       Tear Down The Test Case
Force Tags          CLI      mongo


*** Test Cases ***
Scenario: Verify Error Message For Invalid Credentials On MongoDB Using OC CLI
    [Tags]    smoke    RHOD-470
    When User Creates MongoDB Secret With Invalid Credentials
    And User Imports MongoDB Provider Account Using CLI
    Then Provider Account Import Failure Using CLI

Scenario: Import MongoDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-460
    When User Creates MongoDB Secret Credentials
    And User Imports MongoDB Provider Account Using CLI
    Then Provider Account Imported Successfully Using CLI

Scenario: Deploy MongoDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-480
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Deploys MongoDB Instance Using CLI
    Then DBSC Instance Deployed Successfully Using CLI
