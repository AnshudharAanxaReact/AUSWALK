public class AttachLogisticForCustomer {
    
    public class itineraryDays
    {
        
        @auraenabled public string dayName{get;set;}
        @auraenabled public boolean getGeneric {get;set;}
        @auraenabled public list<accomodationData>Accomodation{get;set;}
        @auraenabled public list<mealData>Meal{get;set;}
        @auraenabled public list<TransportData>Transport{get;set;}
        @auraenabled public list<Tour_Add_onData>TOur_Addon{get;set;}
        @auraenabled public list<GuideData>Guide{get;set;}
        @auraenabled public list<NationalParkData>NationalPark{get;set;}
        @auraenabled public list<auswalk_micscData>Aus_Misc{get;set;}
        @auraenabled public list<highseasonSurchargeData>Hsc{get;set;}
        @auraenabled public boolean showAccomodation {get;set;}
        @auraenabled public boolean showMeal {get;set;}
        @auraenabled public boolean showTransport {get;set;}
        
    } 
    Public Class OLIWrapper{
        @auraenabled public Id oliRecordId{get;set;}
        @auraenabled public string label{get;set;}
        @auraenabled public string value {get;set;}
        @auraenabled public double totalAmount{get;set;}
        @auraenabled public string passengerType{get;set;}
        @auraenabled public double passengerQuantity{get;set;}
        
    }   
    
    Public Class GUIDEWrapper{
        @auraenabled public Id RecordId{get;set;}
        @auraenabled public string firstName{get;set;}
        @auraenabled public string lastName {get;set;}
        
    }  
    Public Class generalLogistics{
        @auraenabled public Id RecordId{get;set;}
        @auraenabled public string glogisticName{get;set;}
        @auraenabled public string glogisticPrice {get;set;}
    } 
    
    Public Class orderLogistics{
        @auraenabled public Id RecordId{get;set;}
        @auraenabled public string OLName{get;set;}
        @auraenabled public string SupplierType{get;set;}
        @auraenabled public string Price {get;set;}
        @auraenabled public string Dateday {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string RoomType {get;set;}
    } 
    
    Public Class OrderWrapper{
        @auraenabled Public List<OLIWrapper>OLI{get;set;}
        @auraenabled Public List<itineraryDays>ITR{get;set;}
        @auraenabled Public List<generalLogistics>GLIBS{get;set;}
        @auraenabled Public List<orderLogistics>OLL{get;set;}
    }
    
    public class bookingData{
        @auraenabled public string Suppliertype{get;set;}
        @auraenabled public string Title{get;set;}
        @auraenabled public string Information{get;set;}
        @auraenabled public string roomTypeRecordId{get;set;}
        @auraenabled public string Price{get;set;}
        @auraenabled public string Day{get;set;}
        // @auraenabled public string availableRoom{get;set;}
        @auraenabled public string allocationId{get;set;}
        
        
    }
    
    public class accomodationData
    {
        @auraenabled public Boolean check{get;set;}
        @auraenabled public string Name{get;set;}
        @auraenabled public List<picklistValue> Roomtype {get;set;}
        @auraenabled public string roomsAvailable{get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public List<picklistpriceCategory> priceCategoryList {get;set;}
        @auraenabled public List<passengerpicklist> PassengerList {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string Comment {get;set;}
        @auraenabled public string selectedRoomType {get;set;}
        @auraenabled public string price {get;set;}
        //@auraenabled public string Price {get;set;}
    }
    
    
    public class MealData
    {
        @auraenabled public Boolean check{get;set;}
        @auraenabled public string Name{get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string Comment {get;set;}
        @auraenabled public List<picklistpriceCategory> priceCategoryList {get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public string price {get;set;}
    }
    
    public class TransportData
    {
        @auraenabled public Boolean check{get;set;}
        @auraenabled public string Name {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public string Comment {get;set;}
        @auraenabled public string price {get;set;}
    }
    public class Tour_Add_onData
    {
        
    }
    public class GuideData
    {
        
    }
    public class NationalParkData
    {
        
    }
    public class auswalk_micscData
    {
        
    }
    public class highseasonSurchargeData
    {
        
    }
    
    public class passengerpicklist
    {
        @auraenabled public Id recordId{get;set;}
        @auraenabled public string label {get;set;}
        @auraenabled public string value {get;set;}
    }
    public class picklistValue
    {
        @auraenabled public Id rtRecordId{get;set;}
        @auraenabled public string label {get;set;}
        @auraenabled public string value {get;set;}
        @auraenabled public double price {get;set;}
        @auraenabled public List<availableRoomList> availableRoomList {get;set;}
    }
    public class availableRoomList
    {
        @auraenabled public string itiDate {get;set;}
        @auraenabled public string recordId {get;set;}
        @auraenabled public double availableRoom {get;set;}
    }
    public class picklistpriceCategory
    {
        @auraenabled public string label {get;set;}
        @auraenabled public string value {get;set;}
    }
    
    public class accomodationMultiple
    {
        @auraenabled public Boolean check1 {get;set;}
        @auraenabled public string selectedrt  {get;set;}
        @auraenabled public string price {get;set;}
    }
    
    public class deleteOrderLogistics{
        @auraenabled public Id olId {get;set;}
    }    
    
    @auraenabled(cacheable=true)
    public static OrderWrapper getOLIData (string OrderId ){
        List<Order_Line_Items__c>  oliList=[Select Id,Name,Passenger_Quantity__c,Total_Amount__c,Passenger_Type__c from Order_Line_Items__c where Orders__c=:OrderId]; 
        system.debug('OLI 95---->'+oliList);
        List<OLIWrapper> OL=new List<OLIWrapper>();
        For(Order_Line_Items__c OLI: oliList) 
        {
            if(OLI.Passenger_Quantity__c>0){
                OliWrapper OLIW= new OliWrapper();
                OLIW.oliRecordId=OLI.Id; 
                OLIW.label=OLI.Name;
                OLIW.value=OLI.Name;
                OLIW.passengerType=OLI.Passenger_Type__c;
                OLIW.passengerQuantity=OLI.Passenger_Quantity__c;
                OLIW.totalAmount=OLI.Total_Amount__c;
                OL.add(OLIW);  
            }
            
        }  
        OrderWrapper OW= new OrderWrapper();
        //Ow.ITR= itiDays;
        OW.OLI= OL;
        return OW; 
    }
    
    
    @auraenabled(cacheable=true)
    public static string deleteOrderLogistics (string recordId ){
        system.debug('RecordId'+recordId);
        list<Order_logistics__c> fetchGuideAllotionToDelete = [SELECT Id FROM Order_logistics__c WHERE Id =:recordId];
        system.debug('fetchGuideAllotionToDelete'+fetchGuideAllotionToDelete);
        if(!fetchGuideAllotionToDelete.isEmpty()){
            delete fetchGuideAllotionToDelete;
            system.debug('success');
        }
        return 'Success';
    }
    
    
    @auraenabled(cacheable=true)
    public static OrderWrapper getItineraryData (string OrderId, string oliID,string oliPassType ){
        system.debug('OrderId line 143---->'+OrderId);
        system.debug('oliID line 144---->'+oliID);
        system.debug('oliPassType line 145---->'+oliPassType);
        
        system.debug('orderid--->'+OrderId);
        list<Orders__c> orderdData = [select id,Trip_Option__c from Orders__c where id=:OrderId];
        system.debug('orderdData line 79---->'+orderdData);
        list<string> tripOption = new list<string>();
        for(Orders__c q:orderdData)
        {
            tripOption.add(q.Trip_Option__c);
        }
        
        
        List<Itinerary__c> itiList = [Select id ,name, Day__c,(Select id, name, Supplier_Type__c ,Accommodation__c,Accommodation__r.name,Meal__c,Meal__r.name,Title__c,Comments__c,Transport__r.Name from Itinerary_Days__r) from Itinerary__c where Trip_Option__c in:tripOption Order By Day__c ASC];
        system.debug('itiList  88---->'+itiList);
        
        // Code to populate room type info
        Set<String> accIds = new Set<String> ();
        Set<String> mealIds = new Set<String> ();
        Set<String> transportIds = new Set<String> ();
        
        List<Itinerary_Booking_Supplier__c> ibsData = [Select id ,Supplier_Type__c,Accommodation__c,Meal__c,Transport__c  from Itinerary_Booking_Supplier__c where Itinerary__r.Trip_Option__c =:tripOption] ;
        for(Itinerary_Booking_Supplier__c ibs : ibsData){
            if(ibs.Supplier_Type__c=='Accomodation'){
                accIds.add(ibs.Accommodation__c);
            }
            if(ibs.Supplier_Type__c=='Meal'){
                mealIds.add(ibs.Meal__c);
            }
            if(ibs.Supplier_Type__c=='Transport'){
                transportIds.add(ibs.Transport__c);
            }
        }
        
        //For General Logistics Itinerary
        Set<String> itineraryset = new Set<String> ();
        List<Itinerary__c> itiListGeneral = [Select id ,name, Day__c from Itinerary__c where Trip_Option__c in:tripOption  AND Day__c=:null  Order By Day__c ASC ];
        system.debug('itiListGeneral  88---->'+itiListGeneral);
        for(Itinerary__c aetIti :itiListGeneral){
            itineraryset.add(aetIti.Id);
        }
        
        List<Itinerary_Booking_Supplier__c> ibsDataGeneral = [Select id ,Supplier_Type__c,Accommodation__c,Meal__c,Transport__c,General_Logistics_Name__c,General_Logistics_Price__c,General_Logistics_Type__c  from Itinerary_Booking_Supplier__c where Itinerary__r.Trip_Option__c =:tripOption AND Itinerary__c In:itineraryset] ;
        system.debug('ibsDataGeneral  99---->'+ibsDataGeneral);
        List<generalLogistics> glList=new List<generalLogistics>();
        
        for(Itinerary_Booking_Supplier__c ibs : ibsDataGeneral){
            if(ibs.General_Logistics_Type__c =='Customer' || ibs.General_Logistics_Type__c=='Both'){
                generalLogistics gl =new generalLogistics();
                gl.glogisticName=ibs.General_Logistics_Name__c;
                gl.glogisticPrice=string.valueOf(ibs.General_Logistics_Price__c);
                glList.add(gl); 
            }
            
        }
        system.debug('glList  99---->'+glList);
        
        //End data for General Logistics Itinerary
        
        Map<String , List<picklistValue>> accRoomTypeMap = new Map<String , List<picklistValue>>();
        List<Allocation__c > getAllocation = [Select id,name,Available_Rooms__c,room_type__c,Itinerary_Date__c from Allocation__c];
        List<Accommodation__c > getAccData = [Select id , name,(Select id, name,Type__c from room_type__r) from Accommodation__c where Id IN:accIds];
        system.debug('GetRoomtypeData'+getAccData);
        for(Accommodation__c accm :getAccData){
            List<picklistValue> listRoomType = new List<picklistValue>();
            for(Room_Type__c  rm :accm.room_type__r){
                picklistValue pick = new picklistValue();
                List<availableRoomList> availableroomList = new List<availableRoomList>();
                for(Allocation__c  all :getAllocation){
                    if(rm.id ==all.room_type__c){
                        availableRoomList avllist = new availableRoomList();
                        avllist.availableRoom=all.Available_Rooms__c;
                        system.debug('Itinerary_Date__cRoomAllocation-------->'+all.Itinerary_Date__c);
                        Date abc =all.Itinerary_Date__c;
                        DateTime yourDate = abc;
                        String dateOutput = yourDate.format('dd/MM/yyyy');
                        avllist.recordId=all.Id;
                        avllist.itiDate=dateOutput;
                        system.debug('avllist-------->'+avllist);
                        system.debug('avllist-------->'+avllist);
                        availableroomList.add(avllist);
                        system.debug('availableroomList-------->'+availableroomList);
                    }
                    
                }
                pick.rtRecordId=rm.Id;
                pick.label=rm.name;
                pick.value= rm.name;
                pick.availableRoomList= availableroomList;
                listRoomType.add(pick);
            }
            accRoomTypeMap.put(accm.id,listRoomType);
        }
        
        // Code to populate room type info ends
        
        // Code to populate Accommodation Logistics_Pricing info starts
        Map<String , List<picklistValue>> acclogisticPricingMap = new Map<String , List<picklistValue>>();
        List<Accommodation__c> getaccPricingData = [Select id,name,(Select id,name,Gross_Cost__c from Logistic_Pricings__r) from Accommodation__c where Id IN:accIds];
        
        if(!getaccPricingData.isEmpty()){
            for(Accommodation__c accm :getaccPricingData){
                List<picklistValue> listLogisticPricing = new List<picklistValue>();
                for(Logistics_Pricing__c lp :accm.Logistic_Pricings__r){
                    picklistValue LogisticPricing = new picklistValue();
                    LogisticPricing.rtRecordId=lp.Id;
                    LogisticPricing.label=lp.name;
                    LogisticPricing.value= lp.name;
                    LogisticPricing.price= lp.Gross_Cost__c;
                    listLogisticPricing.add(LogisticPricing);
                }
                acclogisticPricingMap.put(accm.id,listLogisticPricing);
            }  
        }
        // Code to populate Accommodation Logistics_Pricing info Ends
        
        // Code to populate Meal Logistics_Pricing info starts
        Map<String , List<picklistValue>> meallogisticPricingMap = new Map<String , List<picklistValue>>();
        List<Meal__c> getmealPricingData = [Select id,name,(Select id,name,Gross_Cost__c from Logistic_Pricings__r) from Meal__c WHERE Id IN:mealIds];
        
        if(!getmealPricingData.isEmpty()){
            system.debug('Meal Pricing Line 192'+getmealPricingData);
            for(Meal__c meal :getmealPricingData){
                List<picklistValue> listLogisticPricing = new List<picklistValue>();
                for(Logistics_Pricing__c lp :meal.Logistic_Pricings__r){
                    picklistValue LogisticPricing = new picklistValue();
                    LogisticPricing.rtRecordId=lp.Id;
                    LogisticPricing.label=lp.name;
                    LogisticPricing.value= lp.name;
                    LogisticPricing.price= lp.Gross_Cost__c;
                    listLogisticPricing.add(LogisticPricing);
                }
                meallogisticPricingMap.put(meal.id,listLogisticPricing);
            }
        }
        // Code to populate Accommodation Logistics_Pricing info Ends
        
        
        // Code to populate Transport Logistics_Pricing info starts
        Map<String , List<picklistValue>> transportlogisticPricingMap = new Map<String , List<picklistValue>>();
        List<Transport__c> gettransportPricingData = [Select id,name,(Select id,name,Gross_Cost__c from Logistic_Pricings__r) from Transport__c where Id IN:transportIds];
        system.Debug('gettransportPricingData Size Line 216'+gettransportPricingData.size());
        
        if(!gettransportPricingData.isEmpty()){
            for(Transport__c trans:gettransportPricingData){
                List<picklistValue> listLogisticPricing = new List<picklistValue>();
                for(Logistics_Pricing__c lp :trans.Logistic_Pricings__r){
                    picklistValue LogisticPricing = new picklistValue();
                    LogisticPricing.rtRecordId=lp.Id;
                    LogisticPricing.label=lp.name;
                    LogisticPricing.value= lp.name;
                    LogisticPricing.price= lp.Gross_Cost__c;
                    listLogisticPricing.add(LogisticPricing);
                }
                transportlogisticPricingMap.put(trans.id,listLogisticPricing);
            }
        }
        
        // Code to populate Accommodation Logistics_Pricing info Ends
        
        // Code to populate Pricing Category info starts
        List<picklistpriceCategory> priceCategoryList = new List<picklistpriceCategory>();
        picklistpriceCategory priceCategory = new picklistpriceCategory();
        priceCategory.label='Per Pax';
        priceCategory.value='Per Pax';
        priceCategoryList.add(priceCategory);
        picklistpriceCategory priceCategory1 = new picklistpriceCategory();
        priceCategory1.label='Per Qty';
        priceCategory1.value='Per Qty';
        priceCategoryList.add(priceCategory1);
        // Code to populate Pricing Category info Ends
        
        
        //   FOr Populate Selcted Order Logistics Data Start
        
        List<Logistics_Booking__c>  OLLIDT=[Select Id,Name,(Select id,Name,Room_Type__r.Name,Transport__r.Name,Accommodation__r.Name,Price__c,Meal__r.Name from Order_logistics__r ) from Logistics_Booking__c where Order_Line_Items__c=:oliID]; 
        system.debug('Logistics_Booking__c 95---->'+OLLIDT);
        List<orderLogistics> OLlist=new List<orderLogistics>();
        for(Logistics_Booking__c lb :OLLIDT){
            for(Order_logistics__c  ors :lb.Order_logistics__r){
                orderLogistics oll = new orderLogistics();
                oll.RecordId=ors.Id;
                oll.OLName=ors.name;
                if(ors.Accommodation__r.Name!= null){
                    oll.Title= ors.Accommodation__r.Name;
                    Oll.RoomType=ors.Room_Type__r.Name;
                    Oll.supplierType='Accomodation';
                }else if(ors.Transport__r.Name!= null){
                    oll.Title= ors.Transport__r.Name; 
                    Oll.supplierType='Transport';
                }else if(ors.Meal__r.Name!= null){
                    oll.Title= ors.Meal__r.Name; 
                    Oll.supplierType='Meal';
                }
                // oll.supplierType= ors.name;
                oll.Price=string.valueOf(ors.Price__c);
                oll.dateday= lb.Name;
                OLlist.add(oll);
            }
            
        }
        
        system.debug('Order Logistics--483'+OLlist);
        
        // Populate Passenger For Selected Order Line Item
        
        List<Passenger__c>  PASSLIST=[Select Id,Name from Passenger__c where Order_Line_Items__c=:oliID]; 
        system.debug('Logistics_Booking__c 95---->'+PASSLIST);
        List<passengerpicklist> passengerlist=new List<passengerpicklist>();
        for(Passenger__c PS :PASSLIST){
            
            
            passengerpicklist pass = new passengerpicklist();
            pass.recordId=PS.Id;
            pass.label= PS.Name;
            pass.value=PS.Name;
            passengerlist.add(pass);
            
            
        }
        system.debug('passengerlist 95---->'+passengerlist);        
        List<itineraryDays> itiDays = new List<itineraryDays> ();
        Trip_Option__c  tripoptiondata = [Select id,name,Start_Date__c from Trip_Option__c WHERE Id IN:tripOption];
        system.debug('tripoptiondate----'+tripoptiondata.Start_Date__c);
        Integer i=0;
        for(Itinerary__c iti : itiList){
            itineraryDays itiInfo = new itineraryDays(); 
            
            Date abc =tripoptiondata.Start_Date__c;
            Date date4= abc.addDays(i);
            DateTime yourDate = date4;
            String dateOutput = yourDate.format('dd/MM/yyyy');
            System.debug('Debug: '+iti.Itinerary_Days__r);
            System.debug('daysName: '+iti.Name);
            if(iti.Name=='Pre-Trip'){
                itiInfo.dayName='Pre-Trip';
                itiInfo.getGeneric=false;
            }else if(iti.Name=='Post-Trip'){
                itiInfo.dayName='Post-Trip';
                itiInfo.getGeneric=false;
            }else if(iti.Name=='General Logistics'){
                itiInfo.dayName='General Logistics';
                itiInfo.getGeneric=false;
            }else{
                itiInfo.getGeneric=true;
                itiInfo.dayName='Day '+iti.Day__c+' - '+dateOutput;
                i=i+1;
            }   
            
            List<accomodationData> accData = new List<accomodationData>();
            List<mealData> Mdata = new List<mealData>();
            List<TransportData> Transdata = new List<TransportData>();
            
            
            
            for(Itinerary_Booking_Supplier__c  ibs : iti.Itinerary_Days__r){
                
                // Data for accomodation starts
                if(ibs.Supplier_Type__c =='Accomodation'){
                    
                    List<accomodationMultiple> dataList = new List<accomodationMultiple>();
                    //Boolean check1 =false;
                    //string selectedrt='';
                    //string price='';
                    for(Integer l=0;l<OLlist.size();l++){
                        if(OLlist[l].supplierType=='Accomodation'){
                            
                            if(OLlist[l].Title ==ibs.Accommodation__r.name && OLlist[l].dateday =='Day '+iti.Day__c+' - '+dateOutput){
                                accomodationMultiple data = new accomodationMultiple ();
                                data.check1=true;
                                data.selectedrt=OLlist[l].RoomType;
                                data.price=OLlist[l].Price;
                                dataList.add(data);
                            }
                            
                        }
                    }
                    
                    
                    if(dataList.size()!=0){
                        for(accomodationMultiple  dataValue: dataList){
                            
                            accomodationData acc = new accomodationData();
                            acc.Name=ibs.Accommodation__r.name;
                            acc.Comment=ibs.Comments__c;
                            acc.Roomtype=accRoomTypeMap.get(ibs.Accommodation__c);
                            acc.logisticPricing=acclogisticPricingMap.get(ibs.Accommodation__c);
                            acc.priceCategoryList=priceCategoryList;
                            acc.PassengerList=passengerlist;
                            acc.selectedRoomType=dataValue.selectedrt;
                            acc.price=dataValue.price;
                            acc.check=dataValue.check1;
                            acc.roomsAvailable='';  
                            accData.add(acc); 
                        }   
                    }else{
                        accomodationData acc = new accomodationData();
                        acc.Name=ibs.Accommodation__r.name;
                        acc.Comment=ibs.Comments__c;
                        acc.Roomtype=accRoomTypeMap.get(ibs.Accommodation__c);
                        acc.logisticPricing=acclogisticPricingMap.get(ibs.Accommodation__c);
                        acc.priceCategoryList=priceCategoryList;
                        acc.PassengerList=passengerlist;
                        acc.selectedRoomType='';
                        acc.price='';
                        acc.check=false;
                        acc.roomsAvailable='';  
                        accData.add(acc);
                    }                    
                }
                // Data for accomodation ends
                
                // Data for meal starts
                if(ibs.Supplier_Type__c =='Meal'){
                    mealData MD = new mealData();
                    MD.Name=ibs.Meal__r.name;
                    MD.Comment=ibs.Comments__c;
                    MD.Title=ibs.Title__c;
                    MD.logisticPricing=meallogisticPricingMap.get(ibs.Meal__c);
                    MD.priceCategoryList=priceCategoryList;
                    
                    Boolean check1 =false;
                    string price='';
                    for(Integer l=0;l<OLlist.size();l++){
                        if(OLlist[l].supplierType=='Meal'){
                            if(OLlist[l].Title ==ibs.Meal__r.name && OLlist[l].dateday =='Day '+iti.Day__c+' - '+dateOutput){
                                check1=true;
                                price=OLlist[l].Price;
                            }
                        }
                    }
                    system.debug('heckAccTru----'+check1);
                    
                    MD.price=price;
                    MD.check=check1;
                    MData.add(MD);
                    
                }
                // Data for meal ends
                
                // Data for transport starts
                if(ibs.Supplier_Type__c =='Transport'){
                    TransportData TData = new TransportData();
                    TData.Name=ibs.Transport__r.Name;        
                    TData.Comment=ibs.Comments__c;
                    TData.Title=ibs.Title__c;
                    TData.logisticPricing=transportlogisticPricingMap.get(ibs.Transport__c);
                    Boolean check1 =false;
                    string price='';
                    for(Integer l=0;l<OLlist.size();l++){
                        if(OLlist[l].supplierType=='Transport'){
                            if(OLlist[l].Title ==ibs.Transport__r.name && OLlist[l].dateday =='Day '+iti.Day__c+' - '+dateOutput){
                                check1=true;
                                price=OLlist[l].Price;
                            }
                        }
                    }
                    system.debug('heckAccTru----'+check1);
                    
                    TData.price=price;
                    TData.check=check1;
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
        System.debug('itiDays'+itiDays);
        
        
        
        
        OrderWrapper OW= new OrderWrapper();
        Ow.ITR= itiDays;
        OW.OLL= OLlist;
        OW.GLIBS= glList;
        return OW;  
    }
    
    
    @auraenabled
    public static void saveLogistic(List<bookingData> saveData, Id olirecordIDData,string passtype,Id orderid,List<deleteOrderLogistics> deleteorderLogistics)
    {
        system.debug('oliData--14'+olirecordIDData);
        system.debug('orderid--478'+orderid);
        system.debug('Save Data list---->'+saveData);
        system.debug('deleteorderLogistics Data list---->'+deleteorderLogistics);
        List<Logistics_Booking__c> LogBooking1=new list<Logistics_Booking__c>();
        List<Order_Allocation__c> OrderAllocationList=new list<Order_Allocation__c>();
        List<Order_logistics__c> LogBooking=new list<Order_logistics__c>();
        List<Accommodation__c> Accid= [SELECT Id,Name from Accommodation__c  ];
        List<Transport__c> Tid= [SELECT Id,Name from Transport__c  ];
        // List<Allocation__c> allocationList= [Select id,name,Available_Rooms__c,room_type__c,Itinerary_Date__c from Allocation__c  ];
        List<Room_Type__c> roomTypeId = [SELECT Id,Name from Room_Type__c  ];
        
        Set<String> daysname =new Set<String>();
        
        
        //delete deleteorder Logistics Data
        if(!deleteorderLogistics.isEmpty()){
            system.debug('deleteOrderLogistics line 153 '+deleteorderLogistics.Size());
            set<Id> ordelogisticsIdsSet = New set<Id>();
            for(deleteOrderLogistics dlids:deleteorderLogistics){
                ordelogisticsIdsSet.add(dlids.olId);
            }
            system.debug('ordelogisticsIdsSet line 153 '+ordelogisticsIdsSet);
            if(!ordelogisticsIdsSet.isEmpty()){
                list<Order_logistics__c> fetchGuideAllotionToDelete = [SELECT Id FROM Order_logistics__c WHERE Id IN:ordelogisticsIdsSet];
                system.debug('fetchOrdelogisticsToDeleteLength '+fetchGuideAllotionToDelete.Size());
                system.debug('fetchOrdelogisticsToDelete '+fetchGuideAllotionToDelete);
                
                if(!fetchGuideAllotionToDelete.isEmpty()){
                    delete fetchGuideAllotionToDelete;
                    system.debug('Successfull delete ');
                }
            }
        }
        ////delete deleteorderLogistics Data
        
        
        
        
        Orders__c orderdata =[Select id,Total_Amount_Outstanding__c,Status__c from Orders__c where id =:orderid];
        system.debug('OrserStatus'+orderdata.Status__c);
        system.debug('OrserStatus'+orderdata.Total_Amount_Outstanding__c);
        List<Meal__c> Mid= [SELECT Id,Name from Meal__c  ];
        for(bookingData BD:saveData){
            daysname.add(Bd.Day);
            system.debug('Bd.Day'+Bd.Day);
        }
        
        system.debug('daysname'+daysname);
        
        //  Create Order Allocation for the Customer
        for(bookingData BD:saveData){
            if(BD.Suppliertype=='Accomodation'){
                Order_Allocation__c OA= new Order_Allocation__c();
                if(BD.allocationId!=null && BD.allocationId!=''){
                    List<String> strList = Bd.Day.split('-');
                    String str =  strList[1].trim();
                    System.debug('str---------->'+str);
                    Date dt = Date.parse( str );
                    ID aId = Id.valueOf(BD.allocationId.trim());
                    OA.Allocation__c=aId;
                    OA.Order_Line_Item__c=olirecordIDData;
                    OA.Order_Status__c=orderdata.Status__c;
                    OA.Outstanding_Amount__c=orderdata.Total_Amount_Outstanding__c;
                    OA.Itinerary_Date__c=dt;
                    OA.Passenger_Type__c=passtype;
                    OA.Room_Sold__c=1;
                    ID rId = Id.valueOf(BD.roomTypeRecordId.trim());
                    OA.Room_Type__c=rId;
                    OrderAllocationList.add(OA);  
                    system.debug('OrderAllocationListIIDD=====>>'+BD.allocationId);
                }
            }
            
        }
        
        if(!OrderAllocationList.isEmpty()){
            insert OrderAllocationList;
            system.debug('OrderAllocationList>>> '+OrderAllocationList);
            system.debug('Insert Successfull');
        }
        
        // Upsert Logistics Booking
        List<String> daysnamelist =new List<String>(daysname);
        for(Integer i=0;i<daysnamelist.size();i++){
            Logistics_Booking__c log_Booking = new Logistics_Booking__c ();
            log_Booking.Name = daysnamelist[i];
            log_Booking.Order_Line_Items__c=olirecordIDData;
            log_Booking.Unique_Code__c=olirecordIDData+daysnamelist[i];
            LogBooking1.add(log_Booking);
            
        }
        
        if(!LogBooking1.isEmpty()){
            upsert LogBooking1 Unique_Code__c;
            system.debug('daysnamelist'+daysnamelist);
            system.debug('LogBooking1'+LogBooking1);
        }
        
        List<Logistics_Booking__c> LogisticBookingF =[Select Id,Name from Logistics_Booking__c where Name IN:daysname AND Order_Line_Items__c =:olirecordIDData  ];
        system.debug('LogisticBookingF Line 272'+LogisticBookingF);
        
        
        for(bookingData BD:saveData){
            system.debug('SaveData Line 272'+BD);
            for(Logistics_Booking__c flb:LogisticBookingF){
                Order_logistics__c LB= new Order_logistics__c();
                if(BD.Day == flb.Name){
                    system.debug('Order_logistics__cmatch----- order Logistic match>'+BD.Day+ '------'+flb.Name);
                    LB.Logistics_Booking__c=flb.Id;
                    if(BD.Suppliertype=='Accomodation'){ 
                        For(Integer i=0;i<Accid.size();i++){
                            if(Accid[i].Name==BD.Title ){
                                LB.Accommodation__c=Accid[i].Id;
                                system.debug('acccc----->'+Accid[i].Name);
                                LB.Unique_Code__c='Accomodation'+BD.Title+BD.roomTypeRecordId+flb.Name+olirecordIDData;
                                system.debug('Meal----->'+'Accomodation'+BD.Title+BD.roomTypeRecordId+flb.Name);
                                if(BD.Price!=null){
                                    system.debug('BD.Price '+BD.Price);
                                    Double newValue = double.valueOf(BD.Price.trim());
                                    system.debug('Double newValue '+newValue);
                                    LB.Price__c = newValue;
                                }
                            }
                        }
                        
                        if(BD.roomTypeRecordId!=null){
                            system.debug('RBD.roomTypeRecordId: '+BD.Information);
                            system.debug('RBD.roomTypeRecordId: '+BD.roomTypeRecordId);
                            For(Integer i=0;i<roomTypeId.size();i++){
                                //system.debug('Room Type ID: '+roomTypeId[i].name);
                                //system.debug('RBD.roomTypeRecordId: '+roomTypeId[i].Id);
                                ID newValueID = Id.valueOf(BD.roomTypeRecordId.trim());
                                //system.debug('Id.valueOf(BD.roomTypeRecordId) '+newValueID);
                                if(roomTypeId[i].Id==newValueID){
                                    system.debug('Room Type ID: '+roomTypeId[i].Id);
                                    system.debug('Id.valueOf(BD.roomTypeRecordId) '+newValueID);
                                    LB.Room_Type__c=roomTypeId[i].Id;
                                }
                            }
                        }
                        
                        
                        
                    } else if(BD.Suppliertype=='Transport'){
                        For(Integer i=0;i<Tid.size();i++){
                            if(Tid[i].Name==BD.Title){
                                LB.Transport__c=Tid[i].Id;
                                LB.Unique_Code__c='Transport'+Tid[i].Name+flb.Name+olirecordIDData;
                                system.debug('Meal----->'+'Transport'+Tid[i].Name+flb.Name);
                                if(BD.Price!=null){
                                    system.debug('BD.Price '+BD.Price);
                                    Double newValue = double.valueOf(BD.Price.trim());
                                    system.debug('Double newValue '+newValue);
                                    LB.Price__c = newValue;
                                }
                            }
                        }
                    }else if(BD.Suppliertype=='Meal'){
                        For(Integer i=0;i<Mid.size();i++)
                        {
                            if(Mid[i].Name==BD.Title){
                                LB.Meal__c=Mid[i].Id;
                                LB.Unique_Code__c='Meal'+Mid[i].Name+flb.Name+olirecordIDData;
                                system.debug('Meal----->'+'Meal'+Mid[i].Name+flb.Name);
                                if(BD.Price!=Null){
                                    system.debug('BD.Price '+BD.Price);
                                    Double newValue = double.valueOf(BD.Price.trim());
                                    system.debug('Double newValue '+newValue);
                                    LB.Price__c = newValue;
                                }
                            }
                        }
                    }
                    LogBooking.add(LB);
                }
                
                
            }
        }
        
        system.debug('LogBooking Line258'+LogBooking); 
        insert LogBooking ;  
    }
    
}