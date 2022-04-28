*** Comments ***
Object Repository for Installed Operators Screen


*** Variables ***
${elemDbaasStatus}          //a[contains(.,"OpenShift Database Access Operator")]//ancestor::tr/td[contains(.,"Succeeded")]
${titleDbaasOperator}       //h1[contains(.,"OpenShift Database Access Operator") and contains(@class,"logo__name")]
${elemDbaasInvStatus}       //td[contains(.,"<<paname>>")]/parent::tr/td[contains(.,"SpecSynced, InventoryReady")]
