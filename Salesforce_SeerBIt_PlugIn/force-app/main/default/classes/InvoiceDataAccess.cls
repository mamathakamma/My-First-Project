public class InvoiceDataAccess {
   public static  Profile__c getProfile() {
        return [SELECT Name, Secret_Key__c FROM Profile__c LIMIT 1];
     }
        
   public static String getPublicKey() {
        Profile__c credentials= getProfile();
        String publicKeys = credentials.Name; 
        return publicKeys;
      }
  
    public static Invoice__c invoiceNumber(String invoiceId) {
        List<Invoice__c> invoices = [SELECT Id, InvoiceNo__c FROM Invoice__c WHERE Id = :invoiceId LIMIT 1];

        if (invoices != null && !invoices.isEmpty()) {
            return invoices[0];
        } else {
            return null;
        }
    }
}