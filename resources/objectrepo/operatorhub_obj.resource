*** Comments ***
Object Repository for Operators Hub Screen


*** Variables ***
${drpDwnProjectSelect}          //div[contains(@data-test-id,"namespace-bar-dropdown")]//button
${txtBxProjectSelect}           //input[contains(@data-test,"dropdown-text-filter")]
${btnProjectSelect}             //span[.="<<project>>"]/parent::button
${lblProjectSelect}             //span[.="Project: <<project>>"]
${txtBxFilter}                  //input[@data-test="search-operatorhub"]
${elemDatabaseAccessTile}       //a[contains(@class, "co-catalog-tile") and contains(@href,"redhat-dbaas-operator")]
${elemDatabaseAccessStatus}     //a[contains(@href,"redhat-dbaas-operator")]/div[contains(@class,"footer")]/span
