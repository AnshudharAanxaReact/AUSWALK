@isTest
public class orderCancellationFormControllerTest {
@isTest
    public static void tesMethod1Insert(){
        
       
        
        //create trip 
           Trip__c trip = TestDataFactoryApexClass.createTrip('self_guided');
           insert trip;
       
        
        //create trip option
        Trip_Option__c tripOption = TestDataFactoryApexClass.createTripOption(trip.Id, 'Self_Guided');
        insert tripOption;
        
        
        //create departure date
        Departure_Date__c DepartureDate = TestDataFactoryApexClass.createDepartureDate(tripOption.id,'Rejected','Full Credit;Full Refund');
        insert DepartureDate;
        //system.debug('DepartureDate: '+DepartureDate.id);
        
        Orders__c order = TestDataFactoryApexClass.createOrder('Self_Guided', trip.id, tripOption.id, DepartureDate.id,'Cancelled');
        insert order;
        //system.debug('order: '+order.id);
        
        //create Order_Line_Items__c
        Order_Line_Items__c orderLineItems = TestDataFactoryApexClass.createorderLineItems(order.id,DepartureDate.Id,'Internal - Offload','CS Rejected');
        insert orderLineItems;
        //system.debug('orderLineItems: '+orderLineItems.id);
        
        
        //create Passenger
        Passenger__c Passenger = TestDataFactoryApexClass.createPassenger(orderLineItems.id, order.id);
        insert Passenger;
        
        String recId=order.id;
		orderCancellationFormController.minNotMetCheckData min=orderCancellationFormController.verifyMinNotMetApprovalStatus(order.id);
        List<orderCancellationFormController.recordDataWrapper> lst=orderCancellationFormController.fetchReordDataApexApproval(order.id);
        
       List<orderCancellationFormController.ApprovalHistoryWrapper> lst1=orderCancellationFormController.fetchReordDataApexApprovalHistory(order.id);
       List<orderCancellationFormController.recordDataWrapper> recData=orderCancellationFormController.fetchReordDataApex(order.id, 'Order');
        List<String> Str=orderCancellationFormController.getPicklistvalues('Order_Line_Items__c','Refund_Reason_c__c');
       orderCancellationFormController.saveAndCancel(order.id, recData, true);
       orderCancellationFormController.cancelCompleteOrder(order.id,recData);
       orderCancellationFormController.submitForApproval(recId, recData, true, true);
       orderCancellationFormController.submitForApproval(recId, recData, true, true);
        orderCancellationFormController.sendForApprovalPostDocumentation(recId, recData, true);
        
      Cancellation_Refund__c cn=new Cancellation_Refund__c();
       cn=orderCancellationFormController.canRefRecordAssignment(recId,true);
        
        Coupons__c cpn=new Coupons__c(Send_Coupon__c=true,Cancellation_Refund__c=cn.Id);
        insert cpn;
        orderCancellationFormController.settingSendCouponTrue(cn.Id);
    }
    @isTest
    public static void tesMethod2Insert(){
        
       
        
        //create trip 
           Trip__c trip = TestDataFactoryApexClass.createTrip('self_guided');
           insert trip;
       
        
        //create trip option
        Trip_Option__c tripOption = TestDataFactoryApexClass.createTripOption(trip.Id, 'Self_Guided');
        insert tripOption;
        
        
        //create departure date
        Departure_Date__c DepartureDate = TestDataFactoryApexClass.createDepartureDate(tripOption.id,'processed','Full Credit;Full Refund');
        insert DepartureDate;
        //system.debug('DepartureDate: '+DepartureDate.id);
        
        Orders__c order = TestDataFactoryApexClass.createOrder('Self_Guided', trip.id, tripOption.id, DepartureDate.id,'Secured');
        insert order;
        //system.debug('order: '+order.id);
        
        //create Order_Line_Items__c
        Order_Line_Items__c orderLineItems = TestDataFactoryApexClass.createorderLineItems(order.id,DepartureDate.Id,'Internal - Min Numbers not met','CS Rejected');
        insert orderLineItems;
        //system.debug('orderLineItems: '+orderLineItems.id);
        
        
        //create Passenger
        Passenger__c Passenger = TestDataFactoryApexClass.createPassenger(orderLineItems.id, order.id);
        insert Passenger;
        
        
		orderCancellationFormController.minNotMetCheckData min=orderCancellationFormController.verifyMinNotMetApprovalStatus(order.id);
        
        
       
        
   
    }
}