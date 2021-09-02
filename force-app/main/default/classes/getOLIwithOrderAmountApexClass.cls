public class getOLIwithOrderAmountApexClass {
    
    public static void getOLIAmountWhenInsertOrDelete(list<Order_Line_Items__c> listofOLIRecords){
        system.debug('In getOLIAmountWhenInsert');
        set<id> ordersIdsSet = new set<id>();
        list<Orders__c> listofOrderToUpdate = new list<Orders__c>();
        
        for(Order_Line_Items__c OLI:listofOLIRecords){
            if(OLI.Orders__c!=Null){
            ordersIdsSet.add(OLI.Orders__c);
            }
        }
        
        if(ordersIdsSet.size()>0){
            system.debug('ordersIdsSet: '+ordersIdsSet);
            list<Order_Line_Items__c> FetchOLIListWithOrder = [SELECT id,Orders__c From Order_Line_Items__c WHERE Orders__c IN:ordersIdsSet];
            
            
            if(!FetchOLIListWithOrder.isEmpty()){
                system.debug('FetchOLIListWithOrder '+FetchOLIListWithOrder);
                List<aggregateResult> FetchSumOfOLIwithOrder = [SELECT sum(Total_Amount__c) FROM Order_Line_Items__c Where Orders__c IN:ordersIdsSet];
                List<aggregateResult> FetchHSSAmountOfOLIwithOrder = [SELECT sum(HSS_Amount__c) FROM Order_Line_Items__c Where Orders__c IN:ordersIdsSet];
                
                //fetch Orders__c where we need to make changes
                list<Orders__c> fetchOrderListToUpdate = [SELECT id, Gross_Amount__c,HSS_Amount__c FROM Orders__c where id IN:ordersIdsSet];
                
                for(Orders__c order:fetchOrderListToUpdate){
                    Order.Gross_Amount__c=integer.valueof(FetchSumOfOLIwithOrder[0].get('expr0'));
                    order.HSS_Amount__c=integer.valueof(FetchHSSAmountOfOLIwithOrder[0].get('expr0'));
                    listofOrderToUpdate.add(order);
                }
            }
            
            //if order doesn't have any OLI connect
            if(FetchOLIListWithOrder.isEmpty()){
            //fetch Orders__c where we need to make changes
                list<Orders__c> fetchOrderListToUpdate = [SELECT id, Gross_Amount__c,HSS_Amount__c FROM Orders__c where id IN:ordersIdsSet];
                for(Orders__c order:fetchOrderListToUpdate){
                    Order.Gross_Amount__c=0;
                    order.HSS_Amount__c=0;
                    listofOrderToUpdate.add(order);
                } 
        	}
        }
        if(!listofOrderToUpdate.isEmpty()){
            update listofOrderToUpdate;
            system.debug('listofOrderToUpdate '+listofOrderToUpdate);
        }
    }
    
    public static void getOLIAmountWhenUpdate(list<Order_Line_Items__c> OLIRecordList, map<id,Order_Line_Items__c> OLIOldMap){
        
        set<id> ordersIdSet = new set<id>();
        set<id> oldOrderIdSet = new set<id>();
        set<id> oldOLIIdSet = new set<id>();
        list<Orders__c> orderListToUpdate = new list<Orders__c>();
        
        for(Order_Line_Items__c OLI: OLIRecordList){
            Order_Line_Items__c OldOLI = OLIOldMap.get(OLI.id);
            if(OLI.Orders__c!=null || OLI.Passenger_Quantity__c!=OldOLI.Passenger_Quantity__c){
                ordersIdSet.add(OLI.Orders__c);

                if(OLI.Orders__c!=OldOLI.Orders__c){
                //add old order if into container
                oldOrderIdSet.add(OldOLI.Orders__c);
                oldOLIIdSet.add(OldOLI.Id);
            }
            }
        }
        
        if(oldOrderIdSet.size()>0){
            system.debug('In Old Order update');
            list<Orders__c> FetchOrdertoMakeChange = new list<Orders__c>();
            
            system.debug('oldOrderIdSet:'+oldOrderIdSet);
            if(oldOLIIdSet.size()>0){
                system.debug('oldOLIIdSet:'+oldOLIIdSet);
                List<aggregateResult> FetchSumOfOLIwithOrder = [SELECT sum(Total_Amount__c) FROM Order_Line_Items__c Where id IN:OLIOldMap.keyset()];
                List<aggregateResult> FetchHSSAmountOfOLIwithOrder = [SELECT sum(HSS_Amount__c) FROM Order_Line_Items__c Where Orders__c IN:OLIOldMap.keyset()];
                
                system.debug('FetchSumOfOLIwithOrder'+integer.valueof(FetchSumOfOLIwithOrder[0].get('expr0')));
                system.debug('FetchHSSAmountOfOLIwithOrder:: '+FetchHSSAmountOfOLIwithOrder);
                
                //get old Orders__c record where we need to make changes
                list<Orders__c> OldOrderRecordList = [SELECT id,Gross_Amount__c,HSS_Amount__c FROM Orders__c Where id IN:oldOrderIdSet];
                
                for(Orders__c order:OldOrderRecordList){
                    system.debug('order Gross Amount'+order.Gross_Amount__c);
                    if(order.Gross_Amount__c!=null){
                        order.Gross_Amount__c = order.Gross_Amount__c-(integer.valueof(FetchSumOfOLIwithOrder[0].get('expr0')));
                        
                        if(order.HSS_Amount__c!=Null){
                            order.HSS_Amount__c=order.HSS_Amount__c-(integer.valueof(FetchHSSAmountOfOLIwithOrder[0].get('expr0')));
                        }
                        FetchOrdertoMakeChange.add(order);
                    }

                }
                update FetchOrdertoMakeChange;
            }
            }
        
        if(ordersIdSet.size()>0){
            system.debug('In New Order update');
            //get the new Order line items where we have made changes
            list<Order_Line_Items__c> FetchOLIListWithOrder = [SELECT id,Orders__c from Order_Line_Items__c where Orders__c IN:ordersIdSet]; 
            
            if(!FetchOLIListWithOrder.isEmpty()){
             List<aggregateResult> FetchSumOfOLIwithOrder = [SELECT sum(Total_Amount__c) FROM Order_Line_Items__c Where Orders__c IN:ordersIdSet];
             List<aggregateResult> FetchHSSAmountOfOLIwithOrder = [SELECT sum(HSS_Amount__c) FROM Order_Line_Items__c Where Orders__c IN:ordersIdSet];
                
                //get new order records where we need to make changes
             list<Orders__c> orderListwithOLI = [SELECT id,Gross_Amount__c,HSS_Amount__c FROM Orders__c where id IN: ordersIdSet];
                
                for(Orders__c order:orderListwithOLI){
                    order.Gross_Amount__c=integer.valueof(FetchSumOfOLIwithOrder[0].get('expr0'));
                    order.HSS_Amount__c=integer.valueof(FetchHSSAmountOfOLIwithOrder[0].get('expr0'));
                    orderListToUpdate.add(order);
                }
            }
        }
         update orderListToUpdate;
        }
}