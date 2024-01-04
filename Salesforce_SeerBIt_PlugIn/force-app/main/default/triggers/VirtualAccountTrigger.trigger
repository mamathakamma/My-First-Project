trigger VirtualAccountTrigger on Virtual_Account__c (after insert,after delete) {
    if (Trigger.isInsert) {
        for (Virtual_Account__c virtualAccountObj : Trigger.new) {
            VirtualAccountService.updateVirtualAccountFuture(virtualAccountObj.Id);
        }
        
    }
   
    if(Trigger.isDelete){
        for(Virtual_Account__c virtualAccountObj : Trigger.old){
            if(virtualAccountObj.Reference__c != null)
            VirtualAccountService.deleteVirtualAccount(virtualAccountObj.Reference__c);
        }
    }
    if(Trigger.isUpdate){
        List<Payments__C>paymentsToUpdate=new List<Payments__C>();
        for(Virtual_Account__c virtualAccountObj : Trigger.new){
            VirtualAccountService.updateVirtualAccountFuture(virtualAccountObj.Id);
            List<Payments__c>relatedPayments = [SELECT Id, Amount_Paid__c, Country__c, Customer_Email__c, Customer_Name__c, Payment_Date__c,
                 Payment_Link_Id__c, Payment_Link_Reference__c, Payment_Reference__c, Payment_Status__c, Reason__c
                 FROM Payments__c
                 WHERE Virtual_Account__c = :virtualAccountObj.AccountNumber__c];
            paymentsToUpdate.addAll(relatedPayments);
        }
        if(!paymentsToUpdate.isEmpty()){
            upsert paymentsToUpdate;
        }
    }
}