*** Comments ***
Object Repository for Login Screen

*** Variables ***
${titleLoginType}           //h1[contains(.,"Log in with")]
${titleLoginPage}           //h1[contains(.,"Log in to your account")]
${txtBxUserName}            //input[@id="inputUsername"]
${txtBxPassword}            //input[@id="inputPassword"]
${btnLogin}                 //button[contains(.,"Log in")]
${titleOverview}            //span[contains(.,"Overview")]
${elemNavSideBar}           //div[@id="page-sidebar"]
${eleNavMenu}               //li[starts-with(.,"<<menu>>") and contains(@class,"nav")]
${eleNavChildMenu}          //li[starts-with(.,"<<menu>>") and contains(@class,"nav")]/section//li[contains(.,"<<submenu>>")]
${lblChildPageHeader}       //h1[contains(.,"<<submenu>>")]
${lblPageTitle}             //span[contains(@data-test-id,"resource-title") and contains(.,"<<header>>")]



