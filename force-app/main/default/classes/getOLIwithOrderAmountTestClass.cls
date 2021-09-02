@isTest
public class getOLIwithOrderAmountTestClass {

    @isTest
    public static void tesMethod1Insert(){
        
       //list<RecordType> RCTOrder = AuswalkUtilsApexClass.getRecordType('Self Guided');
        //system.debug('RCTOrder: '+RCTOrder);
        
        //create trip 
        Trip__c trip = TestDataFactoryApexClass.createTrip('Self_Guided');
        insert trip;
        system.debug('trip: '+trip.id);
        
        //create trip option
        Trip_Option__c tripOption = TestDataFactoryApexClass.createTripOption(trip.Id, 'Self Guided');
        insert tripOption;
        system.debug('tripOption: '+tripOption.id);
        
        //create departure date
        Departure_Date__c DepartureDate = TestDataFactoryApexClass.createDepartureDate(tripOption.id);
        insert DepartureDate;
        system.debug('DepartureDate: '+DepartureDate.id);
        
        Orders__c order = TestDataFactoryApexClass.createOrder('Self Guided', trip.id, tripOption.id, DepartureDate.id);
        insert order;
        system.debug('order: '+order.id);
        
        //create Order_Line_Items__c
        Order_Line_Items__c orderLineItems = TestDataFactoryApexClass.createorderLineItems(order.id,DepartureDate.Id);
        insert orderLineItems;
        system.debug('orderLineItems: '+orderLineItems.id);
        
        
        //create Passenger
        Passenger__c Passenger = TestDataFactoryApexClass.createPassenger(orderLineItems.id, order.id);
        insert Passenger;
		system.debug('orderLineItems: '+orderLineItems.id);
        
        
        
    }
}