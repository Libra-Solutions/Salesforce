@isTest
public class ContactInlineExtensionTest{
    
       
     @testSetup static void testSetUp(){
       
       Account act = new Account();
       act.name = 'test';
       act.CTXFirmId__c = '123dfg';
       act.AtticusId__c = '123fghd';
       act.GRSId__c = 1234.99;
       act.KeyMedsID__c = 123456;
       act.BillingStreet = 'Street';
       act.BillingCity = 'city';
       act.BillingState = 'AR';
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
       
       Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c();
       nonAttorney.Role__c = 'Paralegal';
       //nonAttorney.Contact__c = cnt.Id;
              
       insert nonAttorney;
     }
    
    static testMethod void testMethod1() {
     Contact cnt =[Select Id from Contact where FirstName = 'first'];
     List<Non_Attorney_Contact__c> nonAttorney = [Select id, Name, 
                                                  Role__c, Contact__c   
                                                  from Non_Attorney_Contact__c where Contact__c =: cnt.id ];
    
      ApexPages.standardController controller = new ApexPages.StandardController(cnt ) ;
      ContactInlineExtension ext = new ContactInlineExtension(controller);
    
     //create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'TestA1', Email='TestUser1@testorg1.com',
        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestUser1@testorg1.com');
        insert u;
        //System.runAs(u){
        
    }
    
    static testMethod void testMethod2() {
      Account act = new Account();
       act.name = 'test';
       act.CTXFirmId__c = '123dfg';
       act.AtticusId__c = '123fghd';
       act.GRSId__c = 1234.99;
       act.KeyMedsID__c = 123456;
       act.BillingStreet = 'Street1';
       act.BillingCity = 'city1';
       act.BillingState = 'TX';
       act.BillingPostalCode = '123457';
       insert act;
      
      Contact cnt1 = new Contact();
       cnt1.firstname = 'new';
       cnt1.lastname = 'last';
       cnt1.AccountId = act.Id ;
       cnt1.Role__c ='Paralegal';
       insert cnt1;
       
     Account_Relation__c actRel = null;
       
       /*actRel.Role__c  = null;
       actRel.Contact__c = cnt1.Id ;
       actRel.Account__c = act.Id ;
       List<Account_Relation__c > actLst = new List<Account_Relation__c >();
       actLst.add(actRel);
       insert actLst;*/
       
       Non_Attorney_Contact__c nonAttorney1 = new Non_Attorney_Contact__c();
       nonAttorney1.Role__c = 'Paralegal';
       //nonAttorney1.Contact__c = cnt1.Id;
              
       //insert nonAttorney1;
     Contact cnt =[Select Id from Contact where FirstName = 'new'];
     List<Non_Attorney_Contact__c> nonAttorney = [Select id, Name, 
                                                  Role__c
                                                  from Non_Attorney_Contact__c where Contact__c =: cnt.id ];
    
      ApexPages.standardController controller = new ApexPages.StandardController(cnt ) ;
      ContactInlineExtension ext = new ContactInlineExtension(controller);
      ext.isMDUser = false;
      ext.isCTXUser = false;
      ext.isManualUser = true;

      boolean mdUser = ext.isMDUser;
      boolean ctxUser = ext.isCTXUser;
      boolean manualUser = ext.isManualUser;
    
     //create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'TestA1', Email='TestUser1@testorg1.com',
        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestUser1@testorg1.com');
        insert u;
        //System.runAs(u){
        
    }
    
    
   
 }