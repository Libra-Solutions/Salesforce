global class BatchUpdateDateField implements Database.Batchable<sObject> { 
    
    global String stateName;
    
     global BatchUpdateDateField(String stateName){
        this.stateName = stateName;
     }
    
     global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id, Latest_Modified_Date__c,(SELECT Id,LastModifiedDate FROM Tasks Order by LastModifiedDate DESC LIMIT 1) FROM Account where Type =: stateName ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accList) {
       
        // process each batch of records
        List<Account> updatedList = new List<Account>();
        for(Account acc: accList){
            if(acc.Tasks.size()>0){
                
                acc.Latest_Modified_Date__c = acc.Tasks[0].LastModifiedDate;
                updatedList.add(acc);
            }
        }
        try {
            System.debug('@@ inside '+updatedList);
            update updatedList;
        } catch(Exception e) {
            System.debug(e); 
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('@@ finished');
  }
}