public  class Auswalk_Logistic {
    
    public class itineraryDays
    {
        
        @auraenabled public string dayName{get;set;}
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
      Public Class OrderWrapper{
        @auraenabled Public List<OLIWrapper>OLI{get;set;}
        @auraenabled Public List<itineraryDays>ITR{get;set;}
        
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
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public List<picklistpriceCategory> priceCategoryList {get;set;}
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
        @auraenabled public List<picklistpriceCategory> priceCategoryList {get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
    }
    
    public class TransportData
    {
        @auraenabled public string Name {get;set;}
        @auraenabled public string Title {get;set;}
        @auraenabled public List<picklistValue> logisticPricing {get;set;}
        @auraenabled public string Comment {get;set;}
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
    }
    
    public class picklistpriceCategory
    {
        @auraenabled public string label {get;set;}
        @auraenabled public string value {get;set;}
    }
    
    @auraenabled(cacheable=true)
    public static OrderWrapper getItineraryData (string OrderId ){
    List<Order_Line_Items__c>  oliList=[Select Id,Name,Passenger_Quantity__c,Total_Amount__c from Order_Line_Items__c where Orders__c=:OrderId]; 
        system.debug('OLI 95---->'+oliList);
    List<OLIWrapper> OL=new List<OLIWrapper>();
      For(Order_Line_Items__c OLI: oliList) 
        {
        OliWrapper OLIW= new OliWrapper();
        OLIW.oliRecordId=OLI.Id; 
        OLIW.label=OLI.Name;
        OLIW.value=OLI.Name;
        OLIW.passengerQuantity=OLI.Passenger_Quantity__c;
        OLIW.totalAmount=OLI.Total_Amount__c;
        OL.add(OLIW);
         }
        
       system.debug('orderid--->'+OrderId);
       list<Orders__c> orderdData = [select id,Trip_Option__c from Orders__c where id=:OrderId];
        system.debug('orderdData line 79---->'+orderdData);
        list<string> tripOption = new list<string>();
        for(Orders__c q:orderdData)
        {
            tripOption.add(q.Trip_Option__c);
        }
         system.debug('tripoption id---->'+tripOption);
       
        
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
        
        Map<String , List<picklistValue>> accRoomTypeMap = new Map<String , List<picklistValue>>();
        List<Accommodation__c > getAccData = [Select id , name,(Select id, name from room_type__r) from Accommodation__c where Id IN:accIds];
        for(Accommodation__c accm :getAccData){
            List<picklistValue> listRoomType = new List<picklistValue>();
            for(Room_Type__c  rm :accm.room_type__r){
                picklistValue pick = new picklistValue();
                pick.rtRecordId=rm.Id;
                pick.label=rm.name;
                pick.value= rm.name;
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
        
        for(Itinerary__c iti : itiList){
            itineraryDays itiInfo = new itineraryDays(); 
            itiInfo.dayName='Day '+iti.Day__c;

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
        OW.OLI= OL;
        
        return OW;  
    }
    
   
    @auraenabled
    public static void saveLogistic(List<bookingData> saveData, Id olirecordIDData)
           {
         system.debug('oliData--14'+olirecordIDData);
         system.debug('Save Data list---->'+saveData);
         List<Logistics_Booking__c> LogBooking1=new list<Logistics_Booking__c>();
         List<Order_logistics__c> LogBooking=new list<Order_logistics__c>();
         List<Accommodation__c> Accid= [SELECT Id,Name from Accommodation__c  ];
         List<Transport__c> Tid= [SELECT Id,Name from Transport__c  ];
         List<Room_Type__c> roomTypeId = [SELECT Id,Name from Room_Type__c  ];
               
         Set<String> daysname =new Set<String>();
               
                
         List<Meal__c> Mid= [SELECT Id,Name from Meal__c  ];
               for(bookingData BD:saveData){
                
                           daysname.add(Bd.Day);
                   		   
                           system.debug('Bd.Day'+Bd.Day);
                    
               }
               List<String> daysnamelist =new List<String>(daysname);
                for(Integer i=0;i<daysnamelist.size();i++){
                       Logistics_Booking__c  log_Booking =new Logistics_Booking__c ();
                       log_Booking.Name=daysnamelist[i];
                       log_Booking.Order_Line_Items__c=olirecordIDData;
                       LogBooking1.add(log_Booking);
                       
                   }
               
               if(!LogBooking1.isEmpty()){
                   insert LogBooking1;
                   system.debug('daysnamelist'+daysnamelist);
                   system.debug('LogBooking1'+LogBooking1);
               }
               
               List<Logistics_Booking__c> LogisticBookingF =[Select Id,Name from Logistics_Booking__c where Name in:daysname ];
               
        for(bookingData BD:saveData){
            system.debug('SaveData Line 272'+BD);
            for(Logistics_Booking__c flb:LogisticBookingF){
         	Order_logistics__c LB= new Order_logistics__c();
            if(BD.Day == flb.Name){
            LB.Logistics_Booking__c=flb.Id;
         		if(BD.Suppliertype=='Accomodation'){
         		For(Integer i=0;i<Accid.size();i++){
         		if(Accid[i].Name==BD.Title ){
         		LB.Accommodation__c=Accid[i].Id;
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
             if(BD.Price!=Null){
             system.debug('BD.Price '+BD.Price);
         	 Double newValue = double.valueOf(BD.Price.trim());
             system.debug('Double newValue '+newValue);
             LB.Price__c = newValue;
             }
            }
            }
            }
            }
         LogBooking.add(LB);
            }
            }
                system.debug('LogBooking Line258'+LogBooking);
                insert LogBooking;
            }
    
}