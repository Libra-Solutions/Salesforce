/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
public class PSViewRelatedListClass {
    @AuraEnabled
    public static list<PS_View360__c> psViewList(Id cusConIds){
        try {
            
            list<PS_View360__c> lstPSView = [Select Id, PSBookofBusiness__c, PSServicingRepresentative__c, PSBlackListedTempFundingHold__c, 
            PSRealizedMultiple__c,
                                             Attorney_Grade__c, No_of_Total_Cases__c, No_of_Funded_Cases__c, Funded__c, 
                                             No_of_Referral_Cases__c, No_of_Referral_Funded_Cases__c, Referral_Funded__c,
                                             PSContractMultiple__c, PSEstimatedProfit__c, PSMultipleRatio__c, Attorney__c,Total_of_Fundings__c,Total_of_Applications__c
                                             from PS_View360__c where Account_Relation__c = :cusConIds OR Attorney__c = :cusConIds];
            return lstPSView;     
        }  
        catch(Exception ex){throw new AuraHandledException(ex.getStackTraceString() + ', Error: ' + ex.getMessage());}
    }
}