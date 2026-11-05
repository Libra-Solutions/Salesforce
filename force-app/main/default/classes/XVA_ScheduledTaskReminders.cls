global with sharing class XVA_ScheduledTaskReminders implements Schedulable {

    public Date activityDateOverride = null;

    public XVA_ScheduledTaskReminders() {
    }

    public XVA_SCheduledTaskReminders(Date activityDateOverride) {
        this.activityDateOverride = activityDateOverride;
    }




    global void execute(SchedulableContext sc) {
        List<Task> threeDayReminderTasks = [SELECT Id, subject, owner.name, ownerid, owner.email, activitydate, status, isclosed FROM Task WHERE (activitydate =: Date.Today().addDays(3) AND isclosed = false) AND (subject IN ('Website Request Reachout - Demo', 'CMS Demo Follow Up') OR Parsed_From_EMail__c = true or  (from_ms_bookings__c = true AND ownerid != null))];
        List<Task> oneDayReminderTasks = [SELECT Id, subject, owner.name, ownerid, owner.email, activitydate, status, isclosed FROM Task WHERE (activitydate =: Date.Today().addDays(1) AND isclosed = false) AND (subject IN ('Website Request Reachout - Demo', 'CMS Demo Follow Up' ) OR Parsed_From_EMail__c = true or (from_ms_bookings__c = true AND ownerid != null))];
        List<Task> oneDayLateReminderTasks = [SELECT Id, subject, owner.name, ownerid, owner.email, activitydate, status, isclosed, provider__c, rvp__r.email FROM Task WHERE (activitydate =: Date.Today().addDays((-1)) AND isclosed = false) AND (subject IN ('Website Request Reachout - Demo', 'CMS Demo Follow Up') OR Parsed_From_EMail__c = true OR (from_ms_bookings__c = true AND ownerid != null))];
        Id orgWideEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'khenderson@librasolutionsgroup.com' LIMIT 1].Id;
        if(!threeDayReminderTasks.isEmpty()){

            List<messaging.singleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for(Task tsk: threeDayReminderTasks){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String url = System.URL.getOrgDomainUrl().toExternalForm() + '/'+ tsk.id;
                string htmlbody  = '<html><body>Dear '+tsk.owner.name+',<br><br>This task is due in 3 days: <a href="'+url+'">'+tsk.subject+'</a>.<br><br>Regards,<br></body></html>';
                email.setSubject('Reminder: Your Task is due in 3 Days');
                email.setHtmlBody(htmlbody);
                email.setOrgwideEmailAddressId(orgWideEmailId);
                string toEmailAddress = (Test.isRunningTest()) ? 'fakeEmailAddy@nomailer.com' : tsk.owner.email + (runningInASandbox ? '.sandbox' : '');
                email.setToAddresses(new List<String>{toEmailAddress});
                if (runningInASandbox)
                {
                    email.WhatId = tsk.Id;
                    WriteChatterNotification(tsk.Id, htmlbody, email.getSubject(), new List<String>{toEmailAddress});
                    
                }
                emails.add(email);
            }
            Messaging.sendEmail(emails);
        }

        if(!oneDayReminderTasks.isEmpty()){
            List<messaging.singleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for(Task tsk: oneDayReminderTasks){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String url = System.URL.getOrgDomainUrl().toExternalForm() + '/'+ tsk.id;
                string htmlbody  = '<html><body>Dear '+tsk.owner.name+',<br><br>This task is due tomorrow: <a href="'+url+'">'+tsk.subject+'</a>.<br><br>Regards,<br></body></html>';
                email.setSubject('Reminder: Your Task is due tomorrow');
                email.setHtmlBody(htmlbody);
                email.setOrgwideEmailAddressId(orgWideEmailId);
                string toEmailAddress = (Test.isRunningTest()) ? 'fakeEmailAddy@nomailer.com' : tsk.owner.email + (runningInASandbox ? '.sandbox' : '');
                email.setToAddresses(new List<String>{toEmailAddress});
                
                if (runningInASandbox)
                {

                    email.setSaveAsActivity(true);    
                     WriteChatterNotification(tsk.Id, htmlbody, email.getSubject(), new List<String>{toEmailAddress});   
                }
                
                emails.add(email);
            }
            Messaging.sendEmail(emails);
        }

        if(!oneDayLateReminderTasks.isEmpty()){
            List<messaging.singleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for(Task tsk: oneDayLateReminderTasks){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String url = System.URL.getOrgDomainUrl().toExternalForm() + '/'+ tsk.id;
                string htmlbody  = '<html><body>Dear '+tsk.owner.name+',<br><br>This task is past due: <a href="'+url+'">'+tsk.subject+'</a>.<br><br>Regards,<br></body></html>';
                email.setSubject('Reminder: Your Task is past due');
                email.setHtmlBody(htmlbody);
                email.setOrgwideEmailAddressId(orgWideEmailId);
                List<String> toEmails = new List<String>();
                toEmails.add((Test.isRunningTest()) ? 'fakeEmailAddy@nomailer.com' : tsk.owner.email + (runningInASandbox ? '.sandbox' : ''));
                if(tsk.rvp__c != null) toEmails.add(tsk.rvp__r.email + (runningInASandbox ? '.sandbox' : ''));
                if (tsk.provider__c) { 
                    toEmails.add('miglinski@syndeocare.com' + (runningInASandbox ? '.sandbox' : ''));
                } 
                else {
                    toEmails.add( 'jason@oasisfinancial.com' + (runningInASandbox ? '.sandbox' : ''));    
                    toEmails.add('dgraubart@oasisfinancial.com' + (runningInASandbox ? '.sandbox' : ''));
                }
                
                email.setToAddresses(toEmails);
                if (runningInASandbox)
                {

                    email.setSaveAsActivity(true);     
                     WriteChatterNotification(tsk.Id, htmlbody, email.getSubject(), toEmails);
                }
                
                emails.add(email);
            }
            Messaging.sendEmail(emails);
        }
    }

    public Boolean runningInASandbox {
    get {
        if (runningInASandbox == null) {
            runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        }
        return runningInASandbox;
    }
    set;
}
    
    public void WriteChatterNotification(string targetId, string message, string subject, List<String> toEmails) {
        

        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'To: ' + string.join( toEmails, ', ') + '<p>&nbsp;</p>Subject: ' + subject + ' body: ' + message.replace('<br>', '<p>&nbsp;</p>');
        feedItem.ParentId = targetId;
        feedItem.IsRichText = true;
        insert feedItem;

    
    }
}