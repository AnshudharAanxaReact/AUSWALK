public class paymentTransactionsApexClass {

    
    public static void NewPaymentTransactionCreation(list<Payment_Transaction__c> ListofPaymentTransactions){
        system.debug('In NewPaymentTransaction');
        set<Id> ordersIdSet = new set<Id>();
        list<Orders__c> ListOfOrderToUpdate = new list<Orders__c>();
        
        for(Payment_Transaction__c pt:ListofPaymentTransactions){
            if(pt.Orders__c!=null){
                ordersIdSet.add(pt.Orders__c);
            }
        }
        
        if(ordersIdSet.size()>0){
            system.debug('ordersIdSet: '+ordersIdSet);
            
            list<Payment_Transaction__c> fetchPaymentTransactionwithOrder = [SELECT Orders__c FROM Payment_Transaction__c WHERE Orders__c IN:ordersIdSet];
            
            if(!fetchPaymentTransactionwithOrder.isEmpty()){
                //get the sum of amount of all Payment_Transaction__c 
                list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Orders__c IN:ordersIdSet];
                
                //fetch orders list to update amount
                list<Orders__c> fetchListOfOrderToUpdate = [SELECT Id, Total_Payment_Received__c FROM Orders__c WHERE Id IN:ordersIdSet];
                
                system.debug('fetchListOfOrderToUpdate: '+fetchListOfOrderToUpdate);
                
                for(Orders__c order:fetchListOfOrderToUpdate){
                    order.Total_Payment_Received__c = integer.valueof(sumOfAmountCharger[0].get('expr0'));
                    ListOfOrderToUpdate.add(order);
                }
            }
            if(fetchPaymentTransactionwithOrder.isEmpty()){
            //get the orders list to update amount
           list<Orders__c> fetchListOfOrderToUpdate = [SELECT Id, Total_Payment_Received__c FROM Orders__c WHERE Id IN:ordersIdSet];
            
            for(Orders__c order:fetchListOfOrderToUpdate){
                order.Total_Payment_Received__c=0;
                ListOfOrderToUpdate.add(order);
            } 
        }
        }
        if(!ListOfOrderToUpdate.isEmpty()){
            update ListOfOrderToUpdate;
            system.debug('update ListOfOrderToUpdate: '+ListOfOrderToUpdate);
        }
    }
    public static void UpdatePaymentTransaction(list<Payment_Transaction__c> ListofPaymentTransactions,Map<Id,Payment_Transaction__c> MapOfPaymentTransactions){
        system.debug('in Update Payment Transaction');
        set<Id> oldOrdersIdsSet = new set<Id>();
        set<Id> newOrdersIdsSet = new set<Id>();
        set<Id> oldPTIdsSet = new set<Id>();
		
        list<Orders__c> ListOfOrderToUpdate = new list<Orders__c>();
        
		
        for(Payment_Transaction__c newPT:ListofPaymentTransactions){
            
            //get the old values of Payment_Transaction__c
            
            if(newPT.Orders__c!=null){
                newOrdersIdsSet.add(newPT.Orders__c);
                
				//get the immediate Prvious Values of Payment Transaction record
				Payment_Transaction__c oldPT = MapOfPaymentTransactions.get(newPT.Id);
                //compare if any changes in Payment Transaction record
                if(newPT.Orders__c!=oldPT.Orders__c || newPT.Amount_Charged__c!=oldPT.Amount_Charged__c){
                    oldOrdersIdsSet.add(oldPT.Orders__c);
					oldPTIdsSet.add(oldPT.Id);
                }
            }
        }
        
        if(oldOrdersIdsSet.size()>0){
			system.debug('In Old Order update');
			
			if(oldPTIdsSet.size()>0){
				list<Orders__c> fetchOrderToRemove = new list<Orders__c>();
			system.debug('oldOrdersIdsSet: '+oldOrdersIdsSet);
            list<Payment_Transaction__c> fetchPaymentTransactionwithOldOrders = [SELECT Orders__c FROM Payment_Transaction__c WHERE Orders__c IN:MapOfPaymentTransactions.keySet()];
            
            
            if(!fetchPaymentTransactionwithOldOrders.isEmpty()){
                system.debug('fetchPaymentTransactionwithOldOrders: '+fetchPaymentTransactionwithOldOrders);
				
                //get the total sum of all Payment_Transaction connect with order
                list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Orders__c IN:MapOfPaymentTransactions.keySet()];
                
				system.debug('sumOfAmountCharger: '+sumOfAmountCharger);
                //get the order where we need to make changes
                list<Orders__c> fetchOldOrderToUpdate = [SELECT Id, Total_Payment_Received__c FROM Orders__c WHERE Id IN:oldOrdersIdsSet];
                
                
                for(Orders__c order:fetchOldOrderToUpdate){
                    
                    if(order.Total_Payment_Received__c!=null){
                        order.Total_Payment_Received__c=order.Total_Payment_Received__c-(integer.valueof(sumOfAmountCharger[0].get('expr0')));
                        fetchOrderToRemove.add(order);
                    }
                }
            }
            if(!fetchOrderToRemove.isEmpty()){
                update fetchOrderToRemove;
				system.debug('fetchOrderToRemove '+fetchOrderToRemove);
            }
        }
		}
        if(newOrdersIdsSet.size()>0){
            system.debug('In New Order update');
            //get list of Payment_Transaction__c with new order 
         list<Payment_Transaction__c> fetchPaymentTransactionwithNewOrders = [SELECT Orders__c FROM Payment_Transaction__c WHERE Orders__c IN:newOrdersIdsSet];
         
            if(!fetchPaymentTransactionwithNewOrders.isEmpty()){
              //get the total sum of all Payment_Transaction connect with order
                list<aggregateResult> sumOfAmountCharger = [SELECT sum(Amount_Charged__c) FROM Payment_Transaction__c WHERE Orders__c IN:newOrdersIdsSet];
                
                //get the order where we need to make changes
                list<Orders__c> fetchOldOrderToUpdate = [SELECT Id, Total_Payment_Received__c FROM Orders__c WHERE Id IN:newOrdersIdsSet];
                
                for(Orders__c order:fetchOldOrderToUpdate){
                    order.Total_Payment_Received__c = integer.valueof(sumOfAmountCharger[0].get('expr0'));
                    ListOfOrderToUpdate.add(order);
                } 
            } 
        }
        if(!ListOfOrderToUpdate.isEmpty()){
            update ListOfOrderToUpdate;
            system.debug('ListOfOrderToUpdate '+ListOfOrderToUpdate);
        }
    }
}