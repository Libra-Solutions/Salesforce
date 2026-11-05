trigger PSLastFundedCasesTrigger on PSLastFundedCases__c (after insert,after update,after delete,after undelete) {

    set<string> conIds = new set<string>();
    
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        for(PSLastFundedCases__c ps : trigger.new){
            if(ps.Attorney__c != Null){
                conIds.add(ps.Attorney__c);
            }
        }
    }
    
    if(trigger.isDelete || trigger.isUpdate){
        for(PSLastFundedCases__c ps : trigger.old){
            if(ps.Attorney__c != Null){
                conIds.add(ps.Attorney__c);
            }
        }
    }
    
    if(conIds.size() > 0){
        map<string,contact> mapCon = new map<string,contact>();
        
        for(string str : conIds){
            
            mapCon.put(str,new contact(id=str,Last_Fund_Case__c=Null));
        }
        
        for(PSLastFundedCases__c ps : [SELECT id,Attorney__c,PSDateFunded__c FROM PSLastFundedCases__c WHERE 
                                       Attorney__c =: conIds AND PSDateFunded__c !=: Null]){
        
            if(mapCon.containsKey(ps.Attorney__c)){
                if(mapCon.get(ps.Attorney__c).Last_Fund_Case__c == Null){
                    
                    mapCon.get(ps.Attorney__c).Last_Fund_Case__c = ps.PSDateFunded__c;
                }
                else{
                    if(mapCon.get(ps.Attorney__c).Last_Fund_Case__c < ps.PSDateFunded__c){
                        
                        mapCon.get(ps.Attorney__c).Last_Fund_Case__c = ps.PSDateFunded__c;
                    }
                }
            }
        }
        
        if(mapCon.values().size() > 0){
        
            update mapCon.values();
        }
        
    }

}