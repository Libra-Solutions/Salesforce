trigger NonAttorneyContactTrigger on Non_Attorney_Contact__c (after update, before delete, before insert, before update) {
    
    if((Trigger_Denied_Users__c.getAll().get('User_'+UserInfo.getUserId()))==null ){
    
          Trigger_Settings__mdt TriggerFlag = [SELECT 
                                             Label, isActive__c 
                                             FROM Trigger_Settings__mdt 
                                             where Label = 'NonAttorneyTrigger' limit 1];
         
                                             
        if(TriggerFlag.isActive__c) {
            
            // After Update Event
            if(Trigger.isAfter && Trigger.isUpdate){
                //NonAttorneyTriggerEventHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
            }
            if(Trigger.isBefore){
                if(Trigger.isDelete){
                    for(Non_Attorney_Contact__c  accRel : trigger.old){
                        if(!String.isBlank(accRel.AtticusId__c) || accRel.GRSId__c != null || accRel.KeymedsId__c != null || accRel.PresetID__c != null){
                            accRel.addError('You are not allowed to delete the record after it was submitted to backend systems. Please contact your system administrator.');
                        }
                    }
                }
                }
                
            /*    
                if(Trigger.isInsert || Trigger.isUpdate){
                    Set<Id> attProviderIdsSet = new Set<Id>();
                    Set<Id> suppContactIdsSet = new Set<Id>();
                    for(Non_Attorney_Contact__c  nac : trigger.new){
                        attProviderIdsSet.add(nac.Attorney__c);
                        suppContactIdsSet.add(nac.Contact__c);                    
                    }
                    // This is for Attorney
                    List<Non_Attorney_Contact__c> nonAttList = [select id,name, Attorney__c, Contact__c, Firm_Name__c, Firm_Name__r.Name, Role__c  from Non_Attorney_Contact__c  
                                                                    where Contact__c in : attProviderIdsSet];
                                                                    
                                     
                     Map<Id,List<Non_Attorney_Contact__c>> mapContactIdAndSuppConCount = new Map<Id,List<Non_Attorney_Contact__c>>();
                     if(!nonAttList.isEmpty() && nonAttList.size() > 0){
                        for(Non_Attorney_Contact__c nattc : nonAttList){
                            if(mapContactIdAndSuppConCount.get(nattc.Contact__c) == null){
                               mapContactIdAndSuppConCount.put(nattc.Contact__c,new List<Non_Attorney_Contact__c>()); 
                            }
                            mapContactIdAndSuppConCount.get(nattc.Contact__c).add(nattc); 
                        }
                    } 
                   for(Non_Attorney_Contact__c  nac : trigger.new){
                        if(mapContactIdAndSuppConCount.containsKey(nac.Attorney__c)){
                            List<Non_Attorney_Contact__c> nonAttorneyList = mapContactIdAndSuppConCount.get(nac.Attorney__c);
                            if(!nonAttorneyList.isEmpty() && nonAttorneyList.size() > 0){
                                nac.addError('The selected Attorney Contact is '+ nonAttorneyList[0].Role__c+ ' in Account: '+ nonAttorneyList[0].Firm_Name__r.Name +'. Please select an Attorney Contact.');
                            }
                            
                        }                   
                    }
                    // This is for Support Contact
                    List<Account_Relation__c> accRelList = [Select id, Name , Contact__c, Account__c, Role__c, Account__r.Name from Account_Relation__c 
                                                                    where Contact__c in : suppContactIdsSet];
                    Map<Id,List<Account_Relation__c>> mapContactIdAndAccRel = new Map<Id,List<Account_Relation__c>>();
                    if(!accRelList.isEmpty() && accRelList.size() > 0){
                        for(Account_Relation__c accR : accRelList){
                            if(mapContactIdAndAccRel.get(accR.Contact__c) == null){
                               mapContactIdAndAccRel .put(accR.Contact__c,new List<Account_Relation__c>()); 
                            }
                            mapContactIdAndAccRel.get(accR.Contact__c).add(accR); 
                        }
                    } 
                    for(Non_Attorney_Contact__c  nac : trigger.new){
                        if(mapContactIdAndSuppConCount.containsKey(nac.Attorney__c)){
                            List<Non_Attorney_Contact__c> nonAttorneyList = mapContactIdAndSuppConCount.get(nac.Attorney__c);
                            if(!nonAttorneyList.isEmpty() && nonAttorneyList.size() > 0){
                                nac.addError('The selected Attorney/Provider Contact is '+ nonAttorneyList[0].Role__c+ ' on Account: '+ nonAttorneyList[0].Firm_Name__r.Name +'. Please select an Attorney Contact.');
                            }
                            
                        }
                        if(mapContactIdAndAccRel.containsKey(nac.Contact__c)){
                            List<Account_Relation__c> accRRList = mapContactIdAndAccRel.get(nac.Contact__c);
                            if(!accRRList.isEmpty() && accRRList.size() > 0){
                                nac.addError('The selected Support Contact is '+ accRRList[0].Role__c+ ' on Account: '+ accRRList[0].Account__r.Name +'. Please select a Contact in Support role.');
                            }
                            
                        }                   
                    }
                }
                
               
            } */
        }    
    }
}