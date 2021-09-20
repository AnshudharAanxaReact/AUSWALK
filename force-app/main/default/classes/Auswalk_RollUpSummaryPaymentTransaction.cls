public with sharing class Auswalk_RollUpSummaryPaymentTransaction {
    
    public static void rollUpPaymentSummaryInsert(List<Payment_Transaction__c> PaymentTransactionRecordsList) {

       Set<Id> ordersIdSet = new Set<Id>();
       Set<Id> passengersIdSet = new Set<Id>();
       
       //list of parent object records to update
       List<Orders__c> ordersToUpdate = new List<Orders__c>();
       List<Passenger__c> passengersToUpdate = new List<Passenger__c>();

       for(Payment_Transaction__c payment:PaymentTransactionRecordsList){

            if(payment.Orders__c!=Null || payment.Passenger__c!=Null){
                ordersIdSet.add(payment.Orders__c);
                passengersIdSet.add(payment.Passenger__c);
            }

       }

       if(!ordersIdSet.isEmpty() || !passengersIdSet.isEmpty()){
        //get the orders record with payment where we need to update
        List<Orders__c> fetchOrdersWithPaymentToUpdate = [SELECT Id,Total_Payment_Received__c FROM Orders__c WHERE Id IN:ordersIdSet];
        List<Passenger__c> fetchPassengerWithPaymentToUpdate = [SELECT Id,Total_Payment_Received__c FROM Passenger__c WHERE Id IN:passengersIdSet];

        //update orders record
        if(!fetchOrdersWithPaymentToUpdate.isEmpty()){
            //System.debug('Update Order Line 28 '+fetchOrdersWithPaymentToUpdate);
            //retrieve aggregate result for child to update parent records
            list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Orders__c IN:ordersIdSet];

            for(Orders__c order:fetchOrdersWithPaymentToUpdate){
                    order.Total_Payment_Received__c = integer.valueof(sumOfAmountCharger[0].get('expr0'));
                    ordersToUpdate.add(order);
            }
        }
        else if(fetchOrdersWithPaymentToUpdate.isEmpty()){
            
            for(Orders__c order:fetchOrdersWithPaymentToUpdate){
                order.Total_Payment_Received__c = 0;
                ordersToUpdate.add(order);
            }
        }

        if(!ordersToUpdate.isEmpty()){
            update ordersToUpdate;
            //System.debug('ordersToUpdate --Line 46 '+ordersToUpdate);
        }

        //update passenger record
        if(!fetchPassengerWithPaymentToUpdate.isEmpty()){
            //System.debug('Update Passenger Line 52 '+fetchPassengerWithPaymentToUpdate);
            //retrieve aggregate result for child to update parent records
            list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Passenger__c IN:passengersIdSet];

            for(Passenger__c passenger:fetchPassengerWithPaymentToUpdate){
                passenger.Total_Payment_Received__c=integer.valueof(sumOfAmountCharger[0].get('expr0'));
                passengersToUpdate.add(passenger);
            }
            //System.debug('passengersToUpdate to aggregate result --Line 60'+passengersToUpdate);
        }
        else if(fetchPassengerWithPaymentToUpdate.isEmpty()){
            for(Passenger__c passenger:fetchPassengerWithPaymentToUpdate){
                passenger.Total_Payment_Received__c=0;
                passengersToUpdate.add(passenger);
            }
            //System.debug('passengersToUpdate to 0 --Line 66'+passengersToUpdate);
        }

        if(!passengersToUpdate.isEmpty()){
            update passengersToUpdate;
            System.debug('passengersToUpdate Record: Line 72 '+passengersToUpdate);
        }
       }
    }

    public static void rollUpPaymentSummaryUpdate(List<Payment_Transaction__c> PaymentTransactionRecordsList, Map<Id,Payment_Transaction__c> OldptMap) {

        Set<Id> ordersIdSet = new Set<Id>();
        Set<Id> passengersIdSet = new Set<Id>();
        Set<Id> ordersOldIdSet = new Set<Id>();
        Set<Id> passengersOldIdSet = new Set<Id>();

        for(Payment_Transaction__c payment:PaymentTransactionRecordsList){

            if(payment.Orders__c!=null || payment.Passenger__c!=null){
					ordersIdSet.add(payment.Orders__c);
                    passengersIdSet.add(payment.Passenger__c);
                
                //get old record of Payment_Transaction
                Payment_Transaction__c paymentOld = OldptMap.get(payment.Id);
                if(payment.Orders__c!=paymentOld.Orders__c || payment.Amount_Charged__c!=paymentOld.Amount_Charged__c){
                    ordersOldIdSet.add(paymentOld.Orders__c);
                }
                if(payment.Passenger__c!=paymentOld.Passenger__c || payment.Amount_Charged__c!=paymentOld.Amount_Charged__c){
                    passengersOldIdSet.add(paymentOld.Passenger__c);
                }
            }
        }

        //make changes in old parent records
        if(!ordersOldIdSet.isEmpty() || !passengersOldIdSet.isEmpty()){
            //get the old orders records where we need to make changes
            List<Orders__c> fetchOldOrdersWithPayment = [SELECT Id,Total_Payment_Received__c FROM Orders__c WHERE Id IN:ordersOldIdSet];
            List<Passenger__c> fetchOldPassengersWithPayment = [SELECT Id,Total_Payment_Received__c FROM Passenger__c WHERE Id IN:passengersOldIdSet];

            if(!fetchOldOrdersWithPayment.isEmpty()){
                System.debug('fetchOldOrdersWithPayment Line 110 '+fetchOldOrdersWithPayment);
                List<Orders__c> parentOrdersToUpdate = new List<Orders__c>();
                //retrieve aggregate result for child to update parent records
                list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Id IN:OldptMap.keySet()];

                for(Orders__c order:fetchOldOrdersWithPayment){
                    if(order.Total_Payment_Received__c!=Null){
                        order.Total_Payment_Received__c=order.Total_Payment_Received__c-(integer.valueof(sumOfAmountCharger[0].get('expr0')));
                    }
                    parentOrdersToUpdate.add(order);
                }

                if(!parentOrdersToUpdate.isEmpty()){
                    update parentOrdersToUpdate;
                    System.debug('parentOrdersToUpdate Line 121 '+parentOrdersToUpdate);
                }
            }
            
            else if(!fetchOldPassengersWithPayment.isEmpty()){
                //System.debug('fetchOldPassengersWithPayment Line 127 '+fetchOldPassengersWithPayment);
                List<Passenger__c> parentPassengerToUpdate = new List<Passenger__c>();

                //retrieve aggregate result for child to update parent records
                list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Id IN:OldptMap.keySet()];
				//system.Debug('sumOfAmountCharger '+sumOfAmountCharger);
                for(Passenger__c passenger:fetchOldPassengersWithPayment){
                    if(passenger.Total_Payment_Received__c!=null){
                    passenger.Total_Payment_Received__c=passenger.Total_Payment_Received__c-(integer.valueof(sumOfAmountCharger[0].get('expr0')));
                    }
                    parentPassengerToUpdate.add(passenger);
                }
            
            if(!parentPassengerToUpdate.isEmpty()){
                update parentPassengerToUpdate;
                System.debug('parentPassengerToUpdate Line 144 '+parentPassengerToUpdate);
                }
            }
        }
        if(!ordersIdSet.isEmpty() || !passengersIdSet.isEmpty()){
            //get the New orders records where we need to make changes
            List<Orders__c> fetchOrdersWithPayment = [SELECT Id,Total_Payment_Received__c FROM Orders__c WHERE Id IN:ordersIdSet];
            List<Passenger__c> fetchPassengersWithPayment = [SELECT Id,Total_Payment_Received__c FROM Passenger__c WHERE Id IN:passengersIdSet];

            if(!fetchOrdersWithPayment.isEmpty()){
                //System.debug('fetchOrdersWithPayment Line 148 '+fetchOrdersWithPayment);
                List<Orders__c> parentOrdersToUpdate = new List<Orders__c>();
                //retrieve aggregate result for child to update parent records
                list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Orders__c IN:ordersIdSet];

                for(Orders__c order:fetchOrdersWithPayment){
                    order.Total_Payment_Received__c=integer.valueof(sumOfAmountCharger[0].get('expr0'));
                    parentOrdersToUpdate.add(order);
                }

                if(!parentOrdersToUpdate.isEmpty()){
                    update parentOrdersToUpdate;
                    System.debug('parentOrdersToUpdate Line 159 '+parentOrdersToUpdate);
                }
            }
            if(!fetchPassengersWithPayment.isEmpty()){
                //System.debug('fetchPassengersWithPayment Line 166 '+fetchPassengersWithPayment);
                List<Passenger__c> parentPassengerToUpdate = new List<Passenger__c>();
                    
                //retrieve aggregate result for child to update parent records
                list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Passenger__c IN:passengersIdSet];

                for(Passenger__c passenger:fetchPassengersWithPayment){
                    passenger.Total_Payment_Received__c = integer.valueof(sumOfAmountCharger[0].get('expr0'));
                    parentPassengerToUpdate.add(passenger);
                }
                if(!parentPassengerToUpdate.isEmpty()){
                    update parentPassengerToUpdate;
                    System.debug('parentPassengerToUpdate Line 178'+parentPassengerToUpdate);
                }
            }
        }
    }
}