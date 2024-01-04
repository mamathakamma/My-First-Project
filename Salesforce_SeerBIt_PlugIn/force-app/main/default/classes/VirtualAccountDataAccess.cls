public class VirtualAccountDataAccess {
    
    public static Id getVirtualAccountLookupId(String accountNumber) {
        Virtual_Account__c virtualAccount = [SELECT Id FROM Virtual_Account__c WHERE AccountNumber__c = :accountNumber LIMIT 1];
        return virtualAccount != null ? virtualAccount.Id : null;
    }
    
    /* @AuraEnabled(cacheable=true)
        public static Virtual_Account__c getVirtualAccountById(Id virtualAccountId) {
        return [SELECT Id,Name, Email__c, Reference__c, BankName__c, WalletName__c,  WalletId__c, AccountNumber__c, Country__c, Currency__c FROM Virtual_Account__c where Id=:virtualAccountId LIMIT 1];
        }*/

    @AuraEnabled
    public static Virtual_Account__c getVirtualAccount(String recordId){
        return [SELECT Id,Name, Email__c, Reference__c, BankName__c, WalletName__c,  WalletId__c, AccountNumber__c, Country__c, Currency__c FROM Virtual_Account__c where Id=:recordId LIMIT 1];
    }
    
    public static Virtual_Account__c getVirtualAccounts(String referenceId){
        return [SELECT Id,  Name, Email__c, Reference__c, BankName__c, WalletName__c, WalletId__c, AccountNumber__c, Country__c, Currency__c FROM Virtual_Account__c where Reference__c=:referenceId LIMIT 1];
    }
    
    @AuraEnabled
    public static Map<String, Object> deleteVirtualAccount(String virtualAccountId) {
        Map<String, Object> responseObj = new Map<String, Object>();
        try {
                Virtual_Account__c virtualAccObj = [SELECT Id, Name, Email__c, Reference__c, BankName__c, WalletName__c, WalletId__c, AccountNumber__c, Country__c, Currency__c FROM Virtual_Account__c WHERE Id = :virtualAccountId LIMIT 1];
    
                // Query related payments based on the Virtual Account Id
                List<Payments__c> relatedPayments = [SELECT Id FROM Payments__c WHERE Virtual_Account__c = :virtualAccObj.Id];
                delete relatedPayments;
                delete virtualAccObj;
                responseObj.put('success', true);
            } catch (Exception e) {
                    responseObj.put('success', false);
                    responseObj.put('errors', new List<String>{'An error occurred while deleting the Virtual Account.'});
                }
        return responseObj;
    }
    
    /*@AuraEnabled
    public static List<Payments__c> getSortedPayments(String virtualAccountId) {
        return [SELECT Id, Name, Amount_Paid__c, Payment_Date__c FROM Payments__c WHERE Virtual_Account__c = :virtualAccountId ORDER BY Payment_Date__c DESC];
    }*/
    
    public  static Profile__c getProfile() {
        return [SELECT Name, Secret_Key__c FROM Profile__c LIMIT 1];
    }
    
    
    public static String getPublicKey() {
        Profile__c credentials=[SELECT  Name,Secret_Key__c FROM Profile__c LIMIT 1];
        String publicKeys = credentials.Name; 
        return publicKeys;
    }
    
    @AuraEnabled
    public static void updateVirtualAccountAura(String virtualAccountId) {
        try {
            Virtual_Account__c virtualAccountObj = getVirtualAccount(virtualAccountId);
            VirtualAccountService.processUpdates(virtualAccountObj);
        } catch (Exception e) {
              throw new HandleCustomException('Error during updateVirtualAccountAura: ' + e.getMessage() + ' Line Number:' + e.getLineNumber(), e);

        } 
    }
}