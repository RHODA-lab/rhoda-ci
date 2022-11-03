*** Comments ***
Object Repository for Operators Hub Screen


*** Variables ***
${drpDwnProjectSelect}          //div[contains(@data-test-id,"namespace-bar-dropdown")]//button
${txtBxProjectSelect}           //input[contains(@data-test,"dropdown-text-filter")]
${btnProjectSelect}             //span[.="<<project>>"]/parent::button
${lblProjectSelect}             //span[.="Project: <<project>>"]
${txtBxFilter}                  //input[contains(@aria-label,"Filter by keyword")]
${elemDatabaseAccessTile}       //a[contains(@class, "co-catalog-tile") and contains(@href,"redhat-dbaas-operator")]
${elemDatabaseAccessStatus}     //a[contains(@href,"redhat-dbaas-operator")]/div[contains(@class,"footer")]/span
${txtProjects}                  //h1//span[.="Projects"]
${lnkProjectName}               //a[contains(@class,"co-resource-item__resource-name") and (.="<<project>>")]
