@RestResource(urlMapping='/getTripPrice')
    global with sharing class aus_getAllPrice {
      global class mainWrapper{
          global String trip{get;set;}
          global List<tripOption>tripOption{get;set;}
          
        }
    
        global class tripOption {
             global String tripOptionName{get;set;}
             global String uniqueCode{get;set;}
              global List<departureDate>departureDate{get;set;}
    }
         global class departureDate {
              global String departureDateName{get;set;}
              global String price{get;set;}
              global String singleOccupancyPricw{get;set;}
              global String hssAmount{get;set;}
              global String fromDate{get;set;}
              global String toDate{get;set;}
    
            
    }
     
        @HttpGet
       global static mainWrapper orderSearch(){
            
            RestRequest req = RestContext.request;
            String tripUniqueIdentifier = req.params.get('tripUniqueIdentifier');
            String requestBodyString = req.requestBody.tostring();        
            List<Trip_Option__c> result =  [Select Id, Name,Price__c,Trip_Option_External_ID__c from Trip_Option__c where Trip__r.Unique_Code__c =: tripUniqueIdentifier ];
            
            
         
            List<Departure_Date__c> depList = [Select Id, Name,Price__c,Single_Occupancy__c,Trip_Option__c,From_Date__c,To_Date__c,HSS_Price__c from Departure_Date__c where Trip_Option__c In: result];
            
       /*     Map<Id, List<Departure_Date__c>> mapOfTripOptionWithDepDate = new Map<Id, List<Departure_Date__c>>();
            
            for(Departure_Date__c dep : depList){
                if(mapOfTripOptionWithDepDate.containsKey(dep.Trip_Option__c)){
                    List<Departure_Date__c> listOfDepDates = mapOfTripOptionWithDepDate.get(dep.Trip_Option__c);
                    listOfDepDates.add(dep);
                }else{
                    List<Departure_Date__c> newListOfDepDates = new List<Departure_Date__c>();
                    newListOfDepDates.add(dep);
                    mapOfTripOptionWithDepDate.put(dep.Trip_Option__c, newListOfDepDates);
                }
            }
            
             system.debug('mapOfTripOptionWithDepDate --->'+mapOfTripOptionWithDepDate);  */
            
           List<tripOption> tripOptionlist = new List<tripOption>();
              List<tripOption> tripOption = new List<tripOption>();
            
        /*    for(Trip_Option__c tripOption : result){
                tripOption tripOptionInstance = new tripOption();
                tripOptionInstance.tripOptionName = tripOption.Name;
                List<departureDate> departureDateList = new List<departureDate>();
               system.debug('mapOfTripOptionWithDepDateget --->'+mapOfTripOptionWithDepDate.contains(tripOption.Id));
                for(Departure_Date__c depDateInstance : mapOfTripOptionWithDepDate.get(tripOption.Id)){
                      departureDate depdate =new departureDate();
                      depdate.departureDateName=depDateInstance.Name;
                      depdate.singleOccupancyPricw=string.valueOf(depDateInstance.Single_Occupancy__c) ;
                      depdate.price=string.valueOf(depDateInstance.Price__c);
                      departureDateList.add(depdate); 
                }
                tripOptionInstance.departureDate=departureDateList;
                tripOptionlist.add(tripOptionInstance);
            }
              system.debug('tripOption --->'+tripOptionlist);
           system.debug('mapOfTripOptionWithDepDate --->'+mapOfTripOptionWithDepDate);  */
            
            
            for(Trip_Option__c tripop : result){
                tripOption option =new tripOption();
                option.tripOptionName=tripop.Name;
                option.uniqueCode=tripop.Trip_Option_External_ID__c;
               List<departureDate> departureDate = new List<departureDate>();
                for(Departure_Date__c dep : depList){
                    if(tripop.id ==dep.Trip_Option__c){
                      departureDate depdate =new departureDate();
                      depdate.departureDateName=dep.Name;
                      depdate.singleOccupancyPricw=string.valueOf(dep.Single_Occupancy__c) ;
                      depdate.price=string.valueOf(dep.Price__c);
                      depdate.hssAmount=string.valueOf(dep.HSS_Price__c);
                      depdate.toDate=string.valueOf(dep.To_Date__c);
                      depdate.fromDate=string.valueOf(dep.From_Date__c);
                      departureDate.add(depdate);
     
                    }
                                }
                option.departureDate=departureDate;
                tripOption.add(option);
                     
                }
    
            mainWrapper mainwrap1 =new mainWrapper();
            mainwrap1.trip=tripUniqueIdentifier;
            mainwrap1.tripOption=tripOption;
    
            return mainwrap1;
        } 
    
    }

///services/apexrest/getTripPrice?tripUniqueIdentifier=GOWS