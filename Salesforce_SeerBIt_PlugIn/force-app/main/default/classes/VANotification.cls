@RestResource(urlMapping='/vanotification/v1/*')
global class VANotification {

    @AuraEnabled
    @HttpPost
    global static String handleNotification() {
        try {
            String requestBody = RestContext.request.requestBody.toString();
            NotificationRequest req = (NotificationRequest) JSON.deserialize(requestBody, NotificationRequest.class);

            List<NotificationRequest.NotificationRequestItem> items = req.notificationItems;

            if (items != null && !items.isEmpty()) {
                for (NotificationRequest.NotificationRequestItem item : items) {
                    NotificationRequest.Data data = item.data;

                    // Your logic to handle the notification item goes here
                    System.debug('Received event type: ' + item.eventType);
                    System.debug('Received amount: ' + data.amount);

                    // Create a payment object and insert into the database
                        Payments__c payment = new Payments__c(
                        Amount_Paid__c = data.amount,
                        Country__c = data.country,
                        Currency__c = data.currency_z,
                        Customer_Email__c = data.email,
                        Customer_Name__c = data.fullName,
                        Payment_Date__c =Datetime.valueOfGmt(item.eventDate.substring(0, 10) + ' ' + item.eventDate.substring(11, 19)),
                        Payment_Reference__c = data.reference,
                        Payment_Status__c = data.reason,
                        Reason__c = data.reason
                    );
                    System.debug('1. Payment: ' + payment);

                    // Lookup relationship with Virtual_Account__c
                    payment.Virtual_Account__c = getVirtualAccountLookupId(data.creditAccountNumber);
                    System.debug('2. Payment: ' + payment);
                      
                    // Insert payment record
                    insert payment;

                    // Insert into Salesforce object (Assuming you have a custom object named VANotification__c)
                    VA_Notificaton__c notification = new VA_Notificaton__c(
                        Event_Type__c = item.eventType,
                        Event_Date__c = Datetime.valueOfGmt(item.eventDate.substring(0, 10) + ' ' + item.eventDate.substring(11, 19)),
                        Event_Id__c = item.eventId,
                        Amount__c = data.amount,
                        Country__c = data.country,
                        Credit_Account_Number__c = data.creditAccountNumber,
                        Credit_Account_Name__c = data.creditAccountName,
                        Currency__c = data.currency_z,
                        Email__c = data.email,
                        External_Reference__c = data.externalReference,
                        Name = data.fullname,
                        Gateway_Code__c = data.gatewayCode,
                        Code__c = data.code,
                        InternalRef__c = data.internalRef,
                        Gateway_Message__c = data.gatewayMessage,
                        Mobile__c = data.mobile,
                        Narration__c = data.narration,
                        Origin__c = data.origin,
                        Originator_Account_Number__c = data.originatorAccountnumber,
                        Originator_Name__c = data.originatorName,
                        Public_Key__c = data.publicKey,
                        Reference__c = data.reference,
                        Reason__c = data.reason
                    );
                      System.debug('item.eventDate: ' + item.eventDate);

                    // Insert notification record
                    insert notification;
                }
            }
            System.debug('Success');
            return 'Success';
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return 'Error: ' + e.getMessage();
        }
    }

    private static Id getVirtualAccountLookupId(String accountNumber) {
        try {
            Virtual_Account__c virtualAccount = [SELECT Id FROM Virtual_Account__c WHERE AccountNumber__c = :accountNumber LIMIT 1];
            return virtualAccount != null ? virtualAccount.Id : null;
        } catch (Exception e) {
            System.debug('Error in getVirtualAccountLookupId: ' + e.getMessage());
            return null;
        }
    }
}