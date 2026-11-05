@isTest
public class PresetLoginQueuebleJobTest{
    public static testmethod void testCallout() {
       
       Preset_Medlien_Configuration__c objConfig=new Preset_Medlien_Configuration__c();
       objConfig.End_Point__c='http://sfapitest.oasislegal.com/api/login/login';
       objConfig.Server_Type__c='Preset';
       objConfig.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig.name='LoginPreset';
       
       insert objConfig;
       
       
       
       
        Preset_Medlien_Configuration__c objConfig1=new Preset_Medlien_Configuration__c();
       objConfig1.End_Point__c='http://sfapitest.oasislegal.com/api/AttorneyFirm/MergeFirms';
       objConfig1.Server_Type__c='Preset';
       objConfig1.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig1.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig1.name='MergeFirms';
       
       insert objConfig1;
       
       
       
       Preset_Medlien_Configuration__c objConfig2=new Preset_Medlien_Configuration__c();
       objConfig2.End_Point__c='http://sfapitest.oasislegal.com/api/AttorneyFirm/MergeFirmLocations';
       objConfig2.Server_Type__c='Preset';
       objConfig2.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig2.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig2.name='PresetMergeFirmLocations';
       
       insert objConfig2;
       
       
       
       Preset_Medlien_Configuration__c objConfig3=new Preset_Medlien_Configuration__c();
       objConfig3.End_Point__c='http://sfapitest.oasislegal.com/api/AttorneyFirm/MoveAttorney';
       objConfig3.Server_Type__c='Preset';
       objConfig3.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig3.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig3.name='MoveAttorney';
       
       insert objConfig3;
       
       
       
       Preset_Medlien_Configuration__c objConfig4=new Preset_Medlien_Configuration__c();
       objConfig4.End_Point__c='http://sfapitest.oasislegal.com/api/AttorneyFirm/MergeAttorneys';
       objConfig4.Server_Type__c='Preset';
       objConfig4.Token__c='992DB949-BF50-49ED-89DA-2243C802F95C';
       objConfig4.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig4.name='MergeAttorneys';
       
       insert objConfig4;
       
        Account acc=new Account (name='test',CTXFirmId__c='1496359',HeadQuarter__c =true);
        insert acc;
        
        Account acc1=new Account (name='test',CTXFirmId__c='1496359',HeadQuarter__c =false,parentid=acc.id);
        insert acc1;
             
       
       List<String> lstReqBody=new List<String>();
       String Body='{}';
       String status='{"Status":"Success","SessionID":"992DB949-BF50-49ED-89DA-2243C802F95C"}';
       lstReqBody.add(Body);
       
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);
   
        
        Test.startTest();
            
            System.enqueueJob(new PresetMergeParentAccountLoginQueuebleJob ('1496359','24848')); 
            System.enqueueJob(new PresetMergeParentAccountQueuebleJob('1496359','24848')); 
            Map<Id,Account> mapOfMrgAccounts=new Map<Id,Account>();
            mapOfMrgAccounts.put(acc.id,acc);
            mapOfMrgAccounts.put(acc1.id,acc1);
            System.enqueueJob(new PresetServerMergeQueuebleJob (mapOfMrgAccounts)); 
            System.enqueueJob(new PresetServerMergeContactQueuebleJob(new list<String>())); 
            
            List<String> lstOfAttorneyIds=new List<String>();
            lstOfAttorneyIds.add('1496359');
            lstOfAttorneyIds.add('1496359');
            lstOfAttorneyIds.add('1496359');
            
            System.enqueueJob(new PresetServerMoveAttorneyQueuebleJob(lstOfAttorneyIds));
            lstOfAttorneyIds.add('1496359');
            
            System.enqueueJob(new PresetServerMoveAttorneyQueuebleJob(lstOfAttorneyIds));
            System.enqueueJob(new PresetServerMergeAttContactQueuebleJob(lstOfAttorneyIds));
       Test.stopTest();      
    }
 
}