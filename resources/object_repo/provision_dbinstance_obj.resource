*** Comments ***
Object Repository for Create Database Instance Screen


*** Variables ***
${txtBxInstName}                 //input[@id="instance-name"]
${txtBxProjName}                 //input[@id="project-name"]
${elemInstanceRadio}             (//td[contains(.,"<<inst-name>>")]/parent::tr//input)[1]
${btnAddToTplgy}                 //button[@id='instance-select-button']
${txtCreatingDBInst}             //h3[contains(.,"Creating Database Instance...")]
${txtInstCreated}                //h2[contains(.,"Database instance creation started")]
${txtCreationInfo}               //div[.="The database instance is being created, please click the button below to view it."]
${btnViewDBInst}                 //button[(.="View Database Instances") and @aria-disabled="false"]
${txtProvFailHead}               //h2[.="Provider account information retrieval failed"]
${txtProvFailMsg}                //div[.="Provider account information could not be retrieved. Please try again."]
${txtInstFailHead}               //h2[.="Database instances retrieval failed"]
${txtInstRtrvFail}               //div[.="Database instances could not be retrieved. Please try again."]
${btnTryAgain}                   //button[contains(.,"Try Again") and @aria-disabled="false"]
${drpDwnProvAccOptn}             //select[contains(@aria-label,"Provider Account")]/option
${lnkCreateDBInst}               //a[contains(.,"Create New Database Instance")]
${engineTypeDrpDwn}              //select[@aria-label="Engine Type"]
${engineTypeDrpDwnOptn}          //select[@aria-label="Engine Type"]/option
