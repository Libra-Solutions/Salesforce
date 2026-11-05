@isTest
public class MoveContactsControllerTest{
    public static testmethod void testCallout() {
       
       Preset_Medlien_Configuration__c objConfig=new Preset_Medlien_Configuration__c();
       objConfig.End_Point__c='http://sfapitest.oasislegal.com/api/AttorneyFirm/MoveAttorney';
       objConfig.Server_Type__c='Preset';
       objConfig.Token__c='hvNY#1?WieiDLhYh?cqpdvWh-D';
       objConfig.User_Email__c='nmachannagari@oasisfinancial.com';
       objConfig.name='MoveAttorney';
       
       insert objConfig;
       
       List<String> lstReqBody=new List<String>();
       String Body='{}';
       String status='{"Status":"Success","Message":"Successfull"}';
       lstReqBody.add(Body);
       
       PresetMedlienRequestMock Response = new PresetMedlienRequestMock(200,status,Body,null);
        
       Test.setMock(HttpCalloutMock.class, Response);
        
          
       Test.startTest();
            List<String> lst=new List<String>();
            lst.add('MoveAttorney');
            lst.add('1496359');
            lst.add('24848');
            
            System.enqueueJob(new PresetServerMoveAttorneyQueuebleJob (lst)); 
            lst.add('24848');    
            System.enqueueJob(new PresetServerMoveAttorneyQueuebleJob (lst)); 
            
        Test.stopTest();
          
          
       Account acc=new Account();
        acc.name='test';
         acc.CTXFirmId__c ='1496359';
        insert acc;
        
        contact con=new Contact();
        con.lastname='test';
        con.FirstName ='test';
        
        insert con;
        
        Account_Relation__c  accRel=new Account_Relation__c ();
        accRel.role__c='Attorney';
        accRel.Account__c=acc.id;
        accRel.Contact__c=con.id;
        accRel.PresetID__c='1496359';
       
        insert accRel;


        MoveContactsController.Inputs objinput=new MoveContactsController.Inputs ();
        objinput.FromContactsfid=con.id;
        objinput.ToLocationsfid=acc.id;
        
        List<MoveContactsController.Inputs> lstOfMoves=new List<MoveContactsController.Inputs>();
        lstOfMoves.add(objinput);
        MoveContactsController.Contacts(lstOfMoves);
    }
 
}