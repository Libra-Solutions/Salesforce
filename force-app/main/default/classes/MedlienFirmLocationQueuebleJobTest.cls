@isTest
public class MedlienFirmLocationQueuebleJobTest{
    public static testmethod void testAccountCallout() {
       
       Preset_Medlien_Configuration__c objConfig=new Preset_Medlien_Configuration__c();
       objConfig.End_Point__c='http://salesforceqa.keyhealth.net/api/MergeFirmLocations';
       objConfig.Server_Type__c='Medlien';
       objConfig.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig.name='MergeFirmLocations';
       
       insert objConfig;
       
       List<String> lstReqBody=new List<String>();
       String Body='{"keyMedsSourceParentAccountId":"1051875","keyMedsSourceAccountId":"1058284","keyMedsMergeParentAccountId":"1051875","keyMedsMergeAccountId":"1058286","grsSourceParentAccountId":"33005933","grsSourceAccountId":"33017593","grsMergeParentAccountId":"33005933","grsMergeAccountId":"33017595","Firmlocationsfid":"0014B00000fR84rQAC","CurrentFirmlocationsfid":"0014B00000fR7q1QAC","cashTraxSourceParentAccountId":"61527","cashTraxSourceAccountId":"65584","cashTraxMergeParentAccountId":"61527","cashTraxMergeAccountId":"65585","atticusSourceParentAccountId":"3377beb3-71eb-4494-16b5-08d6f27645ac","atticusSourceAccountId":"b96091aa-88ed-4dae-d8a5-08d6f21c3eba","atticusMergeParentAccountId":"3377beb3-71eb-4494-16b5-08d6f27645ac","atticusMergeAccountId":"4a1de64e-8263-4bf6-ad35-08d6f2764644"}';
       String status='{"Status":"OK","Message":"Merge PayerLocations Successfull"}';
       lstReqBody.add(Body);
       
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);
        
       //System.enqueueJob(new MedlienFirmLocationQueuebleJob(lstReqBody)); 
       List<Account> lstOfAccounts=new List<Account>();
       lstOfAccounts.add(new Account (name='test1', Core__c = false, KeyMedsID__c = Null, GRS__c = false, GRSId__c = Null, Atticus__c = false, AtticusId__c = Null, PreSet__c = false, CTXFirmId__c = Null));
       lstOfAccounts.add(new Account (name='test2', Core__c = true, KeyMedsID__c = 1058551, GRS__c = true, GRSId__c =33018380, Atticus__c = true, AtticusId__c='36ee349-a47b-4bef-5432-08d7681ee36b', PreSet__c = true, CTXFirmId__c='44250', Type = 'LawFirm'));
       
       insert lstOfAccounts;
       
       MergeLawFirmLocationController.ModelLocAcc mergeFirm=new MergeLawFirmLocationController.ModelLocAcc();
        mergeFirm.atticusMergeAccountId='36ee349-a47b-4bef-5432-08d7681ee36b';
        mergeFirm.atticusMergeParentAccountId='177ad237-8244-47f8-2811-08d7681ee21b';
        mergeFirm.atticusSourceAccountId='02c4cc63-da4b-4271-5433-08d7681ee36b';
        mergeFirm.atticusSourceParentAccountId='61e50386-94cd-4b03-2812-08d7681ee21b';
        mergeFirm.Firmlocationsfid=lstOfAccounts[0].id+'';
        mergeFirm.CurrentFirmlocationsfid=lstOfAccounts[1].id+'';
        mergeFirm.grsMergeAccountId='33018380';
        mergeFirm.grsMergeParentAccountId='33006262';
        mergeFirm.grsSourceAccountId='33018381';
        mergeFirm.grsSourceParentAccountId='33006263';
        mergeFirm.keyMedsMergeAccountId='1058551';
        mergeFirm.keyMedsMergeParentAccountId='1052115';
        mergeFirm.keyMedsSourceAccountId='1058552';
        mergeFirm.keyMedsSourceParentAccountId='1052116';
        mergeFirm.cashTraxSourceAccountId='0014B00000igG9A';
        /*mergeFirm.cashTraxSourceParentAccountId;
        mergeFirm.cashTraxSourceParentAccountId;
        mergeFirm.cashTraxMergeAccountId;
        mergeFirm.cashTraxMergeParentAccountId;*/
        
        List<MergeLawFirmLocationController.ModelLocAcc> lstOfLocs=new List<MergeLawFirmLocationController.ModelLocAcc>();
        
        lstOfLocs.add(mergeFirm);
        
        MergeLawFirmLocationController.LawFirm_Locations(lstOfLocs);
    }
}