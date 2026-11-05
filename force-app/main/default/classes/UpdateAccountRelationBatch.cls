/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
global class UpdateAccountRelationBatch implements Database.Batchable<sObject>{  
 
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'Select id, Account__c, Account_Relation__c, Attorney__c from PS_View360__c where Account_Relation__c = null';  
        return Database.getQueryLocator(query);  
    }  
   
    global void execute(Database.BatchableContext BC, List<PS_View360__c> scope){
         Set<Id> accountIds = new Set<Id>();
         Set<Id> contactIds = new Set<Id>();
         Map<String, Id> mapOfAccConIdAndAccRelId = new Map<String, Id>();
         list<PS_View360__c> updatePSViewList = new list<PS_View360__c>();
         for(PS_View360__c psView : scope){
             accountIds.add(psView.Account__c);
             contactIds.add(psView.Attorney__c);
         }
         
         
         for(Account_Relation__c acRel : [Select Id, Account__c, Contact__c from Account_Relation__c 
             where Contact__c IN :contactIds AND Account__c IN :accountIds]){mapOfAccConIdAndAccRelId.put(acRel.Account__c+''+acRel.Contact__c,acRel.Id);
         }
         
         
         for(PS_View360__c psView : scope){
             if(mapOfAccConIdAndAccRelId.containskey(psView.Account__c+''+psView.Attorney__c)){
                 psView.Account_Relation__c = mapOfAccConIdAndAccRelId.get(psView.Account__c+''+psView.Attorney__c);
                 updatePSViewList.add(psView);
             }
             
         }
         
         if(updatePSViewList.size()>0){update updatePSViewList;
         }
    }
   
    global void finish(Database.BatchableContext BC){
        
        
    }
}