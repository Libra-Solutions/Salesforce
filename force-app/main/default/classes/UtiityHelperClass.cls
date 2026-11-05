Public class UtiityHelperClass{
    
    public static Lead createLead(){
        Lead leadObj = new Lead(Company = 'TestCom',Firstname = 'FN', Lastname = 'LN', Status = 'Open', Email = 'test@gmail.com', 
        LeadSource = 'Advertisement', ProductInterest__c = 'Core', State = 'AR', City = 'city', Street = 'Street', PostalCode = '12345',
        Country = 'United States', Phone = '1234567890', Fax = '123456789', Annual_Estimate__c = 12);
               
        return leadObj;
    }
    
    public static Account createAccount(){
        Account accountObj = new Account(Name = 'TestAccount', HeadQuarter__c = true, Type = 'LawFirm', Core__c = true,BillingStreet = 'Street',BillingCity = 'city',BillingState = 'LA',BillingPostalCode = '12345',Phone = '1234567890',Fax = '123456789');
       accountObj.Atticus__c = true;
       accountObj.GRS__c = true;
       
       
       return accountObj;
    }
    
    public static Contact createContact(String accountId){
        Contact contactObj = new Contact(FirstName = 'fCon', LastName = 'lCon', AccountId = accountId, Core__c = true, Phone = '123456789', 
        Fax = '123456789');
               
        return contactObj;
    }
    /*
    public static Opportunity createOpportunity(String accountId){
        Opportunity opportunityObj = new Opportunity(Name = 'TestOpp', StageName = 'Prospect', Amount = 12, ProductInterest__c= 'Core', CloseDate = system.today());
               
        return opportunityObj;
    }
    */
    public static Account_Relation__c createAccountRealtion(String accountId, String contactId){
        Account_Relation__c accRelation = new Account_Relation__c(Account__c = accountId, Contact__c = contactId, Role__c = 'Attorney');
               
        return accRelation;  
    }
    
    public static Region_Territory__c createRegionTerritory(){
        Region_Territory__c regionObj = new Region_Territory__c(City__c = 'City', County__c = 'County', GMSA__c = 'GMSA', GMSA_Name__c = 'GMSA_Name', Region__c = 'Region', State__c = 'LA', Territory__c = 'Territory', Zip_Code__c = '12345');
               regionObj.MLRep_UserID__c =null;
        return regionObj;
    }
    
    public static Non_Attorney_Contact__c createNonAttorneyContact(String accountId, String contactId){
        Non_Attorney_Contact__c nonAttObj = new Non_Attorney_Contact__c(Firm_Name__c = accountId, Attorney__c = contactId, PresetID__c = 1111, Role__c = 'Paralegal',Contact__c = contactId);
               
        return nonAttObj;
    }
    
}