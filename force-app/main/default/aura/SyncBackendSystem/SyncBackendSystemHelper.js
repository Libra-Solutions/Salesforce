({
	doSyncSystems : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set("v.showProgressBar", true);       
        var interval = setInterval($A.getCallback(function () {
            var progress = component.get('v.progress');
            component.set('v.progress', progress === 100 ? clearInterval(interval) : progress + 20);
        }), 500);
        
		var action = component.get('c.SyncSystems'); 
        
        action.setParams({ 
            accountId: recordId
        }); 				
        
		action.setCallback(this, function(response) {        
        var state = response.getState();        
        if (component.isValid() && state === "SUCCESS") {    
            //confirm("Do you Really want to save this Form");
            //alert('if----'+state);
            var result = response.getReturnValue(); 
			helper.doSyncSystemsMedlien(component,event,helper);            
            component.set('v.message', result);      
            component.set("v.showProgressBar", false);
            component.set("v.showCloseButton", true);
            
        } else if(state === "ERROR"){
			//alert('else if----'+state);
        }
        }); 
        if(component.get("v.recordId"))
                action.setBackground();
        $A.enqueueAction(action);	
	},
    doSyncSystemsMedlien : function(component, event, helper) {
        var recordId = component.get('v.recordId');
		var action = component.get('c.SyncSystemsMedlien'); 
        action.setParams({ 
            accountId : recordId
        }); 				
        
		action.setCallback(this, function(response) {        
        var state = response.getState();        
        if (component.isValid() && state === "SUCCESS") {  
            //alert('if---'+state);
            //confirm("Do you Really want to save this Form");
            var result = response.getReturnValue();             
            component.set('v.message', result);        
        } else if(state === "ERROR"){
			//alert('elseif--'+state);
        }
        }); 
        $A.enqueueAction(action);	
	},
    finalMethod : function(component, event, helper) {
    	helper.doSyncSystems(component,event,helper);   
    }
    
})