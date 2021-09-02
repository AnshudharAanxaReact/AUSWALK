@RestResource(urlMapping='/leadFromBookNowForm')
global with sharing class aus_LeadResourceWebservice {
    
    global class mainWrapper{
        
       // global String leadEmail {get;set;}
        global String primaryContactPhone  {get;set;}
        
        global String typeOfWalkingHoliday {get;set;}
        global String tripOptionExternalId {get;set;}
        global String departureDate {get;set;}  // Date format should be dd/mm/yyyy Eg - '22/11/2022' || Not available for Private Tours || This would only be necessary in case of Group Guided
        
        global String preferredStartDate {get;set;} //Only available in case of Self Guided and Private Tours -> Date Format = dd/mm/yyyy Eg - '22/11/2022'
        global String alternateStartDate {get;set;} //Only available in case of Self Guided and Private Tours -> Date Format = dd/mm/yyyy Eg - '22/11/2022'
        global String status {get;set;}
        global String noOfPax {get;set;}
        global String primaryContactLastName {get;set;}
        global String primaryContactFirstName {get;set;}
        global String primaryContactEmail {get;set;}
        global String primaryContactRoomType {get;set;}
        global String companyName {get;set;}
        global paxInfo paxInfo {get;set;}
        
    }
    
    global class paxInfo{
        
        global String contactEachUserSeparately {get;set;} //Picklist field with 3 values - Yes, No, Varies by User
        global List<passengerInformation> passengerInformation {get;set;}
        
    }
    
    global class passengerInformation{
        
        global String firstName {get;set;}
        global String lastName {get;set;}
        global String passengerEmail {get;set;}
        global String roomType {get;set;}
        global Boolean contactPassengerSeparately {get;set;}
        
    }
    
    @HttpPost
    global static String leadIdExpose(){
        
        String stringToBeReturned;
        String leadExternalId; 
        RestRequest req = RestContext.request;
        String requestBodyString = req.requestBody.tostring();        
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(requestBodyString, mainWrapper.class);
        system.debug('mainWrap'+mainWrap);
        
        leadExternalId = mainWrap.primaryContactEmail + '#' + mainWrap.primaryContactPhone ;
         system.debug('leadExternalId'+leadExternalId);
        // Created an External Id Field on the Trip Options and will query using that from the database. This needs to come in from the website.This would be the Salesforce Record ID for the Trip Option
        system.debug('mainWrap'+mainWrap.tripOptionExternalId);
        Trip_Option__c ausTripOption= new Trip_Option__c();
        ausTripOption = [Select Id, Name, Trip_Option_External_ID__c,Trip__c from Trip_Option__c where Trip_Option_External_ID__c =: mainWrap.tripOptionExternalId];  
       
        system.debug('ausTripOption'+ausTripOption);
        // system.debug('Name'+Name);
        Lead ld = new Lead();
        ld.External_ID__c = mainWrap.primaryContactEmail + '#' + mainWrap.primaryContactPhone;
        ld.Type_Of_Walking_Holidays__c = mainWrap.typeOfWalkingHoliday;
        ld.Trip_Option__c = ausTripOption.Id;
        ld.Trip__c=ausTripOption.Trip__c;
        system.debug('ausTripOption'+ausTripOption.Id);
        
        if(mainWrap.typeOfWalkingHoliday == 'Self Guided' || mainWrap.typeOfWalkingHoliday == 'Private Tour'){
            
            List<String> preferredStartDateBreakup = mainWrap.preferredStartDate.split('/');
            ld.Preferred_Start_date__c = date.newInstance(integer.valueOf(preferredStartDateBreakup[2]), integer.valueOf(preferredStartDateBreakup[1]), integer.valueOf(preferredStartDateBreakup[0]));
            
            List<String> alternateStartDateBreakup = mainWrap.alternateStartDate.split('/');
            ld.Alternate_Start_Date__c  = date.newInstance(integer.valueOf(alternateStartDateBreakup[2]), integer.valueOf(alternateStartDateBreakup[1]), integer.valueOf(alternateStartDateBreakup[0]));
            
            ld.Departure_Date__c = mainWrap.departureDate;
        }
        
        if(mainWrap.typeOfWalkingHoliday == 'Group Guided'){
            ld.Departure_Date__c = mainWrap.departureDate;
        }
        ld.Company = 'Auswalk';
        ld.LastName = mainWrap.primaryContactLastName;
        ld.FirstName = mainWrap.primaryContactFirstName;
        ld.Email = mainWrap.primaryContactEmail;
        ld.No_Of_PAX__c = integer.valueOf(mainWrap.noOfPax);
        upsert ld External_ID__c;
        
        stringToBeReturned = ld.External_ID__c;
        
        if(mainWrap.status == 'Qualified'){
            system.debug('ld'+ld.Id);
            ld.Status = 'Converted';
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(ld.Id);
            lc.setDoNotCreateOpportunity(True);

            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            system.debug('IsConverted'+ld.IsConverted);
          
            Id personAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_Account').getRecordTypeId();
        	Account account = new Account();
        	account.RecordTypeId = personAccountRecordTypeId;
       	    account.Name = mainWrap.primaryContactFirstName +' '+mainWrap.primaryContactLastName;
        	
        	account.ParentId = account.Id;
        	insert account;
            system.debug('Insert Account'+account.Id);
            system.debug('Create Order');
            
            Id orderRecordTypeId =  Schema.SObjectType.Orders__c.getRecordTypeInfosByName().get(mainWrap.typeOfWalkingHoliday).getRecordTypeId();
            system.debug('orderRecordTypeId'+orderRecordTypeId);
            Orders__c  newOrder = new Orders__c ();
            system.debug('Create Trip_Option__c'+ausTripOption.Id);
            system.debug('Create Trip__c'+ausTripOption.Trip__c);
            newOrder.Account__c =account.Id;
            newOrder.Trip_Option__c = ausTripOption.Id;
            newOrder.Trip__c = ausTripOption.Trip__c;
            newOrder.RecordTypeId = orderRecordTypeId;
           
            List<Departure_Date__c> depDateList = [Select id, From_Date__c, To_Date__c, Trip_Option__c from Departure_Date__c where Trip_Option__c =: ausTripOption.Id];
            system.debug('depDateList'+depDateList);
            for(Departure_Date__c depDate: depDateList){
                if(mainWrap.typeOfWalkingHoliday == 'Self Guided' || mainWrap.typeOfWalkingHoliday == 'Private Tour'){
           // List<String> preferredStartDateBreakup = mainWrap.preferredStartDate.split('/');
                   // newOrder.EffectiveDate=date.newInstance(integer.valueOf(preferredStartDateBreakup[2]), integer.valueOf(preferredStartDateBreakup[1]), integer.valueOf(preferredStartDateBreakup[0]));
                    if(ld.Preferred_Start_date__c >= depDate.From_Date__c && ld.Preferred_Start_date__c <= depDate.To_Date__c){
                        newOrder.Departure_Date__c = depDate.Id;
                        break;
                    }
                }
                if(mainwrap.typeOfWalkingHoliday == 'Group Guided'){
                    List<String> departureDateBreakup = mainWrap.departureDate.split('/');
                    Date orderDepDateToBeSet = date.newInstance(integer.valueOf(departureDateBreakup[2]), integer.valueOf(departureDateBreakup[1]), integer.valueOf(departureDateBreakup[0]));
   		           // newOrder.EffectiveDate=orderDepDateToBeSet;
                                if(orderDepDateToBeSet >= depDate.From_Date__c && orderDepDateToBeSet <= depDate.To_Date__c){
                        newOrder.Departure_Date__c = depDate.Id;
                        break;
                    }
                }
            }
            newOrder.Status__c  = 'Hold';
            newOrder.Sub_Status__c = 'Initial Deposit Pending';
            insert newOrder;
            
            if(mainWrap.paxInfo.passengerInformation != null){
                Order_Line_Items__c newOrderLineItem = new Order_Line_Items__c();
                newOrderLineItem.Orders__c = newOrder.Id;
                newOrderLineItem.Status__c = 'On Hold';
                newOrderLineItem.Departure_Date__c = newOrder.Departure_Date__c;
                insert newOrderLineItem;
                
                Passenger__c primaryPax = new Passenger__c();
                primaryPax.Name = mainWrap.primaryContactFirstName;
                primaryPax.Last_Name__c = mainWrap.primaryContactLastName;
                primaryPax.Email__c = mainWrap.primaryContactEmail;
                primaryPax.Order_Line_Items__c = newOrderLineItem.Id;
                primaryPax.Orders__c = newOrder.Id;
                primaryPax.Passenger_Type__c = mainWrap.primaryContactRoomType;
                insert primaryPax;
                
                List<Passenger__c> listOfPaxToBeInserted = new List<Passenger__c>(); 
                for(passengerInformation paxInfo : mainWrap.paxInfo.passengerInformation){
                    Passenger__c pax = new Passenger__c();
                    pax.Order_Line_Items__c = newOrderLineItem.Id;   
                    pax.Name = paxInfo.firstName;
                    pax.Last_Name__c = paxInfo.lastName;
                    pax.Passenger_Type__c = paxInfo.roomType;
                    pax.Orders__c = newOrder.Id;
                    if(mainWrap.paxInfo.contactEachUserSeparately == 'Yes' || mainWrap.paxInfo.contactEachUserSeparately == 'Varies By User'){
                        if(paxInfo.contactPassengerSeparately == true){
                            pax.Email__c = paxInfo.passengerEmail;
                            pax.Contact_PAX_separately__c = true;
                        }else{
                            pax.Contact_PAX_separately__c = false;
                        }
                    }       
                    listOfPaxToBeInserted.add(pax);    
                } 
                if(!listOfPaxToBeInserted.isEmpty() && listOfPaxToBeInserted != null){
                    insert listOfPaxToBeInserted;
                    //Returning the Order Id if the Order along with OLIs are created....
                    Orders__c result =  [SELECT Id,Name  FROM Orders__c WHERE Id = :newOrder.Id];
                    stringToBeReturned = newOrder.Id+';'+result.Name;
                }
            }
        }
        return stringToBeReturned;
    } 
}