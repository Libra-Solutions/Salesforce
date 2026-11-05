/**********************************************************
    *@author             : 
    *@Version            : V 1.0
    *@Description        : 
    *@Test class         :
    **********************************************************/
Public class ContactTriggerUtilityHandler {
    
    

    /**
     * Restrict to change Mailing Address directly from Contact if Account relation AtticusId, GRSId, KeymedsId and PresetId field is having some value.
     * @param List<Contact>, Map<Id, Contact>
     * @return Nothing.
     * @exception Exception On input error.
     * @see 
    */  
    Public static void restictAddress(List<Contact> conList, Map<Id, Contact> oldMap) {
     /*   
        for(Contact con : conList){          
            if(con.MailingCity != oldMap.get(con.Id).MailingCity ||
               con.MailingState != oldMap.get(con.Id).MailingState || 
               con.MailingPostalCode != oldMap.get(con.Id).MailingPostalCode || 
               con.MailingStreet != oldMap.get(con.Id).MailingStreet){  con.adderror('Address will only be updated at Firm Location level');
                   
                   
               }     
        }
       */ 
        /*
        for(Account_Relation__c aRelation : [Select 
                                             id, Account__c, Contact__c, AtticusId__c, GRSId__c, KeymedsId__c, PresetID__c 
                                             from Account_Relation__c 
                                             where Account__c IN :mapOfAccIdAndConId.keyset() AND Contact__c IN :mapOfAccIdAndConId.values()]){                                   
             
                                                 //if((aRelation.AtticusId__c != null || aRelation.GRSId__c != null || aRelation.KeymedsId__c != null ||  aRelation.PresetID__c != null)){
                                                     checkValue = true;
                                                 //}
        }
        */   
        
    }
    
    
    /* 2024-04-04 - Removed to decouple calls pushing data down to back end systems */
      /**
       * Send back to end systems
       * @param List<Contact>
       * @return Nothing.
       * @exception Exception On input error.
       * @see */
      
        /*
      public static void sendToBackEndSystems(List<Contact> contactList, Map<Id, Contact> oldMap) 
      {
        
          Id recTypeIdConProvider = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
          Id recTypeIdConAttorney = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();
        
          Map<Id,Boolean> contactIdPresetMap = new Map<Id,Boolean>();
          Map<Id,Boolean> contactIdKeyMedsMap = new Map<Id,Boolean>();
          
          
          system.debug('----------cnt trigger CashtraxEntities.UpdatedByCashtrax ---------------'+CashtraxEntities.UpdatedByCashtrax );
         
         //Check for Attorney .
             List<Account_Relation__c> accRelationList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,PresetID__c ,Contact__c, Account__c,Role__c , Account__r.Type,
                                                          Account__r.GRSId__c,Account__r.KeyMedsID__c, Account__r.AtticusId__c 
                                                          from Account_Relation__c 
                                                          where Contact__c IN :oldMap.keySet() and Role__c IN ('Attorney','Physician') 
                                                          and ((PresetID__c != null) or (GRSId__c !=null and GRSId__c!='0') or (KeyMedsID__c!=null and KeyMedsID__c!='0') or AtticusId__c!=null) ];
              if(accRelationList!=null && accRelationList.size()>0){                                            
                  for(Account_Relation__c rel : accRelationList)
                  {
                     if( Utility.IsNonZero(rel.PresetID__c)) contactIdPresetMap.put(rel.Contact__c, true);
                     if( Utility.IsNonZero(rel.KeyMedsID__c) || Utility.IsNonZero(rel.AtticusId__c) || Utility.IsNonZero(rel.GRSId__c)) contactIdKeyMedsMap.put(rel.Contact__c, true);
                  }
              }
         
            //Check for Non-Attorneys too
             List<Non_Attorney_Contact__c> supportList = [select Id, GRSId__c, KeyMedsID__c,AtticusId__c,PresetID__c , Contact__c, Role__c,Attorney__c, Firm_Name__c,Firm_Name__r.Type,
                                                          Firm_Name__r.GRSId__c,Firm_Name__r.KeyMedsID__c, Firm_Name__r.AtticusId__c 
                                                          from Non_Attorney_Contact__c 
                                                          where Contact__c IN  :oldMap.keySet()   
                                                           and ((PresetID__c != null) or (GRSId__c !=null and GRSId__c!=0) or (KeyMedsID__c!=null and KeyMedsID__c!=0) or AtticusId__c!=null) ];
                
                
                if(supportList !=null && supportList.size()>0){                                            
                  for(Non_Attorney_Contact__c rel : supportList)
                  {
                     if( Utility.IsNonZero(String.valueOf(rel.PresetID__c))) contactIdPresetMap.put(rel.Contact__c, true);
                     if( Utility.IsNonZero(String.valueOf(rel.KeyMedsID__c)) || Utility.IsNonZero(rel.AtticusId__c) || Utility.IsNonZero(String.valueOf(rel.GRSId__c))) contactIdKeyMedsMap.put(rel.Contact__c, true);
                  }
              } 
          
          boolean preset=false,ml=false;
        for(Contact cnt: contactList)
        {
        
            preset=false;ml=false;
           // if(cnt.firstname != oldMap.get(cnt.id).firstname || cnt.lastname != oldMap.get(cnt.id).lastname || cnt.email != oldMap.get(cnt.id).email || cnt.Phone != oldMap.get(cnt.id).Phone || cnt.fax != oldMap.get(cnt.id).fax || cnt.Atticus__c != oldMap.get(cnt.id).Atticus__c ||  cnt.GRS__c != oldMap.get(cnt.id).GRS__c || cnt.PreSet__c != oldMap.get(cnt.id).Preset__c || cnt.Core__c != oldMap.get(cnt.id).Core__c || cnt.Accident_Meds__c != oldMap.get(cnt.id).Accident_Meds__c )
           //{
             
              if(contactIdPresetMap.get(cnt.Id)!=null) preset = contactIdPresetMap.get(cnt.Id);
              if(contactIdKeyMedsMap.get(cnt.Id)!=null) ml = contactIdKeyMedsMap.get(cnt.Id);
              
            
            //2024-04-04 - Removed to completely remove the calls to external systems

              //Do not call if updated by CTX itself  or no presetid but fire if coming from opp contracted or if Test is running
               //if((CashtraxEntities.UpdatedByCashtrax == false && preset==true && !Test.isRunningTest()))//|| MedlienSalesforceService.OpportunityContractedFlag ==true)
               //{ 
                //PresetSalesforceToCasthraxController.UpdateContactCTX(cnt.Id);
               //}
               //if(ml==true)// || MedlienSalesforceService.OpportunityContractedFlag ==true) 
              // {
               // MedlienSalesforceToSystemsController.UpdateContactML(cnt.Id);
              // }
          //}  
          
        } 
      } */
      
      
      public static void UpdateAccountrealatection(List<Contact> lstOfNewContacts, Map<Id, Contact> mapOfOldContacts)  {
        Map<id,id> mapofOldAccIds=new Map<id,id>();
        Map<id,id> mapOfAccConIds=new Map<id,id>();
        Map<Id, Contact> mapOfNewContacts = new Map<Id, Contact>(lstOfNewContacts);
        for(Contact con:lstOfNewContacts){
            if(con.Accountid!=null && mapOfOldContacts.get(con.id).accountid!=null && 
             con.Accountid!=mapOfOldContacts.get(con.id).accountid &&
             !mapofOldAccIds.containsKey(mapOfOldContacts.get(con.id).Accountid)){
              mapofOldAccIds.put(mapOfOldContacts.get(con.id).accountid,con.Accountid);
              mapOfAccConIds.put(con.id,mapOfOldContacts.get(con.id).accountid);
          }
        }
        if(mapofOldAccIds.size()>0){
            List<Account_Relation__c> lstOfAccRels=new List<Account_Relation__c >();
            for(Account_Relation__c acc:[select id,Account__c,Contact__c, Account__r.Cimi_Id__c from Account_Relation__c 
                                      where Account__c in:mapofOldAccIds.keySet() and Contact__c in:mapOfAccConIds.keyset()]){
                                    
                      Contact contact = mapOfNewContacts.get(acc.Contact__c);
                      //check to see if this is a combined contact AND a cimi account - if it is, do not move the cimi relations 
                      //2024-11-18 - added this filter after a conversation with Rajiv about moving combined contacts

                      if (contact.MD_User_ID__c != null && contact.CashTrax_ID__c != null && acc.Account__r.Cimi_Id__c != null) continue;

                       Account_Relation__c accRel=new Account_Relation__c ();
                       accRel.id=acc.id;
                       accRel.Account__c=mapofOldAccIds.get(acc.account__c);            
                       lstOfAccRels.add(accRel);
    
            }
    
            if(lstOfAccRels.size()>0){
              update lstOfAccRels;
            }
            
            List<AccountContactRelation> lstOfAccConRels=[select id from AccountContactRelation 
                                                         where AccountId in:mapofOldAccIds.keyset() and
                                                         ContactId in:mapOfAccConIds.keySet()];
            
            if(lstOfAccConRels.size()>0){
                 delete lstOfAccConRels;
            }
            
            
            System.debug('##lstOfAccRels'+lstOfAccRels);
        }
          
    }
}