@RestResource(urlMapping='/getPrice')
global with sharing class aus_GetPriceApi {
  global class mainWrapper{
       	global String price{get;set;}
      global String singleoccupancyPrice{get;set;}
      
    }
    global class mainWrapperReturn{
    	 global String tripOption{get;set;}
         global String trip{get;set;}
        global String departureDate{get;set;}
    }
       
    @HttpPost
    global static mainWrapper orderSearch(){
        
        RestRequest req = RestContext.request;
        String requestBodyString = req.requestBody.tostring();        
        mainWrapperReturn mainWrap = (mainWrapperReturn)JSON.deserialize(requestBodyString, mainWrapperReturn.class);
        Trip_Option__c result =  [Select Id, Name,Price__c from Trip_Option__c where Name =: mainWrap.tripOption And  Trip__r.Name=: mainWrap.trip ];
        Departure_Date__c depDate =  [Select Id, Name,Price__c,Single_Occupancy__c from Departure_Date__c where Name =: mainWrap.departureDate And  Trip_Option__c=: result.Id ];
        mainWrapper mainwrap1 =new mainWrapper();
        mainwrap1.price=string.valueOf(depDate.Price__c);
          mainwrap1.singleoccupancyPrice=string.valueOf(depDate.Single_Occupancy__c);

        system.debug('result'+depDate.Price__c);
        return mainwrap1;
    } 

}