({
	showMLHandler : function(component, event, helper) {   
        console.log('Helper Calling');  
        
        var action = component.get("c.mlViewList");  
		
        var customerId = component.get("v.recordId");
        // Setting parameters for server method   
        action.setParams({
            cusConIds: customerId
        });     
        
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.mlObjList", response.getReturnValue());
            }  
            else {
                    let message = 'Error: ';
                    let errors = response.getError();
                    // Retrieve the error message sent by the server
                    if (errors && errors.length > 0)
                        message = message + errors[0].message;
                    console.log("Error in loading Lightning Component: PSViewRelatedList. " + message);  
               }
        });
        $A.enqueueAction(action);
        
        
		
	}  
})