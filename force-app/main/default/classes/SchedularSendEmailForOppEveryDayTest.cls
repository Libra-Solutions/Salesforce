@istest
public class SchedularSendEmailForOppEveryDayTest {
	public static testMethod void testschedule() {
		Test.StartTest();
		SchedularSendEmailForOppEveryDay testsche = new SchedularSendEmailForOppEveryDay();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}