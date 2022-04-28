*** Settings ***
Documentation       Test to verify installed operators screen for RHODA
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/navigation.resource
Resource            ../resources/keywords/operators.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given The Browser Is On Openshift Home Screen
Test Teardown       Close Browser


*** Test Cases ***
Scenario: Redhat Database Operator Installed On Operator Hub
    [Tags]    smoke
    When User Navigates To OperatorHub Under Operators
    And User Searches Openshift Database Access Operator On RHODA Installed Cluster
    Then The Operator Tile Loads With Installed Status

Scenario: Redhat Dbaas Operator Namespace Created For RHODA Installation
    [Tags]    smoke
    When User Navigates To Installed Operators Under Operators
    And User Filters redhat-dbaas-operator Namespace On Project Dropdown
    Then Openshift Database Access Operator Filtered With Succeeded Status
