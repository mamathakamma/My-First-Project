public with sharing class SeerbitPaymentDetailsController {
    @AuraEnabled(cacheable=true)
    public static List<Payments__c> getPayments(String virtualAccountId) {
        return [SELECT Id, Amount_Paid__c, Country__c, Customer_Email__c, Customer_Name__c, Payment_Date__c,
                 Payment_Link_Id__c, Payment_Link_Reference__c, Payment_Reference__c, Payment_Status__c, Reason__c
                 FROM Payments__c
                 WHERE Virtual_Account__c = :virtualAccountId];
    }
}