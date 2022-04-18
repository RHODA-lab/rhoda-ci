*** Settings ***
Documentation    Test to verify installed operators screen for RHODA
Metadata         Version    0.0.1
Library         SeleniumLibrary
Resource        ../Resources/Keywords/Login.resource
Suite Setup     Set Library Search Order  SeleniumLibrary
Test Setup      Given The Browser is on Openshift Home screen
Suite Teardown  Close Browser


*** Test Cases ***
Scenario: Redhat Database Operator Installed On Operator Hub
    Log To Console  "successfully logged into Openshfit console"

