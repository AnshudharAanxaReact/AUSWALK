({
    initMethodToFecthPrimaryDetails : function(component,event,helper) {
        
        var recId = component.get("v.recordId");
        console.log('recId in fetchOLI method '+recId);
        var action = component.get("c.fetchOLIRec");
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            
            var oli = response.getReturnValue();
            console.log('oli'+JSON.stringify(oli));
            console.log('response'+JSON.stringify(response));
            var state = response.getState();
            
            if(state === "SUCCESS"){
                
                if(oli.orderMasterStatus == 'Travelled' || oli.orderMasterStatus == 'Cancelled'){
                    component.set("v.initErrorMessage","Order Customisation can be created for Orders with Status of 'On Hold', 'Secured', 'In Progress' and 'Temporary Hold' only."); 
                    component.set("v.proceedCheck", false); 
                }else{
                    
                    if(oli.mapOfOLIAndId != null){
                        component.set("v.proceedCheck", true);
                        component.set("v.lstOfOli", oli.mapOfOLIAndId);  
                        var oliList = [];
                        for(var key in oli.mapOfOLIAndId){
                            oliList.push(oli.mapOfOLIAndId[key]);
                        }
                        component.set("v.lstOfOli", oliList);
                    }else{
                        component.set("v.initErrorMessage","There are no Order Line Items for this Order. Create an Order Line Item to create the customisation") 
                        component.set("v.proceedCheck", false);
                    }   
                }
            } 
            else{
                this.showToast(component,"Error!", "error",'There are no Order Line Items for this Order. Create an Order Line Item to create the customisation');
                console.log('This should never happen');
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    fetchAllTheDataRequiredForNewCreation : function(component,event,helper,recordId){
        
        var orderlineId = component.get("v.Olid");
        console.log('orderlineId to be set in the new wrapper: '+orderlineId);
        
        var action = component.get("c.fetchAllTheDataForOCCreation");
        action.setParams({
            
            "recId" : recordId,
            "orderLineItemId" : orderlineId
            
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            //  console.log('STATEEE'+' '+state+' '+'RESULTTT for the new wrapper created'+' '+JSON.stringify(result));	
            if(state === 'SUCCESS'){
                component.set("v.finalOCDataWrapper",result);
                this.settingColumnsForPAXAndComponents(component, event, helper, 'Order',result);
                this.assignPicklistValuesOnMainOCScreen(component, event, helper,result); 
            }            
        });
        $A.enqueueAction(action);  
        
    },
    settingColumnsForPAXAndComponents : function (component, event, helper, StringComingFrom,allDataWrap) {
        // console.log('settingColumnsForPAXAndComponents--->75');
        //  console.log('ITR--->75'+JSON.stringify(allDataWrap.ITR));
        
        component.set("v.showAddOn",false);
        /* if(StringComingFrom == 'Order'){
            component.set("v.ifOLIisSelected",true);
        }else{
            component.set("v.ifOLIisSelected",false); 
        } */
        component.set("v.oliSelect",false);
        
        /*  if(StringComingFrom == 'OC'){
            component.set("v.OLIDetails",true);
        }else{
            component.set("v.OLIDetails",false);
        } */
        component.set("v.OLIDetails",true); 
        component.set("v.showPAXList",true);
        component.set("v.onlyShowPaxName",false);
        // component.set("v.mainHeader","Viewing Order Customisation");
        
        // this.settingColumns(component,event,helper);
        //component.set("v.data",allDataWrap.componentDataWrapper);passengerDataWrapper
        
        this.paxColumns(component,event,helper);
        component.set("v.paxData",allDataWrap.passengerDataWrapper);
        //  console.log('ITR--->75'+JSON.stringify(allDataWrap.ITR));
        var tempPAX = component.get("v.paxData");
        //  console.log('PessengergetData===98 '+JSON.stringify(tempPAX));
        
        
        var savedComponentIds = allDataWrap.savedComponentIds;
        var savedPaxIds = allDataWrap.savedPaxIds;
        // console.log('savedComponentIds103--->'+savedComponentIds);
        // console.log('savedPaxIds'+savedPaxIds);
        
        if(!$A.util.isUndefinedOrNull(savedComponentIds)){
            var selComponentIds = [];
            selComponentIds = allDataWrap.savedComponentIds.split(',');
            component.set("v.selectedRows",selComponentIds); 
            
        }
        
        if(!$A.util.isUndefinedOrNull(savedPaxIds)){
            var selPAXIds = [];
            selPAXIds = allDataWrap.savedPaxIds.split(',');
            console.log('new new new selPAXIds'+selPAXIds);
            component.set("v.selectedPAXRows",selPAXIds); 
            
        }
    },
    
    paxColumns: function(component,event,helper){
        component.set("v.paxColumns",[{label: 'PAX', fieldName: 'paxName', type: 'text',sortable:true},
                                      {label: 'First Name', fieldName: 'paxFirstName', type: 'text',sortable:true},
                                      {label: 'Last Name', fieldName: 'paxLastName', type: 'text',sortable:true},
                                      {label: 'Email', fieldName: 'email', type: 'text',sortable:true}])
        
        var tempPAX = component.get("v.paxColumns");
        console.log('tempPAX tempPAX---->126Pessenger '+JSON.stringify(tempPAX));
    },
    
    addOnSubmitted : function (component, event, helper) {
        component.set("v.OLIDetails",true);
        var showAddOn = component.get("v.showAddOn");
        if(showAddOn) {  
            component.set("v.showAddOn",false); 
            var selectedAddOn = component.find("selectAddOn").get("v.value");
            console.log('selectedAddOn'+selectedAddOn);
            component.set("v.selectedAddOn",selectedAddOn);
        }
        else {
            component.set("v.selectedAddOn","");           
        }
        
    },
    
    onCustomTypeChange : function(component,event,helper){
      	
        var itineraryId = component.find("ItineraryDaysPickList").get("v.value");
        console.log('itineraryId',itineraryId);
        var customTypeSelected = component.find("recordTypePickList").get("v.value");
       
        console.log('customTypeSelected ---> '+customTypeSelected);
         var recData = component.get("v.finalOCDataWrapper");
      
         
        
       
         recData.itineraryDays=itineraryId;
         component.set("v.finalOCDataWrapper",recData);    
        console.log('recData165'+JSON.stringify(recData.itineraryDays));
        recData.customizationType=customTypeSelected;
         component.set("v.finalOCDataWrapper",recData);    
        console.log('recData170'+JSON.stringify(recData.customizationType));
        
        if(customTypeSelected == 'Transport'){
            console.log('Entering for Transport');
            component.set("v.showTransportList", true);
            component.set("v.showAccomList", false);
            component.set("v.showMealList", false);
            
        }
        
        if(customTypeSelected == 'Meal'){
            console.log('Entering for Meal');
            component.set("v.showTransportList", false);
            component.set("v.showAccomList", false);
            component.set("v.showMealList", true);
        }
        
        if(customTypeSelected == 'Accomodation'){
            console.log('Entering for Accom');
            component.set("v.showTransportList", false);
            component.set("v.showAccomList", true);
            component.set("v.showMealList", false);
           
        }
        
        var action = component.get("c.getIbsDetails");
        
        action.setParams({
        	"itineraryId" : itineraryId,
            "customType" : customTypeSelected
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                console.log('RESULTT for final data --> '+JSON.stringify(result));
                component.set("v.finalOCDataWrapper.supplierTypeWrapper", result);
            }            
        });
        $A.enqueueAction(action); 
        
    },
    
    SelectItineraryDays : function(component,event,helper,masterOCWrapper){
        
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        console.log(''+controllerValueKey);
        var action = component.get("c.getTheRecordTypes");
        action.setParams({
            
            "itineraryId" : controllerValueKey
            
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                console.log('RESULTT --> '+JSON.stringify(result));
                var fetchedRecordTypes = [];
                for(var i=0; i < result.length ; i++){
                    fetchedRecordTypes.push({key: result[i], value: result[i]});
                }
                component.set("v.customisationTypeList",fetchedRecordTypes);
            }            
        });
        $A.enqueueAction(action);          
    },
    
    
    
    fetchDepValues: function(component, ListOfDependentFields) {
        
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
    },
    
    assignPicklistValuesOnMainOCScreen : function(component,event,helper,masterOCWrapper){
        
        var StoreResponse = masterOCWrapper.ITR;
        console.log('StoreResponse 192'+StoreResponse);
        component.set("v.depnedentFieldMap",StoreResponse);
        var listOfkeys = [];
        var ControllerField = [];
        
        for (var singlekey in StoreResponse) {
            listOfkeys.push(singlekey);
        }
        
        if (listOfkeys != undefined && listOfkeys.length > 0) {
            ControllerField.push('--- None ---');
        }
        
        for (var i = 0; i < listOfkeys.length; i++) {
            ControllerField.push(listOfkeys[i]);
        }
        component.set("v.listControllingValues", ControllerField);
        
    },
    
    
    showToast: function(component, title, toastType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message
        });
        toastEvent.fire();
    },
    
    rowSelectionOnLDTforPAX : function(component,event,helper){
        
        var selectedRows = event.getParam('selectedRows');
        console.log('selectedRows from PAX '+selectedRows);
        var selPAX_Ids = [];
       // for (var i = 0; i < selectedRows.length; i++){
          for (var i = 0; i < 1; i++){  
            var a = selectedRows[i].paxId;
            selPAX_Ids.push(a);   
        }
        
        
        component.set("v.selectedPAXIds",selPAX_Ids);
        component.set("v.finalOCDataWrapper.paxIds",selPAX_Ids);
        component.set("v.finalOCDataWrapper.selectedPAXQuantity",selPAX_Ids.length);
        console.log('selPAX_Ids'+component.get("v.selectedPAXIds"));
    },
    
    saveFunctionality :function(component,event,helper){
        
        var fetchingNewWrapperVariable = component.get("v.finalOCDataWrapper");
        
       
              /* if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.sObjId))
                    fetchingNewWrapperVariable.sObjId=null;
        console.log('fetchingNewWrapperVariable.sObjId'+fetchingNewWrapperVariable.sObjId);
        
            if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.tadOrderName))
                    fetchingNewWrapperVariable.tadOrderName=null;
        console.log('tadOrderName'+fetchingNewWrapperVariable.tadOrderName);
        
             if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.orderLineItemName))
                    fetchingNewWrapperVariable.orderLineItemName=null;
       console.log('orderLineItemName'+fetchingNewWrapperVariable.orderLineItemName);
        
            if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.initWrap))
                    fetchingNewWrapperVariable.initWrap=null;
        console.log('initWrap'+fetchingNewWrapperVariable.initWrap);
        
        
            if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.customConsultantWrapper))
                    fetchingNewWrapperVariable.customConsultantWrapper=null;
        console.log('customConsultantWrapper'+fetchingNewWrapperVariable.customConsultantWrapper);
        
                    if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.recordTypeWrapper))
                    fetchingNewWrapperVariable.recordTypeWrapper=null;
        console.log('recordTypeWrapper'+fetchingNewWrapperVariable.recordTypeWrapper);
        
            if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.passengerDataWrapper))
                    fetchingNewWrapperVariable.passengerDataWrapper=null;
         console.log('passengerDataWrapper'+fetchingNewWrapperVariable.passengerDataWrapper);

            if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.ITR))
                    fetchingNewWrapperVariable.ITR=null;
         console.log('ITR'+fetchingNewWrapperVariable.ITR);
        
         if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.concatMerchantAndComponentDetails))
                    fetchingNewWrapperVariable.concatMerchantAndComponentDetails=null;
        console.log('fetchingNewWrapperVariable.concatMerchantAndComponentDetails'+fetchingNewWrapperVariable.concatMerchantAndComponentDetails);
        
        if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.customConsultantName))
                    fetchingNewWrapperVariable.customConsultantName=null;
        console.log('fetchingNewWrapperVariable.customConsultantName'+fetchingNewWrapperVariable.customConsultantName);
        
        if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.recordType))
                    fetchingNewWrapperVariable.recordType=null;
        console.log('fetchingNewWrapperVariable.recordType'+fetchingNewWrapperVariable.recordType);
        
        if($A.util.isUndefinedOrNull(fetchingNewWrapperVariable.customType))
                    fetchingNewWrapperVariable.customType=null;
        console.log('fetchingNewWrapperVariable.customType'+fetchingNewWrapperVariable.customType);
        
        */
        if(fetchingNewWrapperVariable.paxIds == '' || fetchingNewWrapperVariable.paxIds == null ||  fetchingNewWrapperVariable.recordType == "--- None ---" ||  fetchingNewWrapperVariable.customConsultantName == "--- NONE ---" || fetchingNewWrapperVariable.customConsultantName == ''){
            this.showToast(component,"Error!", "error",'Missing required fields. Please complete the form before saving');      
        }
        //else if(fetchingNewWrapperVariable.concatMerchantAndComponentDetails =='' || fetchingNewWrapperVariable.concatMerchantAndComponentDetails ==null){
        //    this.showToast(component,"Error!", "error",'Please select the related merchants');
        //   }
           console.log('fetchingNewWrapperVariable364'+JSON.stringify(fetchingNewWrapperVariable));
         console.log('paxId367'+JSON.stringify(fetchingNewWrapperVariable.paxIds));
            var action = component.get("c.onSaveBtnClick");
            action.setParams({
                "orderCusCreationWrapper" : fetchingNewWrapperVariable
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state371old'+state);
                var result = response.getReturnValue();
                
                console.log('state from the new Helper method created!'+result);
                
                if(state === "SUCCESS"){
                    if(result.toBeReturnedBoolean == true){
                        console.log("This Save and New is working fine now!!!");
                        helper.navigate(component,event,helper,result.recordId); 
                    }else{
                        this.closeModal(component,event,helper);
                        this.showToast(component, "Success!", "success", "You have successfully created the Order Customisation"); 
                      //  helper.redirectToTADOrderRecord(component,event,helper,'null'); 
                    }
                }
                else{
                    console.log('There might be some error!');
                }
                
            });
            $A.enqueueAction(action);  
      
    },
    closeModal : function(component){
        /*component.set('v.openPnr',false);
        component.set('v.previewQuote',false);
        component.set("v.sendQuotePNREnable",true);
        component.set("v.disableSendQuoteWithoutFlights",true);
        component.set("v.disableBackButtonWithoutFlights",true);
        component.set("v.disableBackButtonWithFlights",true);
        
        
        component.set("v.previewMinModalWithoutFlight",false);
        */
        var closeEvent = $A.get("e.force:closeQuickAction");
        component.set("v.quotePreviewStringForflightData",null);
        component.set("v.dataPNR",null);
        if(closeEvent){
            closeEvent.fire();
        } else{
            alert('force:closeQuickAction event is not supported in this Ligthning Context');
        }     
    },
    
    
    
    
    
})