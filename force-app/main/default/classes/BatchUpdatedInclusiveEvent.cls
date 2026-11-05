global class BatchUpdatedInclusiveEvent implements Database.Batchable<sObject> {
	global BatchUpdatedInclusiveEvent(){

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordType = 'API ONLY USER';
        if(!Test.isRunningTest()){
            String query = 'SELECT Id,Created_By_Inclusive__c, createdBy.Name FROM Event WHERE Created_By_Inclusive__c = null AND createdBy.Name !=: recordType';
            return Database.getQueryLocator(query);
        }else{
            String query = 'SELECT Id, createdBy.Name, Created_By_Inclusive__c FROM Event';
            return Database.getQueryLocator(query);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Event> tskList) {
        try {
            List<Event> resList = new List<Event>();
            for(Event tsk : tskList){
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