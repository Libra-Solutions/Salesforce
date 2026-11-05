public class ContactInlineExtension {
    Private Contact contactObj = null;
    private Contact contactExt = null;
    public boolean isMDUser 
    {  
        set;
        get 
        {
            return contactExt != null && contactExt.MD_User_Id__c != null;
        }
    }
    public boolean isCTXUser
    {
        set;
        get 
        {
            return contactExt != null && contactExt.Cashtrax_ID__c != null;
        }
    }

    public boolean isManualUser {
        set;
        get {
            return contactExt != null && contactExt.Cashtrax_ID__c == null && contactExt.MD_User_Id__c == null;
        }
    }
    /*public boolean atticusId {get;set;}
    public boolean grsId {get;set;}
    public boolean ctxFirmId {get;set;}
    public boolean keyMedsId {get;set;}*/
    public String role {get;set;}
    public ContactInlineExtension(ApexPages.StandardController controller) {
        contactObj = (Contact)controller.getRecord();
        contactExt = [Select id, Name, MD_User_Id__c, Cashtrax_ID__c from Contact where id =: contactObj.id];


        List<Account_Relation__c> accrel = [Select id, Name, Account__c,Account__r.CTXFirmId__c,
                                                  Account__r.KeyMedsID__c, Account__r.AtticusId__c ,
                                                  Account__r.GRSId__c, Role__c   
                                                  from Account_Relation__c where Contact__c =: contactObj.id ];
        if(accrel != null && accrel.size() > 0){
            /*if(accrel[0].Account__r.CTXFirmId__c != null){
                ctxFirmId  = true;
            }if(accrel[0].Account__r.KeyMedsID__c != null){
                keyMedsId = true;
            }if(accrel[0].Account__r.GRSId__c != null){
                grsId = true;
            }if(accrel[0].Account__r.AtticusId__c  != null){
                atticusId  = true;
            }*/
            if(accrel[0].Role__c != null){
                role = accrel[0].Role__c.toUpperCase();
            }
        }else{
            //check for Non-attorney's too 
            List< Non_Attorney_Contact__c > nonattrel = [Select id, Name, 
                                                  Role__c, Contact__c   
                                                  from Non_Attorney_Contact__c where Contact__c =: contactObj.id ];
            if(nonattrel != null && nonattrel.size() > 0){
                /*if(accrel[0].Account__r.CTXFirmId__c != null){
                    ctxFirmId  = true;
                }if(accrel[0].Account__r.KeyMedsID__c != null){
                    keyMedsId = true;
                }if(accrel[0].Account__r.GRSId__c != null){
                    grsId = true;
                }if(accrel[0].Account__r.AtticusId__c  != null){
                    atticusId  = true;
                }*/
                if(nonattrel[0].Role__c != null){
                    role = nonattrel[0].Role__c.toUpperCase();
                }
            }
        }
        
    }

}