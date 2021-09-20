@isTest
public class aus_LeadResourceWebserviceTest {

  @isTest
    static void testHttpPutError() {
        
      Trip__c trip = TestDataFactoryApexClass.createTrip('Self Guided');
      insert trip;
      system.debug('trip: '+trip.Id);
      
      //create trip option
      Trip_Option__c tripOption = TestDataFactoryApexClass.createTripOption(trip.Id, 'Self Guided');
      tripOption.Trip_Option_External_ID__c = 'QWERTY';
      insert tripOption;
      system.debug('tripOption: '+tripOption.Id);
      
      //create Lead 
      Lead  Lead  = TestDataFactoryApexClass.createLead(trip.Id,tripOption.Id,'Self Guided');
      insert Lead;
      system.debug('DepartureDate: '+Lead.Id);
      
      Departure_Date__c  DepartureDate  = TestDataFactoryApexClass.createDepartureDate(tripOption.Id);
      insert DepartureDate;
      system.debug('DepartureDate: '+DepartureDate.Id);   
        // prepare test-data
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/leadFromBookNowForm'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{"primaryContactEmail":"muneshsinghTest@psagtechnologies.com","primaryContactPhone":"872645698773","typeOfWalkingHoliday":"Self Guided","status":"Qualified","tripOptionExternalId":"QWERTY","departureDate":"1/2/2021","preferredStartDate":"1/2/2021","alternateStartDate":"1/2/2021","noOfPax":"2","primaryContactLastName":"Singh","primaryContactFirstName":"MuneshTest","primaryContactRoomType":"Double","paxInfo":{"contactEachUserSeparately":"Yes","passengerInformation":[{"firstName":"sam","lastName":"Kumar","passengerEmail":"sam.kumar@psagtechnologeies.com","roomType":"Single","contactPassengerSeparately":true},{"firstName" : "Sumit","lastName" : "panchal","passengerEmail":"sumit.panchal@psagtechnologies.com","roomType":"Double","contactPassengerSeparately":false}]}}';
       	req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        aus_LeadResourceWebservice.leadIdExpose();
        Test.stopTest();
        
    }
    
     @isTest
    static void testHttpPutLeadResourceWebservice() {
       //create trip 
       Trip__c trip = TestDataFactoryApexClass.createTrip('Self Guided');
       insert trip;
       system.debug('trip: '+trip.Id);
       
       //create trip option
       Trip_Option__c tripOption = TestDataFactoryApexClass.createTripOption(trip.Id, 'Self Guided');
       tripOption.Trip_Option_External_ID__c = 'QWERTY';
       insert tripOption;
       system.debug('tripOption: '+tripOption.Id);
       
       //create Lead 
       Lead  Lead  = TestDataFactoryApexClass.createLead(trip.Id,tripOption.Id,'Self Guided');
       insert Lead;
       system.debug('DepartureDate: '+Lead.Id);
       
       Departure_Date__c  DepartureDate  = TestDataFactoryApexClass.createDepartureDate(tripOption.Id);
       insert DepartureDate;
       system.debug('DepartureDate: '+DepartureDate.Id);
         
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/leadFromBookNowForm'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{"primaryContactEmail":"muneshsinghTest@psagtechnologies.com","primaryContactPhone":"872645698773","typeOfWalkingHoliday":"Self Guided","status":"Qualified","tripOptionExternalId":"QWERTY","departureDate":"1/2/2021","preferredStartDate":"1/2/2021","alternateStartDate":"1/2/2021","noOfPax":"2","primaryContactLastName":"Singh","primaryContactFirstName":"MuneshTest","primaryContactRoomType":"Double","paxInfo":{"contactEachUserSeparately":"Yes","passengerInformation":[{"firstName":"sam","lastName":"Kumar","passengerEmail":"sam.kumar@psagtechnologeies.com","roomType":"Single","contactPassengerSeparately":true},{"firstName" : "Sumit","lastName" : "panchal","passengerEmail":"sumit.panchal@psagtechnologies.com","roomType":"Double","contactPassengerSeparately":false}]}}';
       	req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
        RestContext.response= res;
     
        
        Test.startTest();
        aus_LeadResourceWebservice.leadIdExpose();
        Test.stopTest();
        
    }
    
   
    
}