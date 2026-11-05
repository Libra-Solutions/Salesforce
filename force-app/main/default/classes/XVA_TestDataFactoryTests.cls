@isTest
public with sharing class XVA_TestDataFactoryTests {
    
    static testMethod void testTestDataFactory() {
        XVA_TestDataFactory testData = new XVA_TestDataFactory();
        System.assertNotEquals(null, testData.TestAccount);
        System.assertNotEquals(null, testData.TestContact);
        testData.createTestDocumentAndContentDocumentLink(testData.TestContact.Id);
        
    }
}