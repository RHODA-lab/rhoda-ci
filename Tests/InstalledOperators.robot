*** Settings ***
Documentation    Test to verify installed operators screen for RHODA
Metadata         Version    0.0.1
Library         SeleniumLibrary
Resource        ../Resources/Keywords/Navigation.resource
Resource        ../Resources/Keywords/Operators.resource
Suite Setup     Set Library Search Order  SeleniumLibrary
Test Setup      Given The Browser is on Openshift Home screen
Suite Teardown  Close Browser


*** Test Cases ***
Scenario: Redhat Database Operator Installed On Operator Hub
    When User Navigates to OperatorHub under Operators
    And User Searches Openshift Database Access Operator on RHODA installed cluster
    Then The Operator tile loads with Installed status
