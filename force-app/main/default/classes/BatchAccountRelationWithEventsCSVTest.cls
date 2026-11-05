@isTest
public class BatchAccountRelationWithEventsCSVTest {
	static testMethod void testMethod1() 
        {
            
             Account act = new Account();
           //act.ParentId = '00300000003T2PGAA0';
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
           insert act;
           
           Contact cnt = new Contact();
           cnt.firstname = 'first1';
           cnt.lastname = 'last';
           cnt.AccountId = act.Id ;
           cnt.Role__c ='Paralegal';
           cnt.Email = 'hitmprashant1@gmail.com';
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
           
           Account_Relation__c actRel= new Account_Relation__c();
           
           actRel.Role__c = 'Attorney' ;
           actRel.Contact__c = cnt.Id ;
           actRel.Account__c = act.Id ;
          // actRel.PresetID__c = '';
           actRel.KeyMedsID__c = '1111';
           actRel.AtticusId__c = '111' ;
           actRel.GRSId__c = '2222';
           List<Account_Relation__c > actLst = new List<Account_Relation__c >();
           actLst.add(actRel);
           insert actLst;
            
            event evt = new event();
            evt.Subject = 'test';
            evt.Oasis_Event_Purpose__c = 'Meeting - Attorney';
            evt.Oasis_Event_Result__c = 'Level 1';
            evt.StartDateTime = system.now();
            evt.EndDateTime = system.now().addHours(5);
            evt.whoId = cnt.Id;
            insert evt;
             
            Test.startTest();
                BatchAccountRelationWithEventsCSV obj = new BatchAccountRelationWithEventsCSV();
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }
}