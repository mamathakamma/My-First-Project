public class HttpUtil {
    public  HttpResponse makeApiCall(String endpoint, String method, String requestBody, String authorizationHeader) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        if(String.isNotBlank(requestBody))
        request.setBody(requestBody);
        return http.send(request);
    }
}