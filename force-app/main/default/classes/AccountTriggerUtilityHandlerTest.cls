@isTest
public class AccountTriggerUtilityHandlerTest {
  testmethod static void testUpdateRegion(){
    
     /*Region_Territory__c regionT = UtiityHelperClass.createRegionTerritory();
      
     insert regionT;*/
      
      Region_Territory__c regionT = new Region_Territory__c(City__c = 'City', County__c = 'County', GMSA__c = 'GMSA', GMSA_Name__c = 'GMSA_Name', Region__c = 'Region', State__c = 'LA', Territory__c = 'Territory', Zip_Code__c = '12345');
      regionT.MLRep_UserID__c ='0054M000003ia3mQAA';
      insert regionT;
     
     Account acc = UtiityHelperClass.createAccount();
     acc.HeadQuarter__c = false;
     insert acc;
     
     regionT.State__c = 'AL';
     regionT.Zip_Code__c = '23456';
     update regionT;
     
     acc.Region__c = 'Region';
     acc.Territory__c = 'Territory';
     acc.GMSA__c = 'GMSA_Name';
     acc.billingstate = 'AL';
     acc.billingPostalCode = '23456';
     acc.Type = 'LawFirm';
     update acc;
     
     
      Account acc1 = UtiityHelperClass.createAccount();
     acc1.HeadQuarter__c = false;
     insert acc1;
     
     
     merge  acc acc1;
     
  }
  
  
  
  

}