@isTest
public class LeadTriggerUtilityHandlerTest {

        
    static testMethod void tstAttorneyAtticusMethod(){
        Id recTypeIdLeadAttorney = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        Id recTypeIdAccAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        convertLead('Atticus',recTypeIdLeadAttorney,recTypeIdAccAttorney);  
    }
    static testMethod void tstAttorneyGRSMethod(){
        Id recTypeIdLeadAttorney = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        Id recTypeIdAccAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        convertLead('GRS',recTypeIdLeadAttorney,recTypeIdAccAttorney);
    }
    static testMethod void tstAttorneyCoreMethod(){
        Id recTypeIdLeadAttorney = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        Id recTypeIdAccAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        convertLead('Core',recTypeIdLeadAttorney,recTypeIdAccAttorney);
    }
    static testMethod void tstAttorneyPreSettlementMethod(){
        Id recTypeIdLeadAttorney = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        Id recTypeIdAccAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        convertLead('Pre-Settlement',recTypeIdLeadAttorney,recTypeIdAccAttorney);
    }
    static testMethod void tstAttorneyAccidentMedsMethod(){
        Id recTypeIdLeadAttorney = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        Id recTypeIdAccAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();       
        convertLead('Accident Meds',recTypeIdLeadAttorney,recTypeIdAccAttorney);
    }

    static testMethod void tstProviderAtticusMethod(){
        
        Id recTypeIdLeadProvider = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Provider').getRecordTypeId(); 
        Id recTypeIdAccProvider = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        convertLead('Atticus',recTypeIdLeadProvider,recTypeIdAccProvider);
        
    }
    static testMethod void tstProviderGRSMethod(){
        
        Id recTypeIdLeadProvider = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Provider').getRecordTypeId(); 
        Id recTypeIdAccProvider = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        convertLead('GRS',recTypeIdLeadProvider,recTypeIdAccProvider);
        
    }
    static testMethod void tstProviderCoreMethod(){
        
        Id recTypeIdLeadProvider = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Provider').getRecordTypeId(); 
        Id recTypeIdAccProvider = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        convertLead('Core',recTypeIdLeadProvider,recTypeIdAccProvider);
        
    }
    static testMethod void tstProviderPreSettlementMethod(){
        
        Id recTypeIdLeadProvider = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Provider').getRecordTypeId(); 
        Id recTypeIdAccProvider = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        convertLead('Pre-Settlement',recTypeIdLeadProvider,recTypeIdAccProvider);
        
    }
    static testMethod void tstProviderAccidentMedsMethod(){
        
        Id recTypeIdLeadProvider = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Provider').getRecordTypeId(); 
        Id recTypeIdAccProvider = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        convertLead('Accident Meds',recTypeIdLeadProvider,recTypeIdAccProvider);
        
    }
    
    static testMethod void testExistingLocation(){
        
        Id recTypeIdLeadAttorney = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();  
        Id recTypeIdAccAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();            
        Lead led = UtiityHelperClass.createLead();
        led.recordtypeID = recTypeIdLeadAttorney;
        led.ProductInterest__c = 'Core';
        insert led;
        
        Account accparent = UtiityHelperClass.createAccount();
        accparent.Name = led.Company+', ' + led.City + ' ' + led.State + ' ' + led.PostalCode;
        accparent.HeadQuarter__c = true;
        //acc.name = 'TestCom';
        //insert accparent;
        
        Account acc = UtiityHelperClass.createAccount();
        acc.name = led.Company+', ' + led.City + ' ' + led.State + ' ' + led.PostalCode;
        acc.HeadQuarter__c = false;
        acc.recordtypeid = recTypeIdAccAttorney;
        acc.BillingStreet = led.Street;
        acc.BillingCity = led.City;
        acc.BillingState = led.State;
        acc.BillingPostalCode = led.PostalCode;
        acc.Phone = led.Phone;
        acc.Fax = led.Fax;
        //acc.parentId = accparent.id;
        insert acc;
        
        /*
        Account acc = UtiityHelperClass.createAccount();
        acc.Name = led.Company+', ' + led.City + ' ' + led.State + ' ' + led.PostalCode;
        acc.HeadQuarter__c = false;
        //acc.name = 'TestCom';
        insert acc;
           
        
        Account childAcc = UtiityHelperClass.createAccount();
        childAcc.Name = led.Company+', ' + led.City + ' ' + led.State + ' ' + led.PostalCode;
        childAcc.recordtypeId = recTypeIdAccAttorney;
        childAcc.HeadQuarter__c = false;
        childAcc.Atticus__c = true;
        childAcc.GRS__c = true;
        childAcc.Core__c = true;
        childAcc.PreSet__c = true;
        childAcc.Accident_Meds__c = true;
        childAcc.parentid = null;
        insert childAcc;
        */
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(led.Id);
        
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        
    }
    
     public static void convertLead(string productIntrest, id leadRecordTypeId, id accRecordTypeId){
        Lead led = UtiityHelperClass.createLead();
        led.recordtypeID = leadRecordTypeId;
        led.ProductInterest__c = productIntrest;
        insert led;
        
        
        
        Account childAcc = UtiityHelperClass.createAccount();
        childAcc.Name = led.Company+', ' + led.City + ' ' + led.State + ' ' + led.PostalCode;
        childAcc.recordtypeId = accRecordTypeId;
        childAcc.HeadQuarter__c = false;
        childAcc.Atticus__c = true;
        childAcc.GRS__c = true;
        childAcc.Core__c = true;
        childAcc.PreSet__c = true;
        childAcc.Accident_Meds__c = true;
        childAcc.BillingStreet = 'test';
        insert childAcc;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(led.Id);
        
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
     }
     
}