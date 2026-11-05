@isTest
public class PresetUpdateFirmJobTest{
    
   public static testmethod void testCallout() {
        List<Preset_Medlien_Configuration__c> lstOfConRecords=new List<Preset_Medlien_Configuration__c >(); 
        Account acc=new Account();
        acc.name='test';
        acc.CTXFirmId__c ='1496359';
        insert acc;
        
        contact con=new Contact();
        con.lastname='test';
        con.FirstName ='test';
        
        insert con;
              
       Preset_Medlien_Configuration__c objConfig1=new Preset_Medlien_Configuration__c();
       objConfig1.End_Point__c='http://sfapitest.oasislegal.com/api/login/login';
       objConfig1.Server_Type__c='Preset';
       objConfig1.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig1.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig1.name='PresetUpdateFirmLocation';
       
       lstOfConRecords.add(objConfig1);
       
       Preset_Medlien_Configuration__c objConfig=new Preset_Medlien_Configuration__c();
       objConfig.End_Point__c='http://sfapitest.oasislegal.com/api/login/login';
       objConfig.Server_Type__c='Preset';
       objConfig.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig.name='LoginPreset';
       
       lstOfConRecords.add(objConfig);

       Preset_Medlien_Configuration__c objConfig2=new Preset_Medlien_Configuration__c();
       objConfig2.End_Point__c='http://sfapitest.oasislegal.com/api/login/login';
       objConfig2.Server_Type__c='Preset';
       objConfig2.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig2.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig2.name='PresetUpdateAttorneyContact';
       
       lstOfConRecords.add(objConfig2);
        
        Preset_Medlien_Configuration__c objConfig3=new Preset_Medlien_Configuration__c();
       objConfig3.End_Point__c='http://sfapitest.oasislegal.com/api/login/login';
       objConfig3.Server_Type__c='Preset';
       objConfig3.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig3.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig3.name='PresetUpdateFirm';
       
       lstOfConRecords.add(objConfig3);
       
       insert lstOfConRecords;
        List<String> lstReqBody=new List<String>();
       String Body='{}';
       String status='{"Status":"Success","SessionID":"992DB949-BF50-49ED-89DA-2243C802F95C"}';
       lstReqBody.add(Body);
       
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);

       Test.startTest();
            System.enqueueJob(new PresetMergeLocationLoginQueuebleJob ('1234',acc.id+'','1234',acc.id+''));    
            System.enqueueJob(new PresetUpdateFirmLocationQueuableJob('1234',acc.id+'','1234',acc.id+''));
            System.enqueueJob(new PresetMergeUpdateAttorneyContactJob (con.id,'12345'));
            System.enqueueJob(new PresetUpdateParentFirmQueuableJob ('12345',acc.id));
       Test.stopTest();    
    }
}