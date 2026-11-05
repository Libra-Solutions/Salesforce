@isTest
private class MLViewRelatedListClassTest {

 @testsetup static  void testSetup() {
       Account act = new Account();
       act.name = 'test';
       act.CTXFirmId__c = '123dfg';
       act.AtticusId__c = '123fghd';
       act.GRSId__c = 1234.99;
       act.KeyMedsID__c = 123456;
       act.BillingStreet = 'Street';
       act.BillingCity = 'city';
       act.BillingState = 'LA';
       act.BillingPostalCode = '12345';
       insert act;
       
        ML_View360__c ml1= new ML_View360__c ();
        ml1.Account__c = act.Id;
        
        List<ML_View360__c > psLst= new List<ML_View360__c >();
        psLst.add(ml1);
        insert psLst;        
        
    }

 @isTest
 private static void testMethod1(){
   Account act = [Select Id from Account Where Name='test'];
   MLViewRelatedListClass.mlViewList(act.Id);
 }
 
 @isTest
 private static void testMethod2(){
   Account act = new Account(); 
   MLViewRelatedListClass.mlViewList(act.Id);
 }
 
    
 }