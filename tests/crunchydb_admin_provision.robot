*** Settings ***
Documentation       Provision and Deploy Crunchy Bridge Database Instance from Administrator View
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/provision_dbinstance.resource
Resource            ../resources/keywords/suite_and_test_teardown.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Test Setup          Given The Browser Is On Openshift Home Screen
Test Teardown       Tear Down The Test


*** Test Cases ***
Scenario: Provision Crunchy Bridge Database Instance for Invalid Provider Account from Administrator View
    [Tags]    smoke    RHOD-57-1
    When User Imports Invalid Crunchy Bridge Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    And User Selects DBProvider And Provider Account
    Then DBSC Instance Retrieval Failed On Admin View

Scenario: Provision Crunchy Bridge Database Instance from Administrator View
    [Tags]    smoke    RHOD-57
    When User Imports Valid Crunchy Bridge Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    And User Enters Data To Create Database Instance On Admin View
    Then Crunchy DBSC Instance Provisioned And Deployed On Developer Topology Graph View
