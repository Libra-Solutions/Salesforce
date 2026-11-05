/**
  * @Created Date 04/24/2019
  * @author    OASISFINANCIAL GROUP
  * @copyright Copyright (c) 2019-2020 
  * @license   
  * @Modified Date
  * @Description 
*/
Global class DeletePSRecordsBatch implements Database.Batchable<sObject>, Database.Stateful{
    @testVisible global integer currentBatchChain=1;
    global DateTime dt2;
    global String dt;
    global list<Daily_Job__c> dailyJobList;
    
        
        
    
     
        
    Global DeletePSRecordsBatch(Integer cBatchChain){
 
       this.currentBatchChain = cBatchChain;
        List<String> objNameList = new List<String>();
        
        objNameList.add('PS_View360__c');
        objNameList.add('PS_Case_Source_Breakdown__c');
        objNameList.add('PSApprovalQueue__c');
        objNameList.add('PS_Case_Type_Breakdown__c');
        objNameList.add('PSCasesNeededForServicing__c');
        objNameList.add('PS_Last3Cases_Paid_In_Full__c');
        objNameList.add('PSLastFundedCases__c');
        objNameList.add('PS_Pricing_Breakdown__c');
        objNameList.add('PSUserNotifications__c');
        
        
        String query= 'select id, status__c, PushDate__c , Object_Name__c from Daily_Job__c where status__c = \'SUCCESS\' and Object_Name__c = \''+ objNameList.get(currentBatchChain-1)+'\'  ORDER BY PushDate__c DESC limit 1';
        
        List<Daily_Job__c> dailyJobList = Database.query(query);
        system.debug('dailyJobList : '+dailyJobList);
        for(Daily_Job__c dj : dailyJobList){
            if(dj.PushDate__c != null){
                dt2 = dj.PushDate__c -1;
            }
        }
        
         system.debug('--------------->>dt-------------'+dt2);
         /*
        if(dt2 != null){dt = dt2.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'', 'America/Chicago');
            
            dt = dt2.formatGmt('yyyy-MM-dd\'T\'23:59:59\'Z\'');
            
            system.debug('--------------->>dt---------FMT---'+dt);
        }*/
        if(test.isRunningTest()){
            dt = system.now().addDays(-1).format('yyyy-MM-dd\'T\'23:59:59\'Z\'', 'America/Los Angeles');
        }
    }
    /*
    Global DeletePSRecordsBatch(Integer chain,List<Daily_Job__c> djList){
        currentBatchChain = chain;
        dailyJobList = djList;
        
        for(Daily_Job__c dj : djList){
            if(dj.PushDate__c != null){
                dt = dj.PushDate__c -1;
            }
        }
        system.debug('dt : '+dt);
    }*/
    
    Global Database.QueryLocator start(Database.BatchableContext BC){
        String qry;
        
        system.debug('------------currentBatchChain ----------'+currentBatchChain+'--->'+dt2);
      //  system.debug('--------------->>dt'+dt);
        if(currentBatchChain == 1){
            qry = 'Select Id From PS_View360__c where LastModifiedDate<  :dt2';
        }else if(currentBatchChain == 2){
            qry = 'Select Id From PS_Case_Source_Breakdown__c where LastModifiedDate< :dt2';
        }
        else if(currentBatchChain == 3){
            qry = 'Select Id From PSApprovalQueue__c where LastModifiedDate< :dt2';
        }else if(currentBatchChain == 4){
            qry = 'Select Id From PS_Case_Type_Breakdown__c where LastModifiedDate< :dt2';
        }else if(currentBatchChain == 5){
            qry = 'Select Id From PSCasesNeededForServicing__c where LastModifiedDate< :dt2';
        }else if(currentBatchChain == 6){
            qry = 'Select Id From PS_Last3Cases_Paid_In_Full__c where LastModifiedDate< :dt2';
        }else if(currentBatchChain == 7){
            qry = 'Select Id From PSLastFundedCases__c where LastModifiedDate< :dt2';
        }else if(currentBatchChain == 8){
            qry = 'Select Id From PS_Pricing_Breakdown__c where LastModifiedDate< :dt2';
                    }else if(currentBatchChain == 9){
            qry = 'Select Id From PSUserNotifications__c where LastModifiedDate< :dt2';
        }
        system.debug(qry);
        return Database.getQueryLocator(qry);
    }
    
    Global void execute(Database.BatchableContext BC, List<sObject> scope){
        if(scope.size()>0){
       //     system.debug('===scope==>'+scope);
            system.debug('===scope==>'+scope.size());
            delete scope;
        }
        
    }
    
    Global void finish(Database.BatchableContext BC){
        if(currentBatchChain < 9)
        {
            currentBatchChain++;
            system.debug('----------------finish currentBatchChain--------------------'+currentBatchChain ); 
            DeletePSRecordsBatch mb = new DeletePSRecordsBatch(currentBatchChain);
            Database.executeBatch(mb, 200);
        }
        
    }
}