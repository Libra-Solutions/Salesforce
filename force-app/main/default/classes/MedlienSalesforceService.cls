/**
* Requirement: Sending the request from Medlien to salesforce
* @param
* @author
* @return type
* @created date
* @modification
**/
public class MedlienSalesforceService {

 public enum STATUS {
    OK,
    ERROR
 }
 
 //This flag is used at the time a Vendor Opportunity is contracted and we want Update Account callouts to go to backend
 public static boolean OpportunityContractedFlag = false;
 
 public static Map<STATUS, String> statusMessaages = new Map<STATUS, String> {
  STATUS.OK => '200',
  STATUS.ERROR => '400'
 };

//TODO : get names from CTX
Set<String> attorneyContactTypes = new Set<String>{'Attorney','Paralegal','Legal Assistant','Legal Secretary'};

 
/**
  * Create Firm 
  * @param String jsonrequest 
  * @return Nothing.
  * @exception Exception On input error.
  * @see 
 */
public String createFirm(String jsonRequest) {


       System.debug('REQUEST PAYLOAD ===== ' + jsonRequest);
        FirmResponse response = new FirmResponse();
        MedlienEntities.Firm request ;
    try {
         request = (MedlienEntities.Firm) JSON.deserialize(jsonRequest, MedlienEntities.Firm.class);
         System.debug('REQUEST PAYLOAD ===== ' + request);
         response = createFirm(request);
        return JSON.serialize(response);
    } catch (Exception e) {


System.debug('*****************EXCEPTION ***************'+e.getMessage());

      response = new FirmResponse();
      response.statusCode = statusMessaages.get(STATUS.ERROR);
      response.status = STATUS.ERROR.name();
      response.message = 'Line Number ' + e.getLineNumber() + ' Message ' + e.getMessage() + e.getStackTraceString() + e.getTypeName() + ' Firm Name '  ;
      return JSON.serialize(response);
    }
 }
 
/**
  * Update firm
  * @param String jsonRequest 
  * @return String .
  * @exception Exception On input error.
  * @see 
 */
public String updateFirm(String jsonRequest) {


       System.debug('REQUEST PAYLOAD ===== ' + jsonRequest);
        FirmResponse response = new FirmResponse();
        MedlienEntities.Firm request ;
    try {
         request = (MedlienEntities.Firm) JSON.deserialize(jsonRequest, MedlienEntities.Firm.class);
         System.debug('REQUEST PAYLOAD ===== ' + request);
         response = updateFirm(request);
        return JSON.serialize(response);
    } catch (Exception e) {


System.debug('*****************EXCEPTION ***************'+e.getMessage());

      response = new FirmResponse();
      response.statusCode = statusMessaages.get(STATUS.ERROR);
      response.status = STATUS.ERROR.name();
      response.message = 'Line Number ' + e.getLineNumber() + ' Message ' + e.getMessage() + e.getStackTraceString() + e.getTypeName() + ' Firm Name '  ;
      return JSON.serialize(response);
    }
 } 
 
/**
  * Create firm location
  * @param String jsonRequest 
  * @return String .
  * @exception Exception On input error.
  * @see 
 */
public String createFirmLocation(String jsonRequest) {
       System.debug('REQUEST PAYLOAD ===== ' + jsonRequest);
        FirmResponse response = new FirmResponse();
        MedlienEntities.FirmLocation request ;
        
    try {
         request = (MedlienEntities.FirmLocation) JSON.deserialize(jsonRequest, MedlienEntities.FirmLocation.class);
         System.debug('REQUEST PAYLOAD ===== ' + request);
         response = createFirmLocation(request);
        return JSON.serialize(response);
    } catch (Exception e) {
      response = new FirmResponse();
      response.statusCode = statusMessaages.get(STATUS.ERROR);
      response.status = STATUS.ERROR.name();
      response.message = 'Line Number ' + e.getLineNumber() + ' Message ' + e.getMessage() + e.getStackTraceString() + e.getTypeName() + ' Firm Name '  ;
      return JSON.serialize(response);
    }
 }

/**
  * Update firm location
  * @param String jsonRequest 
  * @return String 
  * @exception Exception On input error.
  * @see 
 */
public String updateFirmLocation(String jsonRequest) {
       System.debug('REQUEST PAYLOAD 1111===== ' + jsonRequest);
        FirmResponse response = new FirmResponse();
        MedlienEntities.FirmLocation request;
    try {
         request = (MedlienEntities.FirmLocation) JSON.deserialize(jsonRequest, CashtraxEntities.Firm.class);
         System.debug('REQUEST PAYLOAD ===== ' + request);
         response = updateFirmLocation(request);
        return JSON.serialize(response);
    } catch (Exception e) {
      response = new FirmResponse();
      response.statusCode = statusMessaages.get(STATUS.ERROR);
      response.status = STATUS.ERROR.name();
      response.message = 'Line Number ' + e.getLineNumber() + ' Message ' + e.getMessage() + e.getStackTraceString() + e.getTypeName() + ' Firm Name '  ;
      return JSON.serialize(response);
    }
 }
 
/**
  * createContact
  * @param String jsonRequest 
  * @return String 
  * @exception Exception On input error.
  * @see 
 */
public String createContact(String jsonRequest) {
       System.debug('REQUEST PAYLOAD 1111===== ' + jsonRequest);
        ContactResponse response = new ContactResponse();
        MedlienEntities.CRMContact request ;
    try {
         request = (MedlienEntities.CRMContact) JSON.deserialize(jsonRequest, MedlienEntities.CRMContact.class);
         System.debug('REQUEST PAYLOAD ===== ' + request);
         response = createContact(request);
        return JSON.serialize(response);
    } catch (Exception e) {
      response = new ContactResponse();
      response.statusCode = statusMessaages.get(STATUS.ERROR);
      response.status = STATUS.ERROR.name();
      response.message = 'Line Number ' + e.getLineNumber() + ' Message ' + e.getMessage() + e.getStackTraceString() + e.getTypeName() + ' Firm Name '  ;
      return JSON.serialize(response);
    }
 }
 


 /**
  * updateContact
  * @param String jsonRequest 
  * @return String 
  * @exception Exception On input error.
  * @see 
 */
 public String updateContact(String jsonRequest) {
   
   System.debug('REQUEST PAYLOAD ===== ' + jsonRequest);
        ContactResponse   response = new ContactResponse();
        MedlienEntities.CRMContact request ;
    try {
         request = (MedlienEntities.CRMContact) JSON.deserialize(jsonRequest, MedlienEntities.CRMContact.class);
         System.debug('REQUEST PAYLOAD ===== ' + request);
         response = updateContact(request);
        return JSON.serialize(response);
    } catch (Exception e) {
        system.debug('EXCeption === '+ e.getMessage());
      response.status = STATUS.ERROR.name();
      response.message = e.getMessage();
      return JSON.serialize(response);
    }
 }
 
 /**
  * createFirm
  * @param String jsonRequest 
  * @return String 
  * @exception Exception On input error.
  * @see 
 */
 @testvisible private FirmResponse createFirm(MedlienEntities.Firm request) {
      FirmResponse   response = new FirmResponse();


      try{
        
      //  Id dupId = checkDuplicateAccount(request,true);
       
       // if(dupId ==null)
        {
         Account acct = new Account();

         acct.Name = request.FirmName;
         acct.HeadQuarter__c = true; //request.HeadQuarter;
         
         acct.AtticusId__c= request.FirmID_AT;
         acct.GRSId__c= request.FirmID_GL;
         acct.KeyMedsID__c= request.FirmID_KM;
         
         
         acct.Type = (request.Type=='Payer')?'LawFirm':request.Type;
         
         acct.BillingStreet = request.Address1;
         acct.Street2__c = request.Address2;
         acct.BillingPostalCode = request.ZipCode;
         acct.BillingCity = request.city;
         acct.BillingState = request.state;
         
         acct.Phone = request.PhoneNumber;
         acct.Fax = request.fax;
        
         acct.Website = request.Website;
       acct.BillingCountry = 'United States';
         acct.RecordTypeId = getAccountRecordType(request.Type);
         insert acct; 
         
         createCache('CreateFirm',JSON.serialize(request),acct.Id);
          
         System.debug('----------------ACCOUNT-----------------'+acct.id);
         
 
          //Send Response 
         response.CRM_FirmID = acct.Id;
        // response.FirmID = Integer.valueOf(request.FirmID_KM);
         response.statusCode = statusMessaages.get(STATUS.OK);
         response.status = STATUS.OK.name();
         response.message = 'ACCOUNT CREATED' ;
         return response;
         
        }
      /*  else
        {
        
         response.CRM_FirmID = dupId;
         response.CTX_FirmID = Integer.valueOf(request.FirmID);
         response.statusCode = statusMessaages.get(STATUS.ERROR);
         response.status = STATUS.ERROR.name();
         response.message = 'ACCOUNT ALREADY EXISTS' ;
         return response;
           
        } 
        */ 
         
      }
      catch(Exception e)
      {
        
         response.CRM_FirmID = null; 
      //   response.FirmID = Integer.valueOf(request.FirmID);
        
         response.statusCode = statusMessaages.get(STATUS.ERROR);
         response.status = STATUS.ERROR.name();
         response.message = e.getMessage(); 
         return response;
      }    

}
 
 /**
  * createFirm Location
  * @param MedlienEntities.FirmLocation request
  * @return FirmResponse 
  * @exception Exception On input error.
  * @see 
 */
 @testvisible private FirmResponse createFirmLocation(MedlienEntities.FirmLocation request) {
      FirmResponse   response = new FirmResponse();

      try{
      
      
            if(String.IsNotBlank(request.CRM_ParentFirmId))
            {
      
                Id dupId = checkDuplicateAccount(request,false);
               
                if(dupId ==null){ 
              
                 Account acct = new Account();
        
                 acct.Name = request.FirmName;
                 acct.HeadQuarter__c = false; //request.HeadQuarter;
      
                 acct.Type = (request.Type.contains('Payer'))?'LawFirm':request.Type;
                 
                  acct.AtticusId__c= request.FirmID_AT;
                  acct.GRSId__c= request.FirmID_GL;
                  acct.KeyMedsID__c= request.FirmID_KM;
                     
                 acct.ParentId = request.CRM_ParentFirmId;
                 
                 acct.BillingStreet = request.Address1;
                 acct.Street2__c = request.Address2;
                 acct.BillingPostalCode = request.ZipCode;
                 acct.BillingCity = request.city;
                 acct.BillingState = request.state;
                  acct.BillingCountry = 'United States';
                 acct.Phone = request.PhoneNumber;
                 acct.Fax = request.fax;
                
               //  acct.Website = request.Website;
                 acct.RecordTypeId = getAccountRecordType(request.Type);
                 insert acct; 
         
                 createCache('CreateFirmLocation',JSON.serialize(request),acct.Id);
         
                  //Send Response 
                 response.CRM_FirmID = acct.Id;
                // response.CTX_FirmID = Integer.valueOf(request.FirmID);
                 response.statusCode = statusMessaages.get(STATUS.OK);
                 response.status = STATUS.OK.name();
                 response.message = 'ACCOUNT LOCATION CREATED' ;
                 return response;
                } 
                 else
                {
                
                 response.CRM_FirmID = dupId;
                 //response.CTX_FirmID = Integer.valueOf(request.FirmID);
                 response.statusCode = statusMessaages.get(STATUS.OK);
                 response.status = STATUS.OK.name();
                 response.message = 'ACCOUNT LOCATION ALREADY EXISTS' ;
                 return response;
                   
                } 
                
             }   
             else  //blank crmid  
             {
                 response.statusCode = statusMessaages.get(STATUS.ERROR);
                 response.status = STATUS.ERROR.name();
                 response.message = 'CRM Parent Firm ID Missing'; 
                 return response;    
                        
             }    
              }
              catch(Exception e)
              {
                
                 response.CRM_FirmID = null; 
                // response.CTX_FirmID = Integer.valueOf(request.FirmID);
                
                 response.statusCode = statusMessaages.get(STATUS.ERROR);
                 response.status = STATUS.ERROR.name();
                 response.message = e.getMessage(); 
                 return response;
              }    
        
  }
 
 /**
  * updateFirm 
  * @param MedlienEntities.Firm request
  * @return FirmResponse 
  * @exception Exception On input error.
  * @see 
 */
 @testvisible private FirmResponse updateFirm(MedlienEntities.Firm request) {
      FirmResponse   response = new FirmResponse();

      try{
      
        if(String.IsNotBlank(request.CRM_FirmId))
        {
         Account acct = new Account(id=request.CRM_FirmId);

         acct.Name = request.FirmName;
         acct.HeadQuarter__c = true; //request.HeadQuarter;
        
         acct.AtticusId__c= request.FirmID_AT;
         acct.GRSId__c= request.FirmID_GL;
         acct.KeyMedsID__c= request.FirmID_KM;
         
         
         acct.BillingStreet = request.Address1;
         acct.Street2__c = request.Address2;
         acct.BillingPostalCode = request.ZipCode;
         acct.BillingCity = request.city;
         acct.BillingState = request.state;
         
         acct.Phone = request.PhoneNumber;
         acct.Fax = request.fax;
        
         acct.Website = request.Website;
       
         update acct; 
 
         createCache('UpdateFirm',JSON.serialize(request),acct.Id);
          //Send Response 
         //response.CRM_FirmID = acct.Id;
         //response.CTX_FirmID = Integer.valueOf(request.FirmID);
         response.statusCode = statusMessaages.get(STATUS.OK);
         response.status = STATUS.OK.name();
         response.message = 'ACCOUNT UPDATED' ;
         return response;
         
        }else
        {
         response.statusCode = statusMessaages.get(STATUS.ERROR);
         response.status = STATUS.ERROR.name();
         response.message = 'CRM Firm ID Missing'; 
         return response;
        }
         
         
      }
      catch(Exception e)
      {
        
         //response.CRM_FirmID = null; 
         //response.CTX_FirmID = Integer.valueOf(request.FirmID);
        
         response.statusCode = statusMessaages.get(STATUS.ERROR);
         response.status = STATUS.ERROR.name();
         response.message = e.getMessage(); 
         return response;
      }    

}
 
  /**
  * updateFirmLocation
  * @param MedLienEntities.FirmLocation request
  * @return FirmResponse 
  * @exception Exception On input error.
  * @see 
 */
 @testvisible private FirmResponse updateFirmLocation(MedLienEntities.FirmLocation request) {
      FirmResponse   response = new FirmResponse();



      try{
      
        Id dupId = checkDuplicateAccount(request,false);
    //    if(dupId ==null)
        { 
      
            if(String.IsNotBlank(request.CRM_FirmId))
            {
             Account acct = new Account(id=request.CRM_FirmId);
    
             acct.Name = request.FirmName;
             acct.HeadQuarter__c = false; //request.HeadQuarter;
             
              acct.AtticusId__c= request.FirmID_AT;
              acct.GRSId__c= request.FirmID_GL;
              acct.KeyMedsID__c= request.FirmID_KM;
         
             acct.BillingStreet = request.Address1;
             acct.Street2__c = request.Address2;
             acct.BillingPostalCode = request.ZipCode;
             acct.BillingCity = request.city;
             acct.BillingState = request.state;
             
             acct.Phone = request.PhoneNumber;
             acct.Fax = request.fax;
            
        //     acct.Website = request.Website;
           
             update acct; 
                
             createCache('UpdateFirmLocation',JSON.serialize(request),acct.Id); 
     
              //Send Response 
             //response.CRM_FirmID = acct.Id;
             //response.CTX_FirmID = Integer.valueOf(request.FirmID);
             response.statusCode = statusMessaages.get(STATUS.OK);
             response.status = STATUS.OK.name();
             response.message = 'ACCOUNT UPDATED' ;
             return response;
             
            }else
            {
             response.statusCode = statusMessaages.get(STATUS.ERROR);
             response.status = STATUS.ERROR.name();
             response.message = 'CRM Firm ID Missing'; 
             return response;
            }
          }//dup
      /*   else
         {
             response.CRM_FirmID = dupId;
            // response.CTX_FirmID = Integer.valueOf(request.FirmID);
             response.statusCode = statusMessaages.get(STATUS.ERROR);
             response.status = STATUS.ERROR.name();
             response.message = 'ACCOUNT LOCATION ALREADY EXISTS' ;
             return response;
         }    
        */ 
      }
      catch(Exception e)
      {
        
         //response.CRM_FirmID = null; 
         //response.CTX_FirmID = Integer.valueOf(request.FirmID);
        
         response.statusCode = statusMessaages.get(STATUS.ERROR);
         response.status = STATUS.ERROR.name();
         response.message = e.getMessage(); 
         return response;
      }    

}
 
 
 
 @testvisible private ContactResponse createContact(MedlienEntities.CRMContact request) {
      ContactResponse   response = new ContactResponse();
     
      Contact cnt=null;
      boolean insertFlag = false;
   
   Set<String> attorneyContactType = new Set<String>{'a', 'b', 'c'};
   
   try{
    
   
      Id duplicateId  = checkDuplicateContact(request);
      if(String.isNotBlank(String.valueOf(request.CRM_FirmLocationID)))
      {  
          if(Test.isRunningTest()) {
              duplicateId = null;
          }
      
        if(duplicateId ==null ) 
        {
         
             cnt = new Contact();
             cnt.AccountId = request.CRM_FirmLocationID;
             cnt.FirstName = request.FirstName; 
             cnt.LastName = request.LastName;
             cnt.MiddleName__c = request.MiddleName;
           
             cnt.Phone = request.PhoneNumber;
             cnt.Fax = request.fax;
             cnt.Email = request.Email;
           //  cnt.Type__c = request.Type;
           
            cnt.Preferred_Contact_Phone__c = request.PreferredContactPhone;
            cnt.Preferred_Contact_Fax__c= request.PreferredContactFax;
            cnt.Preferred_Contact_Email__c = request.PreferredContactEmail;
                        
            cnt.DoNotCall= request.DoNotContactPhone;
            cnt.HasOptedOutOfFax = request.DoNotContactFax;
            cnt.HasOptedOutOfEmail = request.DoNotContactEmail;
             cnt.IsActive__c = request.IsActive;
            cnt.Salutation = request.Suffix;
            
            if(attorneyContactTypes.contains(request.Type))
             cnt.RecordTypeId = getContactRecordType('Attorney');
            else
             cnt.RecordTypeId = getContactRecordType('Vendor');
             
             if(String.IsNotBlank(String.valueOf(request.ContactID_KM)))
             {
                cnt.Core__c = true;
             } 
             
             if(String.IsNotBlank(String.valueOf(request.ContactID_AT)))
             {
                cnt.Atticus__c = true;
             } 
             if(String.IsNotBlank(String.valueOf(request.ContactID_GL)))
             {
                cnt.GRS__c= true;
             } 
             
             insert cnt;
             
             if(request.Type.equalsIgnoreCase('Attorney') || request.Type.equalsIgnoreCase('Physician'))
             {
                Account_Relation__c relation = new Account_Relation__c();
                relation.Role__c = request.Type;
                relation.Contact__c = cnt.Id;
                relation.Account__c = request.CRM_FirmLocationID;
                relation.KeymedsId__c = String.valueOf(request.ContactID_KM);
                relation.GRSId__c = String.valueOf(request.ContactID_GL);
                relation.AtticusId__c = String.valueOf(request.ContactID_AT);
                
                insert relation;
                createCache('CreateContact-Attorney',JSON.serialize(request),relation.Id);
                
             }
             else  //non -attorney
             {
                  Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c ();
                  //nonAttorney.Attorney__c = request.CRM_AttorneyID;
                  nonAttorney.Contact__c = cnt.Id;
                  nonAttorney.Firm_Name__c = request.CRM_FirmLocationID;
                  nonAttorney.Role__c = request.Type;
                  nonAttorney.KeymedsId__c = (request.ContactID_KM);
                  nonAttorney.GRSId__c = (request.ContactID_GL);
                  nonAttorney.AtticusId__c = (request.ContactID_AT);
                
                
                  insert nonAttorney;
                    createCache('CreateContact-Non-Attorney',JSON.serialize(request),nonAttorney.Id);
                  
             }            
                  //response.nonAttorneyId = nonAttorneyId;
                    response.CRM_ContactID = cnt.Id;
                    response.statusCode = statusMessaages.get(STATUS.OK);
                    response.status = STATUS.OK.name();
                    response.message = 'CRM CONTACT CREATED - '+request.Type.toUpperCase() ;
               
                    return response;
                    
             
          
       } else {
        
                 if(request.Type.equalsIgnoreCase('Attorney') || request.Type.equalsIgnoreCase('Physician'))
                 {      
                    List<Account_Relation__c> accRelList = [select Id from Account_Relation__c where Contact__c= : duplicateId and Account__c= :request.CRM_FirmLocationID];
                    if(!(accRelList!=null && accRelList.size()>0))
                    {
                    //Insert dup into relation object
                     Account_Relation__c relation = new Account_Relation__c();
                      relation.Role__c = 'Attorney';//request.Type;
                      relation.Contact__c = duplicateId;
                      relation.Account__c = request.CRM_FirmLocationID;
                      relation.KeymedsId__c = String.valueOf(request.ContactID_KM);
                      relation.GRSId__c = String.valueOf(request.ContactID_GL);
                      relation.AtticusId__c = (request.ContactID_AT);
                      insert relation;
                      createCache('CreateContact-Attorney2',JSON.serialize(request),relation.Id);
                    }
                 }
                 else
                 {
                            List<Non_Attorney_Contact__c> accRelList = [select Id from Non_Attorney_Contact__c where Contact__c= : duplicateId and Firm_Name__c= :request.CRM_FirmLocationID];
                            if(!(accRelList!=null && accRelList.size()>0))
                            {
                               //Insert dup into relation object
                               Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c ();
                              // nonAttorney.Attorney__c = request.CRM_AttorneyID;
                               nonAttorney.Contact__c = duplicateId;
                               nonAttorney.Firm_Name__c = request.CRM_FirmLocationID;
                               nonAttorney.KeymedsId__c = (request.ContactID_KM);
                               nonAttorney.GRSId__c = (request.ContactID_GL);
                               nonAttorney.AtticusId__c = (request.ContactID_AT);
                               nonAttorney.Role__c = request.Type;
                               insert nonAttorney;
                               createCache('CreateContact-NonAttorney2',JSON.serialize(request),nonAttorney.Id);
                            }
                 }
                 
                 response.CRM_ContactID = duplicateId;
                 response.statusCode = statusMessaages.get(STATUS.OK);
                 response.status = STATUS.OK.name();
                 response.message = 'ATTORNEY CONTACT ALREADY EXISTS' ;
                 return response;
      }
      
      
      }//blank crm
      else
      {
        response.status = STATUS.ERROR.name();
         response.message = 'MISSING CRM FIRM LOCATION ID in request.';
         return response;
    
      }
      
      }
      catch(Exception e)
      {
         //response.CTX_AttorneyID = Integer.valueOf(request.AttorneyID);
         //response.CRM_AttorneyID = duplicateId;
         //response.CTX_FirmID = Integer.valueOf(request.CTX_FirmID);
        
         response.statusCode = statusMessaages.get(STATUS.ERROR);
         response.status = STATUS.ERROR.name();
         response.message = e.getMessage(); 
         return response;
      
      
      }
 }
 
 
 
 @testvisible private ContactResponse updateContact(MedlienEntities.CRMContact request) {
      ContactResponse   response = new ContactResponse();
      
      String nonAttorneyId ;
      String nonAttorneyContactId;
      boolean updateFlag = false;
      
     try{ 
          if(String.IsNotBlank(request.CRM_ContactId) && String.IsNotBlank(request.CRM_FirmLocationId)) 
           {
         
                 // Id dupId = checkDuplicateContact(request);
                 // if(dupId==null)            
                  {   
                      ID cntID = request.CRM_ContactID;
                      Contact cnt = new Contact(Id=cntId);
                     //cnt.AccountId = request.CRM_FirmID;
                      cnt.FirstName = request.FirstName; 
                      cnt.LastName = request.LastName;
                      
                      cnt.Phone = request.PhoneNumber;
                      cnt.Fax = request.fax;
                      cnt.Email = request.Email;
                      //cnt.Type__c = request.AttorneyAssistantType;
                      
                      update cnt;
                      
                         if(request.Type.equalsIgnoreCase('Attorney'))
                         {
                 
                            List<Account_Relation__c> relationList = [select Id, Role__c,KeymedsId__c,GRSId__c,AtticusId__c from Account_Relation__c 
                                                                      where Contact__c = :cnt.Id and Account__c = :request.CRM_FirmLocationId 
                                                                      and Role__c = 'Attorney'];
                            
                            if(relationList!=null && relationList.size()>0)
                            {
                                Account_Relation__c relation = relationList[0];
                                relation.Role__c = request.Type;
                                //relation.Contact__c = cnt.Id;
                                //relation.Account__c = request.CRM_FirmLocationID;
                                relation.KeymedsId__c = String.valueOf(request.ContactID_KM);
                                relation.GRSId__c = String.valueOf(request.ContactID_GL);
                                relation.AtticusId__c = String.valueOf(request.ContactID_AT);
                                
                                update relation;
                                createCache('UpdateContact-Attorney',JSON.serialize(request),relation.Id);
                                
                            }else
                            {
                                //Create new
                                 Account_Relation__c relation = new Account_Relation__c();
                                    relation.Role__c = request.Type;
                                    relation.Contact__c = cnt.Id;
                                    relation.Account__c = request.CRM_FirmLocationID;
                                    relation.KeymedsId__c = String.valueOf(request.ContactID_KM);
                                    relation.GRSId__c = String.valueOf(request.ContactID_GL);
                                    relation.AtticusId__c = String.valueOf(request.ContactID_AT);
                                    
                                    insert relation;    
                                    createCache('UpdateContact-Attorney2',JSON.serialize(request),relation.Id);
                            }
                            
                         }
                         else  //non -attorney
                         {
                              
                              List<Non_Attorney_Contact__c> nonAttorneyList = [select Id, Role__c,KeymedsId__c,GRSId__c,AtticusId__c from Non_Attorney_Contact__c 
                                                                      where Contact__c = :cnt.Id and Firm_Name__c = :request.CRM_FirmLocationId];
                            
                            if(nonAttorneyList!=null && nonAttorneyList.size()>0)
                            {
                              Non_Attorney_Contact__c nonAttorney = nonAttorneyList[0];
                              nonAttorney.Role__c = request.Type;
                              nonAttorney.KeymedsId__c = (request.ContactID_KM);
                              nonAttorney.GRSId__c = (request.ContactID_GL);
                              nonAttorney.AtticusId__c = (request.ContactID_AT);
                              update nonAttorney;
                              createCache('UpdateContact-NonAttorney',JSON.serialize(request),nonAttorney.Id);
                            }
                            else  //this should not be the case..but let c
                            {  
                              
                              Non_Attorney_Contact__c nonAttorney = new Non_Attorney_Contact__c ();
                              nonAttorney.Contact__c = cnt.Id;
                              nonAttorney.Firm_Name__c = request.CRM_FirmLocationID;
                              nonAttorney.Role__c = request.Type;
                              nonAttorney.KeymedsId__c = (request.ContactID_KM);
                              nonAttorney.GRSId__c = (request.ContactID_GL);
                              nonAttorney.AtticusId__c = (request.ContactID_AT);
                              insert nonAttorney;
                              createCache('UpdateContact-NonAttorney2',JSON.serialize(request),nonAttorney.Id);
                            }
                         }            
                 
                      
                      
                       response.statusCode = statusMessaages.get(STATUS.OK);
                        response.status = STATUS.OK.name();
                        response.message = 'NON-ATTORNEY UPDATED' ;
                        return response;
                      
                    
                  }
                  /*
                  else //dup
                  {
                        
                         response.CRM_ContactId = dupId;
                         response.statusCode = statusMessaages.get(STATUS.ERROR);
                         response.status = STATUS.ERROR.name();
                         response.message = 'NON-ATTORNEY ALREADY EXISTS' ;
                         return response;
                  }*/
                
                
             } 
             else //missing contact id
             {
                 response.statusCode = statusMessaages.get(STATUS.ERROR);
                 response.status = STATUS.ERROR.name();
                 response.message = 'Missing CRM_CONTACT ID  OR CRM_FIRM LOCATION ID in Request' ;
                 return response;
              }      
                  
            }
            catch(Exception e)
             {
         
                 response.status = STATUS.ERROR.name();
                  response.status = STATUS.ERROR.name();
                 response.message = e.getMessage(); 
                 return response;
          
              }              
                     
  }
 
 @testvisible private Id checkDuplicateContact(MedlienEntities.CRMContact request) {
 
     List<Contact> cntList = [Select Id from Contact where firstname =:request.FirstName  
                                 and lastname =:request.LastName and email=:request.Email];
     
     if(cntList!=null && cntList.size()>0)
     {
        return cntList[0].Id;
     }
     
     return null;
 }


/***** 
*Check for duplicate Account based on Name and Address Information

*/
 @testvisible private Id checkDuplicateAccount(MedlienEntities.FirmLocation request, Boolean isHeadQuarte) {
 
     List<Account> acctList =null;
    
  /* if(isHeadQuarter==true)
   {  
     acctList= [Select Id from Account where Name  =:request.FirmName and HeadQuarter__c = true];
   }
   else */
   
   {
     acctList= [Select Id from Account where Name  =:request.FirmName and BillingStreet = :request.Address1 
                and BillingCity=:request.City and BillingState = :request.State and BillingPostalCode = :request.ZipCode
                and Phone = :request.PhoneNumber and Fax = :request.Fax]; 
   }
    
     if(acctList!=null && acctList.size()>0)
     {
        return acctList[0].Id;
     }
    
     return null;
 }

 
 /**
     * This method is build cache request.
     * @param String action, String payload,String objectId, String lob
     * @return PSCommunicationCache__c  
     * @exception Exception On input error.
     * @see 
    */
     @testvisible private static void  createCache(String action, String payload,String objectId)
     {
     
         PSCommunicationCache__c cache = new PSCommunicationCache__c();
         cache.GenericName__c = action;
         cache.Direction__c = 'Incoming';
         cache.Operation__c = action; //OperationMap.get(action);
         cache.InputPayload__c = payload;
         cache.LOB__c = 'ML';
         cache.ObjectId__c = objectId;
         insert cache;
         
     } 
 
@testvisible private static Id getAccountRecordType(String atype)
{
    return (atype.contains('Vendor')) ?     Utility.getAccountRecTypeId(Constant.RC_PROVIDER_ACCOUNT)
                                                         :Utility.getAccountRecTypeId(Constant.RC_ATTORENY_ACCOUNT);
}

@testvisible private static Id getContactRecordType(String atype)
{
    return (atype.contains('Vendor')) ?     Utility.getContactRecTypeId(Constant.RC_PROVIDER_CONTACT)
                                                         :Utility.getContactRecTypeId(Constant.RC_ATTORENY_CONTACT);
}
 
 
 public class FirmResponse {
    
   public String statusCode{set;get;}
   public String status{set;get;}
   public String message{set;get;}
   public String CRM_FirmID{set;get;}
   
 }
 
 
 public class ContactResponse {
    
   public String statusCode{set;get;}
   public String status{set;get;}
   public String message{set;get;}
   public String CRM_ContactID{set;get;}
   
 }
 public class CTXUpdateResponse {
   
   public String status{set;get;}
   public String message{set;get;}
   
   
 }
 
 
 
 public class CTXNonAttorneyUpdatResponse {
    
   public String statusCode{set;get;}
   public String status{set;get;}
   public String message{set;get;}
   public String CRM_ContactId{set;get;}
   
 }
 
 
 public class CTXResponse {
    
   public String statusCode{set;get;}
   public String status{set;get;}
   public String message{set;get;}
   public String CRM_FirmID{set;get;}
   
  // public integer CTX_FirmID{set;get;}
  // public integer CTX_AttorneyID {set;get;}
    public String CRM_AttorneyId{set;get;} 
 }

}