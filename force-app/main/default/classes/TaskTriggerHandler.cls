public class TaskTriggerHandler {

    @future
    public static void linkContactFutureMethod(set<string> tskIds,set<string> huntIds)
    {  
        if(huntIds.size() > 0){
            
            map<string,Hunt_List__c> mapHunt = new map<string,Hunt_List__c>();
            list<task> lstTsk = new list<task>();
            
            for(Hunt_List__c objHunt : [SELECT id,Attorney_1__c FROM Hunt_List__c WHERE id =: huntIds]){
                mapHunt.put(objHunt.id,objHunt);                            
            }
            
            for(task tsk : [SELECT id,whatId,whoId FROM task WHERE id =: tskIds]){
            
                if(tsk.WhatId !=Null){
                    if(tsk.WhatId.getSObjectType().getDescribe().getName()=='Hunt_List__c')
                    {
                        if(mapHunt.containsKey(tsk.whatId)){
                        
                            tsk.whoId = mapHunt.get(tsk.whatId).Attorney_1__c;    
                            lstTsk.add(tsk);
                        }
                    }
                }    
            }
            
            if(lstTsk.size() > 0){
            
                update lstTsk;
            }
        }
    }
     public static void crmActivitysPreset(Map<id,Task> newMapRecords){
        Set<id> setOfActivityIds=new Set<id>();
        //check Account and contact task Records
        for(id ids:newMapRecords.keyset()){
            if((newMapRecords.get(ids).Whatid!=null && (newMapRecords.get(ids).Whatid).getSObjectType()+''=='Account')||
              (newMapRecords.get(ids).WhoID!=null && (newMapRecords.get(ids).WhoID).getSObjectType()+''=='Contact')){
                  setOfActivityIds.add(ids);
             }
         }
        if(!test.isrunningtest()){
             System.enqueueJob(new PresetCRMActivityQueuebleJob (setOfActivityIds));
         }
    }      
}