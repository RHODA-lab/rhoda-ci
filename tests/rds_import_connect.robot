*** Settings ***
Documentation       To Verify Provisioning of RDS Provider Account and deployment of Database Instance
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/deploy_application.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given The Browser Is On Openshift Home Screen
Test Teardown       Close Browser


*** Test Cases ***
Scenario: Import RDS Provider Account From Administrator View
    [Tags]    smoke    RHOD-300
    When User Filters Project redhat-dbaas-operator On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Data To Import RDS Provider Account
    Then Provider Account Import Success

Scenario: Deploy RDS Database Instance
    [Tags]    smoke   RHOD-301
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Imports Valid RDS Provider Account
    And User Navigates To Add RDS To Topology Screen
    And User Selects Database Instance For The Provider Account
    Then DBSC Instance Deployed On Developer Topology Graph View

