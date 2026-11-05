@isTest
public class UpdateOpportunityStageBatchTest{
    
    @testsetup static  void testUpdateAccountRelationBatchSetup() {
       
       
       
       Opportunity opt = new Opportunity();
       opt.stagename = 'Closed won';
       opt.name = 'test';
       opt.closedate = system.today();
       //opt.tasks = tsk.id;
       Opportunity opt1 = new Opportunity();
       opt1.stagename = 'Closed won';
       opt1.name = 'test'; 
       opt1.closedate = system.today();        
       
       List<Opportunity > psLst= new List<Opportunity >();
       psLst.add(opt);
       psLst.add(opt1);
       insert psLst;

       List<Task> taskList = new List<Task>();
       for(Opportunity opp: psLst){
         Task tsk = new Task();
         tsk.OwnerId = UserInfo.getUserId();
         tsk.Priority = 'Normal';
         tsk.Subject = 'Call';
         tsk.Status = 'Open';
         tsk.WhatId = opp.id;
         taskList.add(tsk);
       }        

       insert taskList;
        
    }
    
    static testMethod void testMethod1(){
        List<Opportunity> oppList = [Select id, stagename,(Select id, whatid,LastModifiedDate from tasks) from Opportunity];
        Test.StartTest();  

          UpdateOpportunityStageBatch batchOpp = new UpdateOpportunityStageBatch();
          //ID batchprocessid = Database.executeBatch(batchOpp);
          Database.QueryLocator ql = batchOpp.start(null);
          batchOpp.execute(null,oppList);
          batchOpp.Finish(null);
        Test.StopTest();
        
    }
    

   
  }