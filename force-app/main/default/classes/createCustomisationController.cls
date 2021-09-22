public class createCustomisationController {
    
    public class initWrapperForCancelledAndTravelledOrders {
        
        @AuraEnabled public Map<Id, Order_Line_Items__c> mapOfOLIAndId {get;set;}
        @AuraEnabled public string orderMasterStatus {get;set;}
        
    }
    public class oliVerificationWrap {
        @AuraEnabled public Boolean toBeReturned {get;set;}
        @AuraEnabled public String oliName {get;set;}
    }
    
    public class paxListWrapper{
        @AuraEnabled public string paxName {get;set;}
        @AuraEnabled public string paxFirstName {get;set;}
        @AuraEnabled public string paxLastName {get;set;}
        @AuraEnabled public string paxId {get;set;}
        @AuraEnabled public string email {get;set;}
    }
    
    public class finalDataWrapper{
        
        @AuraEnabled public string oliId {get;set;}
        @AuraEnabled public string sObjId {get;set;}
        //   @AuraEnabled public string recordType {get;set;}
        @AuraEnabled public List<String> paxIds {get;set;}
        //      @AuraEnabled public string customConsultantName {get;set;}
        //    @AuraEnabled public string customType {get;set;}
        //   @AuraEnabled public List<String> concatMerchantAndComponentDetails {get;set;}
        @AuraEnabled public String reqDetails {get;set;}
        @AuraEnabled public String btnText {get;set;}
        //     @AuraEnabled public String sObjName {get;set;}
        //     @AuraEnabled public List<String> storedComponentIds {get;set;}
        //    @AuraEnabled public String noteVisibility {get;set;}
        @AuraEnabled public string tadOrderName {get;set;}
        @AuraEnabled public string orderLineItemName {get;set;}
        @AuraEnabled public Integer selectedPAXQuantity {get;set;}
        @AuraEnabled public string paxNames {get;set;}
        @AuraEnabled public string customizationType {get;set;}
        @AuraEnabled public string itineraryDays {get;set;}
        //@AuraEnabled public Map<String, List<String>> getDependentMap {get;set;}
        @AuraEnabled public initWrapperForCancelledAndTravelledOrders initWrap {get;set;}
        @AuraEnabled public List<picklistWrapper> customConsultantWrapper {get;set;}
        @AuraEnabled public List<picklistWrapper> recordTypeWrapper {get;set;}
        //@AuraEnabled public List<picklistWrapper> noteVisibilityPicklistWrapper {get;set;}
        @AuraEnabled public List<paxListWrapper> passengerDataWrapper {get;set;}
        //   @AuraEnabled public List<componentDataWrapper> componentDataWrapper {get;set;}
        @auraenabled Public List<itineraryDays>ITR{get;set;}
        @auraenabled Public List<supplierTypeWrapper> supplierTypeWrapper{get;set;}
        @AuraEnabled public String savedComponentIds {get;set;}
        @AuraEnabled public string savedPaxIds {get;set;}
        
    }
    public class finalDataWrapper1{
        
        @AuraEnabled public string oliId {get;set;}
        @AuraEnabled public string sObjId {get;set;}
        //   @AuraEnabled public string recordType {get;set;}
        @AuraEnabled public List<String> paxIds {get;set;}
        //      @AuraEnabled public string customConsultantName {get;set;}
        //    @AuraEnabled public string customType {get;set;}
        //   @AuraEnabled public List<String> concatMerchantAndComponentDetails {get;set;}
        @AuraEnabled public String reqDetails {get;set;}
        @AuraEnabled public String btnText {get;set;}
        //     @AuraEnabled public String sObjName {get;set;}
        //     @AuraEnabled public List<String> storedComponentIds {get;set;}
        //    @AuraEnabled public String noteVisibility {get;set;}
        @AuraEnabled public string tadOrderName {get;set;}
        @AuraEnabled public string orderLineItemName {get;set;}
        @AuraEnabled public Integer selectedPAXQuantity {get;set;}
        @AuraEnabled public string paxNames {get;set;}
        @AuraEnabled public string customizationType {get;set;}
        @AuraEnabled public string itineraryDays {get;set;}
        //@AuraEnabled public Map<String, List<String>> getDependentMap {get;set;}
        @AuraEnabled public initWrapperForCancelledAndTravelledOrders initWrap {get;set;}
        @AuraEnabled public List<picklistWrapper> customConsultantWrapper {get;set;}
        @AuraEnabled public List<picklistWrapper> recordTypeWrapper {get;set;}
        //@AuraEnabled public List<picklistWrapper> noteVisibilityPicklistWrapper {get;set;}
        @AuraEnabled public List<paxListWrapper> passengerDataWrapper {get;set;}
        //   @AuraEnabled public List<componentDataWrapper> componentDataWrapper {get;set;}
        @auraenabled Public List<itineraryDays>ITR{get;set;}
        @auraenabled Public List<supplierTypeWrapper> supplierTypeWrapper{get;set;}
        @AuraEnabled public String savedComponentIds {get;set;}
        @AuraEnabled public string savedPaxIds {get;set;}
        
    }
    
        
    public class itineraryDays
    {
        
        @auraenabled public string dayName{get;set;}
        @auraenabled public string dayId{get;set;}
        @auraenabled public list<accomodationData>Accomodation{get;set;}
        @auraenabled public list<mealData>Meal{get;set;}
        @auraenabled public list<TransportData>Transport{get;set;}
        
        @auraenabled public boolean showAccomodation {get;set;}
        @auraenabled public boolean showMeal {get;set;}
        @auraenabled public boolean showTransport {get;set;}
        
    }
    
    public class accomodationData
    {
        @auraenabled public Boolean check{get;set;}
        @auraenabled public string Name{get;set;}
        @auraenabled public List<picklistValue> Roomtype {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string Comment {get;set;}
        @auraenabled public string selectedRoomType {get;set;}
        //@auraenabled public string Price {get;set;}
    }
    
    
    public class MealData
    {
        @auraenabled public string Name{get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string Comment {get;set;}
        //@auraenabled public string Price {get;set;}
    }
    
    public class TransportData
    {
        @auraenabled public string Name {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string Comment {get;set;}
    }
    
    public class picklistValue
    {
        @auraenabled public string label {get;set;}
        @auraenabled public string value {get;set;}
    }
    public class picklistWrapper{    
        @AuraEnabled public string picklistValue {get;set;}
        @AuraEnabled public string picklistLabel {get;set;}    
    }
    
    
    @AuraEnabled        
    public static initWrapperForCancelledAndTravelledOrders fetchOLIRec(String recId){
        initWrapperForCancelledAndTravelledOrders wrapInstance = new initWrapperForCancelledAndTravelledOrders();
        
        Orders__c  td = [Select id, Status__c  from Orders__c where id =: recId];
        wrapInstance.orderMasterStatus = td.Status__c ;
        
        List<Order_Line_Items__c>  oliList = [select name,Id,Departure_Date__r.Name,Passenger_Quantity__c,HSS_Amount__c ,Total_Amount__c   from Order_Line_Items__c where Orders__c = :recId AND Status__c!='Cancelled'];
        Map<Id,Order_Line_Items__c> oliMap = new  Map<Id,Order_Line_Items__c>();
        if(oliList!=null)
        {
            for(Order_Line_Items__c oli : oliList)
            {
                oliMap.put(oli.Id,oli);
            }
        }
        if(oliMap.size()>0){
            wrapInstance.mapOfOLIAndId = oliMap;
        }else{
            wrapInstance.mapOfOLIAndId = null;
        }
        return wrapInstance;
    }
    
    @AuraEnabled
    public static oliVerificationWrap verifyThePaxInOLI(String oliId){
        system.debug('oliId '+oliId);
        oliVerificationWrap oliVerWrap = new oliVerificationWrap();
        
        Boolean toBeReturned;
        List<Passenger__c> listOfPAX = [Select id from Passenger__c where Order_Line_Items__c =: oliId];
        if(listOfPAX.size()>0){
            oliVerWrap.toBeReturned = true;
            Order_Line_Items__c oliName = [Select id,Name from Order_Line_Items__c where id =: oliId];
            oliVerWrap.oliName = oliName.Name;
        }else{
            oliVerWrap.toBeReturned = false;
            system.debug('NotMore than Size '+listOfPAX);
        }
        
        return oliVerWrap;
        
    }
    
    @AuraEnabled
    public static finalDataWrapper fetchAllTheDataForOCCreation(String recId,String orderLineItemId){
        
        system.debug('recId '+recId);
        finalDataWrapper fdw = new finalDataWrapper();
        fdw.initWrap = createCustomisationController.fetchOLIRec(recId);
        fdw.oliId = orderLineItemId;
        //    fdw.sObjName = TAD_Constants.tadOrderObjName;
        
        Customization__c exampleInstance = new Customization__c();
        
        
        String objectAPIName = 'Customization__c' ; //any object api
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        Map<String,Id> mapofCaseRecordTypeNameandId = new Map<String,Id>();
        List<picklistWrapper> picklistWrapperList1 = new List<picklistWrapper>();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            picklistWrapper customConsultantWrap = new picklistWrapper();
            customConsultantWrap.picklistValue = info.getRecordTypeId();
            customConsultantWrap.picklistLabel = info.getName();
            picklistWrapperList1.add(customConsultantWrap);
        }
        fdw.recordTypeWrapper = picklistWrapperList1;
        
        Schema.DescribeFieldResult fieldResult = Customization__c.Customization_Consultant__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        List<picklistWrapper> picklistWrapperList2 = new List<picklistWrapper>();
        for( Schema.PicklistEntry v : values) {
            picklistWrapper customConsultantWrap = new picklistWrapper();
            customConsultantWrap.picklistValue = v.getValue();
            customConsultantWrap.picklistLabel = v.getLabel();
            picklistWrapperList2.add(customConsultantWrap);
        }
        fdw.customConsultantWrapper = picklistWrapperList2;
        list<string> tripOption = new list<string>();
        Orders__c order = [Select Id, Name,Trip_Option__c from Orders__c where Id =: recId];
        fdw.tadOrderName = order.Name;
        fdw.sObjId = recId;
        tripOption.add(order.Trip_Option__c);
        system.debug('tripOption'+order.Trip_Option__c);  
        
        
        List<paxListWrapper> paxListWrap = new List<paxListWrapper>();
        List<Passenger__c> listOfPAXInOLI = [Select id,Last_Name__c,Email__c,Pax__c,Name,Order_Line_Items__c from Passenger__c where Order_Line_Items__c=:orderLineItemId];
        system.debug('listOfPAXInOLI'+listOfPAXInOLI);        
        for(Passenger__c pax : listOfPAXInOLI){
            paxListWrapper pWrap = new paxListWrapper();
            pWrap.paxName = pax.Pax__c;
            pWrap.paxFirstName = pax.Name;
            pWrap.paxLastName = pax.Last_Name__c;
            pWrap.paxId = pax.Id;
            pWrap.email =pax.Email__c;
            paxListWrap.add(pWrap);
        }
        
        fdw.passengerDataWrapper = paxListWrap;
        
        //  List<Id> listOfDeals = new List<Id>();
        Order_Line_Items__c oliData = [Select id, Name from Order_Line_Items__c where id =:orderLineItemId];
        //  listOfDeals.add(oliData.Deal__c);
        
        fdw.orderLineItemName = oliData.Name;
        
        
        system.debug('recId213---->'+oliData.Name);
        
        
        List<Itinerary__c> itiList = [Select id ,name, Day__c,(Select id, name, Supplier_Type__c ,Accommodation__c,Accommodation__r.name,Meal__c,Meal__r.name,Title__c,Comments__c,Transport__r.Name from Itinerary_Days__r) from Itinerary__c where Trip_Option__c in:tripOption Order By Day__c ASC];
        system.debug('itiList  88---->'+itiList);
        
        
        // Code to populate room type info
        Set<String> accIds = new Set<String> ();
        List<Itinerary_Booking_Supplier__c> ibsData = [Select id , Accommodation__c  from Itinerary_Booking_Supplier__c where Itinerary__r.Trip_Option__c =:tripOption AND Supplier_Type__c ='Accomodation'] ;
        for(Itinerary_Booking_Supplier__c ibs : ibsData){
            accIds.add(ibs.Accommodation__c);
        }
        system.debug('accIds229'+accIds);
        
        Map<String , List<picklistValue>> accRoomTypeMap = new Map<String , List<picklistValue>>();
        List<Accommodation__c > getAccData = [Select id , name,(Select id , name from room_type__r) from Accommodation__c where Id IN:accIds];
        for(Accommodation__c accm :getAccData){
            List<picklistValue> listRoomType = new List<picklistValue>();
            for(Room_Type__c  rm :accm.room_type__r){
                picklistValue pick = new picklistValue();
                pick.label=rm.name;
                pick.value= rm.name;
                listRoomType.add(pick);
            }
            accRoomTypeMap.put(accm.id,listRoomType);
        }
        
        // Code to populate room type info ends
        //
        List<itineraryDays> itiDays = new List<itineraryDays> ();
        
        for(Itinerary__c iti : itiList){
            itineraryDays itiInfo = new itineraryDays();
            itiInfo.dayName='Day '+iti.Day__c;
            itiInfo.dayId=iti.Id;
            
            List<accomodationData> accData = new List<accomodationData>();
            List<mealData> Mdata = new List<mealData>();
            List<TransportData> Transdata = new List<TransportData>();
            
            for(Itinerary_Booking_Supplier__c  ibs : iti.Itinerary_Days__r){
                
                // Data for accomodation starts
                if(ibs.Supplier_Type__c =='Accomodation'){
                    accomodationData acc = new accomodationData();
                    acc.Name=ibs.Accommodation__r.name;
                    acc.Comment=ibs.Comments__c;
                    acc.Roomtype=accRoomTypeMap.get(ibs.Accommodation__c);
                    acc.check=false;
                    acc.selectedRoomType='';
                    accData.add(acc);
                }
                // Data for accomodation ends
                
                // Data for meal starts
                if(ibs.Supplier_Type__c =='Meal'){
                    mealData MD = new mealData();
                    MD.Name=ibs.Meal__r.name;
                    MD.Comment=ibs.Comments__c;
                    MD.Title=ibs.Title__c;
                    MData.add(MD);
                    
                }
                // Data for meal ends
                
                // Data for transport starts
                if(ibs.Supplier_Type__c =='Transport'){
                    TransportData TData = new TransportData();
                    TData.Name=ibs.Transport__r.Name;        
                    TData.Comment=ibs.Comments__c;
                    TData.Title=ibs.Title__c;
                    Transdata.add(TData);
                    
                }
                // Data for transport ends
            }
            if(accData!=null){
                itiInfo.showAccomodation=true;
                itiInfo.Accomodation=accData;
            }
            else{
                itiInfo.showAccomodation=false;
            }
            if(Mdata!=null){
                itiInfo.showMeal=true;
                itiInfo.Meal=Mdata;
            }
            else{
                itiInfo.showMeal=false;
            }
            if(Transdata!=null){
                itiInfo.showTransport=true;
                itiInfo.Transport=Transdata;
            }
            else{
                itiInfo.showTransport=false;
                
            }
            itiDays.add(itiInfo);
        }
        
        fdw.ITR= itiDays;
        
        
        return fdw;
    }
    
    public class onSaveReturnWrapper{
        
        @AuraEnabled public Boolean toBeReturnedBoolean {get;set;}
        @AuraEnabled public string recordId {get;set;}
        
    }
    
    /*  public class itineraryBookingSupplierWrapper{
@AuraEnabled public Map<String, List<supplierTypeWrapper>> supplierTypeWrapper{get;set;}
//   @AuraEnabled public Map<String, List<accomWrapper>> accomWrapperFinal{get;set;}
//   @AuraEnabled public Map<String, List<transportWrapper>> transportWrapperFinal{get;set;}
} */
    
    public class supplierTypeWrapper{
        @AuraEnabled public string supplierName {get;set;}
        @AuraEnabled public string supplierComments {get;set;}
        @AuraEnabled public List<string> roomType {get;set;}
        @AuraEnabled public string merchantPrice {get;set;}
        @AuraEnabled public boolean check {get;set;}
    }
    
    /* public class accomWrapper{
@AuraEnabled public string accomName {get;set;}
@AuraEnabled public string accomComments {get;set;}
@AuraEnabled public List<string> roomType {get;set;}
@AuraEnabled public string merchantPrice {get;set;}
}

public class mealWrapper{
@AuraEnabled public string mealName{get;set;}
@AuraEnabled public string mealComments{get;set;}
@AuraEnabled public string merchantPrice{get;set;}
}

public class transportWrapper{
@AuraEnabled public string transportName{get;set;}
@AuraEnabled public string transportComments{get;set;}
@AuraEnabled public string merchantPrice{get;set;}
} */
    
    @AuraEnabled
    public static List<String> getTheRecordTypes(String itineraryId){
        
        List<Itinerary_Booking_Supplier__c> ibsList = [Select id, Itinerary__c, RecordTypeId, Accommodation__c, Accommodation__r.Name, Supplier_Type__c,Meal__c,Transport__c,Transport__r.Title__c,Meal__r.Name from Itinerary_Booking_Supplier__c where Itinerary__c =: itineraryId];
        
        Set<String> newSetOfSupplierType = new Set<String>();
        for(Itinerary_Booking_Supplier__c ibs : ibsList){
            newSetOfSupplierType.add(ibs.Supplier_Type__c);
        }
        List<String> listOfAvailableRecordTypes = new List<String>(newSetOfSupplierType);
        return listOfAvailableRecordTypes;
        
    }
    
    
    @AuraEnabled
    public static List<supplierTypeWrapper> getIbsDetails(String itineraryId, String customType){
        
        List<Itinerary_Booking_Supplier__c> ibsList = [Select id, Itinerary__c, RecordTypeId, Accommodation__c, Accommodation__r.Name, Supplier_Type__c,Meal__c,Transport__c,Transport__r.Title__c,Meal__r.Name from Itinerary_Booking_Supplier__c where Itinerary__c =: itineraryId and Supplier_Type__c=:customType];
        
        
        
        Set<Id> AccomIds = new Set<Id>();
        Set<Id> mealIds = new Set<Id>();
        Set<Id> transportIds = new Set<Id>();
        for(Itinerary_Booking_Supplier__c ibs : ibsList){
            if(ibs.Accommodation__c !=null && ibs.Supplier_Type__c == 'Accomodation'){
                AccomIds.add(ibs.Accommodation__c);
            }
            
            if(ibs.Meal__c  !=null && ibs.Supplier_Type__c == 'Meal'){
                mealIds.add(ibs.Meal__c);
            }
            
            if(ibs.Transport__c  !=null && ibs.Supplier_Type__c == 'Transport'){
                transportIds.add(ibs.Transport__c);
            }
        }
        
        Map<Id, List<string>> mapOfAccomWithRoomTypes = new Map<Id, List<string>>();
        if(AccomIds != null){      
            List<Room_Type__c> roomTypesList = [Select id, Name, Accommodation__c from Room_Type__c where Accommodation__c in:AccomIds];
            for(Room_Type__c rt : roomTypesList){
                if(mapOfAccomWithRoomTypes.containsKey(rt.Accommodation__c)){
                    List<String> listOfRoomTypes = mapOfAccomWithRoomTypes.get(rt.Accommodation__c);
                    listOfRoomTypes.add(rt.Name);
                    mapOfAccomWithRoomTypes.put(rt.Accommodation__c, listOfRoomTypes);
                }else{
                    List<String> newListOfRoomTypes = new List<String>();
                    newListOfRoomTypes.add(rt.Name);
                    mapOfAccomWithRoomTypes.put(rt.Accommodation__c, newListOfRoomTypes);
                }
            }
        }
        
        List<supplierTypeWrapper> finalSupplierTypeList = new List<supplierTypeWrapper>();
        for(Itinerary_Booking_Supplier__c ibs : ibsList){
            if(ibs.Supplier_Type__c == 'Accomodation'){
                supplierTypeWrapper accomWrapperInstance = new supplierTypeWrapper();
                accomWrapperInstance.supplierName = ibs.Accommodation__r.Name;
                accomWrapperInstance.supplierComments = '';
                accomWrapperInstance.roomType = mapOfAccomWithRoomTypes.get(ibs.Accommodation__c);
                accomWrapperInstance.merchantPrice = '';
                accomWrapperInstance.check = false;
                finalSupplierTypeList.add(accomWrapperInstance);
            }
            
            if(ibs.Supplier_Type__c == 'Meal'){
                supplierTypeWrapper mealWrapperInstance = new supplierTypeWrapper();
                mealWrapperInstance.supplierName = ibs.Meal__r.Name;
                mealWrapperInstance.supplierComments = '';
                mealWrapperInstance.merchantPrice = '';
                mealWrapperInstance.check = false;
                finalSupplierTypeList.add(mealWrapperInstance);
            }
            
            if(ibs.Supplier_Type__c == 'Transport'){
                supplierTypeWrapper transportWrapperInstance = new supplierTypeWrapper();
                transportWrapperInstance.supplierName = ibs.Transport__r.Title__c;
                transportWrapperInstance.supplierComments = '';
                transportWrapperInstance.merchantPrice = '';
                transportWrapperInstance.check = false;
                finalSupplierTypeList.add(transportWrapperInstance);
            }
        }  
        
        
        return finalSupplierTypeList;
        
    }
    
    @AuraEnabled
    public static onSaveReturnWrapper onSaveBtnClick(finalDataWrapper1 orderCusCreationWrapper){
        system.debug('orderCusCreationWrapper458'+orderCusCreationWrapper);
        Customization__c orderCus = new Customization__c();
        orderCus.Order_Line_Items__c = orderCusCreationWrapper.oliId;
        Itinerary__c itDay=[Select Name from Itinerary__c where Id=:orderCusCreationWrapper.itineraryDays limit 1];
        String Day=itDay.Name;
        
        system.debug('Day500'+Day);
           system.debug('customizationType'+orderCusCreationWrapper.customizationType);
        OrderCus.Passenger_Name__c=orderCusCreationWrapper.passengerDataWrapper[0].paxFirstName+' '+orderCusCreationWrapper.passengerDataWrapper[0].paxLastName;
        OrderCus.Email__c=orderCusCreationWrapper.passengerDataWrapper[0].email;
        system.debug('Email__c--'+OrderCus.Email__c);
          
        OrderCus.Number_of_Days__c=Day;
        OrderCus.Comments__c=orderCusCreationWrapper.supplierTypeWrapper[0].supplierComments;
        if(orderCusCreationWrapper.customizationType =='Accomodation'){
             OrderCus.Room_Type__c=orderCusCreationWrapper.supplierTypeWrapper[0].roomType[0]; 
        }
      
        OrderCus.Merchant_price__c=orderCusCreationWrapper.supplierTypeWrapper[0].merchantPrice;
        OrderCus.Supplier_Type__c=orderCusCreationWrapper.customizationType;
        insert orderCus;
        
        onSaveReturnWrapper abc = new onSaveReturnWrapper();
        abc.toBeReturnedBoolean = false;
        abc.recordId = orderCus.Id;
        system.debug('abc466'+abc);
        return abc;
           
    }
    
    public static void orderStatusCheck (Orders__c ord  , String customType , String recordType ,String reqDetails){
        System.debug('ord.recordType '+recordType);
        System.debug('ord.customType '+customType);
        if( ( customType == 'Upgrade Flight Class' || customType == 'Re/New Ticket Charge' || customType == 'Misc Charge' || customType == 'Upgrade Carrier' || customType == 'Customisation AE' || customType == 'Customisation SB' || customType == 'Customisation SO')  && recordType == 'Flight Customisation' && reqDetails != 'Passenger Replacement'){
            ord.Sub_Status__c = 'Flight Quote Request';
            ord.Status__c = 'Temporary Hold';
        }else if(customType == 'Ticket Changes (Corrections)'  && recordType == 'Flight Customisation'){
            ord.Sub_Status__c = 'Flight Quote Request';
            ord.Status__c = 'Temporary Hold';
        }else if(customType == 'Lounge Pass' && recordType == 'Flight Customisation' ){
            ord.Sub_Status__c = 'Initial Payment Pending';
            ord.Status__c = 'Temporary Hold';
        }else if(recordType == 'Accommodation Booking' && (customType == 'AE Accom' || customType == 'SB Accom' || customType =='Custom Accom (AE)' || customType == 'Custom Accom (SB)' || customType == 'Pre SO' || customType == 'Post SO' || customType == 'Note Only') ){
            ord.Sub_Status__c = 'Pending Customisation';
            ord.Status__c = 'Temporary Hold';
        }else if(recordType == 'Cruise Customisation' && (customType == 'Upgrade Cabin' || customType == 'Customisation' || customType == 'Ticket Changes (Corrections)' || customType == 'Re/New Ticket Charge' ||  customType == 'Misc Charge')  ){
            ord.Sub_Status__c = 'Class (Sub Option) - Cabin Upgrade';
            ord.Status__c = 'Temporary Hold';
        }else if(recordType == 'Land Customisation' &&  (customType == 'Customisation' || customType == 'Misc Charge' || customType == 'Transfer')){
            ord.Sub_Status__c = 'Pending Customisation';
            ord.Status__c = 'Temporary Hold';
        }else if(recordType == 'Stop Over Customisation' && (customType == 'Misc Charge' || customType == 'Pre SO' ||  customType == 'Post SO' )){
            ord.Sub_Status__c = 'Pending Customisation';
            ord.Status__c = 'Temporary Hold';
        }else if(recordType == 'Flight Customisation' && customType == 'Re/New Ticket Charge' && reqDetails == 'Passenger Replacement'){
            ord.Sub_Status__c = 'Replacement Passenger details pending';
            ord.Status__c = 'Temporary Hold';
        }
        System.debug('ord.ordexp_sub_status__c '+ord.Sub_Status__c);
        System.debug('ord.ordexp_master_status__c '+ord.Status__c);
        update ord ;
    }
    
    
    
    
}