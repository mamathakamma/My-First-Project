public class InvoiceService {
    
       private static final String BASE_URL = 'https://seerbitapi.com/invoice/';
   
      @AuraEnabled(cacheable=false)
      public static Map<String, Object> generateInvoice(Id invoiceId) {
         Map<String, Object> result = new Map<String, Object>();
         try {
                AuthService authInstance = new AuthService();
                Profile__c credential = InvoiceDataAccess.getProfile();
                String encryptedKey = authInstance.encryptKeys(credential.Name, credential.Secret_Key__c);
                Invoice__c invoiceRecord = [SELECT Id, Name, CustomerEmail__c, DueDate__c, Currency__c, OrderNo__c FROM Invoice__c WHERE Id = :invoiceId LIMIT 1];
                List<InvoiceItem__c> invoiceItems = [SELECT Name, Quantity__c, Rate__c, Tax__c FROM InvoiceItem__c WHERE Invoice__c = :invoiceId];
                List<Map<String, Object>> invoiceItemsList = new List<Map<String, Object>>();
                for (InvoiceItem__c item : invoiceItems) {
                       Map<String, Object> invoiceItemMap = new Map<String, Object>{
                                'itemName' => item.Name,
                                'quantity' => item.Quantity__c.intValue(),
                                'rate' => item.Rate__c,
                                'tax' => item.Tax__c
                            };
                	   invoiceItemsList.add(invoiceItemMap);
                } 
                Map<String, Object> apiRequest = new Map<String, Object>{
                               'publicKey' => InvoiceDataAccess.getPublicKey(),
                               'orderNo' => invoiceRecord.OrderNo__c,
                               'dueDate' => String.valueOf(invoiceRecord.DueDate__c),
                               'currency' => invoiceRecord.Currency__c,
                               'receiversName' => invoiceRecord.Name,
                               'customerEmail' => invoiceRecord.CustomerEmail__c,
                               'invoiceItems' => invoiceItemsList
          					 };

             
                HttpUtil apiUtil = new HttpUtil();
                HttpResponse response = apiUtil.makeApiCall(BASE_URL+'/create', 'POST', JSON.serialize(apiRequest), encryptedKey);
             System.debug('response: ' +response);
                Map<String, Object> apiResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String status = (String) apiResponse.get('code');
                if (response.getStatusCode() == 201 && status.equals('00')) {
                        Map<String, Object> payload = (Map<String, Object>) apiResponse.get('payload');
                        String invoiceIdFromApi = String.valueOf(payload.get('InvoiceID'));
                        String invoiceNoFromApi = (String) payload.get('InvoiceNo');
                        invoiceRecord.InvoiceId__c = invoiceIdFromApi;
                        invoiceRecord.InvoiceNo__c = invoiceNoFromApi;
                        upsert invoiceRecord;
                        payload.put('success',true);
                        return payload;
                    } else {
                  HandleCustomException.LogException(new HandleCustomException('SeerBit API request failed with status check merchat details ' + status), invoiceId,  'invoiceRequests '+apiRequest, 'response '+response.getBody());

                    result.put('success',false);
                        delete invoiceRecord;
                        return null;
                           }
            } catch (Exception ex) {
                
              throw new HandleCustomException('Exception: ' + ex.getMessage());

           	}
          }
   
    //Resend Invoice
          @AuraEnabled
          public static InvoiceResponse.SeerbitApiResponse resendInvoice(Id invoiceId) {
          System.debug(invoiceId);
           try {
             if (invoiceId == null) {
             System.debug('invoiceId is null');
             return null;
          }

         String invoiceNo = InvoiceDataAccess.invoiceNumber(invoiceId).InvoiceNo__c;

        if (invoiceNo != null) {
            String publicKey = InvoiceDataAccess.getPublicKey();
            System.debug('Public Key: ' + publicKey);

            if (publicKey != null) {
                return callSeerbitApi(publicKey, invoiceNo,invoiceId);
            } else {
                    throw new HandleCustomException('SeerBit API request failed with status check merchat details ');

            }
        } else {
                    throw new HandleCustomException('SeerBit API request failed with status check merchat details ');
        }
    } catch (Exception ex) {
      
              throw new HandleCustomException('Exception: ' + ex.getMessage());
    }
}


   public  static InvoiceResponse.SeerbitApiResponse callSeerbitApi(String publicKey, String invoiceNo, Id invoiceId) {
    try {
        String apiUrl = BASE_URL + publicKey + '/send/' + invoiceNo;

        AuthService authInstance = new AuthService();
        Profile__c credential = InvoiceDataAccess.getProfile();
        String encryptedKey = authInstance.encryptKeys(credential.Name, credential.Secret_Key__c);

        HttpUtil apiUtil = new HttpUtil();
        HttpResponse response = apiUtil.makeApiCall(apiUrl, 'GET', null, encryptedKey);

        if (response.getStatusCode() == 201) {
            return (InvoiceResponse.SeerbitApiResponse) JSON.deserialize(response.getBody(), InvoiceResponse.SeerbitApiResponse.class);
        } else {
                    throw new HandleCustomException('SeerBit API request failed with status check merchat details ');
            
        }
    } catch (Exception ex) {
        // Log the exception using HandleCustomException
                    throw new HandleCustomException('SeerBit API request failed with status check merchat details ');
        // You may want to return a default SeerbitApiResponse object or null here based on your requirements.
    }
}

 }