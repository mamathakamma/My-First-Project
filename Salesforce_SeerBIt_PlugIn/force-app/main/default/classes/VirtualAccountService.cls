public class VirtualAccountService {
    
    private static String apiUrl = 'https://seerbitapi.com/api/v2/';

    @future(callout=true)
    public static void updateVirtualAccountFuture(String virtualAccountId) {
        try {
            Virtual_Account__c virtualAccountObj = VirtualAccountDataAccess.getVirtualAccount(virtualAccountId);
            processUpdates(virtualAccountObj);
        } catch (Exception e) {            
            throw new HandleCustomException('Error during updateVirtualAccountFuture', e);            
        }
    }

    public static void processUpdates(Virtual_Account__c virtualAccountObj) {
        try {
            AuthService authInstance = new AuthService();
            Profile__c credential = VirtualAccountDataAccess.getProfile();
            String encryptedKey = authInstance.encryptKeys(credential.Name, credential.Secret_Key__c);
            
            if (encryptedKey != null) {
                VirtualAccountRequest virtualRequests = new VirtualAccountRequest(
                    credential.Name,
                    virtualAccountObj.Name,
                    null,
                    virtualAccountObj.Currency__c,
                    virtualAccountObj.Country__c,
                    virtualAccountObj.Reference__c,
                    virtualAccountObj.Email__c
                ); 
                String requestBody = JSON.serialize(virtualRequests);
                HttpUtil apiUtil = new HttpUtil();
                HttpResponse response = apiUtil.makeApiCall(apiUrl + 'virtual-accounts/', 'POST', requestBody, encryptedKey);
                
                if (response != null) {
                    String jsonResponse = response.getBody();
                    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    String status = (String) responseMap.get('status');
                    if (response.getStatusCode() == 200 && status.equals('SUCCESS')) {
                        Map<String, Object> data = (Map<String, Object>) responseMap.get('data');
                        Map<String, Object> payments = (Map<String, Object>) data.get('payments');
                        String wallet = (String) payments.get('wallet');     
                        virtualAccountObj.WalletId__c = (String) payments.get('wallet');
                        virtualAccountObj.WalletName__c = (String) payments.get('walletName');
                        virtualAccountObj.AccountNumber__c = (String) payments.get('accountNumber');
                        virtualAccountObj.BankName__c = (String) payments.get('bankName');
                        
                        try {
                            update virtualAccountObj;
                        } catch (DmlException e) {
                           
                            HandleCustomException.LogException(e);
                            
                        }
                    } else {
                 HandleCustomException.LogException(new HandleCustomException('SeerBit API request failed with status: ' + status), virtualAccountObj.Id,  'virtualRequests '+virtualRequests, 'response '+response.getBody());
                        VirtualAccountDataAccess.deleteVirtualAccount(virtualAccountObj.Id); 
                    }
                } else {
                    HandleCustomException.LogException(new HandleCustomException('SeerBit API request failed with status: ' + response), 'virtualAccountObj.Id',  'virtualRequests', 'response.getBody()');
                    
                }
            }
        } catch (Exception e) {
            throw new HandleCustomException('Error during updateVirtualAccountFuture', e);
            
        }
    }
    
    //Vitual Account Payments
        public static Payment.SeerbitResponse getPaymentData(String publicKey, String accountNumber, Id virtualAccountId) {
        try{
            String apiUrl = 'https://seerbitapi.com/api/v2/virtual-accounts/' + publicKey + '/' + accountNumber;
            AuthService authInstance = new AuthService();
            Profile__c credential = VirtualAccountDataAccess.getProfile();
            String encryptedKey = authInstance.encryptKeys(credential.Name, credential.Secret_Key__c);
            HttpUtil apiUtil = new HttpUtil();
            HttpResponse response = apiUtil.makeApiCall(apiUrl, 'GET', null, encryptedKey);
            system.debug('response is---'+response);
            if (response.getStatusCode() == 200) {
                return (Payment.SeerbitResponse)JSON.deserialize(response.getBody(), Payment.SeerbitResponse.class);
            } else {
                 String errorMessage = 'SeerBit API request failed with status: ' + null;
            HandleCustomException.LogException(new HandleCustomException(errorMessage), virtualAccountId, 'virtualRequests ' + null, 'response ' + response);
                return null;
            }
        }catch(Exception e){
            throw new HandleCustomException('Error during Payment');
        }
    }
    @AuraEnabled
    public static Boolean getVirtualAccountPayments(String virtualAccountId){
        try{
            Profile__c credential = VirtualAccountDataAccess.getProfile();
            addPayments(credential.Name,VirtualAccountDataAccess.getVirtualAccount(virtualAccountId).AccountNumber__c);
            return true;
        }catch(Exception e){
            throw new HandleCustomException('Error during getVirtualAccountPayments:'+e.getMessage()+' Line Number:'+e.getLineNumber());

        }
    }
    
    public static void addPayments(String publicKey, String accountNumber) {
            Id virtualAccountId = null; // Declare virtualAccountId here

        try{
          
        Payment.SeerbitResponse seerbitResponse = getPaymentData(publicKey, accountNumber, virtualAccountId);
            
            if (seerbitResponse != null && 'SUCCESS'.equals(seerbitResponse.status)) {
                System.debug('seerbitResponse: ' + seerbitResponse);
                List<Payments__c> paymentsToUpdate = new List<Payments__c>();
                for (Payment.SeerbitPayload payload : seerbitResponse.data.payload) {
                    Payments__c payment = new Payments__c(
                        Amount_Paid__c = payload.amount,
                        Country__c = payload.country,
                        Customer_Email__c = payload.email,
                        Customer_Name__c = payload.fullName,
                        Name = payload.id,
                        Invoice_Number__c = payload.invoiceNumber,
                        Payment_Date__c = Datetime.valueOfGmt(payload.updatedAt.substring(0, 10) + ' '+payload.updatedAt.substring(11, 23)),
                        Payment_Link_Id__c = payload.paymentLinkId,
                        Payment_Link_Reference__c = payload.payLinkCustomizationName,
                        Payment_Reference__c = payload.paymentReference,
                        Payment_Status__c = payload.status,
                        Reason__c = payload.reason
                    );
                     virtualAccountId = VirtualAccountDataAccess.getVirtualAccountLookupId(accountNumber);
                    payment.Virtual_Account__c = virtualAccountId;
                    paymentsToUpdate.add(payment);
                }
                if (!paymentsToUpdate.isEmpty()) {
                    upsert paymentsToUpdate Name;
                }
            } else {
                String errorMessage = seerbitResponse != null ? seerbitResponse.data.message : 'Unknown error';
            }
        }catch(Exception e){
                        throw new HandleCustomException('Error during addPayments:'+e.getMessage()+' Line Number:'+e.getLineNumber());

        }
    }
    
    //Delete Virtual Account   
    //@future(callout=true)
    public static void deleteVirtualAccount(String virtualAccountId) {
        try{
            String deleteUrl = apiUrl + 'virtual-accounts/' + virtualAccountId;
            AuthService authInstance = new AuthService();
            Profile__c credential = VirtualAccountDataAccess.getProfile();
            String encryptedKey = authInstance.encryptKeys(credential.Name, credential.Secret_Key__c);
            System.debug('Authorization Header: ' + encryptedKey);
            HttpUtil apiUtil = new HttpUtil();
            HttpResponse response = apiUtil.makeApiCall(deleteUrl, 'DELETE', null, encryptedKey);
            System.debug('response' + response);
            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String status = (String) result.get('status');
                List<Payments__c> paymentsToDelete = [SELECT Id FROM Payments__c WHERE Virtual_Account__c = :virtualAccountId];
                if (status.equals('SUCCESS') || !paymentsToDelete.isEmpty()) {
                    // Delete associated payments
                    delete paymentsToDelete;
                    System.debug('Associated payments have been deleted.');
                }        
                Map<String, Object> data = (Map<String, Object>) result.get('data');
                String code = (String) data.get('code');
                
                
            } else {
                System.debug('HTTP Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        }catch(Exception e){
            System.debug('Error during deleteVirtualAccount:'+e.getMessage()+' Line Number:'+e.getLineNumber());
        }
        
    } 
   
}