public class PreMedSyncCsvController {
    public String Source{get;set;}
    public String Master{get;set;}
    public List<ModelPreMedlienCmm> lstOfModelCmms{get;set;}
    public List<Preset_Medlien_Communication__c> lstOfPreMedComms{get;set;}
    public String fileName{get;set;}
    Set<id> setOfcmmIds;
    public PreMedSyncCsvController (){
        lstOfPreMedComms=new List<Preset_Medlien_Communication__c>();
        lstOfModelCmms=new List<ModelPreMedlienCmm>();
        setOfcmmIds=new Set<Id>();
        filterRecords();
    }     
    public void filterRecords(){
        lstOfModelCmms.clear();
        
        
        String query='select id,name,Serviving_Id__c,Status_Code__c,Status__c,Input_Payload__c,Deleting_Id__c,Api_Action__c,Deleting_Atticus_Id__c,Deleting_Core_Id__c,';
               query+='Serviving_Atticus_Id__c,Serviving_Core_Id__c,Serviving_Grs_Id__c,';
               query+='Deleting_Grs_Id__c,Output_Body__c,Serviving_CashTrax_Id__c,Deleting_Cashtrax_Id__c from Preset_Medlien_Communication__c ';
               
         if(fileName!=null && fileName.trim()!=''){
             query+=' where name =\''+fileName.trim()+'\'';
         }      
         query+=' order by CreatedDate desc';
         
         for(Preset_Medlien_Communication__c rec: (List<Preset_Medlien_Communication__c> ) database.query(query)){
             
             lstOfModelCmms.add(new ModelPreMedlienCmm(rec,false));
         }    
    }
    
    public class ModelPreMedlienCmm{
        public Preset_Medlien_Communication__c preCmm{get;set;}
        public boolean ischecked{get;set;}
        public boolean isDelete{get;set;}
        public ModelPreMedlienCmm(Preset_Medlien_Communication__c preCmm,boolean ischecked){
            this.ischecked=ischecked;
            this.preCmm=preCmm;
            this.isDelete=false;
        }
    }
    public void deleteRecords(){
        Set<id> setOfDelRec=new Set<id>();
        for(ModelPreMedlienCmm md:lstOfModelCmms){
            if(md.isDelete){
                setOfDelRec.add(md.preCmm.id);
            }
        }
        if(setOfDelRec.size()>0){
             delete [select id from Preset_Medlien_Communication__c  where id in:setOfDelRec];
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ' Successfully Delete'));
             filterRecords();
        }
        else{
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please Select Records'));
        }
    }
    
    public void sysBackEndRecords(){
       setOfcmmIds.clear();
       for(ModelPreMedlienCmm md:lstOfModelCmms){
            if(md.ischecked){
                setOfcmmIds.add(md.preCmm.id);
            }
        }
       if(setOfcmmIds.size()>0){
            System.enqueueJob(new PresetMergeImpCsvLoginJob(setOfcmmIds));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ' Successfully Sys Start Back End Server'));
            sysRefreshRecords();  
        }else{
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please Select Records'));
        }
    }
    
    public void sysRefreshRecords(){
    
        if(setOfcmmIds.size()>0){
            lstOfPreMedComms.clear();
            
             String query='select id,name,Serviving_Id__c,Status_Code__c,Status__c,Input_Payload__c,Deleting_Id__c,Api_Action__c,';
               query+='Deleting_Atticus_Id__c,Serviving_Atticus_Id__c, Deleting_Core_Id__c,Serviving_Core_Id__c,'; 
               query+='Deleting_Grs_Id__c,Serviving_Grs_Id__c,Output_Body__c,Serviving_CashTrax_Id__c,Deleting_Cashtrax_Id__c from Preset_Medlien_Communication__c  ';
               query+=' where id in:setOfcmmIds';
               
            lstOfPreMedComms=(List<Preset_Medlien_Communication__c> ) database.query(query);
        }
    
    }
}