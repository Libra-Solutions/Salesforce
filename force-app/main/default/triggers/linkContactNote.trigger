trigger linkContactNote on ContentDocumentLink (after insert) {

    set<string> huntIds = new set<string>();
    map<string,string> mapHunt = new map<string,string>();
    List<ContentDocumentLink> lnk = new List<ContentDocumentLink>();

    for(ContentDocumentLink cl : trigger.new){
    
        if(cl.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Hunt_List__c'){
        
        
            huntIds.add(cl.LinkedEntityId);    
        }
    }
    
    if(huntIds.size() > 0){
    
        for(Hunt_List__c hnt : [SELECT id,Attorney_Firm_1__c,Attorney_1__c FROM Hunt_List__c WHERE id =: huntIds]){
        
            mapHunt.put(hnt.id,hnt.Attorney_1__c);
        }
        
        for(ContentDocumentLink cl : trigger.new){
    
            if(cl.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Hunt_List__c' && 
               mapHunt.containsKey(cl.LinkedEntityId)){
               
               ContentDocumentLink clnk = new ContentDocumentLink();
               clnk.LinkedEntityId = mapHunt.get(cl.LinkedEntityId);
               clnk.ContentDocumentId = cl.ContentDocumentId;
               clnk.ShareType = 'I';
               lnk.add(clnk);
            
            }
        }
        
        if(lnk.size() > 0){
        
            insert lnk;
        }
    }
}