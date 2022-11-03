*** Settings ***
Documentation       Test to verify installed operators screen for RHODA
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/import_provider_account.resource

Suite Setup         Run Keywords
...                 Set Library Search Order    SeleniumLibrary
...                 AND    Skip If    ${DBaaSPolicyEnabled}
Suite Teardown      Tear Down The Test Suite
Test Setup          Given The Browser Is On Openshift Home Screen
Test Teardown       Tear Down The Test Case
Force Tags          UI


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

Scenario: Error Message To Select Valid Namespace To Import Provider Account
    [Tags]    smoke    RHOD-45
    When User Selects Invalid Namespace To Import Database Provider Account And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    Then Application Navigate To Create Provider Account Page And Error Message Displayed For Invalid Namespace
