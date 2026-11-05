global class BatchGetDuplicateDataCSV implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Account> toBeSaved;
    global List<Account> toBeDeleted;
    global String stateName;
    
    global BatchGetDuplicateDataCSV(String stateName){
        this.stateName = stateName;
        toBeSaved = new List<Account>();
        toBeDeleted = new List<Account>();
    }
    
	 global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id,Name, Full_Name__c, Phone, Latest_Modified_Date__c FROM Account where Billing_State__c =: stateName';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> actList) {
        try {
        // process each batch of records
        Map<String, List<Account>> mp = new Map<String, List<Account>>();
        for(Account acc : actList){
            String key = acc.Name+acc.Phone;
            String keyFullName = acc.Name;
             if(acc.Phone == null || String.isBlank(acc.Phone)){
                if(mp.containsKey(keyFullName)){
                    List<Account> getAcc = mp.get(keyFullName);
                    getAcc.add(acc);
                    mp.put(keyFullName, getAcc);
                }else{
                    mp.put(keyFullName, new List<Account> { acc });
                }
             }else{
                 if(mp.containsKey(key)){
                    List<Account> getAcc = mp.get(key);
                    getAcc.add(acc);
                    mp.put(key, getAcc);
                }else{
                    mp.put(key, new List<Account> { acc });
                }
             }
             
        }
            
        for(String str : mp.keySet()){
            if(mp.containsKey(str) && mp.get(str).size()==1){
                toBeSaved.add(mp.get(str).get(0));
            }else if(mp.containsKey(str) && mp.get(str).size()>1){
               	List<Account> tempToBeDeleted = new List<Account>();
                List<Account> tempToBeSaved = new List<Account>();
                for(Account acc : mp.get(str)){
                    if(tempToBeSaved.isEmpty()){
                        tempToBeSaved.add(acc);
                    }else if(!tempToBeSaved.isEmpty()){
                        if(tempToBeSaved.get(0).Latest_Modified_Date__c < acc.Latest_Modified_Date__c){
                            tempToBeDeleted.addAll(tempToBeSaved);
                            tempToBeSaved = new List<Account>();
                            tempToBeSaved.add(acc);
                        }else{
                            tempToBeDeleted.add(acc);
                        }
                    }
                }   
                toBeSaved.addAll(tempToBeSaved);
                toBeDeleted.addAll(tempToBeDeleted);
            } 
        }
       System.debug('@@ exe toBeDeleted '+toBeDeleted);
        System.debug('@@ exe toBeSaved '+toBeSaved);
        	
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    	System.debug('@@ finished toBeDeleted '+toBeDeleted);
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
                + toBeSaved.size()+toBeDeleted.size()
                + ' records. Please find the attached success and error records CSV.';
            String subject = 'Account - Apex Batch Result for BatchGetDuplicateDataCSV';
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // Define email file attachment list
            Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
          
            if(toBeDeleted.size()>0) {
                // Creating the CSV file for successful updates
                String finalstr = 'Id, Name, Phone \n';
                String attName = stateName+' Deleted Account List' + system.now().format('YYYYMMDDhhmm') + '.csv';
                for( Account acct  : toBeDeleted){
                    string recordString = '"'+acct.id+'","'+acct.Name+'","'+acct.Phone+'","'+acct.Latest_Modified_Date__c+'"\n';
                    finalstr = finalstr +recordString;
                }
               
                // Create the email attachment    
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(attName);
                efa.setBody(Blob.valueOf(finalstr));
                emailAttList.add(efa);
                 
            }
        
             if(toBeSaved.size()>0) {
                    // Creating the CSV file for successful updates
                    String finalstr = 'Id, Name, Phone \n';
                    String attName = stateName+' Saved Account List ' + system.now().format('YYYYMMDDhhmm') + '.csv';
                    for( Account acct  : toBeSaved){
                        string recordString = '"'+acct.id+'","'+acct.Name+'","'+acct.Phone+'","'+acct.Latest_Modified_Date__c+'"\n';
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
            email.setToAddresses( new String[] {'sbattu@oasisfinancial.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(emailAttList);
           
            // Sends the email
            Messaging.SendEmailResult [] r =
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
  	}
}