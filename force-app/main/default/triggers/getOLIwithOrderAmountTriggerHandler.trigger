trigger getOLIwithOrderAmountTriggerHandler on Order_Line_Items__c (After insert, After Delete, After Update) {

    if(trigger.isAfter){
        
        if(trigger.isInsert){
            getOLIwithOrderAmountApexClass.getOLIAmountWhenInsertOrDelete(trigger.new);
        }
        if(trigger.isDelete){
            getOLIwithOrderAmountApexClass.getOLIAmountWhenInsertOrDelete(trigger.old);
        }
        if(trigger.isUpdate){
            getOLIwithOrderAmountApexClass.getOLIAmountWhenUpdate(trigger.new,trigger.oldmap);
        }
    }
}