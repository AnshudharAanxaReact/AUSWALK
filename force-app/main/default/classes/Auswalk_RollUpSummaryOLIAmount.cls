public class Auswalk_RollUpSummaryOLIAmount {
    
    public static void rollUpSummaryOLIAmountInsert(List<Order_Line_Items__c> listOfOLIRecords) {

        //container to hold all orders Id where we need to make changes
        Set<Id> ordersIdSet= new Set<Id>();
        //list of parent object records to update
        List<Orders__c> ordersToUpdate = new List<Orders__c>();

        for(Order_Line_Items__c oli:listOfOLIRecords){
                if(oli.Orders__c!=Null){
                    ordersIdSet.add(oli.Orders__c); 
                }
        }

        if(!ordersIdSet.isEmpty()){
                //get the parent object records with OLI records 
                List<Orders__c> fetchOrderswithOli = [SELECT Id,Gross_Amount__c,HSS_Amount__c FROM Orders__c WHERE Id IN:ordersIdSet];

                //check if we have any orders records with OLI
                if(!fetchOrderswithOli.isEmpty()){
                    
                    //retrieve aggregate result for child to update parent records
                    List<aggregateResult> result = [SELECT sum(Total_Amount__c),sum(HSS_Amount__c) FROM Order_Line_Items__c Where Orders__c IN:ordersIdSet];
                    //System.debug('aggregateResult -- Line 25--> '+result);

                    for(Orders__c order:fetchOrderswithOli){
                        order.Gross_Amount__c=integer.valueOf(result[0].get('expr0'));
                        order.HSS_Amount__c=integer.valueOf(result[0].get('expr1'));
                        ordersToUpdate.add(order);
                    }
                }
                else if(fetchOrderswithOli.isEmpty()){
                    for(Orders__c order:fetchOrderswithOli){
                        order.Gross_Amount__c=0;
                        order.HSS_Amount__c=0;
                        ordersToUpdate.add(order);
                    }
                }
        }
        if(!ordersToUpdate.isEmpty()){
            update ordersToUpdate;
            //System.debug('ordersToUpdate --Line 43-->'+ordersToUpdate);
        }
    }
    public static void rollUpSummaryOLIAmountupdate(List<Order_Line_Items__c> listOfOLIRecords, Map<Id,Order_Line_Items__c> oldOliMap){
        //container to hold all orders Id where we need to make changes
        Set<Id> ordersIdSet= new Set<Id>();
        //hold orders Id if we make any change in reparenting
        Set<Id> ordersOldIdSet = new Set<Id>();
        //list of parent object records to update
        List<Orders__c> ordersToUpdate = new List<Orders__c>();

        for(Order_Line_Items__c oli:listOfOLIRecords){

            if(oli.Orders__c!=null){
                
                //get the old record of oli to compare values
                Order_Line_Items__c oldOli = oldOliMap.get(oli.Id);

                if(oli.Passenger_Quantity__c!=oldOli.Passenger_Quantity__c){
                    ordersIdSet.add(oli.Orders__c);
                }
                else if(oli.Orders__c!=oldOli.Orders__c ){
                    //if any reparenting
                    ordersOldIdSet.add(oldOli.Orders__c);
                }
            }
        }
        
        if(!ordersIdSet.isEmpty()){

            //get the parents record to where we need to make changes
            List<Orders__c> fetchOrderswithOliToUpdate = [SELECT Id,Gross_Amount__c,HSS_Amount__c FROM Orders__c WHERE Id IN:ordersIdSet];

            if(!fetchOrderswithOliToUpdate.isEmpty()){
                //retrieve aggregate result for child to update parent records
                List<aggregateResult> result = [SELECT sum(Total_Amount__c),sum(HSS_Amount__c) FROM Order_Line_Items__c Where Orders__c IN:ordersIdSet ];
                //System.debug('aggregateResult -- Line 79--> '+result);

                for(Orders__c order:fetchOrderswithOliToUpdate){
                    order.Gross_Amount__c=integer.valueOf(result[0].get('expr0'));
                    order.HSS_Amount__c =integer.valueOf(result[0].get('expr1'));
                    ordersToUpdate.add(order);
                }
            }
        }

        if(!ordersToUpdate.isEmpty()){
            update ordersToUpdate;
            //System.debug('ordersToUpdate ---Line 91--> '+ordersToUpdate);
        }

        //check if we make change reparenting
        if(!ordersOldIdSet.isEmpty()){

            List<Orders__c> parentToUpdate = new List<Orders__c>();

            //parent record where we need to make any changes
            List<Orders__c> fetchOrdersListwithOLiToUpdate = [SELECT Id,Gross_Amount__c,HSS_Amount__c FROM Orders__c WHERE Id IN:ordersOldIdSet];

            if(!fetchOrdersListwithOLiToUpdate.isEmpty()){

                //retrieve aggregate result for child to update parent records
                List<aggregateResult> result = [SELECT sum(Total_Amount__c),sum(HSS_Amount__c) FROM Order_Line_Items__c Where Id IN:oldOliMap.keySet()];
                //System.debug('aggregateResult -- Line 106--> '+result);

                for(Orders__c order:fetchOrdersListwithOLiToUpdate){

                    if(order.Gross_Amount__c!=null || order.HSS_Amount__c!=null){
                        order.Gross_Amount__c=order.Gross_Amount__c-(integer.valueOf(result[0].get('expr0')));
                        order.HSS_Amount__c=order.HSS_Amount__c-(integer.valueOf(result[0].get('expr1')));
                        parentToUpdate.add(order);
                    }
                }
            }
            if(!parentToUpdate.isEmpty()){
                update parentToUpdate;
                //System.debug('parentToUpdate - Line 119->'+parentToUpdate);
            }
        }
    }
}