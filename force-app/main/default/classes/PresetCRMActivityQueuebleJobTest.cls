@isTest
public class PresetCRMActivityQueuebleJobTest{

 testMethod static void testPresetCrm(){
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
      
        
        task tsk = new task();
        tsk.Subject = 'test';
        tsk.Oasis_Type__c = 'Email';
        tsk.Oasis_Sub_Type__c = 'Email';
        tsk.WhatId = acc .id;
        tsk.Priority = 'Normal';
        tsk.Status = 'Open';
        insert tsk;
        
        
        event evt = new event();
        evt.Subject = 'test';
        evt.Oasis_Event_Purpose__c = 'Meeting - Attorney';
        evt.Oasis_Event_Result__c = 'Level 1';
        evt.StartDateTime = system.now();
        evt.EndDateTime = system.now().addHours(5);
        evt.WhatId = acc.id;
        insert evt;
        
       Preset_Medlien_Configuration__c objConfig=new Preset_Medlien_Configuration__c();
       objConfig.End_Point__c='http://sfapitest.oasislegal.com/api/login/login';
       objConfig.Server_Type__c='Preset';
       objConfig.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig.name='LoginPreset';
       
       insert objConfig;
       
       Preset_Medlien_Configuration__c objConfig1=new Preset_Medlien_Configuration__c();
       objConfig1.End_Point__c='http://sfapitest.oasislegal.com/api/Activity/AddCRMActivity';
       objConfig1.Server_Type__c='Preset';
       objConfig1.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig1.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig1.name='PresetaddCrmActivity';
       
       insert objConfig1;

       List<String> lstReqBody=new List<String>();
       String Body='{}';
       String status='{"Status":"Success","SessionID":"992DB949-BF50-49ED-89DA-2243C802F95C"}';
       lstReqBody.add(Body);
       
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);
   
        
       Test.startTest();
            Event ev=[select id from event limit 1];
            Task tskRec=[select id from task limit 1];
            Set<id>setOfActivityIds=new Set<id>();
            setOfActivityIds.add(ev.id);
            
            System.enqueueJob(new PresetCRMActivityQueuebleJob (setOfActivityIds));
            setOfActivityIds.clear();
            setOfActivityIds.add(tskRec.id);
            System.enqueueJob(new PresetCRMActivityQueuebleJob (setOfActivityIds));
       Test.stopTest();      
    }
 
}