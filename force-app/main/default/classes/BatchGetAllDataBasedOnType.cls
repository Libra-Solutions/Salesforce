global class BatchGetAllDataBasedOnType implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Account> toBeSaved;
    global String stateName;
    global String phone = '';
    global String fax = '';
    global String type;
    global Map<String, List<Account>> mp;
    global Integer size;
      global Integer num;
    
    global BatchGetAllDataBasedOnType(String type, Integer size, Integer num){
        //this.stateName = stateName;
        toBeSaved = new List<Account>();
        this.type = type;
        this.phone = phone;
        this.fax = fax;
        mp = new Map<String, List<Account>>();
        this.size = size;
        this.num = num;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = '';
        if(num==1){
            query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND Zip__c !=\'\'  AND Fax !=\'\' And Phone != \'\'  LIMIT '+size;
        }else if(num==2){
            query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND Zip__c !=\'\'  And Phone != \'\' AND Fax = \'\' LIMIT '+size;
        }else if(num==3){
            query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND Zip__c !=\'\'  And Fax != \'\' AND Phone = \'\' LIMIT '+size;
        }else if(num==4){
           query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND  Zip__c !=\'\' AND Phone = \'\' AND Fax = \'\' LIMIT '+size;
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> actList) {
        try {
            for(Account acc : actList){
                toBeSaved.add(acc);
            }
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('@@ finished toBeSaved '+toBeSaved);
        
        
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
        String body = 'Your batch job '
            + 'BatchGetDuplicateDataCSV '
            + 'has finished. \n'
            + 'There were total '
            + toBeSaved.size()
            + ' records. Please find the attached success and error records CSV.';
        String subject = 'Account - Apex Batch Result for BatchGetDuplicateDataCSV';
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Define email file attachment list
        Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        
        
        if(toBeSaved.size()>0) {
            // Creating the CSV file for successful updates
            String finalstr = 'Id, ParentId, Name, ParentName, State, City, Zip , Full Name, Phone, Fax, Type, Latest Modified Date \n';
            String attName = Type+' Saved Account List ' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for( Account acct  : toBeSaved){
                string recordString = '"'+acct.id+'","'+acct.Parent.Id+'","'+acct.Name+'","'+acct.Parent.Name+'","'+acct.Billing_State__c+'","'+acct.Billing_City__c+'","'+acct.Zip__c+'","'+acct.Full_Name__c+'","'+acct.Phone+'","'+acct.Fax+'","'+acct.Type+'","'+acct.Latest_Modified_Date__c+'"\n';
                finalstr = finalstr +recordString;
            }
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            emailAttList.add(efa);
            
        }
        // Sets the paramaters of the email
        email.setSubject( subject );
        email.setToAddresses( new String[] {'sbattu@oasisfinancial.com','skhandelwal295@gmail.com'} );
        email.setPlainTextBody( body );
        email.setFileAttachments(emailAttList);
        
        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}