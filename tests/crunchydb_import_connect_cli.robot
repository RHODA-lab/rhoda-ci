*** Settings ***
Documentation       To Verify Provisioning of CrunchyDB Provider Account and deployment of Database Instance Using OC CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/deploy_application.resource
Resource            ../resources/keywords/suite_teardown.resource

Suite Setup         Set Library Search Order    OpenShiftLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI
Test Teardown       Tear Down The Test


*** Test Cases ***
Scenario: Import CrunchyDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-461    cli
    When User Creates CrunchyDB Secret Credentials
    And User Imports CrunchyDB Provider Account Using CLI
    Then Provider Account Imported Successfully Using CLI

Scenario: Verify Error Message For Invalid Credentials On CrunchyDB Using OC CLI
    [Tags]    smoke    RHOD-471    cli
    When User Creates CrunchyDB Secret With Invalid Credentials
    And User Imports CrunchyDB Provider Account Using CLI
    Then Provider Account Import Failure Using CLI

Scenario: Deploy CrunchyDB Provider Account Using OC CLI
    [Tags]    smoke    RHOD-560     cli
    When User Deploys CrunchyDB Instance Using CLI
    Then DBSC Instance Deployed Successfully Using CLI
