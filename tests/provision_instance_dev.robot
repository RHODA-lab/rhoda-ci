*** Settings ***
Documentation       To Verify Database Provisioning From Developers view
Metadata            Version    0.0.1

Library             SeleniumLibrary
Resource            ../resources/keywords/create_provider_account.resource

Suite Setup         Set Library Search Order    SeleniumLibrary
Suite Teardown      Tear Down The Test Suite
Test Setup          Given The Browser Is On Openshift Home Screen
Test Teardown       Close Browser


*** Test Cases ***
Scenario: Error Message To Select Valid Namespace For Provider Account Creation
    When User Filters Project Other Than redhat-dbaas-operator And Navigates To Database Access Page
    And User Navigates To Create Provider Account Screen From Database Access Page
    Then Application Navigate To Create Provider Account Page And Error Message Displayed For Invalid Namespace

Scenario: Create MongoDB Provider Account From Administrator View
    When User Filters Project redhat-dbaas-operator On Project DropDown And Navigates To Database Access Page
    And User Navigates To Create Provider Account Screen From Database Access Page
    And User Enters Data To Create MongoDB Provider Account
    Then Provider Account Creation Successful And Application Navigates To Success Screen
