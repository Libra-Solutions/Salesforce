@isTest
public class ScheduleUpdateOpportunityStageBatchTest{
    
    static testMethod void testMethod1() {        
         test.starttest();
         ScheduleUpdateOpportunityStageBatch myClass = new ScheduleUpdateOpportunityStageBatch ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
    

   
  }