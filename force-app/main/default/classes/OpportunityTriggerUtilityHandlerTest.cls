@isTest
private class OpportunityTriggerUtilityHandlerTest{


  @testSetup static void setUpData(){
    //List<Account> actLst = new List<Account>();
       
    Account acc = new Account(name='Test Account',BillingStreet = 'Street',BillingCity = 'city',BillingState = 'TX',BillingPostalCode = '12345');
    insert acc;
    
    Contact con = UtiityHelperClass.createContact(acc.id);
    insert con;
    update con;
    
    List<Opportunity> lstOpportunity = new List<Opportunity>();
    
    Id providerId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
    
    Opportunity op1 = new Opportunity();
    op1.AccountId= acc.Id;
    op1.Name = 'test opportunity 2';
    op1.CloseDate = Date.newInstance(2018, 12, 15);
    op1.StageName = 'Qualification';
    op1.recordtypeid = providerId;
    op1.PlaintiffFirstName__c = 'Plantiff FirstName';
    op1.PlaintiffLastName__c = 'Plantiff LastName';
    op1.PlaintiffAddress1__c = 'Cross Xing';
    op1.PlaintiffAddress2__c = 'Near Beach';
    op1.PlaintiffCity__c = 'Secramenato';
    op1.PlaintiffState__c = 'AK - Alaska';
    op1.PlaintiffZipCode__c = '123XDF';
    op1.PlaintiffEmail__c = 'hitmprashant1@gmail.com';
    op1.PlaintiffPhoneNumber__c = '9560682173';
    op1.RequestedAmount__c = 20.00;
    op1.CaseType__c = 'Auto';
    op1.Accident_Type__c = 'Sideswipe';
    op1.Injuries__c = 'Broken Bones';
    op1.Treatment__c = 'Surgery';
    op1.InsuranceName__c = 'Term Plan';
    op1.PlaintiffDateofBirth__c = Date.newInstance(2000, 12, 15);
    op1.StateCase__c = 'AK - Alaska';
    op1.Incident_Date__c = Date.newInstance(2015, 12, 15);
    op1.Plaintiff_Involvement__c = 'Yes';
    op1.Treatments_Description__c = 'Treatment Completed';
    op1.Additional_Information__c = 'NA';
    op1.MoreThan1000Damage__c = 'No';
    op1.Offer_Amount__c = 50.00;
    op1.DescriptionofAccident__c='accident desc';
    
    
    insert op1;
    
    op1.Contracted__c = true;
    op1.stagename = 'Closed Won';
    op1.Amount = 123;
    op1.Contracted_Product__c = 'Atticus';
    update op1;
    
    OpportunityContactRole oppConRole = new OpportunityContactRole(OpportunityId = op1.id, ContactId = con.Id,Role = 'Decision Maker');
    insert oppConRole;
    system.debug('===oppConRole==>'+oppConRole);
    system.debug('===oppConRole==>'+oppConRole.id);
    
    list<OpportunityContactRole> oppContactList = [select Id, ContactId,OpportunityId from OpportunityContactRole];
    system.debug('==oppContactList==>'+oppContactList);
    
  }
  
  
  testMethod static void testCreateNewCase(){
      Account acc = [Select id from Account limit 1];
      Contact con = [Select id, AccountId from Contact limit 1];
    Opportunity op = [Select recordtypeid ,Attorney__c, AccountId, PlaintiffFirstName__c , Contracted_Product__c ,PlaintiffLastName__c,
                      PlaintiffAddress1__c,PlaintiffAddress2__c,PlaintiffCity__c,PlaintiffState__c,PlaintiffZipCode__c,PlaintiffEmail__c,
                      PlaintiffPhoneNumber__c,RequestedAmount__c,CaseType__c,Accident_Type__c,Injuries__c,Treatment__c,InsuranceName__c,
                      PlaintiffDateofBirth__c,StateCase__c,Incident_Date__c,Plaintiff_Involvement__c,Treatments_Description__c,AverageWeeklyWage__c,
                      Additional_Information__c,MoreThan1000Damage__c,Offer_Amount__c,DescriptionofAccident__c,DescriptionofIncident__c,ClosedDescription__c,
                      UIMUM__c,PropertyDamageAmount__c,PlaintiffWas__c,PlaintiffInjury__c,If_Yes_how_much__c,Facility_Type__c,DB_Competitor__c,
                      IsSuitFiled__c,IsthereaSettlementOffer__c, Liens_Against_Case__c,                   
                    IsthereathirdPartyAction__c,Liability__c,IsCaseAccepted__c,HasPlaintiffReceivedAnyOffers__c,Accident_Date__c,OpenDate__c,Other_Reason__c,CloseDate,ClaimNumber__c,
                    Additional_Case_Details__c,AmountOfCoverage__c,Probability
                      from Opportunity where PlaintiffEmail__c = 'hitmprashant1@gmail.com'];
    OpportunityTriggerUtilityHandler.updateAccountContactFlags(op,con.id);
    OpportunityTriggerUtilityHandler.CreateNewCase(op);
  }
  
  testMethod static void testremovenull(){
    //OpportunityTriggerUtilityHandler.removeNull('');
  }
  
  testMethod static void testremovenull1(){
    //OpportunityTriggerUtilityHandler.removeNull(null);
  }
  
  
  



}