@isTest
public class ContactTriggerUtilityHandlerTest {
  testmethod static void testContactData(){
      
      List<Account> accList = new List<Account>();
      Account acc = UtiityHelperClass.createAccount();
      acc.HeadQuarter__c = false;
      acc.CTXFirmId__c = '000111000222';
      accList.add(acc);
      
      Account acc1 = UtiityHelperClass.createAccount();
      acc1.HeadQuarter__c = false;
      acc1.CTXFirmId__c = 'q1w2e3r4rt';
      accList.add(acc1);
      insert accList;
          
      Contact con = UtiityHelperClass.createContact(acc.Id);
      //con.MailingCity = 'city';
      insert con;
            
      Account_Relation__c ar = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
      insert ar;
      
      con.firstname = 'fconName';
      con.accountId = acc1.id;
      //con.MailingCity = 'City1';
      update con;
  }
}