public with sharing class InvoiceController {
    @AuraEnabled
    public static List<InvoiceItem__c> getInvoiceItems(Id invoiceId) {
        // Fetch related invoice items for a given invoice Id
        return [SELECT Id, Name, Quantity__c FROM InvoiceItem__c WHERE Invoice__c = :invoiceId];
    }

    @AuraEnabled
    public static Id saveInvoice(Invoice__c invoice, List<InvoiceItem__c> invoiceItems) {
        // Perform validation and other necessary logic before saving

        // Upsert the invoice to ensure it's inserted or updated
        insert invoice;

        // Associate the invoice items with the saved invoice
        for (InvoiceItem__c item : invoiceItems) {
            item.Invoice__c = invoice.Id;
        }

        // Perform DML operation on invoice items (insert or update)
        insert invoiceItems;

        return invoice.Id;
    }
}