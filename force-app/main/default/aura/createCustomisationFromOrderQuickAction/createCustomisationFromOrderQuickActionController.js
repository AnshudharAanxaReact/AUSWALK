({
    doInit : function(component, event, helper) {
        helper.initMethodToFecthPrimaryDetails(component,event,helper);
    },
    checkChilds :function(component, event, helper) {
       	var availableCheckboxes = component.find('recordSelected');
        var resetCheckboxValue  = false;
        var idForRow = event.getSource().get('v.name');
        var recData = component.get("v.lstOfOli");
        
        if (Array.isArray(availableCheckboxes)) {
            //If more than one checkbox available then individually resets each checkbox
            availableCheckboxes.forEach(function(checkbox) {
                checkbox.set('v.value', resetCheckboxValue);
            }); 
        } else {
            //if only one checkbox available then it will be unchecked
            availableCheckboxes.set('v.value', resetCheckboxValue);
        }
        //mark the current checkbox selection as checked
        event.getSource().set("v.value",true);
        var olid=recData[idForRow].Id;
        console.log('olid23'+olid);
        component.set("v.Olid",olid);
	},
    fetchOrderCustomisationRecordTypes  : function (component, event, helper){
        
        var orderlineId = component.get("v.Olid");
        var recId = component.get("v.recordId");
        
        if(orderlineId == '' || orderlineId == '--- NONE ---'){
            helper.showToast(component,"Error!", "error",'Please select an Order Line Item to proceed');
        }else{
            var action = component.get("c.verifyThePaxInOLI");
            action.setParams({
                
                "oliId":orderlineId
                
            });
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                var result = response.getReturnValue();
                console.log("STATEEE"+state);
                console.log("RESULTTT"+JSON.stringify(result));
                
                if(state === "SUCCESS"){
                    if(result.toBeReturned == true){
                        //helper.fetchAddOnPicklist(component, event, helper, orderlineId);
                        component.set("v.oliName",result.oliName);
                        helper.fetchAllTheDataRequiredForNewCreation(component,event,helper,recId);
                    }
                    else{
                        helper.showToast(component, "Error!", "error", "There are no PAX in this Order Line Item"); 
                        
                    }
                }
                else{
                    console.log('This should never arise');
                }
            });
            
            $A.enqueueAction(action);  
        } 
    },
    
    addOnConfirmation : function (component, event, helper){
        var getMasterWrap = component.get("v.finalOCDataWrapper");
        component.set("v.ifOLIisSelected",false);
        var isAddOnAvailable = component.find("isAddOnAvailable");
        if(isAddOnAvailable.get("v.checked")) {
            component.set("v.showAddOn",true);
            component.set("v.isAddOnAvailable",true);
        }
        else {
            component.set("v.showAddOn",false);
            component.set("v.isAddOnAvailable",false);
            helper.addOnSubmitted(component, event, helper);
            helper.assignPicklistValuesOnMainOCScreen(component,event,helper,getMasterWrap);
        }
    },
    
    getItineraryData : function(component,event,helper){
        helper.SelectItineraryDays(component,event,helper);
    },
    
    getSelectedPaxName : function(component,event,helper){
        helper.rowSelectionOnLDTforPAX(component,event,helper);
    },
    
    save: function (component, event, helper)
    {
        component.set("v.finalOCDataWrapper.btnText","Save");
        helper.saveFunctionality(component,event,helper);   
        
    },
    
    onCustomisationTypeChange: function(component,event,helper){
        console.log('Called again');
        helper.onCustomTypeChange(component,event,helper);
    },
    
    onChangePrice : function (component, event, helper){
        var recData = component.get("v.finalOCDataWrapper.supplierTypeWrapper");
        var idForRow = event.getSource().get('v.name');
         var valForRow = event.getSource().get('v.value');
        console.log('ValforRow'+valForRow);
            //if(!$A.util.isUndefined(recData[idForRow].merchantPrice)){
            //if(recData[idForRow].price!=0){
            //
            console.log('Check4');
         console.log('recData'+recData);
        console.log('merchantPrice'+recData[idForRow].merchantPrice);
                recData[idForRow].merchantPrice=valForRow;
                component.set("v.finalOCDataWrapper.supplierTypeWrapper",recData);               
           //else{
                 
            //  helper.showToast(component, "Error!", "error","dismissible","Please Fill Merchant price!");
      //  }  
      //  }
    }
    
})