@isTest
public class MedlienUpdateJobTest{
    
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
       objConfig1.End_Point__c='http://salesforceqa.keyhealth.net/api/MergeFirmLocations';
       objConfig1.Server_Type__c='Medlien';
       objConfig1.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig1.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig1.name='MedlienUpdateFirmLocatons';
       
       insert objConfig1;
       
          Preset_Medlien_Configuration__c objConfig2=new Preset_Medlien_Configuration__c();
       objConfig2.End_Point__c='http://salesforceqa.keyhealth.net/api/MergeFirmLocations';
       objConfig2.Server_Type__c='Medlien';
       objConfig2.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig2.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig2.name='MedlienUpdateFirm';
       
       insert objConfig2;
      
      
      
         Preset_Medlien_Configuration__c objConfig3=new Preset_Medlien_Configuration__c();
       objConfig3.End_Point__c='http://salesforceqa.keyhealth.net/api/MergeFirmLocations';
       objConfig3.Server_Type__c='Medlien';
       objConfig3.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig3.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig3.name='LoginPreset';
       
       insert objConfig3;
      
              
              
       Preset_Medlien_Configuration__c objConfig4=new Preset_Medlien_Configuration__c();
       objConfig4.End_Point__c='http://salesforceqa.keyhealth.net/api/MergeFirmLocations';
       objConfig4.Server_Type__c='Medlien';
       objConfig4.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig4.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig4.name='PresetUpdateAttorneyContact';
       
       insert objConfig4;
         
        List<String> lstReqBody=new List<String>();
       String Body='{}';
       String status='{"Status":"Success","SessionID":"992DB949-BF50-49ED-89DA-2243C802F95C"}';
       lstReqBody.add(Body);
       
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);
       List<String> lstOfAccountsFirm=new List<String>(); 
       List<String> lstOfAccountsFirmLocations=new List<String>(); 
       lstOfAccountsFirm.add('{"Type":"Payer","SFParentFirmld":"0014B00000ez2fFQAQ","KeyMedsParentFirmID":"1008789","KeyMedsFirmID":"1008793","IsParent":true,"GRSParentFirmID":null,"GRSFirmID":null,"grs":false,"core":false,"AtticusParentFirmID":"1008799","AtticusFirmID":null,"atticus":true}');
       lstOfAccountsFirmLocations.add('{"Type":"PayerLocation","SFParentFirmld":"0014B00000ezHB5QAM","KeyMedsParentFirmID":"1012188","KeyMedsFirmID":"1012179","IsParent":false,"GRSParentFirmID":null,"GRSFirmID":null,"grs":false,"core":false,"AtticusParentFirmID":"123444","AtticusFirmID":null,"atticus":true}');
       
       Test.startTest();
            System.enqueueJob(new MedlienUpdateParentFirmQueuebleJob(lstOfAccountsFirm));    
            System.enqueueJob(new MedlienUpdateFirmLocationQueuebleJob(lstOfAccountsFirmLocations));    
           
       Test.stopTest();    
    }
}