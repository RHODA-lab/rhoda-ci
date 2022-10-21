*** Settings ***
Documentation       Provision and Deploy MongoDB Database Instance from Administrator View
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/provision_dbinstance.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Test Setup          Given Setup The Test Case
Test Teardown       Tear Down The Test Case
Suite Teardown      Tear Down The Test Suite
Force Tags          UI      mongo


*** Test Cases ***
Scenario: Provision MongoDB Database Instance for Invalid Provider Account from Administrator View
    [Tags]    smoke    RHOD-62-1
    When User Imports Invalid MongoDB Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    And User Selects DBProvider And Provider Account
    Then DBSC Instance Retrieval Failed On Admin View

Scenario: Provision MongoDB Database Instance from Administrator View
    [Tags]    smoke    RHOD-63
    When User Imports Valid MongoDB Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    And User Enters Data To Create Database Instance On Admin View
    Then MongoDB DBSC Instance Provisioned And Deployed On Developer Topology Graph View
