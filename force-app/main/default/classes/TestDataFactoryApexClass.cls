public class TestDataFactoryApexClass {

    //create trip
    public static Trip__c createTrip(string recordType){
        Id devRecordTypeId = Schema.SObjectType.Trip__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        Trip__c trip = new Trip__c();
        trip.RecordTypeId=devRecordTypeId;
        trip.Name = 'Trip 1';
        trip.Country__c = 'Australia';
        trip.Destination__c='TestDestination';
        trip.IsDomestic__c=true;
        trip.State__c='Victoria';
        return trip;
        
    }
    
    //create trip option
    public static Trip_Option__c createTripOption(Id tripId, string recordType){
        Id devRecordTypeId = Schema.SObjectType.Trip_Option__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();

        Trip_Option__c TripOption = new Trip_Option__c();
        TripOption.RecordTypeId = devRecordTypeId;
        TripOption.Trip__c = tripId;
        TripOption.Trip_Type__c = 'Self-Guided';
        TripOption.Walk_Grade__c='Moderate';
        TripOption.Number_of_days__c = 8;
        TripOption.Single_Occupancy_Charge__c=915;
        TripOption.Price__c=2995;
        
        
		return TripOption;        
    }
      //create Lead
      public static Lead createLead(Id tripId,Id tripoptionId, string recordType){
        
        Lead lead =new Lead();
        lead.External_ID__c ='xyz@psagtechnologies.com#3434343434';
        lead.Trip__c =tripId;
        lead.Trip_Option__c =tripoptionId;
        lead.Type_Of_Walking_Holidays__c =recordType;
        lead.LastName='singh';
        lead.FirstName='munesh';
        lead.Company='Auswalk';
        lead.No_Of_PAX__c=2;
        return Lead;        
    }
    //create departure date record
    public static Departure_Date__c createDepartureDate(ID TripOptionId){
        
        Departure_Date__c DepartureDate = new Departure_Date__c();
        DepartureDate.name='1/2/2021 - 15/12/2021';
        DepartureDate.Price__c=2895;
        DepartureDate.Single_Occupancy__c=915;
        DepartureDate.Trip_Option__c=TripOptionId;
        DepartureDate.Type__c='Normal';
        
        return DepartureDate;
    }
    
    //create person account
    public static Account createPersonAccount(string recordType){
        
        Account personAccount = new Account();
        personAccount.name='Test Person Account';
        personAccount.RecordTypeId=recordType;
        
        return personAccount;
        
    }
    
    //create order
    public static Orders__c createOrder(string recordType, Id tripId,Id TripOptionId,Id DepartureDateId){
        Id devRecordTypeId = Schema.SObjectType.Orders__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();

        Orders__c order = new Orders__c();
        order.Trip__c = tripId;
        Order.RecordTypeId=devRecordTypeId;
        order.Trip_Option__c=TripOptionId;
        order.Departure_Date__c=DepartureDateId;

        return order;
    }
    
    public static Order_Line_Items__c createorderLineItems(Id OrderId,Id DepartureDateId){
        Order_Line_Items__c OLI = new Order_Line_Items__c();
        OLI.Orders__c=OrderId;
        OLI.Departure_Date__c=DepartureDateId;

        return OLI;
    }
    
    public static Passenger__c createPassenger(Id OLIId,Id OrderId){
        Passenger__c passenger = new Passenger__c();
        passenger.name='Test First Name';
        passenger.Orders__c=OrderId;
        passenger.Order_Line_Items__c=OLIId;
        passenger.Passenger_Type__c='Double';
        
        return Passenger;
    }
}