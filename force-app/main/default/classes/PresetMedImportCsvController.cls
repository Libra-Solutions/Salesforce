public class PresetMedImportCsvController {
    public String fileName{get;set;}
    public Blob fileBody{get;set;}
    public List<ModelPsMedComm> lstOfMdsMedComms{get;set;}
    
    public PresetMedImportCsvController (){
    
        lstOfMdsMedComms=new List<ModelPsMedComm>();
    }
  
    public void importCSVFile(){
       try{
       
          lstOfMdsMedComms.clear();
          List<String> lstOfFileRecords= fileBody.toString().split('\n'); 
            
           for(Integer i=1;i<lstOfFileRecords.size();i++){
           
               Preset_Medlien_Communication__c Obj = new  Preset_Medlien_Communication__c() ;
                 
                   string[] csvRecordData = lstOfFileRecords[i].split(',');
                   obj.name=csvRecordData [0];
                   Obj.Deleting_CashTrax_Id__c = csvRecordData [1];
                   Obj.Serviving_CashTrax_Id__c = csvRecordData [2];
                   Obj.Deleting_Atticus_Id__c = csvRecordData [3] ; 
                   Obj.Serviving_Atticus_Id__c = csvRecordData [4] ;
                   Obj.Deleting_Core_Id__c = csvRecordData [5];
                   Obj.Serviving_Core_Id__c = csvRecordData [6];
                   Obj.Deleting_Grs_Id__c = csvRecordData [7];  
                   Obj.Serviving_Grs_Id__c = csvRecordData [8];  
                   Obj.Deleting_Id__c = csvRecordData [9];
                   Obj.Serviving_Id__c = csvRecordData [10];
                   Obj.Api_Action__c = csvRecordData [11];
               
               lstOfMdsMedComms.add(new ModelPsMedComm(Obj,false));   
           }
        
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Import Data Successfully!'));
        }
        catch (Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
  }
    public void SaveData(){
        List<Preset_Medlien_Communication__c > lstOfPreComms=new List<Preset_Medlien_Communication__c>();
        
        for(ModelPsMedComm md:lstOfMdsMedComms){
            if(md.ischecked){
                lstOfPreComms.add(md.preMedCmm);
            }
        }
        if(lstOfPreComms.size()>0){
            upsert lstOfPreComms;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ' Successfully Saved'));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please Select Records'));
        }
    }
    
    public class ModelPsMedComm{
      public Preset_Medlien_Communication__c preMedCmm{get;set;}
      public boolean ischecked{get;set;}
      
      public ModelPsMedComm(Preset_Medlien_Communication__c preMedCmm, boolean ischecked){
          this.preMedCmm=preMedCmm;
          this.ischecked=ischecked;
      }
  }
}