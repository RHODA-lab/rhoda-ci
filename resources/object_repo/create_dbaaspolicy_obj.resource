*** Comments ***
Object Repository for DBaaSPolicies Screen


*** Variables ***
${txtNoDBaaSPolicy}             //div[.="No operands found"]
${lblOperand}                   //label[contains(.,"Current namespace only")]
${btnCreateDBaaSPolicy}         //button[contains(@id,"yaml-create") and (.="Create DBaaSPolicy")]
${titleCreateDBaaSPolicy}       //span[.="Create DBaaSPolicy"]
${txtBxDBaaSPolicyName}         id:root_metadata_name
${btnToggleConnNS}              id:root_spec_connectionNamespaces_accordion-toggle
${btnAddConnNS}                 id:root_spec_connectionNamespaces_add-btn
${txtBxConnNS}                  //input[contains(@id,"root_spec_connectionNamespaces")]
${lnkDBaaSPolicyName}           //a[contains(@href,"DBaaSPolicy") and (.="<<policyname>>")]
