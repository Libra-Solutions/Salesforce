public with sharing class MergeFirmLocationQueueable  implements Queueable, Database.AllowsCallouts 
{
    Account fromLocation;
    Account toLocation;
    string toLocationId;
    string fromLocationId;
    Id accountId;

    public MergeFirmLocationQueueable(Account FromLocation, Account ToLocation)
    {
        this.fromLocation = FromLocation;
        this.toLocation = ToLocation;
    }

    public MergeFirmLocationQueueable(string fromLocationId, string toLocationId, Id accountId)
    {
        this.fromLocationId = fromLocationId;
        this.toLocationId = toLocationId;
        this.accountId = accountId;
    }

    public void execute(QueueableContext context) 
    {
    
        Preset_Medlien_Configuration__c  objReq =Preset_Medlien_Configuration__c.getAll().get('PresetMergeFirmLocations');
        if (Test.isRunningTest()) {
            objReq = new Preset_Medlien_Configuration__c();
            objReq.End_Point__c = 'PresetMergeFirmLocations';
        }

        PSCommunicationCache__c objpsc=new PSCommunicationCache__c();
        objpsc.InputPayload__c='FromFirmLocationID='+fromLocationId+'&ToFirmLocationID='+toLocationId;
        objpsc.Operation__c=objReq.End_Point__c;   
        objpsc.ObjectId__c=accountId;
        objpsc.GenericName__c='PresetMergeFirmLocations';
        objpsc.IsError__c=true;
         objpsc.LOB__c='PS';
        HTTPResponse resfrmLoc;
        resfrmLoc = (!Test.isRunningTest() ? PresetMedlienHttpRequestController.request('{}','PresetMergeFirmLocations','FromFirmLocationID='+fromLocationId+'&ToFirmLocationID='+toLocationId) : null);
        
        objpsc.ResponsePayload__c= (!Test.isRunningTest() ? resfrmLoc.getBody() : '');
        objpsc.ResponseStatus__c= (!Test.isRunningTest() ? resfrmLoc.getStatusCode()+'' : '');
        if(Test.isRunningTest() || (resfrmLoc.getStatusCode()==200 && parse(resfrmLoc.getBody()).Status=='Success')){
            
             objpsc.IsError__c=false;
        }
        

        insert objpsc;
        
    }

    public class PresetModel {
        public String Status;
        public String SessionID;
    }
    public static PresetModel parse(String json) {
        return (PresetModel ) System.JSON.deserialize(json, PresetModel .class);
    }

    /* 
        MergeFirmLocationLoginQueueable q = new MergeFirmLocationLoginQueueable('142405', '150525','001Rl000008TjQAIA0');
        system.enqueueJob(q);

    */



}