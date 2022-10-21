*** Settings ***
Documentation       To Verify Provisioning of RDS Provider Account and deployment of Database Instance Using OC CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/deploy_application.resource

Suite Setup         Run Keywords
...                 Set Library Search Order    OpenShiftLibrary
...                 AND    Skip If    ${DBaaSPolicyEnabled}
Test Setup          Given Login To OpenShift CLI
Test Teardown       Tear Down The Test Suite
Force Tags          CLI     rds


*** Test Cases ***
Scenario: Verify Error Message For Invalid Credentials On RDS Using OC CLI
    [Tags]    smoke    RHOD-510
    When User Creates RDS Secret With Invalid Credentials
    And User Imports RDS Provider Account Using CLI
    Then Provider Account Import Failure Using CLI

Scenario: Import RDS Provider Account Using OC CLI
    [Tags]    smoke    RHOD-520
    When User Creates RDS Secret Credentials
    And User Imports RDS Provider Account Using CLI
    Then Provider Account Imported Successfully Using CLI

Scenario: Deploy RDS Provider Account Using OC CLI
    [Tags]    smoke    RHOD-480
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Deploys RDS Instance Using CLI
    Then DBSC Instance Deployed Successfully Using CLI
