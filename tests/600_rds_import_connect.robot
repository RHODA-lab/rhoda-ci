*** Settings ***
Documentation       To Verify Provisioning of RDS Provider Account and deployment of Database Instance
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/deploy_application.resource
Resource            ../resources/keywords/provision_dbinstance.resource
Resource            ../resources/keywords/import_provider_account.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Test Setup          Given Setup The Test Case
Test Teardown       Tear Down The Test Suite

Force Tags          UI    rds


*** Test Cases ***
Scenario: Verify error message for invalid credentials on RDS
    [Tags]    RHODA-048    smoke
    When User Filters Project ${operatorNamespace} On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Invalid Data To Import RDS Provider Account
    Then Provider Account Import Failure

Scenario: Import RDS Provider Account From Administrator View
    [Tags]    RHODA-049
    When User Filters Project ${operatorNamespace} On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Data To Import RDS Provider Account
    Then Provider Account Import Success

Scenario: Deploy RDS Database Instance
    [Tags]    RHODA-050    smoke
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Imports Valid RDS Provider Account
    And User Navigates To Add RDS To Topology Screen
    And User Selects Database Instance For The Provider Account
    Then DBSC Instance Deployed On Developer Topology Graph View

Scenario: Import RDS Provider Account From Developer View
    [Tags]    smoke     RHOD-303
    When User Navigates To Add Topology Screen From Developer View    RDS
    And User Navigates To Import Provider Account Screen From Developer View
    And User Enters Data To Import RDS Provider Account
    Then Provider Account Import Success

Scenario: Connect RDS DBSC With An Openshift Application
    [Tags]    smoke    RHOD-304
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Imports Valid RDS Provider Account
    And User Navigates To Create Database Instance Screen On Developer View
    And User Enters Data To Create Database Instance For RDS DB PostgreSQL Engine On Developer View
    Then RDS DBSC Instance Provisioned And Deployed On Developer Topology Graph View
    And User Imports Openshift RDS Application From YAML
    And User Creates Service Binding Between RDS DBSC Instance And Imported Openshift Application
    And The Application Accesses The Connected RDS Database Instance
