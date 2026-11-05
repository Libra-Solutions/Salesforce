Public class AccountContactTriggerUtilityHandler {
    
    public static void deleteAccountRelation(List<Account_Relation__c> accRelList) {
         
        for(Account_Relation__c accRel : accRelList){
            if(!accRel.Flow_Flag__c){
                if(!String.isBlank(accRel.AtticusId__c) || !String.isBlank(accRel.GRSId__c) || !String.isBlank(accRel.KeymedsId__c) || !String.isBlank(accRel.PresetID__c)){
                    accRel.addError('You are not allowed to delete the record after it was submitted to backend systems. Please contact your system administrator.');
                }
            }    
        }   
    }
    
    public static void showConRoleError(List<Account_Relation__c> accRelList) {
         
        /*Set<Id> contactIdsSet = new Set<Id>();
            for(Account_Relation__c accRel : accRelList){                                                        
                    contactIdsSet.add(accRel.Contact__c);
            }  
            system.debug('==contactIdsSet==>'+contactIdsSet);                                                    
            List<Non_Attorney_Contact__c> nonAttList = [select id,name, Contact__c, Firm_Name__c, Firm_Name__r.Name, Role__c  from Non_Attorney_Contact__c  
                                                                where Contact__c in : contactIdsSet];
            system.debug('==nonAttList==>'+nonAttList);                                                    
            Map<Id,List<Non_Attorney_Contact__c>> mapContactIdAndSuppConCount = new Map<Id,List<Non_Attorney_Contact__c>>();
            if(!nonAttList.isEmpty() && nonAttList.size() > 0){
                for(Non_Attorney_Contact__c nattc : nonAttList){
                    if(mapContactIdAndSuppConCount.get(nattc.Contact__c) == null){
                       mapContactIdAndSuppConCount.put(nattc.Contact__c,new List<Non_Attorney_Contact__c>()); 
                    }
                    mapContactIdAndSuppConCount.get(nattc.Contact__c).add(nattc); 
                }
            }                                          
            for(Account_Relation__c accRel : accRelList){
                if(mapContactIdAndSuppConCount.containsKey(accRel.Contact__c)){
                    List<Non_Attorney_Contact__c> nonAttorneyList = mapContactIdAndSuppConCount.get(accRel.Contact__c);
                    if(!nonAttorneyList.isEmpty() && nonAttorneyList.size() > 0){
                        accRel.addError('The selected Attorney/Provider Contact is '+ nonAttorneyList[0].Role__c+ ' on Account: '+ nonAttorneyList[0].Firm_Name__r.Name +'. Please select an Attorney or Physician contact.');
                    }
                    
                }
            }   */
    }
}