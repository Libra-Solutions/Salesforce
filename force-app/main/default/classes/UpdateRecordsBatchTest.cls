@isTest
public class UpdateRecordsBatchTest{
    
    @testsetup static  void testDataSetup() {
       
       
       Id recTypeIdLeadAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
       Account act = new Account();
       act.Name = 'test';
       act.recordtypeId = recTypeIdLeadAttorney;
       act.type = 'LawFirm';
       act.billingstate = 'WA';
       act.BillingPostalCode= '98001';
       act.BillingStreet = 'Street';
       act.BillingCity = 'city';
       act.BillingState = 'LA';
       act.BillingPostalCode = '12345';
       //  added this line  
       act.Atticus__c = true; 

       
       Account act1 = new Account();
       act1.Name = 'test';
       act1.recordtypeId = recTypeIdLeadAttorney;
       act1.type = 'LawFirm';
       act1.billingstate = 'WA';
       act1.BillingPostalCode= '98001';
       act1.BillingStreet = 'Street1';
       act1.BillingCity = 'city1';
       //  added this line  
       act1.Atticus__c = true; 
       
       
       List<Account> actlst = new List<Account>();
       actlst.add(act);
       actlst.add(act1);      
       insert actlst;
       
       Region_Territory__c regionT = new Region_Territory__c();
       regionT.GMSA__c          =   '7602';
       regionT.Region__c        =   'West';
       regionT.State__c         =   'WA';
       regionT.Zip_Code__c      =   '98001';
       regionT.GMSA_Name__c     =   'Seattle-Tacoma-Bremerton WA CMSA';
       regionT.MLRep_UserID__c  =   '0054B000001vObeQAE';
       insert regionT;
    }
    
    static testMethod void testMethod1(){
        Test.StartTest();  
          Database.executeBatch(new UpdateRecordsBatch(null));
        Test.StopTest();
        
    }
    

   
  }