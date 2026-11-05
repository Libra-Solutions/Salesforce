({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');        
        var action = component.get('c.PushToCashtrax'); 
        action.setParams({ 
            contactId: recordId                        
        }); 				
        
		action.setCallback(this, function(response) {        
        var state = response.getState();        
        if (component.isValid() && state === "SUCCESS") {    
            //confirm("Do you Really want to save this Form");
            var result = response.getReturnValue();             
            component.set('v.message', result);        
        } 
        }); 
        $A.enqueueAction(action);  
        component.set("v.hideOkButton", false);
        //$A.get("e.force:closeQuickAction").fire() ;
    },
    closeModal: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire() ;
    }  
})