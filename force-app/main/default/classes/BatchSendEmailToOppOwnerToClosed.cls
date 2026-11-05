global class BatchSendEmailToOppOwnerToClosed implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Opportunity> lstSendEmailToOppOwnerToClosed;
    global BatchSendEmailToOppOwnerToClosed(){
        lstSendEmailToOppOwnerToClosed = new List<Opportunity>();
    }
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordTypeName = 'Sizing the Opportunity';
        String StageName = 'Opportunity Request Approved-Need to Confirm with Atty';
        String query = 'select id,name,Account.Name,StageName,CreatedBy.Name,Law_Firm_Name__c,OwnerId from Opportunity where RecordType.Name =: recordTypeName AND StageName =: StageName';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> opList) {
        try {
            for(Opportunity op:opList){
               lstSendEmailToOppOwnerToClosed.add(op);
                
            }
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('@@ finished '+lstSendEmailToOppOwnerToClosed);
        
        if(lstSendEmailToOppOwnerToClosed.size()>0){
            Set<Id> userId = new Set<Id>();
            for(Opportunity opp  : lstSendEmailToOppOwnerToClosed){
                userId.add(opp.OwnerId);
            }
            Map<Id, User> mapCreatedUser = new Map<Id, User>();

            for(User owner: [SELECT id, Name,email FROM User WHERE id IN:userId ]) {
              mapCreatedUser.put(owner.id, owner);
            }
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(Opportunity op  : lstSendEmailToOppOwnerToClosed){
              	String body = mapCreatedUser.get(op.OwnerId).Name+' <br><br> ';
                body += 'Please reach out to '+op.Law_Firm_Name__c+' and communicate the new agreement details. Then, mark the Sizing Opportunity as Closed-Won or Closed-Lost.<br><br>';
                body += 'Opportunity Link: https://oasiscrm--uatsandbox.lightning.force.com/'+op.Id;
                String subject = 'Sizing Opportunity pending Close – Action Needed';
                
                String[] toAddresses = new String[] {mapCreatedUser.get(op.ownerid).email};

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(op.OwnerID);
                mail.setWhatId(op.id);     
                mail.setUseSignature(false);
                mail.setBccSender(false);
                mail.setSaveAsActivity(false);  
                mail.setSubject(subject);
                mail.setToAddresses(toAddresses);
                mail.setHtmlBody(body);
               // mail.setPlainTextBody(body);
                mails.add(mail);
            }
            if(mails.size()>0)
                Messaging.sendEmail(mails);
            	//Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mails});        

        }
  	}
}