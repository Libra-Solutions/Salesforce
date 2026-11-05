global class Xva_BatchTaskCleanup implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date lastYrFeb = Date.newInstance(Date.Today().Year() - 1, 2, 1);
        return Database.getQueryLocator([SELECT Id, Subject, ActivityDate, WhoId FROM Task WHERE CreatedDate <= :lastYrFeb AND Status != 'Completed' AND CompletedDateTime = null AND isClosed = false]);
    }
    global void execute(Database.BatchableContext BC, List<Task> scope) {
        List<Task> tasks = new List<Task>();
        for(Task t : scope){
            tasks.add(t);
        }
       List<Database.DeleteResult> results = Database.Delete(tasks);
       Error_Logs__c el = new Error_Logs__c();
       for(Database.DeleteResult dr : results) {
           if (!dr.isSuccess()) {
            el.exception_message__c +=  'Error deleting task with ID: ' + dr.getId() + ': ' + dr.getErrors()[0].getMessage();
            el.Source_Object__c = 'Xva_BatchTaskCleanup';
            el.Source_Method__c = 'execute';
           } 
       }
       if(el != null) insert el;
    }
    global void finish(Database.BatchableContext BC) {
    }
   
}