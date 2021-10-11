public  class AttachLogisticForGuides {
    
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
    Public Class OrderWrapper{
        @auraenabled Public List<GUIDEWrapper>GUIDE{get;set;}
        @auraenabled Public List<itineraryDays>ITR{get;set;}
        @auraenabled Public List<generalLogistics>GLIBS{get;set;}
        
    }
    
    public class bookingData{
        @auraenabled public string Suppliertype{get;set;}
        @auraenabled public string Title{get;set;}
        @auraenabled public string Information{get;set;}
        @auraenabled public string roomTypeRecordId{get;set;}
        @auraenabled public string Price{get;set;}
        @auraenabled public string Day{get;set;}
        
    }
    
    public class accomodationData
    {
        @auraenabled public Boolean check{get;set;}
        @auraenabled public string Name{get;set;}
        @auraenabled public List<picklistValue> Roomtype {get;set;}
        @auraenabled public string roomsAvailable{get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public List<picklistpriceCategory> priceCategoryList {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string Comment {get;set;}
        @auraenabled public string selectedRoomType {get;set;}
        @auraenabled public string Price {get;set;}
    }
    
    
    public class MealData
    {
        @auraenabled public string Name{get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public string Comment {get;set;}
        @auraenabled public List<picklistpriceCategory> priceCategoryList {get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public string Price {get;set;}
    }
    
    public class TransportData
    {
        @auraenabled public string Name {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public string Comment {get;set;}
        @auraenabled public string Price {get;set;}
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
    
    @auraenabled(cacheable=true)
    public static OrderWrapper getItineraryData (string OrderId ){
       
        list<string> tripOption = new list<string>();
        
        tripOption.add(OrderId);
        system.debug('tripoption id---->'+tripOption);
         Set<String> tripidset = new Set<String> ();
        List<Trip_Option__c>  tripoptiondataid = [Select id,Trip__c from Trip_Option__c WHERE Id IN:tripOption];
         For(Trip_Option__c trip: tripoptiondataid) 
        {
           tripidset.add(trip.Trip__c);
        }
        system.debug('tripidset '+tripidset);
        List<Trip__c> tripList =[Select id,Name,(Select id,Name,Guide__r.Name,Guide__r.Last_Name__c from Guide_Allocation__r) from Trip__c where id In:tripidset];
        system.debug('tripList '+tripList);
        
        List<Guide_Allocation__c>  oliList=[Select id,Name,Guide__r.Id,Guide__r.Name,Guide__r.Last_Name__c from Guide_Allocation__c where Trip__c In:tripidset ]; 
        system.debug('Guide_Allocation__c 95---->'+oliList);
        List<GUIDEWrapper> Guidelist=new List<GUIDEWrapper>();
        For(Guide_Allocation__c Guide: oliList) 
        {
            GUIDEWrapper GW= new GUIDEWrapper();
            GW.RecordId=Guide.Guide__r.Id; 
            GW.firstName=Guide.Guide__r.Name;
            GW.lastName=Guide.Guide__r.Last_Name__c;
            Guidelist.add(GW);
        }
         system.debug('Guidelist---->'+Guidelist);
        
        List<Itinerary__c> itiList = [Select id ,name, Day__c,(Select id, name, Supplier_Type__c ,Accommodation__c,Accommodation__r.name,Meal__c,Meal__r.name,Title__c,Comments__c,Transport__r.Name from Itinerary_Days__r) from Itinerary__c where Trip_Option__c in:tripOption  AND Day__c!=null  Order By Day__c ASC ];
       system.debug('itiList ---->'+itiList);
        
        // Code to populate room type info
        Set<String> accIds = new Set<String> ();
        Set<String> roomIds = new Set<String> ();
        Set<String> mealIds = new Set<String> ();
        Set<String> transportIds = new Set<String> ();
         Set<String> itineraryset = new Set<String> ();
        
        //For General Logistics Itinerary
       List<Itinerary__c> itiListGeneral = [Select id ,name, Day__c from Itinerary__c where Trip_Option__c in:tripOption  AND Day__c=:null  Order By Day__c ASC ];
        system.debug('itiListGeneral  88---->'+itiListGeneral);
        for(Itinerary__c aetIti :itiListGeneral){
            itineraryset.add(aetIti.Id);
        }
        
        List<Itinerary_Booking_Supplier__c> ibsDataGeneral = [Select id ,Supplier_Type__c,Accommodation__c,Meal__c,Transport__c,General_Logistics_Name__c,General_Logistics_Price__c,General_Logistics_Type__c  from Itinerary_Booking_Supplier__c where Itinerary__r.Trip_Option__c =:tripOption AND Itinerary__c In:itineraryset] ;
        system.debug('ibsDataGeneral  99---->'+ibsDataGeneral);
        List<generalLogistics> glList=new List<generalLogistics>();
        
        for(Itinerary_Booking_Supplier__c ibs : ibsDataGeneral){
            if(ibs.General_Logistics_Type__c =='Guide' || ibs.General_Logistics_Type__c=='Both'){
            generalLogistics gl =new generalLogistics();
            gl.glogisticName=ibs.General_Logistics_Name__c;
            gl.glogisticPrice=string.valueOf(ibs.General_Logistics_Price__c);
            glList.add(gl); 
            }
           
        }
        system.debug('glList  99---->'+glList);
      
        //End data for General Logistics Itinerary
        
        
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
        
        Map<String , List<picklistValue>> accRoomTypeMap = new Map<String , List<picklistValue>>();
        List<Allocation__c > getAllocation = [Select id,name,Available_Rooms__c,room_type__c,Itinerary_Date__c from Allocation__c];
        List<Accommodation__c > getAccData = [Select id , name,(Select id, name from room_type__r where Type__c Includes(:'Single')) from Accommodation__c where Id IN:accIds];
        for(Accommodation__c accm :getAccData){
            List<picklistValue> listRoomType = new List<picklistValue>();
            for(Room_Type__c  rm :accm.room_type__r){
                picklistValue pick = new picklistValue();
                
                List<availableRoomList> availableroomList = new List<availableRoomList>();
                for(Allocation__c  all :getAllocation){
                    system.debug('Allocation__c-------->'+all.room_type__c+'room-------->'+rm.id);
                    if(rm.id ==all.room_type__c){
                        availableRoomList avllist = new availableRoomList();
                        Date abc =all.Itinerary_Date__c;
                        DateTime yourDate = abc;
                        String dateOutput = yourDate.format('dd/MM/yyyy');
                        avllist.availableRoom=all.Available_Rooms__c;
                        avllist.recordId=all.id;
                        avllist.itiDate=dateOutput;
                        availableroomList.add(avllist);
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
        // 
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
                    accomodationData acc = new accomodationData();
                    acc.Name=ibs.Accommodation__r.name;
                    acc.Comment=ibs.Comments__c;
                    acc.Roomtype=accRoomTypeMap.get(ibs.Accommodation__c);
                    acc.logisticPricing=acclogisticPricingMap.get(ibs.Accommodation__c);
                    acc.check=false;
                    acc.selectedRoomType='';
                    acc.priceCategoryList=priceCategoryList;
                    acc.Price='';
                    accData.add(acc);
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
                    MD.Price='';
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
                    TData.Price='';
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
        OW.GUIDE= Guidelist;
        OW.GLIBS= glList;
        
        return OW;  
    }
    
    
    @auraenabled
    public static void saveLogistic(List<bookingData> saveData, Id olirecordIDData,Id tripOption)
    {
        system.debug('oliData--14'+olirecordIDData);
        system.debug('Save Data list---->'+saveData);
        system.debug('Save Data list---->'+tripOption);
        List<Guide_Logistics__c> LogBooking=new list<Guide_Logistics__c>();
        List<Accommodation__c> Accid= [SELECT Id,Name from Accommodation__c  ];
        List<Transport__c> Tid= [SELECT Id,Name from Transport__c  ];
        List<Itinerary__c> ITI= [SELECT Id,Name from Itinerary__c where  Trip_Option__c =:tripOption  ];
        system.debug('Itinerary__cData Line258'+ITI);
        List<Room_Type__c> roomTypeId = [SELECT Id,Name from Room_Type__c  ];
        List<Meal__c> Mid= [SELECT Id,Name from Meal__c  ];
        list<guide__c> guideDataList = [SELECT Id,name from guide__c where Id =:olirecordIDData];
        system.debug('Guide Data '+guideDataList);
            
        
        for(bookingData BD:saveData){
            
            for(Itinerary__c itinerary:ITI){
                String dayname='';
                if(Bd.Day=='Pre-Trip'){
                    dayname =Bd.Day;
                }else{
                    List<String> strListdays = Bd.Day.split('-');
                    dayname =  strListdays[0].trim();
                }
               //  system.debug('Iti Match Line 272'+itinerary.Name+'=='+dayname);
                if(dayname == itinerary.Name){
                    Guide_Logistics__c LB= new Guide_Logistics__c();
                    LB.Itinerary__c =itinerary.Id;
                    LB.Trip_Option__c=tripOption;
                    system.debug('DayName Match'+dayname);
                     system.debug('itinerary Match'+itinerary.Id);
                    if(BD.Suppliertype=='Accomodation'){
                        string roomunique='';
                        string accmunique='';
                        if(Bd.Day=='Pre-Trip'){
                            
                        }else{
                            List<String> strList = Bd.Day.split('-');
                            String str =  strList[1].trim();
                            System.debug('str---------->'+str);
                            Date dt = Date.parse( str );
                            LB.Date__c=dt; 
                        }
                        
                        LB.Guide__c=olirecordIDData;
                        For(Integer i=0;i<Accid.size();i++){
                            if(Accid[i].Name==BD.Title ){
                                LB.Accommodation__c=Accid[i].Id;
                                 //accmunique=BD.Title;
                                  system.debug('acccc----->'+Accid[i].Name);
                                  LB.Unique_Code__c='Accomodation'+Accid[i].Name+itinerary.Name+olirecordIDData;
                                 system.debug('accccmatch----->'+'Accomodation'+Accid[i].Name+itinerary.Name+olirecordIDData);
                                if(BD.Price!=null){
                                    system.debug('BD.Price '+BD.Price);
                                    Double newValue = double.valueOf(BD.Price.trim());
                                    system.debug('Double newValue '+newValue);
                                    LB.Price__c = newValue;
                                }
                            }
                        }
                        
                        if(BD.roomTypeRecordId!=null && BD.roomTypeRecordId!=''){
                            system.debug('RBD.roomTypeRecordId: '+BD.Information);
                            system.debug('RBD.roomTypeRecordId: '+BD.roomTypeRecordId);
                            For(Integer i=0;i<roomTypeId.size();i++){
                                
                                ID newValueID = Id.valueOf(BD.roomTypeRecordId.trim());
                                //system.debug('Id.valueOf(BD.roomTypeRecordId) '+newValueID);
                                if(roomTypeId[i].Id==newValueID){
                                    system.debug('Room Type ID: '+roomTypeId[i].Id);
                                    system.debug('Id.valueOf(BD.roomTypeRecordId) '+newValueID);
                                    LB.Room_Type__c=roomTypeId[i].Id;
                                     roomunique=roomTypeId[i].Id;
                                }
                            }
                        }
                        
                        
                    } else if(BD.Suppliertype=='Transport'){
                        For(Integer i=0;i<Tid.size();i++){
                            if(Tid[i].Name==BD.Title){
                                if(Bd.Day=='Pre-Trip'){
                                    
                                }else{
                                    List<String> strList = Bd.Day.split('-');
                                    String str =  strList[1].trim();
                                    System.debug('str---------->'+str);
                                    Date dt = Date.parse( str );
                                    LB.Date__c=dt;
                                }
                                
                                LB.Guide__c=olirecordIDData;
                                LB.Transport__c=Tid[i].Id;
                                LB.Unique_Code__c=Tid[i].Name+itinerary.Name+olirecordIDData;
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
                                
                                if(Bd.Day=='Pre-Trip'){
                                    
                                }else{
                                    List<String> strList = Bd.Day.split('-');
                                    String str =  strList[1].trim();
                                    System.debug('str---------->'+str);
                                    Date dt = Date.parse( str );
                                    LB.Date__c=dt;
                                }
                                
                                LB.Guide__c=olirecordIDData;
                                LB.Meal__c=Mid[i].Id;
                                LB.Unique_Code__c='Meal'+Mid[i].Name +itinerary.Name+olirecordIDData;
                                 system.debug('acccc----->'+'Meal'+Mid[i].Name +itinerary.Name+olirecordIDData);
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
        upsert LogBooking;
    }
    
}