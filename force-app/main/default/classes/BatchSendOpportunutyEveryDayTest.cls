@isTest
public class BatchSendOpportunutyEveryDayTest {
    static testMethod void testMethod1() 
        {
            Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sizing the Opportunity').getRecordTypeId();
            Opportunity opp = new Opportunity(Name='Opp1');
            opp.RecordtypeId = recId;
            opp.What_would_it_take_to_get_the_additional__c = 'Better Pricing';
            opp.StageName = 'Created Opportunity';
            opp.CloseDate = System.today();
               opp.Total_of_Cases_Firm_Level__c = 'tes';
            opp.of_Total_Firm_Cases_that_receive_fund__c = 'rest';
            opp.What_would_it_take_additional_Other__c = '12.0';
            opp.How_many_Additional_Funded_Cases__c = 12.0;
            insert opp;
            
            Opportunity opp1 = new Opportunity(Name='Opp2');
            opp1.RecordtypeId = recId;
            opp1.What_would_it_take_to_get_the_additional__c = 'Better Pricing';
            opp1.StageName = 'Created Opportunity';
            opp1.CloseDate = System.today();
            opp1.Total_of_Cases_Firm_Level__c = 'tes';
            opp1.of_Total_Firm_Cases_that_receive_fund__c = 'rest';
            opp1.What_would_it_take_additional_Other__c = '12.0';
            opp1.How_many_Additional_Funded_Cases__c = 12.0;
            insert opp1;
             
            Test.startTest();
                BatchSendOpportunutyEveryDay obj = new BatchSendOpportunutyEveryDay();
                DataBase.executeBatch(obj); 
            Test.stopTest();
     }

}