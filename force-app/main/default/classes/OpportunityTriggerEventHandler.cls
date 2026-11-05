/**********************************************************
*@author             : 
*@Description        : All Account Trigger event will be managed here. 
*                      Code should be written in the respective handlers and call method from required event method.
**********************************************************/
public class OpportunityTriggerEventHandler {
        
    
    /**
     * All before insert event logic should be called from beforeInsert method
     * @param List<Opportunity> triggerNew
     * @return 
     * @exception Exception On input error.
     * @see 
    */
    public static void beforeInsert(List<Opportunity> triggerNew) {
       
        
        Opportunity opp = triggerNew[0];
        List<Account> accList = [select id, name, HeadQuarter__c  from Account where Id = :opp.AccountId];
        if(accList!=null && accList.size()>0)
        {
            Account acc = accList[0];
            if(acc.HeadQuarter__c==true){opp.addError('It seems you have selected a HeadQuarter Account in \'Choose Existing Account Section\'. Please select a Location.');
            }
        }
        
    }  
    
    
    /**
     * All after insert Event logic should be called from afterInsert method
     * @param List<Opportunity> triggerNew, Map<Id, Opportunity> newMap
     * @return
     * @exception Exception On input error.
     * @see 
    */
    public static void afterInsert(List<Opportunity> triggerNew, Map<Id, Opportunity> newMap) {
        
     Opportunity opp = triggerNew[0];   
     
          Id recTypeIdAuto = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PS-QuickAdd-Auto').getRecordTypeId();
          Id recTypeIdOther = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PS-QuickAdd-Other').getRecordTypeId();
          Id recTypeIdWc = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PS-QuickAdd-WC').getRecordTypeId();
     
         Id recTypeStandard = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Law Firm').getRecordTypeId();
     
     if(opp.recordtypeid == recTypeIdAuto || opp.recordtypeid == recTypeIdOther || opp.recordtypeid == recTypeIdWc)
     {  
         CashtraxEntities.NewCase ncase =  OpportunityTriggerUtilityHandler.CreateNewCase(opp);
         
         if(ncase!=null){ 
            String strCase = JSON.serialize(ncase);
            /* 2024-04-04 Removed to decouple backend systems from trigger logic */
            //PresetSalesforceToCasthraxController.createQuickAdd(strCase,ncase.CRM_ID);
         }
     }
     
     //WOlf Pack scenario  : We need to associate Attorney with the opportunity
     // An OpportunityContactRole is auto created in this scenario with Contact, we can use this contactId for attorney
     if(opp.recordtypeid == recTypeStandard)
     {
        //Check if any OppContactRole is created
        List<OpportunityContactRole> cntList = [select Id, ContactId,OpportunityId from OpportunityContactRole where OpportunityId = :opp.Id order by createdDate desc limit 1];
        if(cntList!=null && cntList.size()>0)
        {
            OpportunityContactRole cntRole = cntList[0];
            /* 2024-04-04 Removed to decouple backend systems from trigger logic */
            //PresetSalesforceToCasthraxController.wolfPackAttorney(cntRole.OpportunityId, cntRole.ContactId);
            
            
        }
         
     }
     
     
    }
    

    /**
     * All after insert Event logic should be called from beforeUpdate method
     * @param String jsonRequest
     * @return String .
     * @exception Exception On input error.
     * @see 
    */
    public static void beforeUpdate(List<Opportunity> triggerNew, List<Opportunity> triggerOld, Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap) {
        
    }
    

    /**
     * All after insert Event logic should be called from afterUpdate method
     * @param List<Opportunity> triggerNew, List<Opportunity> triggerOld, Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap
     * @return 
     * @exception Exception On input error.
     * @see 
    */
    public static void afterUpdate(List<Opportunity> triggerNew, List<Opportunity> triggerOld, Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap) {
        
 
        Id recTypeProvider = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        
        Opportunity opp = triggerNew[0];
 
 
        //Updated from UI Only for Provider Contract Scenario 
        
        if(opp.Contracted__c ==true && opp.StageName=='Closed Won')
        {   
           	system.debug('===If Loop===>');

            //Based on Contracted Product, update the flag on Account Location and contact
       		
            //Get related contact   
            List<OpportunityContactRole> cntList = [select Id, ContactId,OpportunityId from OpportunityContactRole where OpportunityId = :opp.Id order by createdDate desc limit 1];
            
            if(cntList!=null && cntList.size()>0)
            {
                OpportunityContactRole cntRole = cntList[0];
                OpportunityTriggerUtilityHandler.updateAccountContactFlags(opp,cntRole.ContactId);   
            }
            else
            {
               OpportunityTriggerUtilityHandler.updateAccountContactFlags(opp,null); 
            }
    
            /* 2024-04-04 Removed to decouple backend systems from trigger logic */
             //MedlienSalesforceToSystemsController.MedlienSyncSystemsForProvider(opp.AccountId);
    
    
        }
         
        
    }
    
    
    
}