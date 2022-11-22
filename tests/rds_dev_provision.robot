*** Settings ***
Documentation       Provision and Deploy RDS Instance from Developer View
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/provision_dbinstance.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Test Setup          Given Setup The Test Case
Test Teardown       Tear Down The RDS Test Case
Suite Teardown      Tear Down The Test Suite
Force Tags          UI  rds


*** Test Cases ***
Scenario: Provision RDS Database Instance for Invalid Provider Account from Developers View
    [Tags]    smoke    rds01
    When User Imports Invalid RDS Provider Account
    And User Navigates To Create Database Instance Screen On Developer View
    Then DBSC Instance Retrieval Failed On Dev View

Scenario: Provision RDS Database Instance with PostgreSQL engine from Developers View
    [Tags]    smoke    rds02
    When User Imports Valid RDS Provider Account
    And User Navigates To Create Database Instance Screen On Developer View
    And User Enters Data To Create Database Instance For RDS DB PostgreSQL Engine On Developer View
    Then RDS DBSC Instance Provisioned And Deployed On Developer Topology Graph View

Scenario: Provision RDS Database Instance with MariaDB engine from Developers View
    [Tags]    smoke    rds03
    When User Imports Valid RDS Provider Account
    And User Navigates To Create Database Instance Screen On Developer View
    And User Enters Data To Create Database Instance For RDS DB MariaDB Engine On Developer View
    Then RDS DBSC Instance Provisioned And Deployed On Developer Topology Graph View

Scenario: Provision RDS Database Instance with MySQL engine from Developers View
    [Tags]    smoke    rds04
    When User Imports Valid RDS Provider Account
    And User Navigates To Create Database Instance Screen On Developer View
    And User Enters Data To Create Database Instance For RDS DB MySQL Engine On Developer View
    Then RDS DBSC Instance Provisioned And Deployed On Developer Topology Graph View
