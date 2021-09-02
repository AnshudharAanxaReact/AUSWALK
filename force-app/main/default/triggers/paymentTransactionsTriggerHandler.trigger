trigger paymentTransactionsTriggerHandler on Payment_Transaction__c (After insert, After Delete, After Update) {

    if(trigger.isAfter){
        
        if(trigger.isInsert){
            paymentTransactionsApexClass.NewPaymentTransactionCreation(trigger.new);
        }
        if(trigger.isDelete){
            paymentTransactionsApexClass.NewPaymentTransactionCreation(trigger.old);
        }
        if(trigger.isUpdate){
            paymentTransactionsApexClass.UpdatePaymentTransaction(trigger.new,trigger.oldMap);
        }
    }
}