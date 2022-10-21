*** Settings ***
Documentation       Test suite used with generic test cases
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/deploy_instance_dev.resource
Resource            ../resources/keywords/import_provider_account.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Setup The Test Case
Test Teardown       Tear Down The Test Case
Force Tags          UI


*** Test Cases ***
Scenario: Verify Error Message For Duplicate Provider Account Friendly Name
    [Tags]    smoke   RHOD-84-1
    When User Imports Valid CockroachDB Provider Account
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    And User Enters Data To Import Duplicate CockroachDB Provider Account
    Then Duplicate Provider Account Name Error Message Appears

Scenario: Deploy DBInstances to Topology View When Provider Account Has No Instances
    [Tags]    smoke   RHOD-84-2
    When User Imports Valid CockroachDB Provider Account
    And User Navigates To Add CockroachDB To Topology Screen
    And User Selects Provider Account With No Instances
    Then Text Message For A provider Account With No DB Instances Appears

