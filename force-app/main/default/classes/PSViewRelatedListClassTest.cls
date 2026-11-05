@isTest
private class PSViewRelatedListClassTest {

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
       
       Contact cnt = new Contact();
       cnt.firstname = 'first';
       cnt.lastname = 'last';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       insert cnt;
       
       Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;
       
        PS_View360__c ml1= new PS_View360__c();
        ml1.Account_Relation__c= actRel.Id;
        
        List<PS_View360__c > psLst= new List<PS_View360__c >();
        psLst.add(ml1);
        insert psLst;        
        
    }

 @isTest
 private static void testMethod1(){
   Account_Relation__c act = [Select Id from Account_Relation__c Where Role__c = 'Attorney'];
   PSViewRelatedListClass.psViewList(act.Id);
 }
 
 @isTest
 private static void testMethod2(){
   Account_Relation__c rlt = new Account_Relation__c ();
   PSViewRelatedListClass.psViewList(rlt.Id);
 }
 
 }