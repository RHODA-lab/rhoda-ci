*** Settings ***
Documentation       Provision and Deploy CockroachDB Database Instance using CLI
Metadata            Version    0.0.1

Resource            ../resources/keywords/provision_dbinstance.resource

Suite Setup         Run Keywords
...                     Set Library Search Order    OpenShiftLibrary
...                     AND    Skip If    ${DBaaSPolicyEnabled}
Suite Teardown      Tear Down The Test Suite
Test Setup          Given Login To OpenShift CLI
Test Teardown       Tear Down The Test Case

Force Tags          CLI    cockroach


*** Test Cases ***
Scenario: Provision CockroachDB Database Instance On Default Namespace Using OC CLI
    [Tags]    RHODA-046    smoke
    When User Provisions New CockroachDB Instance On Default Namespace Using OC CLI
    Then DB Instance Provisioned Successfully On Default Namespace Using OC CLI

Scenario: Provision CockroachDB Database Instance On User Defined Namespace Using OC CLI
    [Tags]    RHODA-047    smoke
    When User Provisions New CockroachDB Instance On User Defined Namespace Using OC CLI
    Then DB Instance Provisioned Successfully On User Defined Namespace Using OC CLI
