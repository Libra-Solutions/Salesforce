global class BatchUpdatedInclusiveTask implements Database.Batchable<sObject> {
	global BatchUpdatedInclusiveTask(){

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordType = 'API ONLY USER';
        if(!Test.isRunningTest()){
            String query = 'SELECT Id,Created_By_Inclusive__c, createdBy.Name FROM Task WHERE createdBy.Name !=: recordType';
            return Database.getQueryLocator(query);
        }else{
            String query = 'SELECT Id, createdBy.Name, Created_By_Inclusive__c FROM Task';
            return Database.getQueryLocator(query);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Task> tskList) {
        try {
            List<Task> resList = new List<Task>();
            for(Task tsk : tskList){
                tsk.Created_By_Inclusive__c = String.valueOf(tsk.createdBy.Name);
                resList.add(tsk);
            }
            
            if(resList.size()>0){
                update resList;
            }
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('@@ done');
    }
}