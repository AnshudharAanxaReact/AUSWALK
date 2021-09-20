public class orderCancellationFormController {
    
    public class recordDataWrapper{
        @AuraEnabled  public Id Id {get;set;}
        @AuraEnabled  public Id oliId {get;set;}
        @AuraEnabled  public Boolean check {get;set;}
        @AuraEnabled  public String level {get;set;}
        @AuraEnabled  public String name {get;set;}
        @AuraEnabled  public String type {get;set;}
        @AuraEnabled  public Decimal price {get;set;}
        @AuraEnabled  public String oliAddonStatus {get;set;}
        @AuraEnabled  public String status {get;set;}
        @AuraEnabled  public String refundReason {get;set;}
        @AuraEnabled  public Decimal refund {get;set;}
        @AuraEnabled  public String approvalStage {get;set;}
    }
    
    public class ApprovalHistoryWrapper{
        @AuraEnabled  public String approvalName {get;set;}
        @AuraEnabled  public String type {get;set;}
        @AuraEnabled  public string canRefId {get;set;}
        @AuraEnabled  public Boolean sendCouponButton {get;set;}
        @AuraEnabled  public List<recordDataWrapper> oliAddonData {get;set;}
    }
    
    public class minNotMetCheckData{
        @AuraEnabled  public String minMetState {get;set;}
        @AuraEnabled  public List<String> minNotMetOptions {get;set;}
        @AuraEnabled  public Set<string> refundOptions {get;set;}
        @AuraEnabled  public Boolean enableSendCouponButton {get;set;}
        @AuraEnabled  public String OrdName {get;set;}
        
    }
    
    // This method verifies Initial order status 
    @AuraEnabled
    public static minNotMetCheckData verifyMinNotMetApprovalStatus (String recId){ 
        
        minNotMetCheckData minData = new minNotMetCheckData();
        Set<string> refundOptions = new Set<string>();
        
        Orders__c  AusRec = [Select id,Departure_Date__r.Options_available_to_customers__c ,Total_Payment_Received__c, Departure_Date__r.MinNotMetApproval__c,Master_Status__c	   from Orders__c  where id=:recId];
      //  TAD_Order__c tadRec = [Select id,ordexp_departure_date__r.ordexp_Options_availbale_to_customers__c,ordexp_total_payment_received__c, ordexp_departure_date__r.MinNotMetApproval__c,ordexp_master_status__c   from TAD_Order__c  where id=:recId];
        if(AusRec.Master_Status__c	=='On Hold' || AusRec.Total_Payment_Received__c==0){
                      minData.minMetState = 'On Hold';
        }
        else if(AusRec.Master_Status__c	=='Cancelled'){
            minData.minMetState = 'MinCancelled';
            if(AusRec.Departure_Date__r.MinNotMetApproval__c=='Processed'){
                minData.enableSendCouponButton = true;
            }else{
                minData.enableSendCouponButton = false;
            }
           
        } 
        else if(AusRec.Departure_Date__r.MinNotMetApproval__c=='Rejected'){
            minData.minMetState = 'Not Required'; 
        }
        else if(AusRec.Departure_Date__r.MinNotMetApproval__c=='In Progress'){
            minData.minMetState = 'Initiated'; 
        }
        else if(AusRec.Departure_Date__r.MinNotMetApproval__c=='Not Required'||AusRec.Departure_Date__r.MinNotMetApproval__c==null){
            minData.minMetState = 'Not Required'; 
        }
        else if(AusRec.Departure_Date__r.MinNotMetApproval__c=='Processed'){
            minData.minMetState = 'Processed';
            String []  minOptions = AusRec.Departure_Date__r.Options_available_to_customers__c .split(';');
            for(String op :minOptions){
                if(op.contains('Credit') || op.contains('deal')||op.contains('Deal') ){
                    refundOptions.add('Full Credit');
                    refundOptions.add('Partial Credit');
                }
                if(op.contains('Refund')){
                    refundOptions.add('Full Refund');
                    refundOptions.add('Partial Refund');  
                }
                if(op.contains('Coupon')){
                    refundOptions.add('Full Coupon');
                    refundOptions.add('Partial Coupon'); 
                }
            }
            minData.refundOptions=refundOptions;
            minData.minNotMetOptions=minOptions;
        }
        orders__c ord=[select name from orders__c where id=:recId];
        String ordrName=ord.name;
        minData.ordName=ordrName;
        return minData;  
    }
    
    // This method gets records required for re-approval 
    @AuraEnabled
    public static List<recordDataWrapper> fetchReordDataApexApproval (String recId){
        
        String recIdsubstring = recId.substring(0,15);
        
        List<recordDataWrapper> wrap = new List<recordDataWrapper>();
        Set <String> approvalStatus = new Set<string>();
        approvalStatus.add('Pending Documentation');
        approvalStatus.add('CS Rejected');
        approvalStatus.add('Finance Rejected');
        
        
        
        List<Order_Line_Items__c > olitems = [Select Id ,Refund_Status__c , Name, Suboption_Amount__c ,Total_Surcharge__c,City_Surcharge_Amount__c,Cancellation_Amount__c,Refund_Type__c,Refund_Reason_c__c,Status__c,Total_Amount__c
                                            from Order_Line_Items__c  where Orders__c =: recId AND Refund_Status__c IN:approvalStatus];
       
  //     List<AddOn__c> addOnsItems = [Select Id,Refund_Reason_c__c,Refund_Status__c,Order_Line_Item__c,Cancellation_Amount_c__c,Order_Id__c, Name,AddOn_Status__c,RecordType.Name,Amount__c,Refund_Type__c from AddOn__c where Order_Id__c=:recIdsubstring AND Refund_Status__c IN:approvalStatus];
        
    //   List<Customization__c> customisationItems = [Select Id, Refund_Type__c, Status__c, Refund_Reason__c, Refund_Status__c, Order_Line_Items__c, Cancellation_Amount__c, mp_order__c, Name, RecordType.Name, Refund_Status1__c, Total_price__c from Customization__c where mp_order__c=:recIdsubstring AND Refund_Status__c IN:approvalStatus and Status__c != 'Declined'];
        
        
        for(Order_Line_Items__c oli : olitems){
            recordDataWrapper data = new recordDataWrapper();
            if(oli.Refund_Status__c=='CS Rejected' || oli.Refund_Status__c=='Finance Rejected'){
                data.check=true;   
            }else{
              data.check=false; 
            }
            data.Id=oli.id;
            data.level='OLI';
            data.name=oli.Name;
            data.price=OLI.Total_Amount__c;//oli.Suboption_Amount__c+oli.Total_surcharge__c+oli.City_Surcharge_Amount__c;
            data.oliAddonStatus=oli.Status__c;
            data.refundReason=oli.Refund_Reason_c__c;
            data.status=oli.Refund_Type__c;
            data.refund=oli.Cancellation_Amount__c;
            data.approvalStage=oli.Refund_Status__c;
            wrap.add(data);
        } 
    /*    for(AddOn__c add : addOnsItems){
            recordDataWrapper data1 = new recordDataWrapper();
            if(add.Refund_Status__c=='CS Rejected' || add.Refund_Status__c=='Finance Rejected'){
                data1.check=true;   
            }else{
                data1.check=false; 
            } 
            data1.Id=add.id;
            data1.level='AddOn';
            data1.oliId=add.Order_Line_Item__c;
            data1.name=add.Name +'-'+add.RecordType.Name;
            data1.price=add.Amount__c;
            data1.oliAddonStatus=add.AddOn_Status__c;
            data1.refundReason=add.Refund_Reason_c__c;
            data1.status=add.Refund_Type__c;
            data1.refund=add.Cancellation_Amount_c__c;
            data1.approvalStage=add.Refund_Status__c;
            wrap.add(data1);   
        } 
        for(Customization__c oc : customisationItems) {
            recordDataWrapper data2 = new recordDataWrapper();
            if(oc.Refund_Status__c =='CS Rejected' || oc.Refund_Status__c =='Finance Rejected'){
                data2.check=true;   
            }else{
                data2.check=false; 
            } 
            data2.Id=oc.id;
            data2.level='Customisation';
            data2.oliId=oc.Order_Line_Items__c;
            data2.name=oc.Name;
            data2.price=oc.Total_price__c;
            data2.oliAddonStatus=oc.Status__c;
            data2.refundReason=oc.Refund_Reason__c;
            data2.status=oc.Refund_Type__c;
            data2.refund=oc.Cancellation_Amount__c;
            data2.approvalStage=oc.Refund_Status__c ;
            wrap.add(data2);
        }
        */
        return wrap; 
    }
    
    // This method gets Cancellation records which are in progress
    @AuraEnabled
    public static List<ApprovalHistoryWrapper> fetchReordDataApexApprovalHistory (String recId){
        
        Map<id,Cancellation_Refund__c> canRefMap = new Map<id,Cancellation_Refund__c>([Select id,Name,Approval_Status__c,Total_Cancellation_Amount__c,createdDate from Cancellation_Refund__c where Orders__c=:recId ]);
        
        List<Cancellation_Refund__c> canRef = [Select id,Name,Approval_Status__c,Total_Cancellation_Amount__c,createdDate,
                                              (Select Id ,Refund_Status__c, Name,Suboption_Amount__c,Total_surcharge__c,City_Surcharge_Amount__c,Cancellation_Amount__c,Refund_Type__c,Refund_Reason_c__c,Status__c from Order_Line_Items__r),
                                        /*      (Select Id,Refund_Reason_c__c,Refund_Status__c,Order_Line_Item__c,Order_Line_Item__r.Name,Cancellation_Amount_c__c, Name,AddOn_Status__c,RecordType.Name,Amount__c,Refund_Type__c from AddOns__r), 
                                              (Select Id, Refund_Type__c, Status__c, Refund_Reason__c, Refund_Status__c, Order_Line_Items__c, Cancellation_Amount__c, mp_order__c, Name, RecordType.Name, Refund_Status1__c, Total_price__c from Customization__r),*/
                                              (Select id, Send_Coupon__c  from Coupons__r limit 1) 
                                               from Cancellation_Refund__c where Orders__c=:recId ];
        
        system.debug('canRef181'+canRef);
        List<ApprovalHistoryWrapper> wrapData = new List<ApprovalHistoryWrapper>();
        
        for(Cancellation_Refund__c can :canRef){
            
            ApprovalHistoryWrapper  wrap = new ApprovalHistoryWrapper();
            wrap.approvalName= can.Name+' | '+ can.Approval_Status__c+' | '+ can.Total_Cancellation_Amount__c;
            wrap.canRefId = can.Id;
            
            for(Coupons__c cp : can.Coupons__r){
			wrap.sendCouponButton = cp.Send_Coupon__c;
           }
            
            List<recordDataWrapper> recDataList = new List<recordDataWrapper> ();
            
           for(Order_Line_Items__c oli : can.Order_Line_Items__r){
                recordDataWrapper data = new recordDataWrapper();
                data.Id=oli.id;
                data.level='OLI';
                data.name=oli.Name;
                data.price=oli.Suboption_Amount__c+oli.Total_surcharge__c+oli.City_Surcharge_Amount__c;
                data.status=oli.Refund_Type__c;
                data.refund=oli.Cancellation_Amount__c;
                data.approvalStage=oli.Refund_Status__c;
                recDataList.add(data);
            } 
           /* for(AddOn__c add : can.AddOns__r){
                recordDataWrapper data1 = new recordDataWrapper();
                data1.Id=add.id;
                data1.level='AddOn';
                data1.name=add.Order_Line_Item__r.Name+' | '+add.Name +'-'+add.RecordType.Name;
                data1.price=add.Amount__c;
                data1.status=add.Refund_Type__c ;
                data1.refund=add.Cancellation_Amount_c__c;
                data1.approvalStage=add.Refund_Status__c;
                recDataList.add(data1);   
            }
            
            
            for(Customization__c  oc : can.Customization__r ){
                recordDataWrapper data2 = new recordDataWrapper();
                data2.Id=oc.id;
                data2.level='Customisation';
                data2.name=oc.Name;
                data2.type=oc.Refund_Type__c;
                data2.price=oc.Total_price__c;
                data2.status=oc.Refund_Type__c;
                data2.refund=oc.Cancellation_Amount__c;
                data2.approvalStage=oc.Refund_Status__c;
                recDataList.add(data2);   
            }
*/
            wrap.oliAddonData=recDataList;
            wrapData.add(wrap);
        }
        return wrapData; 
    }
    
    // This method get records for cancellation based on level selected
    @AuraEnabled
    public static List<recordDataWrapper> fetchReordDataApex (Id recId, String level){
        
        List<recordDataWrapper> wrap = new List<recordDataWrapper>();
        
        if(level=='Order' || level=='OLI' ){
                                                                                           
            List<Order_Line_Items__c> olitems = [Select Id, Name,Total_Amount__c,Suboption_Amount__c,Total_surcharge__c,City_Surcharge_Amount__c,Status__c,Refund_Reason_c__c,(select Id, Name, Total_price__c, Status__c, Order_Line_Items__c, Refund_Type__c from Customization__r  where Status__c !='Cancelled'), (Select Id,Order_Line_Item__c, Name,AddOn_Status__c,RecordType.Name,Amount__c,Refund_Status__c from AddOns__r where AddOn_Status__c !='Cancelled') from order_Line_items__c where Orders__c  =: recId AND Status__c !='Cancelled'];
            system.debug('oliitems  247');
            for(Order_Line_Items__c oli : olitems){
                recordDataWrapper data = new recordDataWrapper();
                data.Id=oli.id;
                data.level='OLI';
                data.name=oli.Name;
                data.price=oli.Total_Amount__c;//oli.Suboption_Amount__c+oli.Total_surcharge__c+oli.City_Surcharge_Amount__c;
                data.oliAddonStatus=oli.Status__c;
                data.refundReason=oli.Refund_Reason_c__c;
                if(level=='Order'){
                    data.check=true;    
                }else{
                    data.check=false;   
                }
                wrap.add(data);
                
              /*  for(AddOn__c add : oli.AddOns__r){
                    recordDataWrapper data1 = new recordDataWrapper();
                    data1.Id=add.id;
                    data1.oliId=add.Order_Line_Item__c;
                    data1.level='AddOn';
                    data1.name=add.Name +'-'+add.RecordType.Name;
                    data1.price=add.Amount__c;
                    data1.oliAddonStatus=add.AddOn_Status__c;
                    if(level=='Order'){
                        data1.check=true;    
                    }else{
                        data1.check=false;   
                    }
                    wrap.add(data1);   
                }
                
                for(Customization__c oc : oli.Customization__r){
                    recordDataWrapper data2 = new recordDataWrapper();
                    data2.Id=oc.Id;
                    data2.oliId=oc.Order_Line_Items__c;
                    data2.level='Customisation';
                    data2.name=oc.Name;
                    data2.type=oc.Refund_Type__c;
                    data2.price=oc.Total_price__c;
                    data2.oliAddonStatus=oc.Status__c;
                    if(level=='Order'){
                        data2.check=true;    
                    }else{
                        data2.check=false;   
                    }
                    wrap.add(data2);   
                    
                } */
            }  
            
        }
        
     /*    if(level=='Addon'){
            
            List<AddOn__c> addOn = [Select Id, Name,AddOn_Status__c,RecordType.Name,Amount__c,Order_Line_Item__r.Name,Refund_Status__c from AddOn__c where Order_Line_Item__r.Orders__c =: recId AND AddOn_Status__c!='Cancelled'];
            for(AddOn__c add : addOn ){
                recordDataWrapper data = new recordDataWrapper();
                data.Id=add.id;
                data.level='AddOn';
                data.name=add.Order_Line_Item__r.Name +' | '+add.Name +'-'+add.RecordType.Name;
                data.price=add.Amount__c;
                data.oliAddonStatus=add.AddOn_Status__c;
                data.check=false;
                wrap.add(data);
            }  
            
            List<Customization__c> ocs = [Select Id, Name, Refund_Type__c, Status__c, RecordType.Name,Total_price__c,Order_Line_Items__r.Name,Refund_Status__c from Customization__c where Order_Line_Items__r.Orders__c =: recId AND (Status__c!='Cancelled' AND Status__c != 'Declined')];
            for(Customization__c oc : ocs ){
                recordDataWrapper data = new recordDataWrapper();
                data.Id=oc.id;
                data.level='Customisation';
                data.name=oc.Name;
                data.type=oc.Refund_Type__c;
                data.price=oc.Total_price__c;
                data.oliAddonStatus=oc.Status__c;
                data.check=false;
                wrap.add(data);
            } 
        } */
        system.debug('Data 328'+wrap);
        return wrap;
        
    }
    
    // This method gets picklist Values
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname){
        
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getLabel());
        }
        system.debug('optionlist344'+optionlist);
        return optionlist;
        
    } 
    
    // This method cancels order/records if documentation is required
    @AuraEnabled
    public static void saveAndCancel(Id recId, List<recordDataWrapper> recData,Boolean cancelOrder){
        
        List<Order_Line_Items__c > oliToUpdate = new List<Order_Line_Items__c >();
    //    List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
     //   List<Customization__c > customisationToUpdate = new List<Customization__c >();
        
        Boolean updatePaxCount = false;
        
        for(recordDataWrapper data :recData){
            if(data.check==true){
                if(data.level=='OLI'){
                    Order_Line_Items__c  oli = new Order_Line_Items__c (id=data.Id);
                    oli.Cancellation_Amount__c=data.refund;
                    oli.Refund_Type__c=data.status;
                    oli.Refund_Reason_c__c =data.refundReason;
                    oli.Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oli.Refund_Status__c ='Processed'; 
                    }else{
                        oli.Refund_Status__c ='Pending Documentation';    
                    }
                    oliToUpdate.add(oli); 
                    
                    updatePaxCount = true;
                    
                }
            /*    if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    add.Cancellation_Amount_c__c =data.refund;
                    add.Refund_Type__c=data.status;
                    add.Refund_Reason_c__c =data.refundReason;
                    add.AddOn_Status__c ='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        add.Refund_Status__c  ='Processed'; 
                    }else{
                        add.Refund_Status__c  ='Pending Documentation';    
                    }
                    addOnToUpdate.add(add);
                }
                
                if(data.level=='Customisation'){
                    Customization__c oc= new Customization__c(id=data.Id);
                    oc.Cancellation_Amount__c=data.refund;
                    oc.Refund_Type__c =data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    oc.Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oc.Refund_Status__c  ='Processed'; 
                    }else{
                        oc.Refund_Status__c  ='Pending Documentation';    
                    }
                    customisationToUpdate.add(oc);
                }
                */
            }
        }
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                update oliToUpdate;
            }
         /*   if(!addOnToUpdate.isEmpty()){
                update addOnToUpdate;
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            } */
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        if(updatePaxCount==true){
            List<customer__c> cusCount = [Select id from customer__c  where customer_order_id__c =:recId /*AND Order_Line_Items__c.Status__c!='Cancelled'*/ AND pif_final__c=true ];
            Orders__c AusToUpdate = new Orders__c(id=recId);
            AusToUpdate.PIF_count__c  = cusCount.size();
            if(cancelOrder==true){
                AusToUpdate.Master_Status__c ='Cancelled';
                AusToUpdate.Order_Cancelled__c  =true;
                AusToUpdate.Sub_Status__c =orderSubStatusCheck(recData[0].refundReason,recData[0].status);
            } 
            try{
                update AusToUpdate;  
            }catch(DmlException e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }
                if(!Test.isRunningTest())
                 throw new AuraHandledException(msg);   
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
                      
                

        } 
    }
    
    // This method is for Min not met type of cancellation where we cancel whole order
    @AuraEnabled
    public static void cancelCompleteOrder(Id recId, List<recordDataWrapper> recData){
        
       Cancellation_Refund__c canRef = new Cancellation_Refund__c ();
        canRef.Orders__c =recId;
        insert canRef; 
 
        List<Order_Line_Items__c > oliToUpdate = new List<Order_Line_Items__c>();
     //   List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
       // List<Customization__c > customisationToUpdate = new List<Customization__c >();
        
        for(recordDataWrapper data :recData){
            if(data.check==true){
                
                if(data.level=='OLI'){
                    
                    Order_Line_Items__c oli = new Order_Line_Items__c(id=data.Id);
                    oli.Cancellation_Amount__c=data.refund;
                    oli.Refund_Type__c=data.status;
                    oli.Refund_Reason_c__c=data.refundReason;
                    oli.Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oli.Refund_Status__c ='Processed'; 
                    }else{
                        oli.Cancellation_Refund__c=canRef.id;
                        oli.Refund_Status__c ='Approved-Not Processed';    
                    }
                    oliToUpdate.add(oli);   
                }
          /*      if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    add.Cancellation_Amount_c__c=data.refund;
                    add.Refund_Type__c=data.status;
                    add.Refund_Reason_c__c=data.refundReason;
                    add.AddOn_Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        add.Refund_Status__c ='Processed'; 
                    }else{
                        add.Cancellation_Refund__c=canRef.id;
                        add.Refund_Status__c ='Approved-Not Processed';    
                    }
                    addOnToUpdate.add(add);
                }
                 if(data.level=='Customisation'){
                    Customization__c oc= new Customization__c(id=data.Id);
                    oc.Cancellation_Amount__c=data.refund;
                    oc.Refund_Type__c =data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    oc.Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oc.Refund_Status__c  ='Processed'; 
                    }else{
                        oc.Cancellation_Refund__c=canRef.id;
                        oc.Refund_Status__c  ='Pending Documentation';    
                    }
                    customisationToUpdate.add(oc);
                } */
            }
        }
        
        Orders__c AusToUpdate = new Orders__c(id=recId);
        AusToUpdate.Master_Status__c='Cancelled';
        AusToUpdate.Order_Cancelled__c =true;
        AusToUpdate.pif_count__c = 0;
        AusToUpdate.Sub_status__c=orderSubStatusCheck(recData[0].refundReason,recData[0].status);
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                update oliToUpdate;
            }
       /*     if(!addOnToUpdate.isEmpty()){
                update addOnToUpdate;
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            }*/
            update AusToUpdate;
        } 
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }if(!Test.isRunningTest())
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        Cancellation_Refund__c can = updateCanRefRecord(canRef);
        can.Approval_Status__c  ='Approved-Not Processed';
        update can;
        
        
    }
    
    // This methods cancels records and sends for approval
    @AuraEnabled
    public static void submitForApproval(Id recId, List<recordDataWrapper> recData,Boolean cancelOrder, Boolean isCustomerAccepted){
        
        List<order_Line_items__c> oliToUpdate = new List<order_Line_items__c>();
      //  List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
     //  List<Customization__c> customisationToUpdate = new List<Customization__c>();
        
        Boolean updatePaxCount = false;
        Boolean canRefCheck = false;
        
        Cancellation_Refund__c canRef = new Cancellation_Refund__c();
        for(recordDataWrapper rec : recData){
            if(rec.status !='Full Credit' && rec.status !='Partial Credit' && rec.status !='No Refund/Credit' && rec.check==true){
                canRefCheck=true;
                system.debug('OLI560');
                break;
            }
        }
        if(canRefCheck==true){
            system.debug('OLI564');
            canRef = canRefRecordAssignment(recId,isCustomerAccepted); 
            
        }
        
        for(recordDataWrapper data :recData){
            if(data.check==true){
                if(data.level=='OLI'){
                    system.debug('OLI570');
                    order_Line_items__c oli = new order_Line_items__c(id=data.Id);
                    oli.Cancellation_Amount__c=data.refund;
                    oli.Refund_Type__c=data.status;
                    oli.Refund_Reason_c__c=data.refundReason;
                    oli.Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oli.Refund_Status__c ='Processed'; 
                    }else{
                        oli.Cancellation_Refund__c=canRef.id;
                        oli.Refund_Status__c ='Pending CS Approval';
                    }
                    oliToUpdate.add(oli); 
                    updatePaxCount = true;
                    
                }
         /*       if(data.level=='AddOn'){
                     AddOn__c add= new AddOn__c(id=data.Id);
                    add.Cancellation_Amount_c__c=data.refund;
                     system.debug('AddOn588');
                    add.Refund_Type__c=data.status;
                    add.Refund_Reason_c__c=data.refundReason;
                    add.AddOn_Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        add.Refund_Status__c ='Processed'; 
                    }else{
                        add.Cancellation_Refund__c=canRef.id;
                        add.Refund_Status__c ='Pending CS Approval';
                    }
                    addOnToUpdate.add(add);
                    
            }
                if(data.level=='Customisation'){
                    Customization__c oc= new Customization__c(id=data.Id);
                    oc.Cancellation_Amount__c=data.refund;
                     system.debug('Customisation604');
                    oc.Refund_Type__c =data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    oc.Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oc.Refund_Status__c  ='Processed'; 
                    }else{
                        oc.Cancellation_Refund__c=canRef.id;
                        oc.Refund_Status__c ='Pending CS Approval';
                    }
                    customisationToUpdate.add(oc);
                } */
            }
        }
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                update oliToUpdate;
            }
            /* if(!addOnToUpdate.isEmpty()){
                update addOnToUpdate;
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            } */
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        if(updatePaxCount==true){
            List<customer__c> cusCount = [Select id from customer__c where customer_order_id__c=:recId AND Order_Line_Item__r.Status__c!='Cancelled' AND pif_final__c=true];
            Orders__c AusToUpdate = new Orders__c(id=recId);
            AusToUpdate.pif_count__c = cusCount.size();
            if(cancelOrder==true){
                AusToUpdate.Master_Status__c='Cancelled';
                AusToUpdate.Order_Cancelled__c =true;
                AusToUpdate.Sub_status__c=orderSubStatusCheck(recData[0].refundReason,recData[0].status);
            } 
            try{
                update AusToUpdate;
            }catch(DmlException e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }if(!Test.isRunningTest())
                throw new AuraHandledException(msg);
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
        }
        
        if(canRefCheck==true){
            Cancellation_Refund__c can = updateCanRefRecord(canRef);
            can.Approval_Status__c='Pending CS Approval';
           
            update can;
        }
        
    }   
    
    @AuraEnabled
    public static void sendForApprovalPostDocumentation(Id recId, List<recordDataWrapper> recData, Boolean isCustomAccepted){
        
        List<order_Line_items__c> oliToUpdate = new List<order_Line_items__c>();
   //     List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
   //     List<Customization__c> customisationToUpdate = new List<Customization__c>();
        
        Boolean canRefCheck = false;
        Cancellation_Refund__c canRef = new Cancellation_Refund__c();
        
        for(recordDataWrapper rec : recData){
            if(rec.status !='Full Credit' && rec.status !='Partial Credit' && rec.status !='No Refund/Credit' &&  rec.check==true){
                canRefCheck=true;
                break;
            }
        }
        if(canRefCheck==true){
            canRef = canRefRecordAssignment(recId, isCustomAccepted);  
        }
        system.debug('recdata702'+recData);
        for(recordDataWrapper data :recData){
            if(data.check==true){
                if(data.level=='OLI'){
                    order_Line_items__c oli = new order_Line_items__c(id=data.Id);
                    oli.Cancellation_Amount__c=data.refund;
                    oli.Refund_Type__c=data.status;
                    oli.Refund_Reason_c__c=data.refundReason;
                    oli.Status__c='Cancelled';
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oli.Refund_Status__c ='Processed'; 
                    }else{
                        oli.Cancellation_Refund__c=canRef.id;
                        oli.Refund_Status__c ='Pending CS Approval';
                    }
                    oliToUpdate.add(oli);
                }
         /*       if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    add.Cancellation_Amount_c__c=data.refund;
                    add.Refund_Type__c=data.status;
                    add.Refund_Reason_c__c=data.refundReason;
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        add.Refund_Status__c ='Processed'; 
                    }else{
                        add.Cancellation_Refund__c=canRef.id;
                        add.Refund_Status__c ='Pending CS Approval';
                    }
                    addOnToUpdate.add(add);
                }
                if(data.level=='Customisation'){
                    Customization__c oc= new Customization__c(id=data.Id);
                    oc.Cancellation_Amount__c=data.refund;
                    oc.Refund_Type__c=data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    if(data.status=='Full Credit' || data.status=='Partial Credit' || data.status=='No Refund/Credit'){
                        oc.Refund_Status__c ='Processed'; 
                    }else{
                        oc.Cancellation_Refund__c=canRef.id;
                        oc.Refund_Status__c ='Pending CS Approval';
                    }
                    customisationToUpdate.add(oc);
                } */
            }
        }
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                update oliToUpdate;
            }
          /*  if(!addOnToUpdate.isEmpty()){
                update addOnToUpdate;
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            } */
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        if(canRefCheck==true){
            Cancellation_Refund__c can = updateCanRefRecord(canRef);
            can.Approval_Status__c='Pending CS Approval';
            update can;
        }
    } 
    
    private static Cancellation_Refund__c updateCanRefRecord (Cancellation_Refund__c canRef){
        
        Decimal refundAmount =0;
        Decimal coupounAmount =0;
        String cancelledInfo='';
        String reason='';
        String type='';

        List<Cancellation_Refund__c> canRefList = [Select id,Name,
                                                   (Select Id ,Name,Cancellation_Amount__c,Refund_Type__c,Refund_Reason_c__c from Order_Line_Items__r) /*, 
                                                   (Select Id,Name,Amount__c,Refund_Status__c,RecordType.Name from AddOns__r),
                                                   (Select Id,Name,Cancellation_Amount__c,Refund_Status__c from Customization__r) */
                                                   from Cancellation_Refund__c where Id=:canRef.Id ];
        
        for(Cancellation_Refund__c can :canRefList){
            for(order_Line_items__c oli : can.order_Line_items__r){
                if(oli.Refund_Type__c=='Full Coupon' || oli.Refund_Type__c=='Partial Coupon'){
                    coupounAmount=coupounAmount+oli.Cancellation_Amount__c;   
                }else if(oli.Refund_Type__c=='Full Refund' || oli.Refund_Type__c=='Partial Refund'){
                    refundAmount=refundAmount+oli.Cancellation_Amount__c;
                }
                type=oli.Refund_Type__c;
                reason=oli.Refund_Reason_c__c;
                cancelledInfo=cancelledInfo+oli.Name+'\n';
            } 
         /*   for(AddOn__c add : can.AddOns__r){
                if(add.Refund_Status__c=='Full Coupon' || add.Refund_Status__c=='Partial Coupon'){
                    coupounAmount=coupounAmount+add.Cancellation_Amount_c__c;   
                }else if(add.Refund_Status__c=='Full Refund' || add.Refund_Status__c=='Partial Refund'){
                    refundAmount=refundAmount+add.Amount__c;
                }
                cancelledInfo=cancelledInfo+'AddOn - '+add.RecordType.Name+' | '+add.Name+'\n';
            }
            for(Customization__c oc : can.Customization__r){
                if(oc.Refund_Status__c=='Full Coupon' || oc.Refund_Status__c=='Partial Coupon'){
                    coupounAmount=coupounAmount+oc.Cancellation_Amount__c;   
                }else if(oc.Refund_Status__c=='Full Refund' || oc.Refund_Status__c=='Partial Refund'){
                    refundAmount=refundAmount+oc.Cancellation_Amount__c;
                } 
                cancelledInfo=cancelledInfo+'Order Customisation - '+oc.Name+'\n';
            } */
        }
        Cancellation_Refund__c  canRefData = new  Cancellation_Refund__c();
        canRefData.Id=canRef.Id;
        canRefData.Refund_Amount_c__c =refundAmount;
        canRefData.Coupon_Amount__c =coupounAmount;
        canRefData.Cancelled_Records_Information__c =cancelledInfo;
        canRefData.CS_Refund_Rejection_Reason__c  ='';
        canRefData.Finance_Refund_Rejection_Reason__c   ='';
        //canRefData.Cancellation_Type__c ='Cancellation'; 
        canRefData.Refund_reason__c=reason;
        canRefData.Refund_Type__c =type; 
        return canRefData;
    }
    @TestVisible
    private static String orderSubStatusCheck (String refundReason,String refundStatus ){
        String subStatus='';
        
        if(refundReason.contains('Offload')){
            subStatus='Offloaded'; 
        }
        else if(refundReason.contains('Min Numbers')){
            if(refundStatus.contains('Credit')){
                subStatus='Min Number - Credit issued';
            }else{
                subStatus='Mins Not Met';  
            }
        }
        else if(refundReason.contains('Internal')){
            subStatus='Internal'; 
        }
        else if(refundReason.contains('Customer')){
            subStatus='Customer Request'; 
        }
        else if(refundReason.contains('External')){
            subStatus='External'; 
        }
        return subStatus;
    } 
    @TestVisible
    private static Cancellation_Refund__c canRefRecordAssignment (Id recId, Boolean isCustomerAccepted  ){
        Cancellation_Refund__c canRef = new Cancellation_Refund__c ();
        
        Set<String> approvalStatus = new Set<String>();
        approvalStatus.add('Approved-Not Processed');
        approvalStatus.add('Processed');
        
        List<Cancellation_Refund__c> canRefFindList = [Select id,Refund_Amount_c__c ,Coupon_Amount__c,Cancelled_Records_Information__c  from Cancellation_Refund__c where Orders__c =:recId AND Approval_Status__c NOT IN:approvalStatus];
        
        if(canRefFindList.isEmpty()){
            canRef.Orders__c =recId;
            canRef.Customer_Accepts__c = isCustomerAccepted;
            canRef.Cancellation_Type__c ='Cancellation'; 
            insert canRef;   
            
        }else{
            canRef = canRefFindList[0];
            ProcessInstanceWorkitem[] workItems = [ SELECT Id
                                                   FROM ProcessInstanceWorkitem 
                                                   WHERE ProcessInstance.TargetObjectId =: canRef.id
                                                   AND ProcessInstance.Status = 'Pending' ]; 
            
            if(!workItems.isEmpty()){
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();  
                pwr.setAction('Removed');
                pwr.setWorkItemId(workItems[0].id);   
                Approval.ProcessResult result = Approval.process(pwr);
            }
           canRef.Approval_Status__c=''; 
           update canRef; 
        }
        return canRef;
    }
    
    @AuraEnabled
    public static void settingSendCouponTrue(String canRefId){
        
        
        Coupons__c  couponToBeUpdated = [Select id, Send_Coupon__c  from Coupons__c  where Cancellation_Refund__c  =: canRefId];
        couponToBeUpdated.Send_Coupon__c  = true;
        update couponToBeUpdated; 
       
    }
}