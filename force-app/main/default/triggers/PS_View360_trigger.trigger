trigger PS_View360_trigger on PS_View360__c (after insert,after update,after delete,after undelete) {

/* 1/26/2021 Trigger is turned off, as the batch aspect is not handled for a single SoQL lookup
              This will have to be redone.  */
 Trigger_Settings__mdt TriggerFlag = [SELECT 
                                             Label, isActive__c 
                                             FROM Trigger_Settings__mdt 
                                             where Label ='PSView360trigger' limit 1];
   


    if(trigger.isAfter){

        set<string> conIds = new set<string>();
        if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
            for(PS_View360__c ps : trigger.new){                         
           
               if(ps.Attorney__c != Null){
               
                   conIds.add(ps.Attorney__c);
               }
           }       
        }
        
        if(trigger.isDelete || trigger.isUpdate){
            for(PS_View360__c ps : trigger.old){       
           
               if(ps.Attorney__c != Null){
               
                   conIds.add(ps.Attorney__c);
               }
           }           
       }
       
       if(conIds.size() > 0){
           
           map<string,contact> mapCon = new map<string,contact>();
           
           for(string str : conIds){
           
               mapCon.put(str,new contact(id=str,No_of_Funded_Cases__c=0,Funded__c=0, of_Total_Cases__c=0, Total_of_Applications__c=0,Total_of_Fundings__c=0));
           }
           
           for(PS_View360__c ps : [SELECT id,Attorney__c,No_of_Funded_Cases__c,Funded__c,No_of_Total_Cases__c,Total_of_Applications__c, Total_of_Fundings__c, OwnerEmail__c FROM PS_View360__c WHERE Attorney__c =: conIds]){
           
               if(mapCon.containskey(ps.Attorney__c)){
               
                   if(ps.No_of_Funded_Cases__c != Null){
                       mapCon.get(ps.Attorney__c).No_of_Funded_Cases__c += ps.No_of_Funded_Cases__c;
                   }
                   
                   if(ps.Funded__c != Null){
                       mapCon.get(ps.Attorney__c).Funded__c += ps.Funded__c;
                   }
                   
                   if(ps.No_of_Total_Cases__c!= Null){
                       mapCon.get(ps.Attorney__c).of_Total_Cases__c += ps.No_of_Total_Cases__c;
                   }
                   if(ps.Total_of_Applications__c!= Null){
                       mapCon.get(ps.Attorney__c).Total_of_Applications__c += ps.Total_of_Applications__c;
                   }
                   if(ps.Total_of_Fundings__c!= Null){
                       mapCon.get(ps.Attorney__c).Total_of_Fundings__c += ps.Total_of_Fundings__c;
                   }
                   // Modified 7/27/2020 DW to pull owner Email
                   if(String.isNotBlank(String.valueOf(ps.OwnerEmail__c)))
                   {    User Usr = new User();
                        Usr =[SELECT Id, Name, Email FROM User where Email=:ps.OwnerEmail__c ];
                        mapCon.get(ps.Attorney__c).OwnerId = Usr.Id;   // UserId
                   }
              
               }    
           }
           
           if(mapCon.values().size() > 0){
           
               update mapCon.values();
           }
           
       }
   }
    
}