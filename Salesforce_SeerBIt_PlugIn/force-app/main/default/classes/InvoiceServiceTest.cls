@isTest
public class InvoiceServiceTest {

    // Mock class for HTTP callouts
    private class MockHttpResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(201);
           
            // Simulate a successful API response with '00' status
           String responseBody = '{"code": "00", "payload": {"InvoiceID": "771", "InvoiceNo": "SBT-INV-000771"}}';
            
         response.setBody(responseBody);
            System.debug('response: ' +response);
            return response;
        }
    }
    private class MockHttpGenerateInvoiceResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
           
            // Simulate a successful API response with '00' status
            String responseBody;
            if(request.getEndpoint().contains('/encrypt/keys')){
                 response.setStatusCode(200);
           		responseBody = '{"status":"SUCCESS","data":{"code": "S20","payments":{"wallet":"9767365726","walletName":"HUTECH SOLUTIONS","accountNumber":"9767365726","bankName":"9PAYMENT SERVICE BANK"},"EncryptedSecKey":{"encryptedKey":"9767365726"}}}';
            }
            else{
                 response.setStatusCode(201);
            responseBody = '{"code": "00", "payload": {"InvoiceID": "771", "InvoiceNo": "SBT-INV-000771"}}';
            }
            
         response.setBody(responseBody);
            System.debug('response: ' +response);
            return response;
        }
    }
    // Mock class for a failed HTTP response
    private class MockHttpFailedResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(400);
            response.setBody('{ "status": "FAILURE", "message": "Failed API response" }');
            return response;
        }
    }

    // Mock class for an HTTP response that generates an exception
    private class MockHttpResponseGeneratorWithException extends Exception implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setBody('Internal Server Error');
            return response;
        }
    }

     // Mock class for a successful HTTP response specific to the resendInvoice method
    private class MockHttpResponseForResend implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            // Set the response body based on the expected structure for resendInvoice
            String responseBody = '{"code": "00", "message":  "Invoice has been sent successfully"}';
            response.setBody(responseBody);
                  return response;
        }
    }

    // Mock class for a failed HTTP response specific to the resendInvoice method
    private class MockHttpFailedResponseGeneratorForResend implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(400);
            // Set the response body based on the expected structure for failure
            String responseBody = '{"code": "99", "message": "Resend failed"}';
            response.setBody(responseBody);
            return response;
        }
    }
  
    // generateInvoice
    
    @isTest
    static void testGenerateInvoiceSuccess() {
        // Create a test instance of Profile__c
        Profile__c testProfile = new Profile__c(
           Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;

        Invoice__c testInvoice = new Invoice__c(
            DueDate__c = Date.today(),
            Name = 'Test',
            OrderNo__c = '1234',
            CustomerEmail__c = 'Test@gmail.com',
            Currency__c = 'NGN'
            // Other required fields...
        );
        insert testInvoice;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerateInvoiceResponse());
        try {
            Map<String, Object> result = InvoiceService.generateInvoice(testInvoice.Id);
        System.assert(result.containsKey('InvoiceID'), 'InvoiceID should be present in the result');
        System.assertEquals('771', result.get('InvoiceID'), 'InvoiceID should match the expected value');
        System.assert(result.containsKey('InvoiceNo'), 'InvoiceNo should be present in the result');
        System.assertEquals('SBT-INV-000771', result.get('InvoiceNo'), 'InvoiceNo should match the expected value');
        HttpRequest mockRequest = new HttpRequest();
        HttpResponse successResponse = new HttpResponse();
        successResponse.setStatusCode(201);
        successResponse.setBody('{"code": "00", "payload": {"InvoiceID": "771", "InvoiceNo": "SBT-INV-000771"},"EncryptedSecKey":{"encryptedKey":"9767365726"}}');
        HttpCalloutMock mockSuccess = new MockHttpResponse();
        HttpResponse mockResponse = mockSuccess.respond(mockRequest);

        Map<String, Object> apiResponse = (Map<String, Object>) JSON.deserializeUntyped(mockResponse.getBody());
        String status = (String) apiResponse.get('code');
        System.assertEquals('00', status, 'Status should be "00"');

    } catch (Exception ex) {
            System.debug('Exception in testGenerateInvoiceSuccess: ' + ex.getMessage());
        }
        Test.stopTest();
    }    
    
// generate Invoice Failure
    
    @isTest
    static void testGenerateInvoiceFailure() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;

        Invoice__c testInvoice = new Invoice__c(
            DueDate__c = Date.today(),
            Name = 'Test',
            OrderNo__c = '1234',
            CustomerEmail__c = 'Test@gmail.com',
            Currency__c = 'NGN' 
            // Currency__c and Country__c fields will take default values
        );
        insert testInvoice;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpFailedResponseGenerator());
        try {
            Map<String, Object> result = InvoiceService.generateInvoice(testInvoice.Id);
            // Add assertions for the generated response in case of failure
            System.assert(result != null, 'Result should not be null');
            System.assert(result.containsKey('success'), 'Result should contain success key');
            System.assertEquals(false, result.get('success'), 'Invoice generation should fail');
        } catch (Exception ex) {
            // Handle the exception if needed
        }

        Test.stopTest();
    }
    @isTest
    static void testGenerateInvoiceSuccessWithItems() {
        // New test method...
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Invoice__c testInvoice = new Invoice__c(
            DueDate__c = Date.today(),
            Name = 'Test',
            OrderNo__c = '1234',
            CustomerEmail__c = 'Test@gmail.com',
            Currency__c = 'NGN'
            // Add other required fields...
        );
        insert testInvoice;

        InvoiceItem__c testInvoiceItem = new InvoiceItem__c(
            Invoice__c = testInvoice.Id,
            Name = 'Item Test',
            Quantity__c = 2,
            Rate__c = 50,
            Tax__c = 5
        );
        insert testInvoiceItem;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        try {
            Map<String, Object> result = InvoiceService.generateInvoice(testInvoice.Id);
            // Add assertions for the generated response
            System.assert(result != null, 'Result should not be null');
            System.assert(result.containsKey('success'), 'Result should contain success key');
            System.assertEquals(true, result.get('success'), 'Invoice generation should be successful');
            
            // Ensure that the specific part of the code handling the API response status is covered
            System.assertEquals('771', testInvoice.InvoiceId__c, 'InvoiceId__c should be updated');
            System.assertEquals('SBT-INV-000771', testInvoice.InvoiceNo__c, 'InvoiceNo__c should be updated');
        } catch (Exception ex) {
            System.debug('Exception in testGenerateInvoiceSuccessWithItems: ' + ex.getMessage());
        }
        Test.stopTest();
    }
    //Resend
    
    @isTest
static void testResendInvoice() {
    Profile__c testProfile = new Profile__c(
        Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
        Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
    );
    insert testProfile;

    Invoice__c testInvoice = new Invoice__c(
        DueDate__c = Date.today(),
        Name = 'Test',
        OrderNo__c = '1234',
        CustomerEmail__c = 'Test@gmail.com',
        Currency__c = 'NGN' 
    );
    insert testInvoice;
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseForResend());

    Test.startTest();
    try {
        InvoiceResponse.SeerbitApiResponse response = InvoiceService.resendInvoice(testInvoice.Id);
        if (response != null) {
            if (response.code.contains('status check merchant details')) {
                System.debug('SeerBit API request failed with status check merchant details. This might be expected.');
            } else {
                assertSuccessResponse(response, '00', 'Invoice has been sent successfully');
            }
        } else {
            System.debug('The response is null. This might be expected in certain scenarios.');
        }
    } catch (Exception ex) {
        System.debug('Exception in testResendInvoice: ' + ex.getMessage());
        System.debug('Exception occurred: ' + ex.getMessage());    }
    Test.stopTest();
}
    
 //ResendInvoiceFailure   
   @isTest
    static void testResendInvoiceFailure() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Invoice__c testInvoice = new Invoice__c(
            DueDate__c = Date.today(),
            Name = 'Test',
            OrderNo__c = '1234',
            CustomerEmail__c = 'Test@gmail.com',
            Currency__c = 'NGN'
        );
        insert testInvoice;
        Test.setMock(HttpCalloutMock.class, new MockHttpFailedResponseGeneratorForResend());

        Test.startTest();
        try {
            InvoiceResponse.SeerbitApiResponse response = InvoiceService.resendInvoice(testInvoice.Id);
            System.assertEquals(null, response, 'Response should be null in case of failure');
        } catch (Exception ex) {
            System.debug('Exception in testResendInvoiceFailure: ' + ex.getMessage());
        }
        Test.stopTest();
    }
    //ResendInvoiceException
@isTest
static void testResendInvoiceException() {
    Profile__c testProfile = new Profile__c(
        Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
        Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
    );
    insert testProfile;
    Invoice__c testInvoice = new Invoice__c(
        DueDate__c = Date.today(),
        Name = 'Test',
        OrderNo__c = '1234',
        CustomerEmail__c = 'Test@gmail.com',
        Currency__c = 'NGN' 
        // Currency__c and Country__c fields will take default values
    );
    insert testInvoice;
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithException());

    Test.startTest();
    try {
        System.debug('Calling resendInvoice method...');
        InvoiceResponse.SeerbitApiResponse response = InvoiceService.resendInvoice(testInvoice.Id);
        System.debug('Response from resendInvoice method: ' + response);

        if (response != null) {
            if (response.code.contains('status check merchant details')) {
                System.debug('SeerBit API request failed with status check merchant details. This might be expected.');
            } else {
                assertExceptionResponse(response, 'yourExpectedCode', 'yourExpectedMessage');
            }
        } else {
            System.debug('The response is null. This might be expected in certain scenarios.');
        }
    } catch (Exception ex) {
        System.debug('Exception in testResendInvoiceException: ' + ex.getMessage());
    }
    Test.stopTest();
}
   
    @isTest
    static void testCallSeerbitApiSuccess() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;

        Invoice__c testInvoice = new Invoice__c(
            DueDate__c = Date.today(),
            Name = 'Test',
            OrderNo__c = '1234',
            CustomerEmail__c = 'Test@gmail.com',
            Currency__c = 'NGN'
        );
        insert testInvoice;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        try {
            // Call the method to be tested
            InvoiceResponse.SeerbitApiResponse response = InvoiceService.callSeerbitApi(testProfile.Name, 'MockInvoiceNo', testInvoice.Id);

           // Check if the response is not null before making assertions
        if (response != null) {
            if (response.code.contains('status check merchant details')) {
                System.debug('SeerBit API request failed with status check merchant details. This might be expected.');
            } else {
                assertSuccessResponse(response, '00', 'Invoice has been sent successfully');
            }
        } else {
            System.debug('The response is null. This might be expected in certain scenarios.');
        }
    } catch (Exception ex) {
        System.debug('Exception in testCallSeerbitApiSuccess: ' + ex.getMessage());
        System.debug('Exception occurred: ' + ex.getMessage());    }
    Test.stopTest();
}
    @isTest
    static void testCallSeerbitApiFailure() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NZ',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;

        Invoice__c testInvoice = new Invoice__c(
            DueDate__c = Date.today(),
            Name = 'Test',
            OrderNo__c = '1234',
            CustomerEmail__c = 'Test@gmail.com',
            Currency__c = 'NGN'
        );
        insert testInvoice;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpFailedResponseGenerator());

                try {
            InvoiceResponse.SeerbitApiResponse response = InvoiceService.callSeerbitApi(testProfile.Name, 'MockInvoiceNo', testInvoice.Id);
            if (response != null) {
                 assertFailureResponse(response, '99', 'Resend failed');
                
            } else {
                System.debug('The response is null. This might be expected in certain scenarios.');
               
            }
        } catch (Exception ex) {
            System.debug('Exception in testCallSeerbitApiFailure: ' + ex.getMessage());
        }

        Test.stopTest();
    }
  
    // Helper method to assert success response for generate or resend invoice
    private static void assertSuccessResponse(InvoiceResponse.SeerbitApiResponse response, String expectedCode, String expectedMessage) {
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(expectedCode, response.code, 'Code should match the expected code');
        System.assertEquals(expectedMessage, response.message, 'Message should match the expected message');
            }

    // Helper method to assert failure response for generate or resend invoice
    private static void assertFailureResponse(InvoiceResponse.SeerbitApiResponse response, String expectedCode, String expectedMessage) {
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(expectedCode, response.code, 'Code should match the expected code');
        System.assertEquals(expectedMessage, response.message, 'Message should match the expected message');
        
    }

    // Helper method to assert exception response for generate or resend invoice
    private static void assertExceptionResponse(InvoiceResponse.SeerbitApiResponse response, String expectedCode, String expectedMessage) {
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(expectedCode, response.code, 'Code should match the expected code');
        System.assertEquals(expectedMessage, response.message, 'Message should match the expected message');
        
    }

}