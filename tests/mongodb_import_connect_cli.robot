*** Settings ***
Documentation       To Verify Provisioning of MongoDB Provider Account and deployment of Database Instance Using OC CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/deploy_application.resource
Resource            ../resources/keywords/suite_and_test_teardown.resource

Suite Setup         Set Library Search Order    OpenShiftLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI


*** Test Cases ***
Scenario: Import MongoDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-460    cli
    When User Creates MongoDB Secret Credentials
    And User Imports MongoDB Provider Account Using CLI
    Then Provider Account Imported Successfully Using CLI

Scenario: Verify Error Message For Invalid Credentials On MongoDB Using OC CLI
    [Tags]    smoke    RHOD-470    cli
    When User Creates MongoDB Secret With Invalid Credentials
    And User Imports MongoDB Provider Account Using CLI
    Then Provider Account Import Failure Using CLI

Scenario: Deploy MongoDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-480     cli
    When User Deploys MongoDB Instance Using CLI
    Then DBSC Instance Deployed Successfully Using CLI
