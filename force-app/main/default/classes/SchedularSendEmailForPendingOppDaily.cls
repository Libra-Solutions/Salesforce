global class SchedularSendEmailForPendingOppDaily implements Schedulable{
    global void execute(SchedulableContext sc) {
    
      BatchSendOppForPendingApprovals obj1 = new BatchSendOppForPendingApprovals();
      Database.executeBatch(obj1,10);
    
   }
}