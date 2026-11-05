trigger AccountRelationTrigger on Account_Relation__c (before insert, before delete, before update) {
    if((Trigger_Denied_Users__c.getAll().get('User_'+UserInfo.getUserId()))==null ){
        Trigger_Settings__mdt TriggerFlag = [SELECT 
                                             Label, isActive__c 
                                             FROM Trigger_Settings__mdt 
                                             where Label = 'AccountRelationTrigger' limit 1];
                                             
        if(TriggerFlag.isActive__c) {  
            // Before Insert Event
            if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
                AccountRelationTriggerEventHandler.beforeInsert(Trigger.new);
            }
            
            // Before Delete Event
            if(Trigger.isBefore && Trigger.isDelete){
                AccountRelationTriggerEventHandler.beforeDelete(Trigger.old, Trigger.oldMap);
            }
            
        }    
        /*
        if(Trigger.isBefore){
        
            if(Trigger.isDelete){
                for(Account_Relation__c accRel : trigger.old){
                   
                    if(!String.isBlank(accRel.AtticusId__c) || !String.isBlank(accRel.GRSId__c) || !String.isBlank(accRel.KeymedsId__c) || !String.isBlank(accRel.PresetID__c)){
                            accRel.addError('You are not allowed to delete the record after it was submitted to backend systems. Please contact your system administrator.');
                    }
                      
                }
            } 
            if(Trigger.isInsert){
                Set<Id> contactIdsSet = new Set<Id>();
                for(Account_Relation__c accRel : trigger.new){                                                        
                        contactIdsSet.add(accRel.Contact__c);
                }  
                List<Non_Attorney_Contact__c> nonAttList = [select id,name, Contact__c, Firm_Name__c, Firm_Name__r.Name, Role__c  from Non_Attorney_Contact__c  
                                                                    where Contact__c in : contactIdsSet];
                                                                    
                Map<Id,List<Non_Attorney_Contact__c>> mapContactIdAndSuppConCount = new Map<Id,List<Non_Attorney_Contact__c>>();
                if(!nonAttList.isEmpty() && nonAttList.size() > 0){
                    for(Non_Attorney_Contact__c nattc : nonAttList){
                        if(mapContactIdAndSuppConCount.get(nattc.Contact__c) == null){
                           mapContactIdAndSuppConCount.put(nattc.Contact__c,new List<Non_Attorney_Contact__c>()); 
                        }
                        mapContactIdAndSuppConCount.get(nattc.Contact__c).add(nattc); 
                    }
                }                                          
                for(Account_Relation__c accRel : trigger.new){
                    if(mapContactIdAndSuppConCount.containsKey(accRel.Contact__c)){
                        List<Non_Attorney_Contact__c> nonAttorneyList = mapContactIdAndSuppConCount.get(accRel.Contact__c);
                        if(!nonAttorneyList.isEmpty() && nonAttorneyList.size() > 0){
                            accRel.addError('The selected Attorney Contact is '+ nonAttorneyList[0].Role__c+ ' in Account: '+ nonAttorneyList[0].Firm_Name__r.Name +'. Please select an Attorney Contact.');
                        }
                        
                    }
                }
            }
        }
        */
    }
}