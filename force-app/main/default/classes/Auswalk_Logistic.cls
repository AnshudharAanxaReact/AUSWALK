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
        @auraenabled public string label {get;set;}
        @auraenabled public string value {get;set;}
    }
    
    @auraenabled
    public static list<itineraryDays> getItineraryData(String OrderId ){
        
       
        //order orderdData =[select id,Trip_Option__c from order where id=:OrderId];
       // String tripOption=orderdData.Trip_Option__c;
       String tripOption='a025D00000CGxOYQA1';
        List<Itinerary__c> itiList = [Select id ,name, Day__c,(Select id, name, Supplier_Type__c ,Accommodation__c,Accommodation__r.name,Meal__r.name,Title__c,Comments__c,Transport__r.Name from Itinerary_Days__r) from Itinerary__c where Trip_Option__c =:tripOption Order By Day__c ASC];
        
        // Code to populate room type info
        Set<String> accIds = new Set<String> ();
        List<Itinerary_Booking_Supplier__c> ibsData = [Select id , Accommodation__c  from Itinerary_Booking_Supplier__c where Itinerary__r.Trip_Option__c =:tripOption AND Supplier_Type__c ='Accomodation'] ;
        for(Itinerary_Booking_Supplier__c ibs : ibsData){
            accIds.add(ibs.Accommodation__c);
        }
        
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
        
        
        
        List<itineraryDays> itiDays = new List<itineraryDays> ();
        
        for(Itinerary__c iti : itiList){
            itineraryDays itiInfo = new itineraryDays(); 
            itiInfo.dayName='Day '+iti.Day__c;

            List<accomodationData> accData = new List<accomodationData>();
            List<mealData> mealdata = new List<mealData>();
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
                if(ibs.Supplier_Type__c =='Meal '){
                    mealData MD = new mealData();
                    MD.Name=ibs.Meal__r.name;
                    MD.Comment=ibs.Comments__c;
                    MD.Title=ibs.Title__c;
                    mealData.add(MD);
                    
                }
                // Data for meal ends
                
                // Data for transport starts
                if(ibs.Supplier_Type__c =='Transport'){
                    TransportData TrnsData = new TransportData();
                    TrnsData.Name=ibs.Transport__r.Name;
                    TrnsData.Comment=ibs.Comments__c;
                    TrnsData.Title=ibs.Title__c;
                    Transdata.add(TrnsData);
                    
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
            if(mealData!=null){
               itiInfo.showMeal=true;
               itiInfo.Meal=mealData;
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
        return itiDays;  
    }
    
}