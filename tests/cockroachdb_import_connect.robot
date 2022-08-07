*** Settings ***
Documentation       To Verify Provisioning of CockroachDB Provider Account and deployment of Database Instance
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/deploy_application.resource
Resource            ../resources/keywords/suite_and_test_teardown.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given The Browser Is On Openshift Home Screen


*** Test Cases ***
Scenario: Verify error message for invalid credentials on CockroachDB
    [Tags]    smoke
    When User Filters Project redhat-dbaas-operator On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Invalid Data To Import CockroachDB Provider Account
    Then Provider Account Import Failure

Scenario: Import Cockroach Provider Account From Administrator View
    [Tags]    smoke
    When User Filters Project redhat-dbaas-operator On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Data To Import CockroachDB Provider Account
    Then Provider Account Import Success

Scenario: Deploy CockroachDB Database Instance
    [Tags]    smoke    RHOD-60
    Skip If    "${PREV_TEST_STATUS}" == "FAIL"
    When User Imports Valid CockroachDB Provider Account
    And User Navigates To Add CockroachDB To Topology Screen
    And User Selects Database Instance For The Provider Account
    Then DBSC Instance Deployed On Developer Topology Graph View

Scenario: Connect CockroachDB DBSC With An Openshift Application
    [Tags]    smoke    RHOD-68
    When User Deploys CockroachDB Database Instance On Developer Topology Screen
    And User Imports Openshift cockroach Application From YAML
    And User Creates Service Binding Between cockroach DBSC Instance And Imported Openshift Application
    Then The Application Accesses The Connected cockroach Database Instance
