@isTest
public class ManageNotesBatchTest {

 @testsetup static void dataSetup(){
       Note c = new Note();
       c.title = 'test1';
       c.body ='Monthly notification sent for case(s): 507';
       c.parentId = '0014B00000eQDXlQAO';
       //c.OwnerId = '0014B00000eQDXlQAO';
       c.IsPrivate = false;
       
       Note c1 = new Note();
       c1.title = 'test';
       c1.body ='Monthly notification sent for case(s): 507';
       c1.parentId = '0014B00000eQDXlQAO';
       //c1.OwnerId = '0014B00000eQDXlQAO';
       c1.IsPrivate = false;
       List<Note> notlst = new List<Note>();
       notlst.add(c);
       notlst.add(c1);
       //insert notlst;
     
 }

 static testMethod void testMethod1(){
     List<Note> note = [select id,title, body,parentId,OwnerId, CreatedDate,IsPrivate from Note];
     Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Database.executeBatch(new ManageNotesBatch());
     Test.stopTest();
 }
 
 


}