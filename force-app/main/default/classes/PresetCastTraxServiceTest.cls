@isTest
private class PresetCastTraxServiceTest {
    
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"email":"are02@gmail.com","LastName":"ABCD","FirstName":"ACFPY","Suffix":"","Title":"Engineer","Psw":"","PhoneCode":"","Phone":"100-000-000"}';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
            
        }
    }
    
    @isTest
    private static void testCreateAttorneyAssistant(){
        String request = '{"CRM_FirmID" : 343,"CRM_AttorneyID":"1234","AttorneyAssistantID":123,"AttorneyAssistantType":"Assistant","FirstName":"FirstName","LastName":"LastName","email":"test346@gmail.com","PhoneNumber":"1234567890","Fax"  : "3323232"}';
        new PresetCastTraxService().createAttorneyAssistant(request);
        
    }
    
    @isTest
    private static void testCreateAttorneyAssistantException(){
        String request = null;
        new PresetCastTraxService().createAttorneyAssistant(request);
        
    }
    
    @isTest
    private static void testUpdateAttorneyAssistant(){
        String request = '{"CRM_FirmID" : 343,"CRM_AttorneyID":"0034B00000XbgA8QAJ","AttorneyAssistantID":123,"AttorneyAssistantType":"Assistant","FirstName":"FirstName","LastName":"LastName","email":"test346@gmail.com","PhoneNumber":"1234567890","Fax"  : "3323232"}';
        new PresetCastTraxService().updatedAttorneyAssistant(request);
    }
    
    @isTest
    private static void testUpdateAttorneyAssistantException(){
        String request = null;
        new PresetCastTraxService().updatedAttorneyAssistant(request);
    }
    
    @isTest
    private static void testCreateCTXAttorney(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        new PresetCastTraxService().CreateCTXAttorney(request);
    }
    
    @isTest
    private static void testupdateCTXActivity(){
        String request = '{"Type":"Task","TaskStatus":"Open","SubType":"Accounts Receivable","Subject":"Call","LastModifiedDate":"2022-03-02 05:38:49","Description":"","CRM_ID":"00T7e00000e1n0eEAA","CRM_AttorneyID":"0036100001HnwAAAAZ","CreatedDate":"2022-03-02 05:38:49","AttorneyNoteID":"","AssignedTo":"Raj Battu","ActivityDate":"3/2/2022"}';
        new PresetCastTraxService().updateCTXActivity(request);
    }
    
     @isTest
    private static void testupdateCTXActivityException(){
        String request = null;
        new PresetCastTraxService().updateCTXActivity(request);
        
    }
    
    @isTest
    private static void testCreateCTXAttorneyException(){
        String request = null;
        new PresetCastTraxService().CreateCTXAttorney(request);
    }
    
    @isTest
    private static void testupdateCTXAttorney(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        new PresetCastTraxService().updateCTXAttorney(request);
        
    }
    
    @isTest
    private static void testupdateCTXAttorneyException(){
        String request = null;
        new PresetCastTraxService().updateCTXAttorney(request);
        
    }
    
    @isTest
    private static void testcreateCTXFirm(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        new PresetCastTraxService().createCTXFirm(request);
    }
    
    @isTest
    private static void testcreateCTXFirmException(){
        String request = null;
        new PresetCastTraxService().createCTXFirm(request);
    }
    
    @isTest
    private static void testupdateCTXFirm(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        new PresetCastTraxService().updateCTXFirm(request);
    }
    
    @isTest
    private static void testupdateCTXFirmException(){
        String request = null;
        new PresetCastTraxService().updateCTXFirm(request);
    }
    
    @isTest
    private static void testcreateCTXFirmLocation(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        new PresetCastTraxService().createCTXFirmLocation(request);
    }
    
    @isTest
    private static void testcreateCTXFirmLocationException(){
        String request = null;
        new PresetCastTraxService().createCTXFirmLocation(request);
    }
    
    @isTest
    private static void testupdateCTXFirmLocation(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        new PresetCastTraxService().updateCTXFirmLocation(request);
    }
    
    @isTest
    private static void testupdateCTXFirmLocationException(){
        String request = null;
        new PresetCastTraxService().updateCTXFirmLocation(request);
    }
    
    
    @isTest
    private static void testcreateActivities(){
        String request = '{"CRMNoteID" : "Test","Attorney" : "Test" ,"Title" : "Test","NoteText" : "Law Firm" ,"OwnerName" : "Test","CreatedBy" : "Prashant","CreatedDate" : "2014-01-01T23:28:56.782Z"}';
        new PresetCastTraxService().fetchActivities(request);
    }
    
    @isTest
    private static void testcreateActivitiesException(){
        String request = null;
        new PresetCastTraxService().fetchActivities(request);
    }
    
    @isTest
    private static void testcreateEvents(){
        String request = '{"CRMNoteID" : "Test","Attorney" : "Test" ,"Title" : "Test","NoteText" : "Law Firm" ,"OwnerName" : "Test","CreatedBy" : "Prashant","CreatedDate" : "2014-01-01T23:28:56.782Z"}';
        new PresetCastTraxService().fetchEvents(request);
    }
    
    @isTest
    private static void testcreateEventsException(){
        String request = null;
        new PresetCastTraxService().fetchEvents(request);
    }
    
    @isTest
    private static void testcaseFunded(){
        String request = '{"plaintiffName" : "Test","caseNumber" : 10123 ,"amount" : 10.0,"CRM_FirmID" : "Test","CRM_FirmLocationID" : "Test","CRM_AttorneyID" : "Test"}';
        new PresetCastTraxService().caseFunded(request);
    }
    
    @isTest
    private static void testcaseFundedException(){
        String request = null;
        new PresetCastTraxService().caseFunded(request);
    }
    
    @isTest
    private static void testcreateAttorneyNote(){
        String request = '{"FirmID" : "1234fghj","FirmName" : "Test" ,"HeadQuarter" : true,"PhoneNumber" : "+19089787867" ,"Website" : "Hello.com","Fax" : "19089787867" }';
        new PresetCastTraxService().createAttorneyNote(request);
    }
    
    @isTest
    private static void testcreateAttorneyNoteException(){
        String request = null;
        new PresetCastTraxService().createAttorneyNote(request);
    }
    
    /*@isTest
private static void testfetchNotes(){
String request = '{"CRM_FirmLocationID" : "Test","CRM_AttorneyID" : "Test" ,"count" : 1}';
new PresetCastTraxService().fetchNotes(request);
}*/
    
    @isTest
    private static void testfetchNotesException(){
        String request = null;
        new PresetCastTraxService().fetchNotes(request);
    }
    
    @isTest
    private static void testcreateCache(){
        String action = '/services/apexrest/createAttorneyNot';
        String payload = '{"FirmID" : "1234fghj","FirmName" : "Test" ,"HeadQuarter" : true,"PhoneNumber" : "+19089787867" ,"Website" : "Hello.com","Fax" : "19089787867" }';
        String objectId = '1234';
        PresetCastTraxService.createCache(action, payload, objectId);
    }
    
    testMethod static void testCTXUpdateResponse(){
        PresetCastTraxService.CTXUpdateResponse rep = new PresetCastTraxService.CTXUpdateResponse();
        rep.status = '1234ert';
        rep.message = 'ssss';
        
        
        System.assertNotEquals(null, rep.status );
        System.assertNotEquals(null, rep.message);
        
        
    }
    
    testMethod static void testCTXNonAttorneyResponse(){
        PresetCastTraxService.CTXNonAttorneyResponse rep = new PresetCastTraxService.CTXNonAttorneyResponse();
        rep.status = '1234ert';
        rep.message = 'ssss';
        rep.statusCode = '1234';
        rep.CRM_ContactId='ddd';
        
        
        
        System.assertNotEquals(null, rep.status );
        System.assertNotEquals(null, rep.message);
        System.assertNotEquals(null, rep.statusCode );
        System.assertNotEquals(null, rep.CRM_ContactId);
        
        
    }
    
    testMethod static void testCTXNonAttorneyUpdatResponse(){
        PresetCastTraxService.CTXNonAttorneyUpdatResponse rep = new PresetCastTraxService.CTXNonAttorneyUpdatResponse();
        rep.status = '1234ert';
        rep.message = 'ssss';
        rep.statusCode = '1234';
        rep.CRM_ContactId='ddd';
        
        
        
        System.assertNotEquals(null, rep.status );
        System.assertNotEquals(null, rep.message);
        System.assertNotEquals(null, rep.statusCode );
        System.assertNotEquals(null, rep.CRM_ContactId);
        
        
    }
    
    testMethod static void testCTXNoteResponseN(){
        PresetCastTraxService.CTXNoteResponse rep = new PresetCastTraxService.CTXNoteResponse();
        rep.status = '1234ert';
        rep.message = 'ssss';
        rep.statusCode = '1234';
        rep.Notes = new List<PresetCastTraxService.CRMNote>();
        
        
        
        System.assertNotEquals(null, rep.status );
        System.assertNotEquals(null, rep.message);
        System.assertNotEquals(null, rep.statusCode );
        System.assertEquals(new List<PresetCastTraxService.CRMNote>(), rep.Notes);
        
        
    }
    
    testMethod static void testCRMNoteF(){
        PresetCastTraxService.CRMNote rep = new PresetCastTraxService.CRMNote();
        rep.NoteID = '1234ert';
        rep.CRMNoteID = 'ssss';
        
        System.assertNotEquals(null, rep.NoteID );
        System.assertNotEquals(null, rep.CRMNoteID );
        
        
    }
    
    testMethod static void testNoteResponseF(){
        PresetCastTraxService.NoteResponse rep = new PresetCastTraxService.NoteResponse();
        rep.notes = new List<CashtraxEntities.SFNote>();
        
        System.assertEquals(new List<CashtraxEntities.SFNote>(), rep.notes );
        
        
        
    } 
    
    testMethod static void testCTXActivityResponseF(){
        PresetCastTraxService.CTXActivityResponse rep = new PresetCastTraxService.CTXActivityResponse();
        rep.activities = new List<CashtraxEntities.Activity>();
        
        System.assertEquals(new List<CashtraxEntities.Activity>(), rep.activities );
        
        
        
    } 
    
    testmethod static void testcheckDuplicateContactO() {
        CashtraxEntities.AttorneyAssistant cashtrxEnt = new CashtraxEntities.AttorneyAssistant();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.CRM_FirmLocationID = '1234ert';
        cashtrxEnt.CRM_AttorneyID = '0036100001HnwAAAAZ';
        cashtrxEnt.CRM_AttorneyAssistantID = '1234ert';
        cashtrxEnt.AttorneyAssistantID = 1234;
        cashtrxEnt.AttorneyAssistantType = 'test';
        cashtrxEnt.Name = 'test 1';
        cashtrxEnt.FirstName = 'test';
        cashtrxEnt.LastName = 'test';
        cashtrxEnt.Email = 'hitmprashant@gmail.com';
        cashtrxEnt.PhoneNumber = '9560682173';
        cashtrxEnt.Fax = '9560682173';
        new PresetCastTraxService().checkDuplicateContact(cashtrxEnt, 'test', 'test' );
    }
    
    testmethod static void testcreateFundedCase() {
        String json = '{\"Cases\":[{\"CRM_FirmLocationID\":\"0014B00000eQx5rQAC\",\"CRM_AttorneyID\":\"0034B00000XOOgSQAX\",\"CaseNumber\":\"1090356\",\"PlaintiffName\":\"Test Test Test\",\"Amount\":\"2000.0000\"},{\"CRM_FirmLocationID\":\"0014B00000eQx5rQAC\",\"CRM_AttorneyID\":\"0034B00000XOOgxQAH\",\"CaseNumber\":\"1121238\",\"PlaintiffName\":\"1121238\",\"Amount\":\"2350.0000\"},{\"CRM_FirmLocationID\":\"0014B00000eQx5rQAC\",\"CRM_AttorneyID\":\"0034B00000XOOgSQAX\",\"CaseNumber\":\"1116190\",\"PlaintiffName\":\"1116190\",\"Amount\":\"5000.0000\"}],\"Count\":3}';
        FundedCaseParser.Cases fCase = new FundedCaseParser.Cases(System.JSON.createParser(json));     
        new PresetCastTraxService().createFundedCase(fCase);
    }
    
    @isTest
    private static void testupdateAttorneyAssistantO() {
        CashtraxEntities.AttorneyAssistant cashtrxEnt = new CashtraxEntities.AttorneyAssistant();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.CRM_FirmLocationID = '0036100001HnwAAAAZ';
        cashtrxEnt.CRM_AttorneyID = '0036100001HnwAAAAZ';
        cashtrxEnt.CRM_AttorneyAssistantID = '0036100001HnwAAAAZ';
        cashtrxEnt.AttorneyAssistantID = 1234;
        cashtrxEnt.AttorneyAssistantType = 'test';
        cashtrxEnt.Name = 'test';
        cashtrxEnt.FirstName = 'test';
        cashtrxEnt.LastName = 'test';
        cashtrxEnt.Email = 'hitmprashant@gmail.com';
        cashtrxEnt.PhoneNumber = '9560682173';
        cashtrxEnt.Fax = '9560682173';  
        new PresetCastTraxService().updateAttorneyAssistant(cashtrxEnt);
    }
    
    @isTest
    private static void testupdateAttorneyAssistantException1() {
        CashtraxEntities.AttorneyAssistant cashtrxEnt = null;
        new PresetCastTraxService().updateAttorneyAssistant(cashtrxEnt);
    }
    
    testmethod static void testcreateAttorneyAssistantO() {
        CashtraxEntities.AttorneyAssistant cashtrxEnt = new CashtraxEntities.AttorneyAssistant();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.CRM_FirmLocationID = '0017e00001NLbymAAD';
        cashtrxEnt.CRM_AttorneyID = '0036100001HnwAAAAZ';
        cashtrxEnt.CRM_AttorneyAssistantID = '1234ert';
        cashtrxEnt.AttorneyAssistantID = 1234;
        cashtrxEnt.AttorneyAssistantType = 'Paralegal';
        cashtrxEnt.Name = 'test rt';
        cashtrxEnt.FirstName = 'test';
        cashtrxEnt.LastName = 'test';
        cashtrxEnt.Email = 'hitmprashant@gmail.com';
        cashtrxEnt.PhoneNumber = '9560682173';
        cashtrxEnt.Fax = '9560682173'; 
        Test.setMock(HttpCalloutMock.class, new RestMock());
        new PresetCastTraxService().createAttorneyAssistant(cashtrxEnt);
    }
    
    testmethod static void testupdateCTXActivityo() {
         Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        c.Email = 'hitmprashant@gmail.com';
        insert c;
        
        CashtraxEntities.UpdateActivity cashtrxEnt = new CashtraxEntities.UpdateActivity();
        cashtrxEnt.Type = 'Task';
        cashtrxEnt.TaskSubtype = 'Accounts Receivable';
        cashtrxEnt.Subject = 'Call';
        cashtrxEnt.Description = 'test';
        cashtrxEnt.CRM_AttorneyID = c.id;
        cashtrxEnt.AttorneyNoteID = 'test';
        cashtrxEnt.AssignedTo = 'Raj Battu';
        Test.setMock(HttpCalloutMock.class, new RestMock());
        new PresetCastTraxService().updateCTXActivity(cashtrxEnt);
}
    
        
    testmethod static void testupdateCTXActivityoException() {
        
        CashtraxEntities.UpdateActivity cashtrxEnt = new CashtraxEntities.UpdateActivity();
        cashtrxEnt.Type = 'Task';
        cashtrxEnt.TaskSubtype = 'Accounts Receivable';
        cashtrxEnt.Subject = 'Call';
        cashtrxEnt.Description = 'test';
        cashtrxEnt.CRM_AttorneyID = '00';
        cashtrxEnt.AttorneyNoteID = 'test';
        cashtrxEnt.AssignedTo = 'Raj Battu';
        Test.setMock(HttpCalloutMock.class, new RestMock());
        new PresetCastTraxService().updateCTXActivity(cashtrxEnt);
}
    
    testmethod static void testcreateAttorneyAssistantWhenAttornyIdNull() {
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        c.Email = 'hitmprashant@gmail.com';
        insert c;
        
        CashtraxEntities.AttorneyAssistant cashtrxEnt = new CashtraxEntities.AttorneyAssistant();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.CRM_FirmLocationID = '0017e00001NLbymAAD';
        cashtrxEnt.CRM_AttorneyID = '0036100001HnwAAAAZ';
        cashtrxEnt.CRM_AttorneyAssistantID = '1234ert';
        cashtrxEnt.AttorneyAssistantID = 1234;
        cashtrxEnt.AttorneyAssistantType = 'Paralegal';
        cashtrxEnt.Name = 'test rt';
        cashtrxEnt.FirstName = 'test';
        cashtrxEnt.LastName = 'test';
        cashtrxEnt.Email = 'hitmprashant@gmail.com';
        cashtrxEnt.PhoneNumber = '9560682173';
        cashtrxEnt.Fax = '9560682173';  
        Test.setMock(HttpCalloutMock.class, new RestMock());
        new PresetCastTraxService().createAttorneyAssistant(cashtrxEnt);
    }
    
    testmethod static void testupdateAttorneyO() {
        CashtraxEntities.Attorney cashtrxEnt = new CashtraxEntities.Attorney();
        cashtrxEnt.CRM_FirmLocationID = '0017e00001NLbymAAD';
        cashtrxEnt.CRM_AttorneyID = '0036100001HnwAAAAZ';
        cashtrxEnt.AttorneyID = 1234;
        cashtrxEnt.FirstName = 'test 1';
        cashtrxEnt.LastName = 'test';
        cashtrxEnt.Email = 'hitmprashant@gmail.com';
        cashtrxEnt.Portal = true;
        cashtrxEnt.PhoneNumber = '9560682173';
        cashtrxEnt.Fax = '9560682173';
        cashtrxEnt.Birthday = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        cashtrxEnt.ContactInformation = 'Colorado';
        cashtrxEnt.BarVerificationDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        cashtrxEnt.BarVerificationExpirationDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        cashtrxEnt.OwnerEmail = 'hitmprashant@gmail.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='hitmprashant@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing_Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTestData@testorg.com');
        
        insert u;
        new PresetCastTraxService().updateAttorney(cashtrxEnt);
    }
    
    testmethod static void testcreateAttorneyO() {
        XVA_TestDataFactory factory = new XVA_TestDataFactory();
        
        CashtraxEntities.Attorney cashtrxEnt = new CashtraxEntities.Attorney();
        //cashtrxEnt.CRM_FirmLocationID = '0017e00001NLbymAAD';
        //cashtrxEnt.CRM_AttorneyID = '1234ert';
        cashtrxEnt.CRM_FirmLocationID = factory.TestAccount.Id;
        cashtrxEnt.CRM_AttorneyID = factory.TestContact.Id;
        cashtrxEnt.AttorneyID = 1234;
        cashtrxEnt.FirstName = 'test 1';
        cashtrxEnt.LastName = 'test';
        cashtrxEnt.OwnerEmail = 'hitmprashant@gmail.com';
        cashtrxEnt.Portal = true;
        cashtrxEnt.PhoneNumber = '9560682173';
        cashtrxEnt.Fax = '9560682173';
        cashtrxEnt.Birthday = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        cashtrxEnt.ContactInformation = 'Colorado';
        cashtrxEnt.BarVerificationDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        cashtrxEnt.BarVerificationExpirationDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);  
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='hitmprashant@gmail.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing_Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTestData@testorg.com');
        
        insert u;
        Test.setMock(HttpCalloutMock.class, new RestMock());
        new PresetCastTraxService().createAttorney(cashtrxEnt);
    }
    
    @isTest
    private static void testupdateFirmLocationO() {
        CashtraxEntities.FirmLocation cashtrxEnt = new CashtraxEntities.FirmLocation();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.CRM_FirmLocationID = '0017e00001NLbymAAD';
        cashtrxEnt.FirmLocationID = '1234ert';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.FirmLocationName = 'test';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Address1 = 'adr 1';
        cashtrxEnt.Address2 = 'adr 2';
        cashtrxEnt.City = 'Connecticut';
        cashtrxEnt.State = 'MO';
        cashtrxEnt.ZipCode = '1234ER';
        cashtrxEnt.type = 'new'; 
        new PresetCastTraxService().updateFirmLocation(cashtrxEnt);
    }
    
    testmethod static void testcreateFirmO() {
        CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Website = 'https://www.google.com';
        cashtrxEnt.fax = '9560682173';
        cashtrxEnt.type = 'new';
        cashtrxEnt.PhoneNumber = '9560682173';
        new PresetCastTraxService().createFirm(cashtrxEnt);
    }
    /*@isTest
private static void testselectNotes() {
CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
cashtrxEnt.CRM_FirmID = '123ertt';
cashtrxEnt.FirmID = '1234ert';
cashtrxEnt.HeadQuarter = true;
cashtrxEnt.Website = 'https://www.google.com';
cashtrxEnt.fax = '9560682173';
cashtrxEnt.type = 'new';
cashtrxEnt.PhoneNumber = '9560682173';
new PresetCastTraxService().createFirm(cashtrxEnt);

CashtraxEntities.ActivityRequest cashtrxEnt1 = new CashtraxEntities.ActivityRequest();

cashtrxEnt1.CRM_FirmLocationID = '123ertt';
cashtrxEnt1.CRM_AttorneyID = '123412345678900';
cashtrxEnt1.count = 1;
new PresetCastTraxService().selectNotes(cashtrxEnt1);

CashtraxEntities.ActivityRequest cashtrxEnt1 = new CashtraxEntities.ActivityRequest();
cashtrxEnt1.CRM_FirmLocationID = '123ertt';
cashtrxEnt1.CRM_AttorneyID = '1234ert';
cashtrxEnt1.count = 1;
new PresetCastTraxService().selectNotes(cashtrxEnt1);

}*/

    static testMethod void testSelectNotes() {
        XVA_TestDataFactory factory = new XVA_TestDataFactory();
        factory.createTestDocumentAndContentDocumentLink(factory.TestContact.Id);
        factory.createTestNoteAndContentDocumentLink(factory.TestContact.Id);
        CashtraxEntities.ActivityRequest request = new CashtraxEntities.ActivityRequest();
        request.CRM_FirmLocationID = factory.TestAccount.Id;
        request.CRM_AttorneyID = factory.TestContact.Id;
        request.count = 1;
        new PresetCastTraxService().selectNotes(request);
    }

    @isTest
    private static void testsSelectNotesException(){
        CashtraxEntities.ActivityRequest request = null;
        new PresetCastTraxService().selectNotes(request);
    }
    
    @isTest
    private static void testselectActivities() {
        CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Website = 'https://www.google.com';
        cashtrxEnt.fax = '9560682173';
        cashtrxEnt.type = 'new';
        cashtrxEnt.PhoneNumber = '9560682173';
        new PresetCastTraxService().createFirm(cashtrxEnt);
        
        CashtraxEntities.ActivityRequest cashtrxEnt1 = new CashtraxEntities.ActivityRequest();
        
        cashtrxEnt1.CRM_FirmLocationID = '123ertt';
        cashtrxEnt1.CRM_AttorneyID = '0036100001HnwAAAAZ';
        cashtrxEnt1.count = 1;
        new PresetCastTraxService().selectActivities(cashtrxEnt1);
        
    }
    
    testMethod static void testActivity(){
        CashtraxEntities.Activity cashtrxEnt = new CashtraxEntities.Activity();
        cashtrxEnt.FirmName = '123ertt';
        cashtrxEnt.Attorney = '1234ert';
        cashtrxEnt.Subject = '1234ert';
        cashtrxEnt.Type = '1234ert';
        cashtrxEnt.Comments = 'test';
        cashtrxEnt.AssignedTo = 'test 1';
        cashtrxEnt.DueDate = Date.newInstance(2000,09,09);
        cashtrxEnt.CreatedBy = 'test';
        cashtrxEnt.CreatedDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        
        System.assertNotEquals(null, cashtrxEnt.FirmName);
        System.assertNotEquals(null, cashtrxEnt.Attorney);
        System.assertNotEquals(null, cashtrxEnt.Subject);
        System.assertNotEquals(null, cashtrxEnt.Type);
        System.assertNotEquals(null, cashtrxEnt.Comments);
        System.assertNotEquals(null, cashtrxEnt.AssignedTo);
        System.assertEquals(Date.newInstance(2000,09,09), cashtrxEnt.DueDate);
        System.assertNotEquals(null, cashtrxEnt.CreatedBy);
        System.assertEquals(datetime.newInstance(2014, 9, 15, 12, 30, 0), cashtrxEnt.CreatedDate);
    }
    
    @isTest
    private static void testsActivitiesException(){
        CashtraxEntities.ActivityRequest request = null;
        new PresetCastTraxService().selectActivities(request);
    }
    
    @isTest
    private static void testselectEventsException(){
        CashtraxEntities.ActivityRequest request = null;
        new PresetCastTraxService().selectEvents(request);
    }
    
    @isTest
    private static void testupdateFirmLocationException(){
        CashtraxEntities.FirmLocation request = null;
        new PresetCastTraxService().updateFirmLocation(request);
    }
    
    @isTest
    private static void testcreateFirmException(){
        CashtraxEntities.Firm request = null;
        new PresetCastTraxService().createFirm(request);
    }
    
    @isTest
    private static void testcreateFirmLocationException(){
        CashtraxEntities.FirmLocation request = null;
        new PresetCastTraxService().createFirmLocation(request);
    }
    
    @isTest
    private static void testupdateFirmException(){
        CashtraxEntities.Firm request = null;
        new PresetCastTraxService().updateFirm(request);
    }
    
    static testMethod void testParse() {
        String json = '{'+
            ''+
            '  \"Count\": 2,'+
            ''+
            '  \"Notes\": ['+
            ''+
            '    {'+
            ''+
            '      \"CRM_FirmID\": \"0014B00000eRWSXQA4\",'+
            ''+
            '      \"CRM_FirmLocationID\": \"0014B00000eRWSXQA4\",'+
            ''+
            '      \"CRM_AttorneyID\": \"0034B00000XbW6sQAF\",'+
            ''+
            '      \"NoteID\": 235343,'+
            ''+
            '      \"NoteText\": \"Monthly notification sent for case(s): 507\",'+
            ''+
            '      \"Name\": \"Automated Process\",'+
            ''+
            '      \"DateCreated\": \"2011-04-11\"'+
            ''+
            '    },'+
            ''+
            '    {'+
            ''+
            '      \"CRM_FirmID\": \"0014B00000eRWSXQA4\",'+
            ''+
            '      \"CRM_FirmLocationID\": \"0014B00000eRWSXQA4\",'+
            ''+
            '      \"CRM_AttorneyID\": \"0034B00000XbW6sQAF\",'+
            ''+
            '      \"NoteID\": 39,'+
            ''+
            '      \"NoteText\": \"Monthly notification sent for case(s): 507\",'+
            ''+
            '      \"Name\": \"Automated Process\",'+
            ''+
            '      \"DateCreated\": \"2010-11-22\"'+
            ''+
            '    }'+
            ''+
            '  ]'+
            ''+
            '}';
        JSON2Apex r = JSON2Apex.parse(json);
        System.assert(r != null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex objJSON2Apex = new JSON2Apex(System.JSON.createParser(json));
        System.assert(objJSON2Apex != null);
        System.assert(objJSON2Apex.Count == null);
        System.assert(objJSON2Apex.Notes == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Notes objNotes = new JSON2Apex.Notes(System.JSON.createParser(json));
        objNotes.NoteText = 'Test';
        objNotes.CRM_AttorneyID = '0036100001HnwAAAAZ';
        System.assert(objNotes != null);
        try {
            new PresetCastTraxService().createAttorneyNotes(new List<JSON2Apex.Notes>{objNotes});
            //Assert.isTrue(false); //we expect a failure here
        } catch(Exception ex) {
            //Assert.isTrue(true); //we expect a failure here
        }
    }
    
    static testMethod void testMethod1(){
        
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
        insert evt;
        
    }
    
    @isTest
    private static void testselectEvents() {
        CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Website = 'https://www.google.com';
        cashtrxEnt.fax = '9560682173';
        cashtrxEnt.type = 'new';
        cashtrxEnt.PhoneNumber = '9560682173';
        new PresetCastTraxService().createFirm(cashtrxEnt);
        
        CashtraxEntities.ActivityRequest cashtrxEnt1 = new CashtraxEntities.ActivityRequest();
        
        cashtrxEnt1.CRM_FirmLocationID = '123ertt';
        cashtrxEnt1.CRM_AttorneyID = '123412345678900';
        cashtrxEnt1.count = 1;
        new PresetCastTraxService().selectEvents(cashtrxEnt1);
        
    }
    
    static testMethod void testFundedCaseParser() {
        String json = '{\"Cases\":[{\"CRM_FirmLocationID\":\"0014B00000eQx5rQAC\",\"CRM_AttorneyID\":\"0034B00000XOOgSQAX\",\"CaseNumber\":\"1090356\",\"PlaintiffName\":\"1090356\",\"Amount\":\"2000.0000\"},{\"CRM_FirmLocationID\":\"0014B00000eQx5rQAC\",\"CRM_AttorneyID\":\"0034B00000XOOgxQAH\",\"CaseNumber\":\"1121238\",\"PlaintiffName\":\"1121238\",\"Amount\":\"2350.0000\"},{\"CRM_FirmLocationID\":\"0014B00000eQx5rQAC\",\"CRM_AttorneyID\":\"0034B00000XOOgSQAX\",\"CaseNumber\":\"1116190\",\"PlaintiffName\":\"1116190\",\"Amount\":\"5000.0000\"}],\"Count\":3}';
        FundedCaseParser r = FundedCaseParser.parse(json);
        System.assert(r != null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        FundedCaseParser objFundedCaseParser = new FundedCaseParser(System.JSON.createParser(json));
        System.assert(objFundedCaseParser != null);
        System.assert(objFundedCaseParser.Cases == null);
        System.assert(objFundedCaseParser.Count == null);
        
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        FundedCaseParser.Cases objCases = new FundedCaseParser.Cases(System.JSON.createParser(json));
        System.assert(objCases != null);
        System.assert(objCases.CRM_FirmLocationID == null);
        System.assert(objCases.CRM_AttorneyID == null);
        System.assert(objCases.CaseNumber == null);
        System.assert(objCases.PlaintiffName == null);
        System.assert(objCases.Amount == null);
    }
    
    @isTest
    private static void testdeleteFirmLocationO() {
        Account ac = new Account();
        ac.name = 'test';
        insert ac;
        
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        c.Email = 'hitmprashant@gmail.com';
        c.accountId = ac.Id;
        insert c;
        CashtraxEntities.FirmLocation cashtrxEnt = new CashtraxEntities.FirmLocation();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.CRM_FirmLocationID = ac.Id;
        cashtrxEnt.FirmLocationID = '1234ert';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.FirmLocationName = 'test';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Address1 = 'adr 1';
        cashtrxEnt.Address2 = 'adr 2';
        cashtrxEnt.City = 'Connecticut';
        cashtrxEnt.State = 'Colorado';
        cashtrxEnt.ZipCode = '1234ER';
        cashtrxEnt.type = 'new'; 
        new PresetCastTraxService().deleteFirmLocation(cashtrxEnt);
    }
    
    private static void testdeleteFirmLocationOWithNoContact() {
        Account ac = new Account();
        ac.name = 'test';
        insert ac;
        
        CashtraxEntities.FirmLocation cashtrxEnt = new CashtraxEntities.FirmLocation();
        cashtrxEnt.CRM_FirmID = '123ertt';
        cashtrxEnt.CRM_FirmLocationID = ac.Id;
        cashtrxEnt.FirmLocationID = '1234ert';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.FirmLocationName = 'test';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Address1 = 'adr 1';
        cashtrxEnt.Address2 = 'adr 2';
        cashtrxEnt.City = 'Connecticut';
        cashtrxEnt.State = 'Colorado';
        cashtrxEnt.ZipCode = '1234ER';
        cashtrxEnt.type = 'new'; 
        new PresetCastTraxService().deleteFirmLocation(cashtrxEnt);
    }
    
    @isTest
    private static void testdeleteFirm(){
        Account ac = new Account();
        ac.name = 'test';
        insert ac;
        CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
        cashtrxEnt.CRM_FirmID = ac.ID;
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Website = 'https://www.google.com';
        cashtrxEnt.fax = '9560682173';
        cashtrxEnt.type = 'new';
        cashtrxEnt.PhoneNumber = '9560682173';
        
        new PresetCastTraxService().deleteFirm(cashtrxEnt);
    }
    
    @isTest
    private static void testdeleteFirmWithContact(){
        Account ac = new Account();
        ac.name = 'test';
        insert ac;
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        c.Email = 'hitmprashant@gmail.com';
        c.accountId = ac.Id;
        insert c;
        CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
        cashtrxEnt.CRM_FirmID = ac.ID;
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Website = 'https://www.google.com';
        cashtrxEnt.fax = '9560682173';
        cashtrxEnt.type = 'new';
        cashtrxEnt.PhoneNumber = '9560682173';
        
        new PresetCastTraxService().deleteFirm(cashtrxEnt);
    }
    
    @isTest
    private static void testdeleteFirmInCRM(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        
        new PresetCastTraxService().deleteFirmInCRM(request);
    }
    
    @isTest
    private static void testdeleteFirmInCRMException(){
        String request = null;
        new PresetCastTraxService().deleteFirmInCRM(request);
    }
    
    @isTest
    private static void testdeleteFirmLocation(){
        String request = '{"CRM_FirmID" : "0014B00000eRRbv","FirmName": "Prashant","FirstName": "Kumar Last","CTX_FirmID": 1234567,"LastName": "Test Last Name","MiddleName":"","Address1":"","Address2":"","City":"","State":"","Zip":"","DayPhone":"","Fax":"","Email":"","AttorneyID":123567,"Type":"Payer"}';
        new PresetCastTraxService().deleteFirmLocation(request);
    }
    
    @isTest
    private static void testdeleteFirmLocationException(){
        String request = null;
        new PresetCastTraxService().deleteFirmLocation(request);
    }
    
    @isTest
    private static void testcreateAttorneyAssistantException1(){
        CashtraxEntities.AttorneyAssistant request = null;
        new PresetCastTraxService().createAttorneyAssistant(request);
    }
    
    @isTest
    private static void testdeleteFirmLocationException1() {
        CashtraxEntities.FirmLocation cashtrxEnt = null;
        new PresetCastTraxService().deleteFirmLocation(cashtrxEnt);
    }
    
    @isTest
    private static void testcreateAttorneymException() {
        CashtraxEntities.Attorney cashtrxEnt = null;
        new PresetCastTraxService().createAttorney(cashtrxEnt);
    }
    
    @isTest
    private static void testconvertGMTtoLocal(){
        Date dToday = Date.today();
        DateTime dt = DateTime.newInstance(dToday.dayOfYear(), dToday.month(),dToday.day());
        new  PresetCastTraxService().convertGMTtoLocal(dt);
    }
    
    @isTest
    private static void testdeleteFirmmException() {
        CashtraxEntities.Firm cashtrxEnt = null;
        new PresetCastTraxService().deleteFirm(cashtrxEnt);
    }
    
    @isTest
    private static void testcreateFirmLocation() {
        CashtraxEntities.FirmLocation cashtrxEnt = new CashtraxEntities.FirmLocation();
        cashtrxEnt.CRM_FirmID = '0017e00001NLbymAAD';
        cashtrxEnt.CRM_FirmLocationID = '0017e00001NLbymAAD';
        cashtrxEnt.FirmLocationID = '1234ert';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.FirmLocationName = 'test';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Address1 = 'adr 1';
        cashtrxEnt.Address2 = 'adr 2';
        cashtrxEnt.City = 'Connecticut';
        cashtrxEnt.State = 'MO';
        cashtrxEnt.ZipCode = '1234ER';
        cashtrxEnt.type = 'new'; 
        new PresetCastTraxService().createFirmLocation(cashtrxEnt);
    }
    
    @isTest
    private static void testcreateFirmLocationWhenNull() {
        CashtraxEntities.FirmLocation cashtrxEnt = new CashtraxEntities.FirmLocation();
        cashtrxEnt.CRM_FirmID = '';
        cashtrxEnt.CRM_FirmLocationID = '0017e00001NLbymAAD';
        cashtrxEnt.FirmLocationID = '1234ert';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.FirmLocationName = 'test';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Address1 = 'adr 1';
        cashtrxEnt.Address2 = 'adr 2';
        cashtrxEnt.City = 'Connecticut';
        cashtrxEnt.State = 'MO';
        cashtrxEnt.ZipCode = '1234ER';
        cashtrxEnt.type = 'new'; 
        new PresetCastTraxService().createFirmLocation(cashtrxEnt);
    }
      
    testmethod static void testupdateFirmO() {
        CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
        cashtrxEnt.CRM_FirmID = '0017e00001NLbymAAD';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.FirmName = 'Test';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Website = 'https://www.google.com';
        cashtrxEnt.fax = '9560682173';
        cashtrxEnt.type = 'new';
        cashtrxEnt.PhoneNumber = '9560682173';
        new PresetCastTraxService().updateFirm(cashtrxEnt);
    }
    
    testmethod static void testupdateFirmOWhenNull() {
        CashtraxEntities.Firm cashtrxEnt = new CashtraxEntities.Firm();
        cashtrxEnt.CRM_FirmID = '';
        cashtrxEnt.FirmID = '1234ert';
        cashtrxEnt.FirmName = 'Test';
        cashtrxEnt.HeadQuarter = true;
        cashtrxEnt.Website = 'https://www.google.com';
        cashtrxEnt.fax = '9560682173';
        cashtrxEnt.type = 'new';
        cashtrxEnt.PhoneNumber = '9560682173';
        new PresetCastTraxService().updateFirm(cashtrxEnt);
    }
    
    
    @isTest
    private static void testupdateAttorneyException1() {
        CashtraxEntities.Attorney request = null;
        new PresetCastTraxService().updateAttorney(request);
    }
}