public class MedlienMergeContactServerController{

    //Removed lstOfMedlien parameter List<String>
    public static void mergeContact(List<String> lstOfPreset){
        if(!Test.isRunningTest()){ System.enqueueJob(new PresetServerMergeContactQueuebleJob (lstOfPreset)); }
        
       // if(lstOfMedlien.size()>0 && !Test.isRunningTest()){ System.enqueueJob(new MedlienMergeContactsQueuebleJob (lstOfMedlien)); }
           
        
    }
}