public class SeerbitPaymentController {
	@AuraEnabled
    public static Map<String,Object> getVirtualAccountPayments(String virtualAccountId) {
        Map<String, Object> result = new Map<String, Object>();
        Virtual_Account__c virtualAccount = [SELECT Id,AccountNumber__c FROM Virtual_Account__c WHERE Id = :virtualAccountId LIMIT 1];
        GetPaymentVirtualAccount.processSeerbitResponse(SeerbitVirtualAccountService.getPublicKey(),virtualAccount.AccountNumber__c);
      	result.put('success',true);
        return result;
    }
}