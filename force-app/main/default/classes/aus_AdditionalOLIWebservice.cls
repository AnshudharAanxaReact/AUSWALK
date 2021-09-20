@RestResource(urlMapping='/additionalOLI')
global with sharing class aus_AdditionalOLIWebservice {
    
    global class mainWrapper{
        global String orderName {get;set;}
        global String firstName {get;set;}
        global String lastName {get;set;}
        global String passengerEmail {get;set;}
        global String roomType {get;set;}
        
    }
    
    @HttpPost
    global static String additionalOLI(){
        
        String stringToBeReturned;
        RestRequest req = RestContext.request;
        String requestBodyString = req.requestBody.tostring();        
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(requestBodyString, mainWrapper.class);
         system.debug('mainWrap20' +mainWrap);
        
        Orders__c order= new Orders__c();
        order = [Select Id,Name, Departure_Date__c  from Orders__c where Name =: mainWrap.orderName ];
        system.debug('order22' +order);
        Order_Line_Items__c newOrderLineItem = new Order_Line_Items__c();
        newOrderLineItem.Orders__c = order.Id;
        newOrderLineItem.Status__c = 'On Hold';
        newOrderLineItem.Departure_Date__c = order.Departure_Date__c;
        insert newOrderLineItem;
        
        Passenger__c primaryPax = new Passenger__c();
        primaryPax.Name = mainWrap.firstName;
        primaryPax.Last_Name__c = mainWrap.lastName;
        primaryPax.Email__c = mainWrap.passengerEmail;
        primaryPax.Order_Line_Items__c = newOrderLineItem.Id;
        primaryPax.Orders__c = order.Id;
        primaryPax.Passenger_Type__c = mainWrap.roomType;
        insert primaryPax;
        stringToBeReturned = order.Id+';'+order.Name;
        
        return stringToBeReturned;
    } 
    
    
}