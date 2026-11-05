/**********************************************************
    *@author             : 
    *@Version            : V 1.0
    *@Description        : 
    *@Test class         :
    **********************************************************/
public class OpportunityTriggerUtilityHandler {
      
    /**
     * This method is creating new Quick case records from salesforce to CTX.
     * @param List<Opportunity> oppList
     * @return CashtraxEntities.NewCase
     * @exception Exception On input error.
     * @see 
    */  
    Public static CashtraxEntities.NewCase CreateNewCase(Opportunity opp) {
        
        
        system.debug('===call class==>');
      //  list<CashtraxEntities.NewCase> newCaseList = new list<CashtraxEntities.NewCase>();
        CashtraxEntities.NewCase cse=null;
           //if(opp.recordtypeid == recTypeIdAuto || opp.recordtypeid == recTypeIdOther || opp.recordtypeid == recTypeIdWc)
            
                    cse = New CashtraxEntities.NewCase();
                    system.debug('==removeNull(opp.PlaintiffFirstName__c)==>'+removeNull(opp.PlaintiffFirstName__c));
                    if(opp.PlaintiffFirstName__c!=null || opp.PlaintiffFirstName__c == null )
                        cse.PlaintiffFirstName = removeNull(opp.PlaintiffFirstName__c);
                    if(opp.PlaintiffLastName__c!=null || opp.PlaintiffLastName__c==null)
                        cse.PlaintiffLastName  = removeNull(opp.PlaintiffLastName__c);
                    if(opp.PlaintiffAddress1__c!=null || opp.PlaintiffAddress1__c==null )
                        cse.Address1 = removeNull(opp.PlaintiffAddress1__c);
                    if(opp.PlaintiffAddress2__c!=null || opp.PlaintiffAddress2__c==null )
                        cse.Address2 = removeNull(opp.PlaintiffAddress2__c);
                    if(opp.PlaintiffCity__c!=null || opp.PlaintiffCity__c==null )
                        cse.City = removeNull(opp.PlaintiffCity__c);
                    
                    if(opp.PlaintiffState__c!=null || opp.PlaintiffState__c==null){
                        
                        String st = removeNull(opp.PlaintiffState__c);
                        if(st.trim().length()>2)
                        {
                            st =st.left(2);
                            
                        }
                        cse.State = st;
                    }
                    
                    if(opp.PlaintiffZipCode__c!=null || opp.PlaintiffZipCode__c==null)
                        cse.ZipCode = removeNull(opp.PlaintiffZipCode__c);  
                    if(opp.PlaintiffEmail__c!=null || opp.PlaintiffEmail__c==null)
                        cse.Email = removeNull(opp.PlaintiffEmail__c);
                    if(opp.PlaintiffPhoneNumber__c!=null || opp.PlaintiffPhoneNumber__c==null)
                        cse.Phone = removeNull(opp.PlaintiffPhoneNumber__c);
                    if(opp.RequestedAmount__c!=null || opp.RequestedAmount__c==null)
                        cse.AmountRequested = (opp.RequestedAmount__c);
                    if(opp.CaseType__c!=null || opp.CaseType__c==null)
                        cse.CaseType = removeNull(opp.CaseType__c);
                    if(opp.Accident_Type__c!=null || opp.Accident_Type__c==null)
                        cse.AccidentType = removeNull(opp.Accident_Type__c);
                    if(opp.Injuries__c!=null || opp.Injuries__c==null)
                        cse.Injuries = removeNull(opp.Injuries__c);
                    if(opp.Treatment__c!=null || opp.Treatment__c==null)
                        cse.Treatments = removeNull(opp.Treatment__c);  
                    if(opp.InsuranceName__c!=null || opp.InsuranceName__c==null)
                        cse.WhosInsurancePaid = removeNull(opp.InsuranceName__c);
                    if(opp.PlaintiffDateofBirth__c!=null || opp.PlaintiffDateofBirth__c==null)
                        cse.DOB = opp.PlaintiffDateofBirth__c;
                    if(opp.StateCase__c!=null || opp.StateCase__c==null)
                        cse.StateOfCourt = removeNull(opp.StateCase__c);
                    if(opp.Incident_Date__c!=null || opp.Incident_Date__c==null )
                        cse.IncidentDate = opp.Incident_Date__c;
                    if(opp.Plaintiff_Involvement__c!=null || opp.Plaintiff_Involvement__c==null)
                        cse.PlaintiffInvolvement = removeNull(opp.Plaintiff_Involvement__c);
                    if(opp.Treatments_Description__c!=null || opp.Treatments_Description__c==null)
                        cse.TreatmentsDescription = removeNull(opp.Treatments_Description__c);
                    if(opp.Additional_Information__c!=null || opp.Additional_Information__c==null )
                        cse.AdditionalInformation = removeNull(opp.Additional_Information__c);
                    if(opp.MoreThan1000Damage__c!=null || opp.MoreThan1000Damage__c==null)
                        cse.MoreThan1000Damage = removeNull(opp.MoreThan1000Damage__c);
                    if(opp.DescriptionofAccident__c!=null || opp.DescriptionofAccident__c==null)
                        cse.descriptionOfAccident = removeNull(opp.DescriptionofAccident__c);
                    if(opp.DescriptionofIncident__c!=null || opp.DescriptionofIncident__c==null)
                        cse.descriptionOfIncident = removeNull(opp.DescriptionofIncident__c);
                    if(opp.ClosedDescription__c!=null || opp.ClosedDescription__c==null)
                        cse.closedDescription = removeNull(opp.ClosedDescription__c);
                    if(opp.UIMUM__c!=null || opp.UIMUM__c==null)
                        cse.uimum = removeNull(opp.UIMUM__c);
                    if(opp.PropertyDamageAmount__c!=null || opp.PropertyDamageAmount__c==null)
                        cse.propertyDamageAmount = removeNull(opp.PropertyDamageAmount__c);
                    if(opp.PlaintiffWas__c!=null || opp.PlaintiffWas__c==null)
                        cse.plaintiffWas = removeNull(opp.PlaintiffWas__c);
                    if(opp.PlaintiffInjury__c!=null || opp.PlaintiffInjury__c==null)
                        cse.plaintiffInjury = removeNull(opp.PlaintiffInjury__c);
                    if(opp.If_Yes_how_much__c!=null || opp.If_Yes_how_much__c==null)
                        cse.ifYesHowMuch = removeNull(opp.If_Yes_how_much__c);
                    if(opp.Facility_Type__c!=null || opp.Facility_Type__c==null)
                        cse.facilityType = removeNull(opp.Facility_Type__c);
                    //if(opp.DB_Competitor__c!=null || opp.DB_Competitor__c==null)
                      //  cse.dbCompetetor = removeNull(opp.DB_Competitor__c);
                    if(opp.AverageWeeklyWage__c!=null || opp.AverageWeeklyWage__c==null)
                        cse.averageWeeklyWage = removeNull(opp.AverageWeeklyWage__c);
                    if(opp.IsSuitFiled__c!=null || opp.IsSuitFiled__c==null)
                        cse.isSuitFiled = removeNull(opp.IsSuitFiled__c);
                    if(opp.IsthereaSettlementOffer__c!=null || opp.IsthereaSettlementOffer__c==null)
                        cse.isthereaSettlementOffer = removeNull(opp.IsthereaSettlementOffer__c);
                    if(opp.IsthereathirdPartyAction__c!=null || opp.IsthereathirdPartyAction__c==null)
                        cse.isthereathirdPartyAction = removeNull(opp.IsthereathirdPartyAction__c);
                    if(opp.Liens_Against_Case__c!=null || opp.Liens_Against_Case__c==null)
                        cse.liensAgainstCase = removeNull(opp.Liens_Against_Case__c);
                    if(opp.Liability__c!=null || opp.Liability__c==null)
                        cse.liability = removeNull(opp.Liability__c);
                    if(opp.IsCaseAccepted__c!=null || opp.IsCaseAccepted__c==null)
                        cse.isCaseAccepted = removeNull(opp.IsCaseAccepted__c);
                    if(opp.HasPlaintiffReceivedAnyOffers__c!=null || opp.HasPlaintiffReceivedAnyOffers__c==null)
                        cse.hasPlaintiffReceivedAnyOffers = removeNull(opp.HasPlaintiffReceivedAnyOffers__c);
                    if(opp.Accident_Date__c!=null || opp.Accident_Date__c==null)
                        cse.accidentDate = opp.Accident_Date__c;
                    if(opp.OpenDate__c!=null || opp.OpenDate__c==null)
                        cse.openDate = opp.OpenDate__c;
                    if(opp.Other_Reason__c!=null || opp.Other_Reason__c==null)
                        cse.otherReason = removeNull(opp.Other_Reason__c);
                    if(opp.CloseDate!=null || opp.CloseDate==null)
                        cse.closeDate = opp.CloseDate;
                    if(opp.ClaimNumber__c!=null || opp.ClaimNumber__c==null)
                        cse.claimNumber = removeNull(opp.ClaimNumber__c);
                    if(opp.Additional_Case_Details__c!=null || opp.Additional_Case_Details__c==null)
                        cse.additionalCaseDetails = removeNull(opp.Additional_Case_Details__c);
        
                    if(opp.Offer_Amount__c!=null) {
                        cse.OfferAmount = opp.Offer_Amount__c;
                    } else {cse.OfferAmount = 0.0; 
                    }
                    if(opp.AmountOfCoverage__c!=null) {
                        cse.amountOfCoverage = opp.AmountOfCoverage__c;
                    } else {cse.amountOfCoverage = 0.0; 
                    }
                    if(opp.Probability!=null) {
                        cse.Probability = opp.Probability;
                    } else {cse.OfferAmount = 0.0; 
                    }
                  //  newCaseList.add(cse);
          
                    
          
          List<Account_Relation__c> accRelation = [select Id,PresetID__c from Account_Relation__c where 
                                                      Account__c = :opp.AccountId and Contact__c = :opp.Attorney__c]; 
          
          if(accRelation!=null && accRelation.size()>0){cse.AttorneyID = (accRelation[0].PresetID__c!=null) ?Integer.valueOf(accRelation[0].PresetID__c):0;
            }
          
          //cse.AttorneyID = 1441084;
          cse.CRM_ID = opp.Id;
          cse.CaseID = 0;
          
            system.debug('===newCaseList==>'+cse.AttorneyId +'---'+cse);
                            
        if(Utility.IsBlank(String.valueOf(cse.AttorneyID))) return null;
        
        
        
        return cse;
    }
       
    public static void updateAccountContactFlags(Opportunity opp,Id contactId)
    {
       
        MedlienSalesforceService.OpportunityContractedFlag = true; 
        
        String contractedProduct = opp.Contracted_Product__c;
        boolean fChanged=false, flocChanged=false;
        
        List<Account> accList = [select id,Name, ParentId, Atticus__c,Accident_Meds__c,Core__c,GRS__c,PreSet__c from Account where Id = :opp.AccountId];
        if(accList!=null && accList.size()>0)
        {
            //Account location
            Account acc = accList[0];
         
             
            //Update Parent to trigger calls
            if(acc.ParentId!=null){  
                //Parent Account    
                List<Account> accList2 = [select id,Name, ParentId, Atticus__c,Accident_Meds__c,Core__c,GRS__c,PreSet__c from Account where Id = :acc.ParentId];
                if(accList2!=null && accList2.size()>0)
                {
                    Account acc2 = accList2[0];
                            
                   if( contractedProduct =='Atticus') {
                        if(acc2.Atticus__c == false) { fChanged=true; acc2.Atticus__c = true;}
                    }
                    if(contractedProduct=='GRS') {
                        
                        if(acc2.GRS__c == false) { fChanged=true; acc2.GRS__c = true;}
                    }
                    if(contractedProduct== 'Core') {
                        if(acc2.Core__c ==false) { fChanged=true; acc2.Core__c = true;}
                    }
                    
                    if(contractedProduct=='Accident Meds') {
                        if(acc2.Accident_Meds__c ==false) { fChanged=true; acc2.Accident_Meds__c = true;}
                    }
                    if(fChanged==true)  update acc2;   
                            
                 }     
             }
         
         
                    //Update Location now
                if( contractedProduct =='Atticus') {
                    if(acc.Atticus__c == false) { flocChanged=true; acc.Atticus__c = true;}
                }
                if(contractedProduct=='GRS') {
                    
                    if(acc.GRS__c == false) { flocChanged=true; acc.GRS__c = true;}
                }
                if(contractedProduct== 'Core') {
                    if(acc.Core__c ==false) { flocChanged=true; acc.Core__c = true;}
                }
                if(contractedProduct=='Pre-Settlement' ) {
                    if(acc.PreSet__c ==false) { flocChanged=true; acc.PreSet__c = true;}
                }
                if(contractedProduct=='Accident Meds') {
                    if(acc.Accident_Meds__c ==false) { flocChanged=true; acc.Accident_Meds__c = true;}
                }
                if(flocChanged==true)  update acc;   
        }
        
        
        system.debug('===contactId===>'+contactId);      
        if(contactId!=null)
        {   
            List<Contact> contactList = [select id,Name, Atticus__c,Accident_Meds__c,Core__c,GRS__c,PreSet__c from Contact where Id = :contactId];
            if(contactList !=null && contactList .size()>0)
            {
                Contact cnt = contactList [0];
                
                if( contractedProduct =='Atticus') {
                    if(cnt.Atticus__c ==false) cnt.Atticus__c = true;
                }
                if(contractedProduct=='GRS') {
                    if(cnt.GRS__c ==false) cnt.GRS__c = true;
                 }
                if(contractedProduct== 'Core') {
                   if(cnt.Core__c ==false) cnt.Core__c = true;
                }
                if(contractedProduct=='Pre-Settlement' ) {
                  if(cnt.PreSet__c ==false) cnt.PreSet__c = true; 
                }
                if(contractedProduct=='Accident Meds') {
                  if(cnt.Accident_Meds__c ==false) cnt.Accident_Meds__c = true;
                }
                
                update cnt;   
            }             
        }
    }
    
    
   /**
     * This method is removing the null.
     * @param String str
     * @return String 
     * @exception Exception On input error.
     * @see 
    */ 
   private static String removeNull(String str)
   {
      //return (str==null)?'':str.trim(); 
      system.debug('------>'+str);
      return (String.isBlank(str))?'':str.trim(); 
   } 
    
}