public class Auswalk_tripcloneApexHandler {

    public class tripOptionData {
        @auraenabled public string tripOptionName{get;set;}
		@auraenabled public string tripTypeName{get;set;}
        @auraenabled public double tripPrice{get;set;}
        @auraenabled public date dateFrom{get;set;}
        @auraenabled public date dateTo{get;set;}
        @auraenabled public boolean showitinerary {get;set;}
        @auraenabled public List<itineraryData> Itinerary{get;set;}

    }
    
    public class cloneData{
        @auraenabled public string optionName{get;set;}
        @auraenabled public string optionType{get;set;}
        @auraenabled public string optionPrice{get;set;}
        @auraenabled public string optionNewName{get;set;}
    }
    
    public class itineraryData {
        @auraenabled public string itineraryName{get;set;}

    }
    @auraenabled
    public static List<tripOptionData> getTripOptionData(string tripId){

        system.debug('tripId >'+tripId);
     List<Trip_Option__c> tripOption = [SELECT Id,name,Trip_Type__c,Price__c,Start_Date__c,End_Date__c,(Select id,name,Day__c FROM itineraries__r) FROM Trip_Option__c WHERE trip__c=:tripId];
     system.debug('tripOption :'+tripOption);

     List<Itinerary__c> itiList = [Select id,name, Day__c,Trip_Option__r.trip__c FROM Itinerary__c where Trip_Option__r.trip__c =:tripId Order By Day__c ASC];        
        
     List<tripOptionData> triptionList = new List<tripOptionData>();

        for(Trip_Option__c option:tripOption){
            tripOptionData optionData = new tripOptionData();
			List<itineraryData> itiData = new List<itineraryData>();
            
            optionData.tripOptionName=option.Name;
            optionData.tripTypeName=option.Trip_Type__c;
            optionData.tripPrice=option.Price__c;
            optionData.dateFrom=option.Start_Date__c;
            optionData.dateTo=option.End_Date__c;
            
            if(!itiList.isEmpty()){
                for(Itinerary__c varIti:itiList){
                    itineraryData iti = new itineraryData();
            		iti.itineraryName='Day '+varIti.Day__c;
                    itiData.add(iti);
                }
            }
            if(itiData!=null){
                optionData.showitinerary=true;
                optionData.Itinerary=itiData;
            }
            triptionList.add(optionData);
        }
        //system.debug('triptionList '+triptionList);
      Return triptionList;
        
}
    //clone record
    @auraenabled
    public static void cloneTripOption(List<cloneData> cloneDataList){
        
        system.debug('insert option Line 67 '+cloneDataList);

        Map<string,string> tripOptionNameMap = new Map<string,string>();
        
        for(cloneData data:cloneDataList){
			tripOptionNameMap.put(data.optionName, data.optionNewName);
        }
        
        system.debug('tripOptionNameMap Line 75==> '+tripOptionNameMap);
        
        
        List<Trip_Option__c> tripOptionListToClone = new List<Trip_Option__c>();
        List<Itinerary__c> itiListToClone = new List<Itinerary__c>();
        
        List<Trip_Option__c> tripOptionList = [SELECT Id,Name,Trip__c,Trip_Type__c,Alternative_Start_Date__c,Comments__c,Duration__c,End_Date__c,End_Day_of_Week__c,Number_of_days__c,
                                              Price__c,Single_Occupancy_Charge__c,Start_Date__c,Start_Day_of_Week__c,Start_Location__c,Status__c,Total_Walk_Distance__c,Trip_Option_External_ID__c,
                                              Trip_Option_Highlights__c,Trip_Option_Overview__c,Walk_Grade__c FROM Trip_Option__c WHERE name IN:tripOptionNameMap.keySet()];

		system.debug('tripOptionList ==> '+tripOptionList.size());
        
        if(!tripOptionList.isEmpty()){
            for(Trip_Option__c toption : tripOptionList){
                Trip_Option__c option = toption.clone(false,true);
                option.Name=tripOptionNameMap.get(toption.Name);
                option.Trip_Option_External_ID__c='';
                tripOptionListToClone.add(option);
            }
        }
        if(!tripOptionListToClone.isEmpty()){
            insert tripOptionListToClone;
        }
        
        Map<Id,Id> tripOptionIdsMap = new Map<Id,Id>();
        
        List<Trip_Option__c> fetchTripOptionList = [SELECT Id,Name FROM Trip_Option__c WHERE name IN:tripOptionNameMap.values()]; 
        system.debug('fetchTripOptionList Line 100:'+fetchTripOptionList);
        
        
        if(!fetchTripOptionList.isEmpty()){
            
            for(Trip_Option__c newOption:fetchTripOptionList){
                
                for(Trip_Option__c Option:tripOptionList){
                    tripOptionIdsMap.put(Option.id,newOption.id);
                }
            }
        }
        if(!tripOptionIdsMap.isEmpty()){
           system.debug('tripOptionIdsMap Line 113=> '+tripOptionIdsMap);  
            list<Itinerary__c> itiList = [SELECT Id,name,Day__c,Title__c,Trip_Option__c,Walking_Info__c,Itinerary_Overview__c,Meal__c,Meal_Information__c,Meal_Requirement__c,
                                          Status__c From Itinerary__c where Trip_Option__c IN:tripOptionIdsMap.keyset() Order By Day__c ASC];
            
            for(Itinerary__c iti:itiList){ 
                Itinerary__c cloneIti = iti.clone(false,true);
                cloneIti.Trip_Option__c = tripOptionIdsMap.get(iti.Trip_Option__c);
                itiListToClone.add(cloneIti);
            }
        }
        if(!itiListToClone.isEmpty()){
            insert itiListToClone;
            system.debug('itiListToClone Line 125 '+itiListToClone);
        }
   }
}