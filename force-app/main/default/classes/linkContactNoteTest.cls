@isTest
public class linkContactNoteTest{
    
    static testMethod void testMethod1(){
    
        Account acc = UtiityHelperClass.createAccount();
        insert acc;
        Contact con = UtiityHelperClass.createContact(acc.Id);
        insert con;
        
        Hunt_List__c objHunt = new Hunt_List__c();
        objHunt.Attorney_Firm_1__c = acc.id;
        objHunt.Attorney_1__c = con.id;
        insert objHunt;
        
        ContentNote cn = new ContentNote();
        cn.Title = 'test1';
        String body = 'Please work';
        cn.Content = Blob.valueOf(body.escapeHTML4());
        insert cn;
        
        ContentDocumentLink newCD = new ContentDocumentLink();
        newCD.ContentDocumentId = cn.id;
        newCD.LinkedEntityId = objHunt.id;
        newCD.ShareType = 'V';
        newCD.Visibility = 'AllUsers';
        insert newCD;
        
    }
}