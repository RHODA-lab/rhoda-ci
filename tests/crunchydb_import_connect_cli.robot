*** Settings ***
Documentation       To Verify CrunchyDB Provider Account Import and Instance Deployment Using CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/deploy_application.resource

Suite Setup         Run Keywords
...                 Set Library Search Order    OpenShiftLibrary
...                 AND    Skip If    ${DBaaSPolicyEnabled}
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI
Test Teardown       Tear Down The Test Case
Force Tags          CLI     crunchy


*** Test Cases ***
Scenario: Verify Error Message For Invalid Credentials On CrunchyDB Using OC CLI
    [Tags]    smoke    RHOD-471
    When User Creates CrunchyDB Secret With Invalid Credentials
    And User Imports CrunchyDB Provider Account Using CLI
    Then Provider Account Import Failure Using CLI

Scenario: Import CrunchyDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-461
    When User Creates CrunchyDB Secret Credentials
    And User Imports CrunchyDB Provider Account Using CLI
    Then Provider Account Imported Successfully Using CLI

Scenario: Deploy CrunchyDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-560
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Deploys CrunchyDB Instance Using CLI
    Then DBSC Instance Deployed Successfully Using CLI
