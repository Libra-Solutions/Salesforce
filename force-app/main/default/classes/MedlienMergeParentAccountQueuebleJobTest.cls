@isTest
public class MedlienMergeParentAccountQueuebleJobTest {
    public static testmethod void testAccountCallout() {
       
       Preset_Medlien_Configuration__c objConfig=new Preset_Medlien_Configuration__c();
       objConfig.End_Point__c='http://salesforceqa.keyhealth.net/api/mergeparentaccounts';
       objConfig.Server_Type__c='Medlien';
       objConfig.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig.name='MergeParentAccounts';
       
       insert objConfig;
       
       List<String> lstReqBody=new List<String>();
       String Body='{"keyMedsSourceAccountId":"1058552","keyMedsMergeAccountId":"1058551","grsSourceAccountId":"33018381","grsMergeAccountId":"33018380","sfid":"0014B00000fR84rQAC","cashTraxSourceAccountId":"65584","cashTraxMergeAccountId":"65585","atticusSourceAccountId":"02c4cc63-da4b-4271-5433-08d7681ee36b","atticusMergeAccountId":"36ee349-a47b-4bef-5432-08d7681ee36b"}';
       String status='{"Status":"OK","Message":"Merge Payer Successfull"}';
       lstReqBody.add(Body);
       
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);
        
       //System.enqueueJob(new MedlienFirmLocationQueuebleJob(lstReqBody)); 
       List<Account> lstOfAccounts=new List<Account>();
       lstOfAccounts.add(new Account (name='test1', Core__c = false, KeyMedsID__c = Null, GRS__c = false, GRSId__c = Null, Atticus__c = false, AtticusId__c = Null, PreSet__c = false, CTXFirmId__c = Null, ownerId = '0054M000003ia3m'));
       lstOfAccounts.add(new Account (name='test2', Core__c = true, KeyMedsID__c = 1058551, GRS__c = true, GRSId__c =33018380, Atticus__c = true, AtticusId__c='36ee349-a47b-4bef-5432-08d7681ee36b', PreSet__c = true, CTXFirmId__c='44250', Type = 'LawFirm'));
       
       insert lstOfAccounts;
        
       MergeParentAccountController.Modelparentacc mergeParentFirm=new MergeParentAccountController.Modelparentacc();
        mergeparentFirm.atticusMergeAccountId='36ee349-a47b-4bef-5432-08d7681ee36b';
        //mergeFirm.atticusMergeParentAccountId='177ad237-8244-47f8-2811-08d7681ee21b';
        mergeparentFirm.atticusSourceAccountId='02c4cc63-da4b-4271-5433-08d7681ee36b';
        //mergeFirm.atticusSourceParentAccountId='61e50386-94cd-4b03-2812-08d7681ee21b';
        mergeparentFirm.sfid=lstOfAccounts[0].id+'';
        mergeparentFirm.fromsfid=lstOfAccounts[1].id+'';
        mergeparentFirm.grsMergeAccountId='33018380';
        //mergeFirm.grsMergeParentAccountId='33006262';
        mergeparentFirm.grsSourceAccountId='33018381';
        //mergeFirm.grsSourceParentAccountId='33006263';
        mergeparentFirm.keyMedsMergeAccountId='1058551';
        //mergeFirm.keyMedsMergeParentAccountId='1052115';
        mergeparentFirm.keyMedsSourceAccountId='1058552';
        //mergeFirm.keyMedsSourceParentAccountId='1052116';
        mergeparentFirm.cashTraxSourceAccountId='0014B00000igG9A';
        /*mergeFirm.cashTraxSourceParentAccountId;
        mergeFirm.cashTraxSourceParentAccountId;
        mergeFirm.cashTraxMergeAccountId;
        mergeFirm.cashTraxMergeParentAccountId;*/
        
        List<MergeParentAccountController.Modelparentacc> lstOfLocs=new List<MergeParentAccountController.Modelparentacc>();
        
        lstOfLocs.add(mergeparentFirm);

            MergeParentAccountController.Parent_LawFirms(lstOfLocs);
        
    }
 
}