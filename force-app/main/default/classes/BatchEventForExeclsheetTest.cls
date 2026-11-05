@isTest
public class BatchEventForExeclsheetTest {
	static testMethod void testMethod1() 
        {
        
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        Hunt_List__c objHunt = new Hunt_List__c();
        objHunt.Attorney_Firm_1__c = acc.id;
        objHunt.Attorney_1__c = con.id;
        insert objHunt;
        
        event evt = new event();
        evt.Subject = 'test';
        evt.Oasis_Event_Purpose__c = 'Meeting - Attorney';
        evt.Oasis_Event_Result__c = 'Level 1';
        evt.StartDateTime = system.now();
        evt.EndDateTime = system.now().addHours(5);
        evt.WhatId = objhunt.id;
        evt.whoId = con.Id;
        insert evt;
        
        evt.StartDateTime = system.now();
        update evt;
            
            Test.startTest();
                BatchEventForExeclsheet obj = new BatchEventForExeclsheet();
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }

}