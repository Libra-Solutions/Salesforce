global class BatchGetDuplicateDataCSVNew implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Account> toBeSaved;
    global List<Account> toBeDeleted;
    global String stateName;
    global String phone = '';
    global String fax = '';
    global String type;
    global Map<String, List<Account>> mp;
    global Integer size;
      global Integer num;
    
    global BatchGetDuplicateDataCSVNew(String type, Integer size, String phone, String fax, Integer num){
        //this.stateName = stateName;
        toBeSaved = new List<Account>();
        toBeDeleted = new List<Account>();
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
            query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND isVisit__c != true AND Zip__c !=\'\'  AND Fax !=\'\' And Phone != \'\'  LIMIT '+size;
        }else if(num==2){
            query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND isVisit__c != true AND Zip__c !=\'\'  And Phone != \'\' AND Fax = \'\' LIMIT '+size;
        }else if(num==3){
            query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND isVisit__c != true AND Zip__c !=\'\'  And Fax != \'\' AND Phone = \'\' LIMIT '+size;
        }else if(num==4){
           query = 'SELECT Id,Parent.Id,Parent.Name, Name, Zip__c,Full_Name__c, Billing_State__c,Billing_City__c,Type, Fax, Phone, Latest_Modified_Date__c,isVisit__c FROM Account where Type =: type AND isVisit__c != true AND Zip__c !=\'\' AND Phone = \'\' AND Fax = \'\' LIMIT '+size;
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> actList) {
        try {
            // process each batch of records
            Map<String, List<Account>> mapOfCurrentIteration = new Map<String, List<Account>>();
            for(Account acc : actList){
                acc.isVisit__c = true;
                String key = '';
                if(String.isNotBlank(acc.Phone) && String.isNotBlank(phone) && String.isNotBlank(acc.Fax) && String.isNotBlank(fax) && String.isNotBlank(acc.Zip__c)){
                    key = acc.Name+acc.Phone+acc.Fax+acc.Zip__c;
                }else if(String.isBlank(phone) && String.isNotBlank(fax) && String.isNotBlank(acc.Fax) && String.isNotBlank(acc.Zip__c)){
                    key = acc.Name+acc.Fax+acc.Zip__c;
                }else if(String.isBlank(Fax) && String.isNotBlank(acc.Phone) && String.isNotBlank(phone) && String.isNotBlank(acc.Zip__c)){
                    key = acc.Name+acc.Phone+acc.Zip__c;
                }else if(String.isNotBlank(acc.Zip__c) && String.isBlank(phone) && String.isBlank(fax)){
                    key = acc.Name+acc.Zip__c;
                }
                key= key.replaceAll( '\\s+', '');
                
                if(String.isNotBlank(key)){
                    System.debug('@@ key -> '+key);
                    if(mp.containsKey(key)){
                        List<Account> getAcc = mp.get(key);
                        getAcc.add(acc);
                        mp.put(key, getAcc);
                        mapOfCurrentIteration.put(key, getAcc);
                    }else{
                        mp.put(key, new List<Account> { acc });
                        mapOfCurrentIteration.put(key, new List<Account> { acc });
                    }
                }  
            }
            System.debug('@@ mapsize '+mp.keySet().size());
            System.debug('@@ mapOfCurrentIteration '+mapOfCurrentIteration.keySet().size());
            for(String str : mapOfCurrentIteration.keySet()){
                if(mp.containsKey(str) && mp.get(str).size()==1){
                    toBeSaved.add(mp.get(str).get(0));
                }else if(mp.containsKey(str) && mp.get(str).size()>1){
                    Set<Id> setOfIds = new Set<Id>();
                    List<Account> tempToBeDeleted = new List<Account>();
                    List<Account> tempToBeSaved = new List<Account>();
                    for(Account acc : mp.get(str)){
                        if(tempToBeSaved.isEmpty()){
                            if(!setOfIds.contains(acc.Id)){
                                tempToBeSaved.add(acc);
                                setOfIds.add(acc.Id);
                            }
                        }else if(!tempToBeSaved.isEmpty()){
                            if(tempToBeSaved.get(0).Latest_Modified_Date__c == null && acc.Latest_Modified_Date__c == null){
                                tempToBeDeleted.add(acc);
                            }else if(tempToBeSaved.get(0).Latest_Modified_Date__c == null && acc.Latest_Modified_Date__c != null){
                                tempToBeDeleted.addAll(tempToBeSaved);
                                tempToBeSaved.clear();
                                if(!setOfIds.contains(acc.Id)){
                                    tempToBeSaved.add(acc);
                                     setOfIds.add(acc.Id);
                                }
                            }else if(acc.Latest_Modified_Date__c != null && tempToBeSaved.get(0).Latest_Modified_Date__c < acc.Latest_Modified_Date__c){
                                tempToBeDeleted.addAll(tempToBeSaved);
                                tempToBeSaved.clear();
                                if(!setOfIds.contains(acc.Id)){
                                    tempToBeSaved.add(acc);
                                     setOfIds.add(acc.Id);
                                }
                            }else{
                                tempToBeDeleted.add(acc);
                            }
                        }else{
                            tempToBeDeleted.add(acc);
                        }
                    }   
                    toBeSaved.add(tempToBeSaved.get(0));
                    toBeDeleted.addAll(tempToBeDeleted);
                } 
            }
            System.debug('@@ exe toBeDeleted '+toBeDeleted.size());
            System.debug('@@ exe toBeSaved '+toBeSaved.size());
            if(actList.size()>0){
                update actList;
            }
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
            String finalstr = 'Id, ParentId, Name, ParentName, State, City, Zip , Full Name, Phone, Fax, Type \n';
            String attName = Type+' Deleted Account List' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for( Account acct  : toBeDeleted){
                string recordString = '"'+acct.id+'","'+acct.Parent.Id+'","'+acct.Name+'","'+acct.Parent.Name+'","'+acct.Billing_State__c+'","'+acct.Billing_City__c+'","'+acct.Zip__c+'","'+acct.Full_Name__c+'","'+acct.Phone+'","'+acct.Fax+'","'+acct.Type+'"\n';
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
            String finalstr = 'Id, ParentId, Name, ParentName, State, City, Zip , Full Name, Phone, Fax, Type \n';
            String attName = Type+' Saved Account List ' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for( Account acct  : toBeSaved){
                string recordString = '"'+acct.id+'","'+acct.Parent.Id+'","'+acct.Name+'","'+acct.Parent.Name+'","'+acct.Billing_State__c+'","'+acct.Billing_City__c+'","'+acct.Zip__c+'","'+acct.Full_Name__c+'","'+acct.Phone+'","'+acct.Fax+'","'+acct.Type+'"\n';
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