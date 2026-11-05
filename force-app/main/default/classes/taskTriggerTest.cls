@isTest
public class taskTriggerTest{
    
    static testMethod void testMethod1(){
    
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        Hunt_List__c objHunt = new Hunt_List__c();
        objHunt.Attorney_Firm_1__c = acc.id;
        objHunt.Attorney_1__c = con.id;
        insert objHunt;
        
        task tsk = new task();
        tsk.Subject = 'test';
        tsk.Oasis_Type__c = 'Email';
        tsk.Oasis_Sub_Type__c = 'Email';
        tsk.WhatId = objhunt.id;
        tsk.Priority = 'Normal';
        tsk.Status = 'Open';
        insert tsk;
        
    }
}