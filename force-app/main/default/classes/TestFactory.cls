@isTest
public class TestFactory {
  public static Account getAccount(String name, Boolean doInsert){
    Account a = new Account(name = name);
    if(doInsert){
      insert a;
    }
    return a;
  }
  
  public static List<Account> getAccountPresetCashTraxControllerAccount() {
      List<Account> actLst = new List<Account>();
      Account act = new Account();

       act.HeadQuarter__c = true;
       act.GRSId__c = 123456;
       act.KeyMedsID__c = 44444444 ;
       act.AtticusId__c = 'wewewe4444';
       act.Name = 'ssfdf';
       act.Street2__c = 'erer4545';
       act.BillingStreet = 'erer4545';
       act.BillingCity = 'CA';
       act.BillingState = 'AR';
       act.BillingPostalCode = '123ER';
       act.BillingCountry = 'United States';
       act.Phone = '9560682173';
       act.Fax = '9560682173';
       act.Website = 'https://www.google.com';
       act.type = 'Payor';
       
       Account act1 = new Account();
       act1 .HeadQuarter__c = true;
       act1 .GRSId__c = 123456;
       act1.KeyMedsID__c = 44444444 ;
       act1.AtticusId__c = 'wewewe4444';
       act1.Name = 'titu';
       act1.Street2__c = 'erer4545';
       act1.BillingStreet = '';
       act1.BillingCity = '';
       act1.BillingState = '';
       act1.BillingPostalCode = '';
       act1.BillingCountry = '';
       act1.Phone = '9560682173';
       act1.Fax = '9560682173';
       act1.Website = 'https://www.google.com';
       act1.type = 'Payor';
       
       actLst.add(act1);
       actLst.add(act);
       insert actLst;
       return actLst;
  }
  
  public static Contact getAccountPresetCashTraxControllerContact() {
     List<Account> actLst = getAccountPresetCashTraxControllerAccount();
     Account act = actLst.get(0);
      Contact cnt = new Contact();
       cnt.firstname = 'firs';
       cnt.lastname = 'las';
       cnt.AccountId = act.Id ;
       cnt.Role__c ='Paralegal';
       cnt.Email = 'testprashant1@gmail.com';
       cnt.Phone = '9560682173';
       cnt.Fax = '9560682173';
       cnt.BirthDate = Date.newInstance(2000, 09, 09);
       cnt.ContactInstructions__c = 'fff';
       cnt.Preferred_Contact_Phone__c = true;
       cnt.Preferred_Contact_Fax__c = true;
       cnt.Preferred_Contact_Email__c = true;
       cnt.DoNotCall = true;
       cnt.HasOptedOutOfFax = true;
       cnt.HasOptedOutOfEmail = true;
       cnt.IsActive__C = true;
       cnt.Salutation = 'Mr';
       insert cnt;
       return cnt;
  }
  
  public static Account_Relation__c getAccountPresetCashTraxControllerAccountContactRelation() {
     List<Account> actLst = getAccountPresetCashTraxControllerAccount();
     Account act = actLst.get(0);
     Contact cnt = getAccountPresetCashTraxControllerContact();
     
     Account_Relation__c actRel= new Account_Relation__c();
       
       actRel.Role__c = 'Attorney' ;
       actRel.Contact__c = cnt.Id ;
       actRel.Account__c = act.Id ;
       actRel.KeyMedsID__c = '1111';
       actRel.AtticusId__c = '111' ;
       actRel.GRSId__c = '2222';
       
       insert actRel;
       
       return actRel;
  }
  
  /*public static Contact getContact(Id accountId, String fname, String lname, Boolean doInsert){
    Contact c = new Contact(firstName = fname, lastName = lname, accountId = accountId);
    if(doInsert){
      insert c;
    }
    return c;
  }*/
  
  /*public static void generateAccountWithContacts(Integer numContacts){
    Account a = getAccount('default account ltd', true);
    List<Contact> contacts = new List<Contact>();
    for(Integer i = 0; i < numContacts; i++){
      String contactName = 'contact' + i;
      contacts.add(getContact(a.id, contactName, contactName, false));
    }
    insert contacts;
  }*/
  public static Opportunity[] generateOppsForAccount(id accountId, Decimal amount, Integer numOpps){
    List<Opportunity> opps = new List<Opportunity>();
    for(Integer i = 0; i < numOpps; i++){
      Opportunity o = new Opportunity();
      o.name = 'Account ' + i;
      o.accountId = accountid;
      o.amount = amount;
      o.closeDate = Date.today().addDays(5);
      o.stageName = 'Prospecting';
      opps.add(o);
    }
    return opps;
  }
  public static User generateUser(String profileName){
    UserRole userRole = new UserRole(DeveloperName = 'TestingTeam', Name = 'Testing Team');
    insert userRole;
    User u = new User(
      ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
      LastName = 'last',
      Email = 'test@gmail.com',
      Username = 'test@gmail.com',
      CompanyName = 'Testing Co',
      Title = 'Captian',
      Alias = 'alias',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      UserRoleId = userRole.Id
    );
    insert u;
    return u;
  }
}