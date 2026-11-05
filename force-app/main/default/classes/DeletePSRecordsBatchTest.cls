@isTest
public class DeletePSRecordsBatchTest{
    
    static testMethod void testMethod1(){
        Test.StartTest();  
        
        	Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          	insert dailyJob1;
        	Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          	insert dailyJob2;
        	Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          	insert dailyJob3;
        	Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          	insert dailyJob4;
        	Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          	insert dailyJob5;
        	Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          	insert dailyJob6;
        	Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          	insert dailyJob7;
        	Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          	insert dailyJob8;
        	Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          	insert dailyJob9;
            	
            	/*
            	if(i==3)
            		dailyJob.Object_Name__c = 'PSApprovalQueue__c';
            	if(i==4)
            		dailyJob.Object_Name__c = 'PS_Case_Type_Breakdown__c';
            	if(i==5)
            		dailyJob.Object_Name__c = 'PSCasesNeededForServicing__c';
            	if(i==6)
            		dailyJob.Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c';
            	if(i==7)
            		dailyJob.Object_Name__c = 'PSLastFundedCases__c';
            	if(i==8)
            		dailyJob.Object_Name__c = 'PS_Pricing_Breakdown__c';
            	if(i==9)
            		dailyJob.Object_Name__c = 'PSUserNotifications__c'; */
            //	insert dailyJob;
       		/*}*/
          
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 1;       
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
    
     static testMethod void testMethod2(){
        Test.StartTest();  
        
          	Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          	insert dailyJob1;
        	Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          	insert dailyJob2;
        	Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          	insert dailyJob3;
        	Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          	insert dailyJob4;
        	Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          	insert dailyJob5;
        	Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          	insert dailyJob6;
        	Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          	insert dailyJob7;
        	Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          	insert dailyJob8;
        	Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          	insert dailyJob9;
            	
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 2;
                 
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
    
    static testMethod void testMethod3(){
        Test.StartTest();  
        
          Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          insert dailyJob1;
          Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          insert dailyJob2;
          Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          insert dailyJob3;
          Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          insert dailyJob4;
          Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          insert dailyJob5;
          Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          insert dailyJob6;
          Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          insert dailyJob7;
          Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          insert dailyJob8;
          Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          insert dailyJob9;
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 3;
                 
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
    
    static testMethod void testMethod4(){
        Test.StartTest();  
        
          Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          insert dailyJob1;
          Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          insert dailyJob2;
          Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          insert dailyJob3;
          Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          insert dailyJob4;
          Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          insert dailyJob5;
          Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          insert dailyJob6;
          Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          insert dailyJob7;
          Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          insert dailyJob8;
          Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          insert dailyJob9;
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 4;
                 
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
    
    static testMethod void testMethod5(){
        Test.StartTest();  
        
          Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          insert dailyJob1;
          Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          insert dailyJob2;
          Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          insert dailyJob3;
          Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          insert dailyJob4;
          Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          insert dailyJob5;
          Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          insert dailyJob6;
          Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          insert dailyJob7;
          Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          insert dailyJob8;
          Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          insert dailyJob9;
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 5;
                 
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
    
    static testMethod void testMethod6(){
        Test.StartTest();  
        
          Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          insert dailyJob1;
          Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          insert dailyJob2;
          Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          insert dailyJob3;
          Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          insert dailyJob4;
          Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          insert dailyJob5;
          Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          insert dailyJob6;
          Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          insert dailyJob7;
          Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          insert dailyJob8;
          Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          insert dailyJob9;
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 6;
                 
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
    
    static testMethod void testMethod7(){
        Test.StartTest();  
        
          Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          insert dailyJob1;
          Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          insert dailyJob2;
          Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          insert dailyJob3;
          Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          insert dailyJob4;
          Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          insert dailyJob5;
          Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          insert dailyJob6;
          Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          insert dailyJob7;
          Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          insert dailyJob8;
          Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          insert dailyJob9;
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 7;
                 
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
    
    static testMethod void testMethod8(){
        Test.StartTest();  
        
          Daily_Job__c dailyJob1 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_View360__c');
          insert dailyJob1;
          Daily_Job__c dailyJob2 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Source_Breakdown__c');
          insert dailyJob2;
          Daily_Job__c dailyJob3 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSApprovalQueue__c');
          insert dailyJob3;
          Daily_Job__c dailyJob4 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Case_Type_Breakdown__c');
          insert dailyJob4;
          Daily_Job__c dailyJob5 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSCasesNeededForServicing__c');
          insert dailyJob5;
          Daily_Job__c dailyJob6 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Last3Cases_Paid_In_Full__c');
          insert dailyJob6;
          Daily_Job__c dailyJob7 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSLastFundedCases__c');
          insert dailyJob7;
          Daily_Job__c dailyJob8 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PS_Pricing_Breakdown__c');
          insert dailyJob8;
          Daily_Job__c dailyJob9 = new Daily_Job__c(status__c = 'SUCCESS',PushDate__c = System.today(),Object_Name__c = 'PSUserNotifications__c');
          insert dailyJob9;
          
          Account acc = UtiityHelperClass.createAccount();
          insert acc;
          
          Contact con = UtiityHelperClass.createContact(acc.id);
          insert con;
          
          Account_Relation__c accRel = UtiityHelperClass.createAccountRealtion(acc.id,con.id);
          insert accRel;
          
          PS_View360__c ps= new PS_View360__c (Account__c = acc.Id,Account_Relation__c = accRel.Id,Attorney__c = con.id);
          insert ps;
                    
          Integer cBatchChain = 8;
                 
          DeletePSRecordsBatch batch = new DeletePSRecordsBatch(cBatchChain);
          
          //batch.dailyJobList.addAll(dailyJobList);
          Database.executeBatch(new DeletePSRecordsBatch(cBatchChain));
        Test.StopTest();
        
    }
   
  }