@RestResource(urlMapping='/Order/*')
global with sharing class aus_OrderSearchWebservice {
       
    global class mainWrapper{
        
       	 global String OrderName{get;set;}
    	 global String noOfPax{get;set;}
         global String type{get;set;}
         global String departureDate{get;set;}
    	 global String status{get;set;}
    	 global String subStatus{get;set;}
    	 global String grossAmount{get;set;}
 	     global String totalAmountOutstanding{get;set;}
    	 global String trip{get;set;}
         global String tripOption{get;set;}
         global String HSSAmount {get;set;}
         global String NettAmount{get;set;}
         global String TotalPaymentReceived {get;set;}
         global List<passengerInformation> passengerInformation {get;set;}
         global List<orderLineItemformation> orderLineItemformation {get;set;}
    }
    global class orderLineItemformation{
        global String oliName {get;set;}
        global String status {get;set;}
        global String totalAmount {get;set;}
        global String optionSurcharge {get;set;}
        global String noOfPasseneger {get;set;}
    }
    
    global class passengerInformation{
        global String firstName {get;set;}
        global String lastName {get;set;}
        global String passengerEmail {get;set;}
        global String roomType {get;set;}
        global String orderLineItemName {get;set;}
    }
       
    @HttpGet
    global static mainWrapper orderSearch(){
        
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String OrderId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);
        Orders__c result =  [SELECT Id,Departure_Date__r.Name,Name,RecordTypeId,Status__c,Sub_Status__c , Gross_Amount__c ,Total_Amount_Outstanding__c,Nett_Amount__c ,HSS_Amount__c ,Total_Payment_Received__c , Trip__r.Name,Trip_Option__r.Name  FROM Orders__c WHERE Name = :OrderId Or Unique_Identifier_Code__c  = :OrderId];
        
        //For Order Line Item
        List<Order_Line_Items__c > OLIlist = [select Name,Passenger_Quantity__c,Status__c,Total_Amount__c,Option_Surchange__c,HSS_Amount__c, Solo_Surcharge__c from Order_Line_Items__c  where Orders__c = :result.Id];
        List<orderLineItemformation> OliInfoList = new List<orderLineItemformation>();
	   
        for(Order_Line_Items__c oliItem : OLIlist){
 			orderLineItemformation oliInfo =new orderLineItemformation();
            oliInfo.oliName=oliItem.Name;
            oliInfo.status=oliItem.Status__c;
            oliInfo.totalAmount=string.valueOf(oliItem.Total_Amount__c);
            oliInfo.optionSurcharge=string.valueOf(oliItem.Option_Surchange__c);
            oliInfo.noOfPasseneger=string.valueOf(oliItem.Passenger_Quantity__c);
            OliInfoList.add(oliInfo);
		    }

        
        //For Passenger Information        
        List<Passenger__c> passList = [select Id, Name ,Last_Name__c ,Email__c ,Passenger_Type__c, Order_Line_Items__r.Name  from Passenger__c where Orders__c = :result.Id];
   		List<passengerInformation> passengerList = new List<passengerInformation>();
        
	    for(Passenger__c passenger : passList){
 			passengerInformation passInfo =new passengerInformation();
            passInfo.firstName=passenger.Name;
            passInfo.lastName=passenger.Last_Name__c;
            passInfo.passengerEmail=passenger.Email__c;
            passInfo.roomType=passenger.Passenger_Type__c;
            passInfo.orderLineItemName=passenger.Order_Line_Items__r.Name;
            passengerList.add(passInfo);
      		     
		    }
        
        // For Getting the RecordType Name
          RecordType type = [Select Id, Name from RecordType where Id =:result.RecordTypeId];  
          system.debug('type'+type.Name);        
        //For Order Information With Passenger and Order Line Item
         	mainWrapper mainwrap =new mainWrapper();
            mainwrap.OrderName = result.Name;
       		mainwrap.noOfPax = string.valueOf(passList.size());
            mainwrap.type = type.Name;
            mainwrap.status = result.Status__c;
            mainwrap.departureDate = result.Departure_Date__r.Name;
            mainwrap.subStatus = result.Sub_Status__c;
            mainwrap.grossAmount = string.valueOf(result.Gross_Amount__c);
            mainwrap.totalAmountOutstanding = string.valueOf(result.Total_Amount_Outstanding__c);
            mainwrap.trip = result.Trip__r.Name;
            mainwrap.tripOption = result.Trip_Option__r.Name;
            mainwrap.HSSAmount = string.valueOf(result.HSS_Amount__c);
            mainwrap.NettAmount = string.valueOf(result.Nett_Amount__c);
            mainwrap.TotalPaymentReceived = string.valueOf(result.Total_Payment_Received__c);
            mainwrap.passengerInformation =passengerList;
        	mainwrap.orderLineItemformation =OliInfoList;
        system.debug('ReturnString'+mainwrap);
        return mainwrap;
    } 

}