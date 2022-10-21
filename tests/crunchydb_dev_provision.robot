*** Settings ***
Documentation       Provision and Deploy Crunchy Bridge Database Instance from Developer View
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/provision_dbinstance.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Test Setup          Given Setup The Test Case
Test Teardown       Tear Down The Test Case
Suite Teardown      Tear Down The Test Suite
Force Tags          UI     crunchy


*** Test Cases ***
Scenario: Provision Crunchy Bridge Database Instance for Invalid Provider Account from Developers View
    [Tags]    smoke    RHOD-57-dev
    When User Imports Invalid Crunchy Bridge Provider Account
    And User Navigates To Create Database Instance Screen On Developer View
    Then DBSC Instance Retrieval Failed On Dev View

Scenario: Provision CrunchyDB Database Instance from Developers View
    [Tags]    smoke    RHOD-58-dev
    When User Imports Valid Crunchy Bridge Provider Account
    And User Navigates To Create Database Instance Screen On Developer View
    And User Enters Data To Create Instance On Dev View
    Then Crunchy DBSC Instance Provisioned And Deployed On Developer Topology Graph View
