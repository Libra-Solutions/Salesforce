@isTest
public class MergeContactsControllerTest{
    public static testmethod void testAccountCallout() {
        
      Preset_Medlien_Configuration__c objConfiglogin=new Preset_Medlien_Configuration__c();
       objConfiglogin.End_Point__c='http://sfapitest.oasislegal.com/api/login/login';
       objConfiglogin.Server_Type__c='Preset';
       objConfiglogin.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfiglogin.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfiglogin.name='LoginPreset';
       
       insert objConfiglogin;
       
         
       Preset_Medlien_Configuration__c objConfig=new Preset_Medlien_Configuration__c();
       objConfig.End_Point__c='http://sfapitest.oasislegal.com/api/AttorneyFirm/MoveAttorney';
       objConfig.Server_Type__c='Preset';
       objConfig.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig.name='MoveAttorney';
       
       insert objConfig;
       
       
       Preset_Medlien_Configuration__c objConfig2=new Preset_Medlien_Configuration__c();
       objConfig2.End_Point__c='http://sfapitest.oasislegal.com/api/AttorneyFirm/MergeAttorneys';
       objConfig2.Server_Type__c='Preset';
       objConfig2.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig2.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig2.name='MergeAttorneys';
       
       insert objConfig2;
       
       List<String> lstReqBody=new List<String>();
       String Body='';
       String status='{"Status":"OK","SessionID":"hvNY#1?WieiDLhYh?cqpdvWh-D"}';
       lstReqBody.add(Body);
     
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);
      
          
      Account acc = UtiityHelperClass.createAccount();
      acc.HeadQuarter__c = false;
      acc.CTXFirmId__c ='20864';
      insert acc;
      
      Contact con1 = UtiityHelperClass.createContact(acc.Id);
      con1.Core__c = true;
      con1.GRS__c = true;
      con1.Atticus__c = true;
      con1.PreSet__c = true;
      
      //con.MailingCity = 'city';
      insert con1;
      
     
      Contact con2 = UtiityHelperClass.createContact(acc.Id);
       con2.Core__c = true;
       con2.GRS__c = true;
       con2.Atticus__c = true;
       con2.PreSet__c =true;
      
      insert con2;
      
      
      
      Account_Relation__c  accRel1=new Account_Relation__c ();
       accRel1.account__c=acc.id;
      accRel1.Role__c ='Attorney';
      
      accRel1.KeyMedsID__c='48524';
      accRel1.GRSId__c='33009977';
      accRel1.AtticusId__c='31550cc3-b5aa-4991-0ee6-08d6eea29ada';
      accRel1.PresetID__c ='1441066';
      accRel1.Contact__c =con1.id;
      
      insert accRel1;
      
      Account_Relation__c  accRel2=new Account_Relation__c ();
      accRel2.account__c=acc.id;
      accRel2.Role__c ='Attorney';
      
      accRel2.KeyMedsID__c='48524';
      accRel2.GRSId__c='33009977';
      accRel2.AtticusId__c='31550cc3-b5aa-4991-0ee6-08d6eea29ada';
      accRel2.PresetID__c ='1441066';
      accRel2.Contact__c =con2.id;
      
      insert accRel2;
      
    
    
      MergeContactsController.Inputs obj=new MergeContactsController.Inputs();
      
        obj.MasterContactId=con1.id;
        obj.MergeContactId=con2.id;
        obj.keyMedsSourceContactId=con1.id;
        obj.keyMedsMergeContactId=con2.id;
        obj.grsSourceContactId=con1.id;
        obj.grsMergeContactId=con2.id;
        obj.atticusSourceContactId=con1.id;
        obj.atticusMergeContactId=con2.id;
        obj.cashTraxSourceContactId=con1.id;
        obj.cashTraxMergeContactId=con2.id;
        obj.sfid=con1.id; 
          
        List<MergeContactsController.Inputs> request =new List<MergeContactsController.Inputs>();
        request.add(obj);
        
        MergeContactsController.Contacts(request);  
      
    Test.startTest();
    
      Preset_Medlien_Configuration__c objConfig5=new Preset_Medlien_Configuration__c();
       objConfig5.End_Point__c='http://salesforceqa.keyhealth.net/api/MergeContacts';
       objConfig5.Server_Type__c='Medlien';
       objConfig5.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig5.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig5.name='MergeContacts';
       
       insert objConfig5;
       
       
    
      
       String Body1='{"sfid":"0034B00000Xxs3TQAR","keyMedsSourceContactId":"48330","keyMedsMergeContactId":"48329","grsSourceContactId":"33009957","grsMergeContactId":"33009956","grs":true,"core":true,"ContactType":"PAYERLOCATION","atticusSourceContactId":"d652b8df-e23d-45c1-b2e4-08d6e3a95cac","atticusMergeContactId":"0d004556-f4af-4fe0-b2e3-08d6e3a95cac","atticus":true}';
       String status1='{"Status":"OK","Message":"Merge Contacts Successfull"}';
       
       PresetMedlienRequestMock Response1 = new PresetMedlienRequestMock(200,status1,Body1,null);
        
       Test.setMock(HttpCalloutMock.class, Response1);
       
       List<String> lstOfBody=new List<String>();
       lstOfBody.add(Body1);
       System.enqueueJob(new MedlienMergeContactsQueuebleJob (lstOfBody));
     
    Test.stopTest();
     
      
        
        
        
        
    }
}