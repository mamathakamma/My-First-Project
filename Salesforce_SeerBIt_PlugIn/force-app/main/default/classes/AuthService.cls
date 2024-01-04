public class AuthService {
    
    private static final String API_URL = 'https://seerbitapi.com/api/v2';
   
    public  String encryptKeys(String publicKey, String secretKey) {
        try{
            String endpoint = API_URL + '/encrypt/keys';
            Map<String, String> payloadMap = new Map<String, String>{
                'key' => secretKey + '.' + publicKey
            };

            String payload = JSON.serialize(payloadMap);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(payload);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
                if (response.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> data = (Map<String, Object>) responseMap.get('data');
                Map<String, Object> encryptedKeyData = (Map<String, Object>) data.get('EncryptedSecKey');
                String encryptedKey = (String) encryptedKeyData.get('encryptedKey');
                system.debug(encryptedKey);
                    
                return encryptedKey;
                } else {
                System.debug('Error making the request. Status code: ' + response.getStatusCode());
                System.debug('Response body: ' + response.getBody());
                return null;
            }
        }catch (Exception e) {
            System.debug('Error encryptKeys"'+e.getMessage()+' Line Number:'+e.getLineNumber());
            return null;
        }
    }
}