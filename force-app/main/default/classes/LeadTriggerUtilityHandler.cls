/**
 * Requirement: Sending the request from cashtrax to salesforce
 * @param
 * @author
 * @return type
 * @created date
 * @modification
 **/
public class LeadTriggerUtilityHandler {

    /**
     * Convert lead
     * @param List<Lead> , Map<Id, Lead> 
     * @return 
     * @exception Exception On input error.
     * @see 
     */
    Public static void ConvertLead(List <Lead> ledObj, Map <Id, Lead> oldMap) {

        // no bulk processing; will only run from the UI
        if (ledObj.size() == 1) {

            CashTraxEntities.UpdateComingFromLeadConversion =true;

            if (oldMap.get(ledObj[0].Id).isConverted == false && ledObj[0].isConverted == true) {

                // if a new account was created
                if (ledObj[0].ConvertedAccountId != null) {

                    Id recTypeIdLeadProvider = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Provider').getRecordTypeId();

                    Id recTypeIdLeadAttorney = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();

                    Id recTypeIdAccAttorney = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();
                    Id recTypeIdAccProvider = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();

                    Id recTypeIdConAttorney = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Attorney').getRecordTypeId();
                    Id recTypeIdConProvider = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Provider').getRecordTypeId();

                    Id recTypeIdOppStand = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Law Firm').getRecordTypeId();
                    Id recTypeIdOppProvider = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Provider').getRecordTypeId();



                       String query = 'SELECT';
                      Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
                       
                       
                              
                      // Grab the fields from the describe method and append them to the queryString one by one.
                        for(String s : objectFields.keySet()) {
                      
                          Schema.DescribeFieldResult field = objectFields.get(s).getDescribe();  
                            
                         if(s.startsWith('kw_')) continue;
                           
                           if(field.isUpdateable()) query += ' ' + s + ',';
                        }
                                                       
                       // Strip off the last comma if it exists.
                        if (query.endsWith(',')){
                            query = query.subString(0,query.length()-1);
                        }
                        
                                    
                    /*    

                    // update the converted account with data from the lead
                    List <Account> convertedAccount = [Select Id, Name, ParentId, HeadQuarter__c, Type,Phone,Fax,Facility_Type__c,
                                                                Atticus__c,GRS__c,Core__c,PreSet__c,Accident_Meds__c , Region__c, GMSA__c,BillingStreet,
                                                                AtticusId__c,KeyMedsId__c
                                                                From Account Where Id =: ledObj[0].ConvertedAccountId];
                    */
                    
                    List <Account> convertedAccount = Database.query( query +' From Account where Id =\'' + ledObj[0].ConvertedAccountId + '\'');
                    
                    Boolean isLocationExists = false;
                    Account acc = new Account();
                    Account accLoc = new Account();
                    Id parentId = null;
                    //Create New Account Scenario
                    //Associate Headquarter as parent to location
                    if (convertedAccount != null && convertedAccount.size() > 0) {
                        if (convertedAccount[0].Headquarter__c == false) {
                            
                            system.debug('++++++++++++++++'+convertedAccount[0]);
                            acc.Name = convertedAccount[0].Name;  
                            acc.Headquarter__c = true;
                            if (ledObj[0].recordtypeId == recTypeIdLeadAttorney) {
                                acc.Type = 'LawFirm';
                                acc.RecordTypeId = recTypeIdAccAttorney;
                            
                                    
                                    //Updating Child Lob
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Atticus') ) {
                                        convertedAccount[0].Atticus__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('GRS') ) {
                                        convertedAccount[0].GRS__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Core') ) {
                                        convertedAccount[0].Core__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Pre-Settlement') ) {
                                        convertedAccount[0].PreSet__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Accident Meds') ) {
                                        convertedAccount[0].Accident_Meds__c = true;
                                    }
                                    //Multiselect code ends
                                    
                                    
                            
                            } else if (ledObj[0].recordtypeId == recTypeIdLeadProvider) {
                                acc.Type = 'Vendor';
                                acc.RecordTypeId = recTypeIdAccProvider;
                            
                            }
                            
                       
                            if (ledObj[0].recordtypeId == recTypeIdLeadAttorney) {
                                convertedAccount[0].Type = 'LawFirm';
                                convertedAccount[0].RecordTypeId = recTypeIdAccAttorney;
                            } else if (ledObj[0].recordtypeId == recTypeIdLeadProvider) {
                                convertedAccount[0].Type = 'VendorLocation';
                                convertedAccount[0].RecordTypeId = recTypeIdAccProvider;
                            }

                            convertedAccount[0].Facility_Type__c = ledObj[0].Type__c;

                            List <Account> existingParentList = [Select Id, Name,Atticus__c,GRS__c,Core__c,PreSet__c,BillingStreet,Accident_Meds__c,Facility_Type__c   from Account where Name =: ledObj[0].Company and Headquarter__c = true];
                            if (existingParentList != null && existingParentList.size() > 0) {parentId = existingParentList[0].Id;
                               
                             }else {
                                insert acc;
                                parentId = acc.id;
                            }

                            //Check if this is new or existing account chooosen
                            if (convertedAccount[0].ParentId == null) {
                                convertedAccount[0].ParentId = parentId;
                                convertedAccount[0].name = convertedAccount[0].name + ', ' + ledObj[0].City + ' ' + ledObj[0].State + ' ' + ledObj[0].PostalCode;
                               // system.debug('------------------->convertedAccount[0].name:'+convertedAccount[0].name);
                               // system.debug('------------------->Account Name:'+[SELECT Id, NAME,Headquarter__c FROM Account]);
                                

                                /*List <Account> existingLocationList = [Select Id, Phone,Fax,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingGeocodeAccuracy,
                                                                                            ShippingStateCode,AccountSource,SicDesc,Jigsaw,NumberOfEmployees,OwnerId,Industry,ShippingCountryCode,ShippingLatitude,ShippingLongitude,Website
                                                                                        ,ShippingCountry,Description,Site, BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingCity,BillingStateCode,BillingCountryCode, 
                                                                                        BillingCountry ,BillingPostalCode, BillingState,Name,Atticus__c,BillingStreet, GRS__c,Core__c,PreSet__c,Accident_Meds__c,Region__c, GMSA__c ,
                                                                                        No_of_Locations__c ,NumberOfLocations__c 
                                                                                        from Account where Name =: ConvertedAccount[0].Name and Headquarter__c = false
                                    and BillingStreet =: ledObj[0].Street and BillingCity =: ledObj[0].City
                                    and BillingState =: ledObj[0].State and BillingPostalCode =: ledObj[0].PostalCode
                                    and Phone =: ledObj[0].Phone and Fax =: ledObj[0].Fax
                                ];
                               */
                            
                               String phone = ledObj[0].Phone != null ? ledObj[0].Phone : '';
                               String fax= ledObj[0].Fax != null ? ledObj[0].Fax : '';
                               
                               // 8/28/2020 DW Add a handler for ' in the Account Name.                               

                               String query2 = ' FROM Account where Name =\''+ string.escapeSingleQuotes(ConvertedAccount[0].Name) +'\' and Headquarter__c = false'+
                                     ' and BillingStreet =\''+ ledObj[0].Street +'\' and BillingCity =\''+ ledObj[0].City+'\''+
                                     ' and BillingState=\''+ ledObj[0].State + '\' and BillingPostalCode =\''+ ledObj[0].PostalCode+'\''+
                                    ' and Phone =\''+ phone +'\' and Fax =\''+ fax+'\'';
                                   
                                    
                               system.debug('---------------'+query2);       
                               
                               query = query +' '+query2;
                               List <Account> existingLocationList  = Database.query (query);                                 
                                                               
                                system.debug('------------------->existingLocationList:'+existingLocationList.size());
                                system.debug('------------------->existingLocationList:'+existingLocationList);
                                system.debug('----------beforeMerge------->convertedAccount[0]'+convertedAccount[0]);
                                
                                //Id existingLocationId = null;
                                if (existingLocationList != null && existingLocationList.size() > 0) {
                                    //system.debug('----------------->existingLocationList[0]'+existingLocationList[0].GMSA__c);
                                    //system.debug('----------------->existingLocationList[0]'+existingLocationList[0].Region__c);
                                    isLocationExists = true;
                                
                                
                                                                    
                                    Map<String, SObjectField>  fields = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
                                      for(string str: fields.keySet()){
                                      
                                          Schema.DescribeFieldResult field = fields.get(str).getDescribe(); 
                                         
                                          //system.debug('field isUpdateable : '+field.isUpdateable());
                                          
                                          if(str.startsWith('kw_')){
                                            continue;
                                           }
                                           
                                           system.debug('str : '+str);
                                           system.debug('existingLocationList[0].get(field) : '+convertedAccount[0].get(str));
                                           
                                            if(field.isUpdateable()) 
                                            {
                                              if(field.isnillable() && convertedAccount[0].get(str) == null){
                                                
                                                system.debug(str +'------->'+existingLocationList[0].get(str)+'-->'+existingLocationList[0].get(str));
                                                    convertedAccount[0].put(str, existingLocationList[0].get(str));
                                                }
                                                else
                                                {
                                              
                                                 if(!field.isnillable()){
                                                    if(existingLocationList[0].get(str) != null){
                                                    
                                                    system.debug(str +'------->'+convertedAccount[0].get(str)+'-->'+existingLocationList[0].get(str));
                                                        convertedAccount[0].put(str, existingLocationList[0].get(str));
                                                    }
                                                  }
                                              
                                                }
                                            
                                            }  //isupdate
                                      }//for
                                    
                                   
                                    merge convertedAccount[0] existingLocationList[0];
                                    system.debug('--------AFterMerge--------->convertedAccount[0]---->'+convertedAccount[0]);
                                
                                    if(convertedAccount[0].RecordTypeId ==recTypeIdAccAttorney )
                                    {
                                    
                                        if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Atticus') ) {convertedAccount[0].Atticus__c = true;}
                                        if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('GRS') ) {convertedAccount[0].GRS__c = true;}
                                        if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Core') ) {convertedAccount[0].Core__c = true;}
                                        if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Pre-Settlement') ) {convertedAccount[0].PreSet__c = true;}
                                        if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Accident Meds') ) {convertedAccount[0].Accident_Meds__c = true;}
                                        
                                        // convertedAccount[0].Facility_Type__c = ledObj[0].Type__c;
                                         update convertedAccount[0];
                                         system.debug('-----------att------>convertedAccount[0]--->'+convertedAccount[0]);
                                    }
                                
                                } else {
                                    
                                    update convertedAccount[0];
                                    //existingLocationId = convertedAccount[0].Id;
                                }
                            }else{
                                    system.debug('==============>'+convertedAccount[0]);
                                  
                                if(convertedAccount[0].RecordTypeId ==recTypeIdAccAttorney )
                                { 
                                  
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Atticus') ) {
                                        convertedAccount[0].Atticus__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('GRS') ) {
                                        convertedAccount[0].GRS__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Core') ) {
                                        convertedAccount[0].Core__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Pre-Settlement') ) {
                                        convertedAccount[0].PreSet__c = true;
                                    }
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Accident Meds') ) {
                                        convertedAccount[0].Accident_Meds__c = true;
                                    }
                                  }
                                    update convertedAccount[0];
                            }

                            //Update Contact
                            List <Contact> conList = [Select id, accountId, Atticus__c, Core__c, GRS__c, Phone, Fax from Contact where id =: ledObj[0].convertedContactId];
                              
                              if (ledObj[0].recordtypeId == recTypeIdLeadAttorney) {
                              

                                if (conList != null && conList.size() > 0) {
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Atticus') ) {
                                    conList[0].Atticus__c = true;
                                }
                                if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('GRS') ) {
                                    conList[0].GRS__c = true;
                                }
                                if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Core') ) {
                                    conList[0].Core__c = true;
                                }
                                if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Pre-Settlement') ) {
                                    conList[0].PreSet__c = true;
                                }
                                if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Accident Meds') ) {
                                    conList[0].Accident_Meds__c = true;
                                }
                              
                              
                                    conList[0].RecordTypeId = recTypeIdConAttorney;
                                    //conList[0].Phone = ledObj[0].Phone;
                                    //conList[0].Fax = ledObj[0].Fax;
                              
                                } else if (ledObj[0].recordtypeId == recTypeIdLeadProvider) {
                                    conList[0].RecordTypeId = recTypeIdConProvider;
                                    //conList[0].Phone = ledObj[0].Phone;
                                    //conList[0].Fax = ledObj[0].Fax;
                                }
                            
                            }
                            
                            
                            if (ledObj[0].recordtypeId == recTypeIdLeadAttorney) {
                              

                                if (isLocationExists) {     
                                    conList[0].AccountId = convertedAccount[0].Id; //existingLocationId;
                              
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Atticus') ) {conList[0].Atticus__c = true;}
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('GRS') ) {conList[0].GRS__c = true;}
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Core') ) {conList[0].Core__c = true;}
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Pre-Settlement') ) {conList[0].PreSet__c = true;}
                                    if( ledObj[0].ProductInterest__c != null && ledObj[0].ProductInterest__c.contains('Accident Meds') ) {conList[0].Accident_Meds__c = true;}
                                    
                                }  
                              }
                                if (ledObj[0].recordtypeId == recTypeIdLeadProvider) {

                                    List <Account_Relation__c> relList = [select Id from Account_Relation__c where Account__c =: convertedAccount[0].Id and Contact__c =: ledObj[0].ConvertedContactId and Role__c = 'Physician'];
                                    if (!(relList != null && relList.size() > 0)) {
                                        Account_Relation__c aRel = new Account_Relation__c(Account__c = convertedAccount[0].Id, Contact__c = ledObj[0].ConvertedContactId, Role__c = 'Physician');
                                        insert aRel;
                                    }
                                } else {

                                    List <Account_Relation__c> relList = [select Id from Account_Relation__c where Account__c =: convertedAccount[0].Id and Contact__c =: ledObj[0].ConvertedContactId and Role__c = 'Attorney'];
                                    if (!(relList != null && relList.size() > 0)) {
                                        Account_Relation__c aRel = new Account_Relation__c(Account__c = convertedAccount[0].Id, Contact__c = ledObj[0].ConvertedContactId, Role__c = 'Attorney');
                                        insert aRel;
                                    }
                                }

                                update conList[0];

                            


                            //Updating Opportunity
                            if (ledObj[0].RecordTypeId == recTypeIdLeadProvider) {
                                List <Opportunity> oppList = [Select id, accountid, Name, amount,Facility_Type__c from opportunity where id =: ledObj[0].convertedOpportunityId];
                                if (oppList != null && oppList.size() > 0) {
                                    oppList[0].recordtypeid = recTypeIdOppProvider;
                                    oppList[0].amount = ledObj[0].Annual_Estimate__c;
                                    oppList[0].ProductInterest__c = ledObj[0].ProductInterest__c == null ? '' : ledObj[0].ProductInterest__c;
                                    oppList[0].Facility_Type__c = ledObj[0].Type__c;
                                    if (oppList[0].Name.endsWith('-')) {
                                        oppList[0].Name = ledObj[0].FirstName + ' ' + ledObj[0].LastName + ' - ' + ledObj[0].City + ' ' + ledObj[0].State + ' ' + ledObj[0].PostalCode;
                                    }
                                    update oppList[0];
                                }
                            }
                        }

                        
    

                    } // Closing of Converted Account Size Check
                    //Deleting Opportunity in case of Attorney
                    if (ledObj[0].RecordTypeId == recTypeIdLeadAttorney && ledObj[0].convertedOpportunityId != null) {
                    
                        //Move the Activities from Opp to Account, before deleting
                        system.debug('converted opp id: '+ledObj[0].convertedOpportunityId);
                        List<Task> taskList = [select Id, WhatId from Task where WhatId = :ledObj[0].convertedOpportunityId];
                        
                        if(taskList!=null && taskList.size()>0)
                        {
                            for(Task t: taskList)
                            {
                               t.WhatId =  ledObj[0].convertedAccountId;
                            }
                                update taskList;
                        }      


                        
                        List<Event> eventList = [select Id, WhatId, ownerId from Event where WhatId = :ledObj[0].convertedOpportunityId];
                        List<Event> clonedEvents = new List<Event>();
                        User assignedEventUser = new User();
                        if(eventList.size() > 0){
                            assignedEventUser = [SELECT Id, name FROM User WHERE Id =: eventList[0].ownerId LIMIT 1];
                        }
                        Set<Id> parentEventIds = new Set<Id>();
                        if(eventList!=null && eventList.size()>0)
                        {
                            for(Event t: eventList)
                            {
                                Event newEvent = t.clone(false, true, true, false);
                                newEvent.WhatId = ledObj[0].convertedAccountId;
                                clonedEvents.add(newEvent);
                                t.WhatId =  ledObj[0].convertedAccountId;
                            //     Schema.SObjectType objType = t.whatId.getSObjectType();
                            //     Schema.DescribeSObjectResult describeResult = objType.getDescribe();
                            // if(describeResult.getName() == 'Event'){
                            //         parentEventIds.add(t.WhatId);
                            //     } else {
                            //         t.WhatId =  ledObj[0].convertedAccountId;
                            //     }

                            } 
                            try{
                                update eventList;
                            } catch(exception e){
                                system.debug('Error in updating events: '+e.getMessage());
                                system.debug('event Id: '+eventList[0].Id);
                                try{
                                    insert clonedEvents;
                                } catch(exception f){
                                    system.debug('Error in inserting cloned events: '+f.getMessage());
                                }
                                
                                // if(parentEventIds.size()>0){
                                //     List<Event> parentEventList = [select Id, WhatId, ownerId from Event where Id IN: parentEventIds];
                                //     for(Event evt: parentEventList)
                                //     {
                                //         evt.WhatId =  ledObj[0].convertedAccountId;
                                //     }
                                //     try{
                                //         update parentEventList;
                                //     } catch(exception f){
                                //         system.debug('Error in updating parent events: '+f.getMessage());
                                //         system.debug('event Id: '+parentEventList[0].Id);
                                //     }
                            }
                        }
                            
                        
                    
                        list <Opportunity> oppList = [Select id, accountid from Opportunity where id =: ledObj[0].convertedOpportunityId];
                        if (oppList != null && oppList.size() > 0) {
                            delete oppList;
                        }
                    }
                }  
            }


        }

    }
}