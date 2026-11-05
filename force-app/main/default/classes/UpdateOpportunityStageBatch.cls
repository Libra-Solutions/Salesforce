/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
global class UpdateOpportunityStageBatch implements Database.Batchable<sObject>{  
 
    global Database.QueryLocator start(Database.BatchableContext BC){
        Date dt = System.today() - Integer.valueof(label.Opportunity_Auto_Closed);  //LastModifiedDate    
        String query = 'Select id, stagename,(Select id, whatid,LastModifiedDate from tasks where LastModifiedDate  < :dt order by LastModifiedDate  desc limit 1) from Opportunity where stagename != \'Closed won\'';  
        return Database.getQueryLocator(query);  
    }  
   
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Set<Id> opportunityIds = new Set<Id>();  
        Set<Id> aOpportunityIds = new Set<Id>();
        List<Opportunity> updateOppList = new List<Opportunity>();
        
        for(Opportunity opp : scope){   
            for(Task tsk : opp.tasks){
                opportunityIds.add(opp.Id);        
            }
               
        }  
       
        for(Opportunity opp : [Select Id, StageName from Opportunity Where Id IN: opportunityIds]){
            opp.StageName = 'Closed Lost';
            opp.Closed_Lost_Reason__c = 'Auto-Closed by System';
            updateOppList.add(opp);
        }
          
        if(updateOppList.size()>0){
            update updateOppList;    
        } 
    }
   
    global void finish(Database.BatchableContext BC){
        
        
    }
}