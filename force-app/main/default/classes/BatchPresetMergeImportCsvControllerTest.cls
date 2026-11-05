@isTest
public class BatchPresetMergeImportCsvControllerTest{
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
          
          
          List<Preset_Medlien_Communication__c> lstOfPreCmm=new List<Preset_Medlien_Communication__c>();
          Set<id> setOfpsCmmIds=new Set<Id>();
          
          for(integer i=0;i<14;i++){
              Preset_Medlien_Communication__c objCsv=new Preset_Medlien_Communication__c();
          
              objCsv.Api_Action__c='PresetUpdateFirm';
              objCsv.Deleting_Atticus_Id__c='1234';
              objCsv.Deleting_Cashtrax_Id__c='1234';
              objCsv.Deleting_Core_Id__c='1234';
              objCsv.Deleting_Grs_Id__c='1234';
              objCsv.Serviving_Atticus_Id__c='1234';
              objCsv.Serviving_CashTrax_Id__c='1234';
              objCsv.Serviving_Core_Id__c='1234';
              objCsv.Serviving_Grs_Id__c='1234';
              objCsv.Serviving_Id__c =acc.id;
              objCsv.Deleting_Id__c=acc.id;
              
              lstOfPreCmm.add(objCsv);
          }
          
          lstOfPreCmm[0].Api_Action__c='PresetUpdateFirm';
          lstOfPreCmm[1].Api_Action__c='PresetUpdateFirmLocation';
          lstOfPreCmm[2].Api_Action__c='PresetUpdateAttorneyContact';
          lstOfPreCmm[2].Serviving_Id__c =con2.id;
          lstOfPreCmm[2].Deleting_Id__c=con2.id;
          
          lstOfPreCmm[3].Api_Action__c='MergeFirms';
          lstOfPreCmm[4].Api_Action__c='MergeAttorneys';
          lstOfPreCmm[4].Serviving_Id__c =con2.id;
          lstOfPreCmm[4].Deleting_Id__c=con2.id;
          
          lstOfPreCmm[5].Api_Action__c='MergeFirms';
          lstOfPreCmm[6].Api_Action__c='MedlienUpdateFirm';
          lstOfPreCmm[7].Api_Action__c='MedlienUpdateFirmLocatons';
          lstOfPreCmm[8].Api_Action__c='MedlienUpdateContact';
          lstOfPreCmm[8].Serviving_Id__c =con2.id;
          lstOfPreCmm[8].Deleting_Id__c=con2.id;
          
        lstOfPreCmm[9].Api_Action__c='MergeFirmLocations';
        lstOfPreCmm[10].Api_Action__c='MergeContacts';
        lstOfPreCmm[10].Serviving_Id__c =con2.id;
        lstOfPreCmm[10].Deleting_Id__c=con2.id;
        
        lstOfPreCmm[11].Api_Action__c='PresetMergeFirmLocations';
        lstOfPreCmm[12].Api_Action__c='MoveAttorney';
        lstOfPreCmm[12].Serviving_Id__c =con2.id;
        lstOfPreCmm[12].Deleting_Id__c=con2.id;
        lstOfPreCmm[13].Api_Action__c='MergeParentAccounts';
          
          insert lstOfPreCmm;
          
          for(Preset_Medlien_Communication__c  pre:lstOfPreCmm){
              setOfpsCmmIds.add(pre.id);
          }
          
          String str = 'test,test,test,test,test,test,test,test,test,test,test\n,1234,1234,1234,1234,1234,1234,1234,1234,1234,1234,1234,1234,1234';
          PresetMedImportCsvController  objcsv=new PresetMedImportCsvController ();
          objcsv.fileBody=Blob.valueOf(str);
          objcsv.importCSVFile();
          objcsv.SaveData();
          
          
          
         Test.startTest();

            DataBase.executeBatch(new BatchPresetMergeImportCsvController (setOfpsCmmIds)); 
            
        Test.stopTest();
        
          
      }
     
    
 }