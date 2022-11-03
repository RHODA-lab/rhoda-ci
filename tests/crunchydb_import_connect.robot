*** Settings ***
Documentation       To Verify Importing of CrunchyDB Provider Account and deployment of Database Instance
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/deploy_application.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Setup The Test Case
Test Teardown       Tear Down The Test Case
Force Tags          UI     crunchy


*** Test Cases ***
Scenario: Import CrunchyDB Provider Account From Developer View
    [Tags]    smoke    RHOD-11
    When User Navigates To Add Crunchy Bridge Topology Screen From Developer View
    And User Navigates To Import Provider Account Screen From Developer View
    And User Enters Data To Import CrunchyDB Provider Account
    Then Provider Account Import Success

Scenario: Verify error message for invalid credentials on CrunchyDB
    [Tags]    smoke    RHOD-49-2
    When User Filters Project ${operatorNamespace} On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Invalid Data To Import CrunchyDB Provider Account
    Then Provider Account Import Failure

Scenario: Import CrunchyDB Provider Account From Administrator View
    [Tags]    smoke    RHOD-47
    When User Filters Project ${operatorNamespace} On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Data To Import CrunchyDB Provider Account
    Then Provider Account Import Success

Scenario: Deploy CrunchyDB Database Instance
    [Tags]    smoke    RHOD-51
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Imports Valid Crunchy Bridge Provider Account
    And User Navigates To Add Crunchy Bridge To Topology Screen
    And User Selects Database Instance For The Provider Account
    Then DBSC Instance Deployed On Developer Topology Graph View

Scenario: Connect CrunchyDB DBSC With An Openshift Application
    [Tags]    smoke    RHOD-67
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Deploys Crunchy Database Instance On Developer Topology Screen
    And User Imports Openshift crunchy Application From YAML
    And User Creates Service Binding Between crunchy DBSC Instance And Imported Openshift Application
    Then The Application Accesses The Connected crunchy Database Instance
