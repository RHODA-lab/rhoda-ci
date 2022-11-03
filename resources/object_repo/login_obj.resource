*** Comments ***
Object Repository for Login Screen


*** Variables ***
${titleLoginType}           //h1[contains(.,"Log in with")]
${titleLoginPage}           //h1[contains(.,"Log in to your account")]
${txtBxUserName}            //input[@id="inputUsername"]
${txtBxPassword}            //input[@id="inputPassword"]
${btnLogin}                 //button[contains(.,"Log in")]
${lblLoginError}            //div[contains(@class,"error-placeholder")]/p[contains(.,"Invalid login" )]
${titleOverview}            //span[contains(.,"Overview")]
${elemNavSideBar}           //div[@id="page-sidebar"]
${elemNavMenu}              //li[starts-with(.,"<<menu>>") and contains(@class,"nav")]
${btnNavMenu}               //li[starts-with(.,"<<menu>>") and contains(@class,"nav")]/button
${elemNavChildMenu}         //li[starts-with(.,"<<menu>>") and contains(@class,"nav")]/section//li[contains(.,"<<submenu>>")]
${lblChildPageHeader}       //h1[contains(.,"<<submenu>>")]
${lblPageTitle}             //span[contains(@data-test-id,"resource-title") and contains(.,"<<header>>")]
${elemDataServiceNav}       //li[starts-with(.,"Data Services") and contains(@class,"nav")]
${elemDataAccessNav}        //li[starts-with(.,"Data Services") and contains(@class,"nav")]/section//li[contains(.,"Database Access")]
${btnPerspective}           (//div[@id="page-sidebar"]//button)[1]
${elemCurrPerspective}      //button[contains(@class,"dropdown")]//h2[.="<<perspective>>"]
${elemPerspectiveOpt}       //h2[.="<<option>>"]/parent::a
${elemWelcomeTile}          //b[contains(.,"Welcome to the Developer Perspective!")]
${btnWelcomTileClose}       //button[contains(@aria-label,"Close")]

