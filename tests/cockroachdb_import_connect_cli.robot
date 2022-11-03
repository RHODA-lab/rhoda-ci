*** Settings ***
Documentation       To Verify Importing of CockroachDB Provider Account and deployment of Database Instance Using OC CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/deploy_application.resource

Suite Setup         Run Keywords
...                 Set Library Search Order    OpenShiftLibrary
...                 AND    Skip If    ${DBaaSPolicyEnabled}
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI
Test Teardown       Tear Down The Test Case
Force Tags          CLI  cockroach


*** Test Cases ***
Scenario: Verify Error Message For Invalid Credentials On CockroachDB Using OC CLI
    [Tags]    smoke    RHOD-472
    When User Creates CockroachDB Secret With Invalid Credentials
    And User Imports CockroachDB Provider Account Using CLI
    Then Provider Account Import Failure Using CLI

Scenario: Import CockroachDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-462
    When User Creates CockroachDB Secret Credentials
    And User Imports CockroachDB Provider Account Using CLI
    Then Provider Account Imported Successfully Using CLI

Scenario: Deploy CockroachDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-570
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Deploys CockroachDB Instance Using CLI
    Then DBSC Instance Deployed Successfully Using CLI
