*** Settings ***
Documentation       To verify DBaaSPolicy
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/dbaas_policy.resource

Suite Setup         Configure DBaaS Policy Namespaces
Suite Teardown      Tear Down The Test Suite
Test Teardown       Close Browser
Force Tags          UI  DBaaS

*** Test Cases ***
Scenario: Verify Invalid Namespace Error Message For Project Admin To Create DBaaS Policy
    [Tags]  dbaas-test-01
    Given The User Logs In To Openshift As OCP_LDAP_PROJECT_ADM
    When User Filters Project ${DBaaSTestNS} On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    Then Import Provider Account Failure For DBaaS Policy

Scenario: Verify Invalid Namespace Error Message For Service Admin To Create DBaaS Policy
    [Tags]  dbaas-test-02
    Given The User Logs In To Openshift As OCP_LDAP_SERVICE_ADM
    When User Filters Project ${DBaaSTestNS} On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    Then Import Provider Account Failure For DBaaS Policy

Scenario: Verify Invalid Namespace Error Message For Developer To Create DBaaS Policy
    [Tags]  dbaas-test-03
    Given The User Logs In To Openshift As OCP_LDAP_DEV
    When User Filters Project ${DBaaSTestNS} On Project DropDown And Navigates To Database Access Page
    And User Navigates To Import Database Provider Account Screen From Database Access Page
    Then Import Provider Account Failure For DBaaS Policy
