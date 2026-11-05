global class BatchSendOpportunutyEveryDay implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Opportunity> toBeBetterPricing;
    global List<Opportunity> toBeNonBetterPricing;
    global BatchSendOpportunutyEveryDay(){
        toBeBetterPricing = new List<Opportunity>();
        toBeNonBetterPricing = new List<Opportunity>();
    }
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordTypeName = 'Sizing the Opportunity';
        String query = 'select id,name,Account.Name, Atty_ID__c,Atty_Name__c,What_would_it_take_to_get_the_additional__c,CreatedBy.Name,Firm_Id__c,Law_Firm_Name__c,Current_Pricing__c,	Comments__c,Recommend_Pricing__c from Opportunity where RecordType.Name =: recordTypeName AND createddate >= YESTERDAY';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> opList) {
        try {
            System.debug('@@ opList '+opList.size());
            for(Opportunity op:opList){
                if(op.What_would_it_take_to_get_the_additional__c != 'Better Pricing'){
                    toBeNonBetterPricing.add(op);
                    System.debug('@@ inside if 1');
                }
                if( op.What_would_it_take_to_get_the_additional__c  == 'Better Pricing' &&
                   (op.What_would_it_take_to_get_the_additional__c == 'Other' ||
                    op.What_would_it_take_to_get_the_additional__c == 'More Reductions' ||
                    op.What_would_it_take_to_get_the_additional__c == 'Co-Marketing')){
                    toBeBetterPricing.add(op);
                         System.debug('@@ inside if 2');
                }else if(op.What_would_it_take_to_get_the_additional__c  == 'Better Pricing'){
                    toBeBetterPricing.add(op);
                     System.debug('@@ inside if 3');
                }
                
            }
            
        System.debug('@@ finished toBeBetterPricing 11 '+toBeBetterPricing);
        System.debug('@@ finished toBeNonBetterPricing 22 '+toBeNonBetterPricing);
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('@@ finished toBeBetterPricing '+toBeBetterPricing);
        System.debug('@@ finished toBeNonBetterPricing '+toBeNonBetterPricing);
        
         AsyncApexJob a = [SELECT id, ApexClassId,
                              JobItemsProcessed, TotalJobItems,
                              NumberOfErrors, CreatedBy.Email
                              FROM AsyncApexJob
                              WHERE id = :BC.getJobId()];
        if(toBeBetterPricing.size()>0){
            String body = 'Please use the link below to evaluate and Approve or Reject Pricing Related Sizing Requests. CSV is attached with applicable data.';
            body += 'Approval List View: https://oasiscrm.lightning.force.com/lightning/o/Opportunity/list?filterName=00B4M000004aSaOUAU';
            String subject = 'Sizing Requests to Approve – Pricing Related';
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // Define email file attachment list
            Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        
             
            // Creating the CSV file for successful updates
            String finalstr = 'Id, Opportunity Name, Account Name, Atty_ID__c,Atty_Name__c,Request Sub-Type,CreatedBy Name, Firm_Id__c,Law_Firm_Name__c, Current_Pricing__c,Comments__c,Recommend_Pricing__c,Opportunity Link \n';
            String attName = 'Opporunity List for Last 24 hours ' + system.now().format('YYYYMMDDhhmm') + '.csv';
            String link = 'https://oasiscrm--uatsandbox.lightning.force.com/lightning/r/Opportunity/';
            for(Opportunity opp  : toBeBetterPricing){
                link += opp.id+'/view';
                String accountName = String.isBlank(opp.Account.Name) ? 'NA' : opp.Account.Name;
                String attId = String.isBlank(String.valueof(opp.Atty_ID__c)) ? 'NA' : opp.Atty_ID__c;
                String attName1 = String.isBlank(opp.Atty_Name__c) ? 'NA' : opp.Atty_Name__c;
                String subType = String.isBlank(opp.What_would_it_take_to_get_the_additional__c) ? 'NA' : opp.What_would_it_take_to_get_the_additional__c;
                String firmId = String.isBlank(opp.Firm_Id__c) ? 'NA' : opp.Firm_Id__c;
                String lawFirmName = String.isBlank(opp.Law_Firm_Name__c) ? 'NA' : opp.Law_Firm_Name__c;
                String curPricing = String.isBlank(opp.Current_Pricing__c) ? 'NA' : opp.Current_Pricing__c;
                String recPricing = String.isBlank(opp.Recommend_Pricing__c) ? 'NA' : opp.Recommend_Pricing__c;
                String comment = String.isBlank(opp.Comments__c) ? 'NA' : opp.Comments__c;
                String recordString = '"'+opp.id+'","'+opp.Name+'","'+accountName+'","'+attId+'","'+attName1+'","'+subType+'","'+opp.CreatedBy.Name+'","'+firmId+'","'+lawFirmName+'","'+curPricing+'","'+recPricing+'","'+comment+'","'+link+'"\n';
                finalstr = finalstr +recordString;
            }
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            emailAttList.add(efa);
                     
            email.setSubject( subject );
            email.setToAddresses( new String[] {'sbattu@oasisfinancial.com','apriyatmo@oasisfinancial.com','jrufo@oasisfinancial.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(emailAttList);
           
            Messaging.SendEmailResult [] r =
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
             
        }
        
       /* if(toBeNonBetterPricing.size()>0){
            String body = 'Please use the link below to evaluate and Approve or Reject Pricing Related Sizing Requests. CSV is attached with applicable data.';
            String subject = 'Sizing Requests to Approve – Non Pricing Related';
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // Define email file attachment list
            Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        
            // Creating the CSV file for successful updates
            String finalstr = 'Id, Opportunity Name, Account Name, Atty_ID__c,Atty_Name__c,Request Sub-Type,CreatedBy Name, Firm_Id__c,Law_Firm_Name__c, Current_Pricing__c,Comments__c,Recommend_Pricing__c,Opportunity Link \n';
            String attName = 'Opporunity List for Last 24 hours ' + system.now().format('YYYYMMDDhhmm') + '.csv';
            String link = 'https://oasiscrm--uatsandbox.lightning.force.com/lightning/r/Opportunity/';
            for(Opportunity opp  : toBeNonBetterPricing){
                link += opp.id+'/view';
                String accountName = String.isBlank(opp.Account.Name) ? 'NA' : opp.Account.Name;
                String attId = String.isBlank(String.valueof(opp.Atty_ID__c)) ? 'NA' : opp.Atty_ID__c;
                String attName1 = String.isBlank(opp.Atty_Name__c) ? 'NA' : opp.Atty_Name__c;
                String subType = String.isBlank(opp.What_would_it_take_to_get_the_additional__c) ? 'NA' : opp.What_would_it_take_to_get_the_additional__c;
                String firmId = String.isBlank(opp.Firm_Id__c) ? 'NA' : opp.Firm_Id__c;
                String lawFirmName = String.isBlank(opp.Law_Firm_Name__c) ? 'NA' : opp.Law_Firm_Name__c;
                String curPricing = String.isBlank(opp.Current_Pricing__c) ? 'NA' : opp.Current_Pricing__c;
                String recPricing = String.isBlank(opp.Recommend_Pricing__c) ? 'NA' : opp.Recommend_Pricing__c;
                String comment = String.isBlank(opp.Comments__c) ? 'NA' : opp.Comments__c;
                String recordString = '"'+opp.id+'","'+opp.Name+'","'+accountName+'","'+attId+'","'+attName1+'","'+subType+'","'+opp.CreatedBy.Name+'","'+firmId+'","'+lawFirmName+'","'+curPricing+'","'+recPricing+'","'+comment+'","'+link+'"\n';
                finalstr = finalstr +recordString;
            }
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            emailAttList.add(efa);
                     
                
            // Sets the paramaters of the email
            email.setSubject( subject );
            email.setToAddresses( new String[] {'sbattu@oasisfinancial.com','clawler@oasisfinancial.com','rcutlip@oasisfinancial.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(emailAttList);
           
            // Sends the email
            Messaging.SendEmailResult [] r =
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
             
        }*/
  	}
}