trigger PSLast3CasesPaidinFullTrigger on PS_Last3Cases_Paid_In_Full__c (after insert,after update,after delete,after undelete) {
set<string> conIds = new set<string>();
    
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        for(PS_Last3Cases_Paid_In_Full__c ps : trigger.new){
            if(ps.Attorney__c != Null){
                conIds.add(ps.Attorney__c);
            }
        }
    }
    
    if(trigger.isDelete || trigger.isUpdate){
        for(PS_Last3Cases_Paid_In_Full__c ps : trigger.old){
            if(ps.Attorney__c != Null){
                conIds.add(ps.Attorney__c);
            }
        }
    }
    
    if(conIds.size() > 0){
        map<string,contact> mapCon = new map<string,contact>();
        
        for(string str : conIds){
            
            mapCon.put(str,new contact(id=str,Last_Payment_Date__c=Null,Amount_Paid__c=Null));
        }
        
        for(PS_Last3Cases_Paid_In_Full__c ps : [SELECT id,Attorney__c,Last_Payment_Date__c,Amount_Paid__c FROM PS_Last3Cases_Paid_In_Full__c WHERE 
                                       Attorney__c =: conIds AND Last_Payment_Date__c !=: Null AND Amount_Paid__c !=:Null]){
        
            if(mapCon.containsKey(ps.Attorney__c)){
                if(mapCon.get(ps.Attorney__c).Last_Payment_Date__c == Null){
                    
                    mapCon.get(ps.Attorney__c).Last_Payment_Date__c = ps.Last_Payment_Date__c;
                    mapCon.get(ps.Attorney__c).Amount_Paid__c= ps.Amount_Paid__c;
                }
                else{
                    if(mapCon.get(ps.Attorney__c).Last_Payment_Date__c < ps.Last_Payment_Date__c){
                        
                        mapCon.get(ps.Attorney__c).Last_Payment_Date__c = ps.Last_Payment_Date__c;
                        mapCon.get(ps.Attorney__c).Amount_Paid__c = ps.Amount_Paid__c;
                    }
                }
            }
        }
        
        if(mapCon.values().size() > 0){
        
            update mapCon.values();
        }
        
    }
}