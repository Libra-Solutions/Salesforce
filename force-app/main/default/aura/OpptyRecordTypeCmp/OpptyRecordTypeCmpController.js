({
    doInit : function(component,event,helper) {
       
        var action = component.get("c.getContactdetails");
        var contactId = component.get("v.recordId"); 
        
        action.setParams({   conIds: contactId });
        action.setCallback(this, function(response) {  
        var state = response.getState();  
        if (state === "SUCCESS") {     
               
        	component.set("v.ContactRec", response.getReturnValue());
             console.log('test only');  
             
             //let today = new Date().toLocaleDateString();    
             //var today = new Date();
			//console.log(today);     
        } 
        });
        
        var action1 = component.get("c.doDisableNextButton");
        action1.setParams({   conIds: contactId });
        action1.setCallback(this, function(response) {  
        var state = response.getState();  
        if (state === "SUCCESS") {                    
        	component.set("v.disableNextButton", response.getReturnValue());            
        } 
        });
        $A.enqueueAction(action);     
        $A.enqueueAction(action1);        
    },       
    
    valuePopulate : function(component,event,helper) {  
      /*  
        var action1 = component.get("c.getContactdetails");
        var contactId = component.get("v.recordId");
        action1.setParams({   conIds: contactId });
       action1.setCallback(this, function(response1) {  
         var state = response1.getState();  
         if (state === "SUCCESS") {  
            component.set(response1.getreturnvalue(),"v.ContactDetail");
            
             
         } 
      });
       $A.enqueueAction(action1);*/
    },
    
    onChange : function(component,event,helper) {
     var selectedValue = component.find("selectid").get("v.value");      
     var action = component.get("c.fetchRecordTypeLabel");
     console.log('==selectedValue=>'+selectedValue);   
     component.set("v.recordType", selectedValue);    
        
     action.setParams({
         "selectedValue": selectedValue
     });
     action.setCallback(this, function(response) {
         var resObj = response.getReturnValue();
         console.log('==resObj=>'+resObj);   
         component.set("v.recordTypeLabel", response.getReturnValue());  
         
      });       
      $A.enqueueAction(action);
    },
    
      
   /* In this "createRecord" function, first we have call apex class method 
    * and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord"
    * event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event
    * if response state is not equal = "SUCCESS" then display message on various situations.
    */
   createRecord: function(component, event, helper) {
      
 	  var recdTypeLabel = component.get("v.recordTypeLabel");       
      var action = component.get("c.getRecTypeId");      
      var contactId = component.get("v.recordId"); 
      console.log('==recdTypeLabel==>'+recdTypeLabel);
      // Setting parameters for server method   
      
      action.setParams({
         "recordTypeLabel": recdTypeLabel,
          conIds: contactId
      });
      action.setCallback(this, function(response) {  
         var state = response.getState();    
          console.log('==state==>'+state);
         if (state === "SUCCESS") {  
            var createRecordEvent = $A.get("e.force:createRecord");
            var RecTypeID  = response.getReturnValue();      
            console.log('==RecTypeID==>'+RecTypeID);
             if(RecTypeID == 'Please select any value'){
                 component.set("v.message1",'Please select Case Type.');
             }else{
            
            //let today = new Date().toLocaleDateString();    
            var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-dd");
       		console.log(today);           
    
            console.log(component.get("v.ContactRec.AccountId"));    
            createRecordEvent.setParams({
               "entityApiName": 'Opportunity', 
               "recordTypeId": RecTypeID,  
                "defaultFieldValues" : {   
                    
                    "StageName" : 'Qualification',  
                    "Probability" : '10',    
                    "Attorney__c" : component.get("v.ContactRec.Id"),  
                    "AccountId" : component.get("v.ContactRec.AccountId"),    
                    "CaseType__c" : component.get("v.recordType"),  
                    "Name"  : component.get("v.ContactRec.FirstName")+' '+component.get("v.ContactRec.LastName"),
                    "CloseDate"   :  today     
                    
                }
            }); 
            createRecordEvent.fire();
            }
         } else if (state == "INCOMPLETE") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Oops!",
               "message": "No Internet Connection"
            });
            toastEvent.fire();  
             
         } else if (state == "ERROR") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Error!",
               "message": "Please contact your administrator"
            });
            toastEvent.fire();
         }
         
      });
      
       
      $A.enqueueAction(action);
      
   },
     
})