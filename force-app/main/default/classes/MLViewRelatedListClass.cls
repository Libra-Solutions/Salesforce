/**
* Requirement: Sending the request from cashtrax to salesforce
* @param
* @author
* @return type
* @created date
* @modification
**/
public class MLViewRelatedListClass {

    /**
     * This method is getting ml view list.
     * @param Id cusConIds
     * @return list<ML_View360__c>
     * @exception Exception On input error.
     * @see 
    */
    @AuraEnabled
    public static list<ML_View360__c> mlViewList(Id cusConIds){   
        try {
                 
            list<ML_View360__c> lstMLView = [Select Id, DateofFirstReferral__c, Name, 
                                            MostRecentPatientName__c,
                                             NoofCasesDeclined__c, NoofcaseswithAttorney__c, NoofClassAReferral__c, NoofClassBReferral__c, 
                                             Site_Collection_age__c
                                             from ML_View360__c where Account__c  =:cusConIds]; 
            return lstMLView;            
         
        }       
        catch(Exception ex){throw new AuraHandledException(ex.getStackTraceString() + ', Error: ' + ex.getMessage());}
    }
}