global class Xva_BatchOpportunityCleanup implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date lastYrFeb = Date.newInstance(Date.Today().Year() - 1, 2, 1);
        return Database.getQueryLocator([SELECT Id, Name, CloseDate, StageName, CreatedDate FROM Opportunity WHERE CreatedDate <= :lastYrFeb AND StageName != 'Closed Won' AND StageName != 'Closed Lost']);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Opportunity o : scope){
            opportunities.add(o);
        }
       List<Database.DeleteResult> results = Database.Delete(opportunities);
       Error_Logs__c el = new Error_Logs__c();
       for(Database.DeleteResult dr : results) {
           if (!dr.isSuccess()) {
            el.exception_message__c +=  'Error deleting opportunity with ID: ' + dr.getId() + ': ' + dr.getErrors()[0].getMessage();
            el.Source_Object__c = 'Xva_BatchOpportunityCleanup';
            el.Source_Method__c = 'execute';
           } 
       }
       if(el != null) insert el;
    }
    global void finish(Database.BatchableContext BC) {
    }
}