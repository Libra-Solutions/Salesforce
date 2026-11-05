@isTest
public with sharing class MergeFirmLocationTests {
    
    static testMethod void testMergeFirmLocationLoginQueueable() {
        MergeFirmLocationLoginQueueable q = new MergeFirmLocationLoginQueueable(null, null, null);
        Test.startTest();
        system.enqueueJob(q);
        Test.stopTest();
    }

    static testMethod void testMergeFirmLocationQueueable() {
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        
        MergeFirmLocationQueueable q2 = new MergeFirmLocationQueueable('Test', 'Test', a.Id);
        q2.execute(null);
        
    }

    static testMethod void testMergeFirmLocationLoginStatusParse() {
        string json = '{"Status": "success", "SessionID": "1234"}';
        MergeFirmLocationLoginQueueable.parse(json);
    }

    static testMethod void testMergeLocationQueueable() {
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        MergeFirmLocationQueueable q = new MergeFirmLocationQueueable(a, a);
        MergeFirmLocationQueueable q2 = new MergeFirmLocationQueueable('Test', 'Test', a.Id);

        
    }

    static testMethod void testMergeFirmLocationStatusParse() {
        string json = '{"Status": "success", "SessionID": "1234"}';
        MergeFirmLocationQueueable.parse(json);
    }
}