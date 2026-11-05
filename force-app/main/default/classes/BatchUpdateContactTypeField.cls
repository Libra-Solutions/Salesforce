global class BatchUpdateContactTypeField implements Database.Batchable<sObject> { 
    
    
     global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String typeName = 'Law Firm';
        String query = 'Select id,type from Account where type =: typeName';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accList) {
       try {
        // process each batch of records
        List<Account> updatedList = new List<Account>();
        for(Account acc: accList){
           acc.Type = 'LawFirm';
            updatedList.add(acc);
        }
        
            update updatedList;
        } catch(Exception e) {
            System.debug(e); 
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('@@ finished');
  }
}