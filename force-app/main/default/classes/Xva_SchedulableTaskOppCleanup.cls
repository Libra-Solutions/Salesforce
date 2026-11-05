global class Xva_SchedulableTaskOppCleanup implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new Xva_BatchTaskCleanup());
        Database.executeBatch(new Xva_BatchOpportunityCleanup());
    }

}