*** Settings ***
Documentation       Provision and Deploy RDS Instance from Administrator View
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/provision_dbinstance.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Test Setup          Given Setup The Test Case
Test Teardown       Tear Down The RDS Test Case
Suite Teardown      Tear Down The Test Suite
Force Tags          UI  rds


*** Test Cases ***
Scenario: Provision RDS Database Instance for Invalid Provider Account from Administrator View
    [Tags]    smoke    test01
    When User Imports Invalid RDS Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    AND User Selects DBProvider And Provider Account
    Then DBSC Instance Retrieval Failed On Admin View

Scenario: Provision RDS PostgreSQL Database Instance from Administrator View
    [Tags]    smoke    test02
    When User Imports Valid RDS Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    And User Enters Data To Create Database Instance For RDS DB PostgreSQL Engine On Admin View
    Then RDS DBSC Instance Provisioned And Deployed On Developer Topology Graph View

Scenario: Provision RDS MariaDB Database Instance from Administrator View
    [Tags]    smoke    test03
    When User Imports Valid RDS Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    And User Enters Data To Create Database Instance For RDS DB MariaDB Engine On Admin View
    Then RDS DBSC Instance Provisioned And Deployed On Developer Topology Graph View

Scenario: Provision RDS MySQL Database Instance from Administrator View
    [Tags]    smoke    test04
    When User Imports Valid RDS Provider Account
    And User Navigates To Create Database Instance Screen From Database Access Page
    And User Enters Data To Create Database Instance For RDS DB MySQL Engine On Admin View
    Then RDS DBSC Instance Provisioned And Deployed On Developer Topology Graph View
