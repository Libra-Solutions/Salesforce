global class BatchSendOppForPendingApprovals implements Database.Batchable<sObject>, Database.Stateful { 
    global List<Opportunity> toBeBetterPricing;
    global Set<id> ownerids;
    global BatchSendOppForPendingApprovals(){
          toBeBetterPricing = new List<Opportunity>();
          ownerids = new Set<id>();
    }
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordTypeName = 'Sizing the Opportunity';
        List<Id> oppIds = new List<Id>();
        String stage1 = 'Closed Won';
        String stage2 = 'Closed Lost';
       /* List<ProcessInstance> processes = [Select TargetObjectId from ProcessInstance where Status = 'Pending'];
        for(ProcessInstance process : processes)
            oppIds.add(process.TargetObjectId);*/
        String query = 'select id,ownerid,name,Account.Name,Total_of_Cases_Firm_Level__c,Total_of_Cases_Firm_Level_Other__c,Current_Total_of_cases__c,How_many_Additional_Funded_Cases__c,Please_enter_your_pricing_request__c,What_would_it_take_additional_Other__c, Atty_ID__c,Atty_Name__c,Attorney__r.Name,What_would_it_take_to_get_the_additional__c,Status__c,Decision_Date__c,StageName,CreatedDate,CreatedBy.Name,Firm_Id__c,Law_Firm_Name__c,Current_Pricing__c,Closed_Won_Lost_Date__c,Pricing_Reverted_Date__c,Comments__c,Recommend_Pricing__c,Deal_Type__c,Recommended_Pricing_ID__c,isFirstOrSecondApproval__c,Stage_Change_Date__c  from Opportunity where isSubmitted__c= true AND StageName !=: stage1 AND StageName !=: stage2 AND RecordType.Name =: recordTypeName';// AND id IN :oppIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> opList) {
        	
            for(Opportunity opp  : opList){
                ownerids.add(opp.ownerid);
                toBeBetterPricing.add(opp);

            }
       }
                       

    
    global void finish(Database.BatchableContext BC) {
        System.debug('@@ toBeBetterPricing '+toBeBetterPricing.size());
         if(toBeBetterPricing.size()>0){
            Map<Id, User> mapOwnerEmail = new Map<Id, User>();
            for(User owner: [SELECT id, Name,email FROM User WHERE id IN:ownerids ]) {
              mapOwnerEmail.put(owner.id, owner);
            }
            String subject = 'There are Sizing Opportunity Requests awaiting your Approval/Rejection';
            String body = 'There are Sizing Requests awaiting your decision. Please use the link below to Approve or Reject all Sizing Requests at your earliest convenience. \n';
            body += '\n';
			body += 'Sizing Approval Queue:';
            body += 'https://oasiscrm.lightning.force.com/lightning/o/Opportunity/list?filterName=00B4M000004aSaOUAU';
             //String finalstr = 'Id,CreatedDate, CreatedBy,Firm ID,Account Name, Attorney ID, Contact Name, Total # of Cases (Firm Level),Other: Total # of Cases (Firm Level), Total # of Funded Cases Last 12m,How many Additional Fundings per MONTH,Please enter your pricing request:,How do we get additional cases?,Request Sub-Type,Current Pricing,Recommended Pricing,Recommended Pricing ID,Management Comments (Confidential),Status,Decision Date,Deal Type,Date Closed Won/Lost,Stage Change Date,StageName,isFirstOrSecondApproval__c,Pricing Reverted Date, Opportunity Link \n';
           // String attName = 'Opporunity List for Last 24 hours ' + system.now().format('YYYYMMDDhhmm') + '.csv';
            String link = 'https://oasiscrm--uatsandbox.lightning.force.com/lightning/r/Opportunity/';
            for(Opportunity opp  : toBeBetterPricing){
                
            link += opp.id+'/view';
            /*String accountName = String.isBlank(opp.Account.Name) ? 'NA' : opp.Account.Name;
            accountName = accountName.replaceAll(',', '');
            String attId = String.isBlank(String.valueof(opp.Atty_ID__c)) ? 'NA' : opp.Atty_ID__c;
            attId = attId.replaceAll(',', '');
            String attName1 = String.isBlank(opp.Attorney__r.Name) ? 'NA' : opp.Attorney__r.Name;
            attName1 = attName1.replaceAll(',', '');
            System.debug('@@ attName1 '+attName1);
            String subType = String.isBlank(opp.What_would_it_take_to_get_the_additional__c) ? 'NA' : opp.What_would_it_take_to_get_the_additional__c;
            subType = subType.replaceAll(',', '');
            String firmId = String.isBlank(opp.Firm_Id__c) ? 'NA' : opp.Firm_Id__c;
            String lawFirmName = String.isBlank(opp.Law_Firm_Name__c) ? 'NA' : opp.Law_Firm_Name__c;
            lawFirmName = lawFirmName.replaceAll(',', '');
            String curPricing = String.isBlank(opp.Current_Pricing__c) ? 'NA' : opp.Current_Pricing__c;
            curPricing = curPricing.replaceAll(',', '');
            String recPricing = String.isBlank(opp.Recommend_Pricing__c) ? 'NA' : opp.Recommend_Pricing__c;
                 recPricing = recPricing.replaceAll(',', '');
            String comment = String.isBlank(opp.Comments__c) ? 'NA' : opp.Comments__c;
            comment = comment.replaceAll(',', '');
            String deal_Type = String.isBlank(opp.Deal_Type__c) ? 'NA' : opp.Deal_Type__c; 
            deal_Type = deal_Type.replaceAll(',', '');
            String totalOfCasesFirmLevel = String.isBlank(opp.Total_of_Cases_Firm_Level__c) ? 'NA' : opp.Total_of_Cases_Firm_Level__c; 
            totalOfCasesFirmLevel = totalOfCasesFirmLevel.replaceAll(',', '');
                String totalOfCasesFirmLevelOther = String.isBlank(String.valueOf(opp.Total_of_Cases_Firm_Level_Other__c)) ? 'NA' : String.valueOf(opp.Total_of_Cases_Firm_Level_Other__c); 
            String currentTotalOfCases = String.isBlank(String.valueOf(opp.Current_Total_of_cases__c)) ? 'NA' : String.valueOf(opp.Current_Total_of_cases__c); 
            currentTotalOfCases = currentTotalOfCases.replaceAll(',', '');
                String howManyAdditionalFundedCases = String.isBlank(String.valueOf(opp.How_many_Additional_Funded_Cases__c)) ? 'NA' : String.valueOf(opp.How_many_Additional_Funded_Cases__c);
            howManyAdditionalFundedCases = howManyAdditionalFundedCases.replaceAll(',', '');
                String pleaseEnterPricingRequest = String.isBlank(opp.Please_enter_your_pricing_request__c) ? 'NA' : opp.Please_enter_your_pricing_request__c; 
            pleaseEnterPricingRequest = pleaseEnterPricingRequest.replaceAll(',', '');
                String whatWouldTakeAdditionalOther = String.isBlank(opp.What_would_it_take_additional_Other__c) ? 'NA' : opp.What_would_it_take_additional_Other__c; 
             whatWouldTakeAdditionalOther = whatWouldTakeAdditionalOther.replaceAll(',', '');
                String status = String.isBlank(opp.Status__c) ? 'NA' : opp.Status__c; 
            status = status.replaceAll(',', '');
                String decisionDate = String.isBlank(String.valueOf(opp.Decision_Date__c)) ? 'NA' : String.valueOf(opp.Decision_Date__c);
             decisionDate = decisionDate.replaceAll(',', '');
                String closedWonLostDate = String.isBlank(String.valueOf(opp.Closed_Won_Lost_Date__c)) ? 'NA' : String.valueOf(opp.Closed_Won_Lost_Date__c);
           closedWonLostDate = closedWonLostDate.replaceAll(',', '');
                String pricingRevertedDate = String.isBlank(String.valueOf(opp.Pricing_Reverted_Date__c)) ? 'NA' : String.valueOf(opp.Pricing_Reverted_Date__c);    
            String recommended_Pricing_ID = String.isBlank(String.valueOf(opp.Recommended_Pricing_ID__c)) ? 'NA' : String.valueOf(opp.Recommended_Pricing_ID__c);  
            String isFirstOrSecondApproval = String.isBlank(opp.isFirstOrSecondApproval__c) ? 'NA' : opp.isFirstOrSecondApproval__c; 
            String StageChangeDate = String.isBlank(String.valueOf(opp.Stage_Change_Date__c)) ? 'NA' : String.valueOf(opp.Stage_Change_Date__c);                 
			String recordString = ''+opp.id+','+opp.CreatedDate+','+opp.CreatedBy.Name+','+firmId+', '+accountName+', '+attId+','+attName1+', '+totalOfCasesFirmLevel+', '+totalOfCasesFirmLevelOther+','+currentTotalOfCases+', '+howManyAdditionalFundedCases+', '+pleaseEnterPricingRequest+', '+whatWouldTakeAdditionalOther+','+subType+', '+curPricing+','+recPricing+','+recommended_Pricing_ID+','+comment+', '+status+', '+decisionDate+','+deal_Type+', '+closedWonLostDate+', '+StageChangeDate+', '+opp.StageName+','+isFirstOrSecondApproval+','+pricingRevertedDate+', '+link+'\n';
            finalstr = finalstr +recordString;*/
            // Create the email attachment    
           
         }
             // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // Define email file attachment list
            Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        
             
          Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
           // efa.setFileName(attName);
          //  efa.setBody(Blob.valueOf(finalstr));
           // emailAttList.add(efa);
                     
            email.setSubject( subject );
            email.setToAddresses( new String[] {'sbattu@oasisfinancial.com','apriyatmo@oasisfinancial.com','rcutlip@oasisfinancial.com','clawler@oasisfinancial.com'} );
            email.setPlainTextBody( body );
           // email.setFileAttachments(emailAttList);
           
            Messaging.SendEmailResult [] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
  		}
    }
}