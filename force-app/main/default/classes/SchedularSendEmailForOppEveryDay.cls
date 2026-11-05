global class SchedularSendEmailForOppEveryDay implements Schedulable{
    global void execute(SchedulableContext sc) {
    
      BatchSendOpportunutyEveryDay obj1 = new BatchSendOpportunutyEveryDay();
      Database.executeBatch(obj1);
    
   }
}