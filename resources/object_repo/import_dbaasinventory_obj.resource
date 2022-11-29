*** Comments ***
Object Repository for DBaaSInvertories Screen


*** Variables ***
${titleImportProviderAcc}       //div[@class="section-title" and contains(.,"Import Database Provider Account")]
${txtInvalidNamespace}          //h4[contains(.,"Invalid Namespace")]
${btnCreateDisabled}            //button[contains(.,"Create") and @aria-disabled="true"]
${btnImportDisabled}            //button[contains(.,"Import") and @aria-disabled="true"]
${btnCancelEnabled}             //button[contains(.,"Cancel") and @aria-disabled="false"]
${txtBxName}                    id:inventory-name
${drpDwnDBProvider}             //select[contains(@aria-label,"Database Provider")]
${txtBxMongoDBOrgID}            id:mongodb-atlas-registration-orgId
${txtBxMongoDBPubAPI}           id:mongodb-atlas-registration-publicApiKey
${txtBxMongoDBPrivAPI}          id:mongodb-atlas-registration-privateApiKey
${txtBxCrunchyPubAPI}           id:crunchy-bridge-registration-publicApiKey
${txtBxCrunchyPrivAPI}          id:crunchy-bridge-registration-privateApiSecret
${txtBxCockroachAPI}            id:cockroachdb-cloud-registration-apiSecretKey
${txtBxRdsAwsAccsKeyID}         //input[@id='rds-registration-AWS_ACCESS_KEY_ID']
${txtBoxRdsAwsSecKeyID}         //input[@id='rds-registration-AWS_SECRET_ACCESS_KEY']
${txtBoxRdsAwsRegion}           //input[@id='rds-registration-AWS_REGION']
${txtBoxAckResrceTags}          //input[@id='rds-registration-ACK_RESOURCE_TAGS']
${txtBoxAckLogLvl}              //input[@id='rds-registration-ACK_LOG_LEVEL']
${btnImportEnabled}             //button[contains(.,"Import") and @aria-disabled="false"]
${importBtnChkbox}              //input[@id="rds-warning-section-checkbox"]
${btnCreateEnabled}             //button[contains(.,"Create") and @aria-disabled="false"]
${lblDBInstSuccess}             //h2[contains(.,"Database instances") and contains(.,"successful")]
${btnViewProviderAcc}           //button[contains(.,"View Provider Accounts")]
${tblInstanceTable}             id:instance-table
${btnMenuDropDown}              //button[contains(.,"<<menu>>")]
${btnMenuOptDropDown}           //a[contains(.,"<<menuopt>>")]
${tblDBProviderAcc}             id:instance-connection-status-table
${lblDBInstFailure}             //h2[.="Database instances retrieval failed"]
${txtInvCred}                   //div[contains(.,"Invalid credentials")]
${btnEditProvAcc}               //button[(.="Edit Provider Account") and @aria-disabled="false"]
${txtProvNoDBInst}              //div[contains(.,"The Provider Account resource has been created but the database instances could not be fetched.")]
${txtErrNoDBInst}               //div[.="No database instance in this Provider Account"]
${btnClose}                     //button[contains(.,"Close") and @aria-disabled="false"]
${lblDuplProvAccName}           //div[@aria-label="Danger Alert"]/div[contains(.,"already exists")]
${errCreateDBaaSPolicy}         //div[@aria-label="Warning Alert"]//a[contains(.,"create a Policy")]
