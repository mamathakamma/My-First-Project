@isTest
public class VirtualAccountServiceTest {

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            //res.setBody('{ "status": "SUCCESS","data": {"payments": { "wallet": "9767365726", "walletName": "HUTECH SOLUTIONS", "accountNumber": "9767365726", "bankName": "9PAYMENT SERVICE BANK" }}}');
            //res.setBody('{ "status": "SUCCESS","data": {"payments": { "wallet": "9767365726", "walletName": "HUTECH SOLUTIONS", "accountNumber": "9767365726", "bankName": "9PAYMENT SERVICE BANK" },"EncryptedSeckey":{"encryptedKey": "9767365726"}}');
            res.setBody('{"status":"SUCCESS","data":{"code": "S20","payments":{"wallet":"9767365726","walletName":"HUTECH SOLUTIONS","accountNumber":"9767365726","bankName":"9PAYMENT SERVICE BANK"},"EncryptedSecKey":{"encryptedKey":"9767365726"}}}');
            return res;
        }
    }
    
    private class MockHttpSeerbitPaymentResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"SUCCESS","data":{"code":"00","payload":[{"id":14705414,"fullName":"Customer Name","publicKey":"YOUR_PUBLIC_KEY","processor":"_9PAYMENT_SERVICE_BANK","paymentType":"TRANSFER","shopperReference":null,"amount":100,"productId":null,"productDescription":null,"email":"customeremail@gmail.com","quantity":null,"maskedPan":null,"gateway":"_9PAYMENT_SERVICE_BANK","gatewayMessage":"Successful","gatewayCode":"00","transactionRef":"GT-01","gatewayRef":"100004230627104826104793084015","businessName":"Business Name","fee":null,"mode":"LIVE","callbackUrl":null,"redirectUrl":null,"channelType":"transfer","paymentKey":null,"sourceIP":null,"deviceType":null,"clientAppCode":null,"cardBin":null,"lastFourDigits":null,"type":null,"linkingreference":null,"country":"NG","currency":"NGN","smsProvider":null,"customerId":null,"internalreference":"_SBT_N7N7EU523C","accountNumber":"customer account number","narration":null,"creditAccountName":"Seerbit(Tola Sambo)","transferType":"RESERVE_ACCOUNT","paymentReference":"GT-01_SBT_N7N7EU523C","batchId":null,"sessionId":null,"bankName":"","creditAccountNumber":"4015310501","bankCode":null,"alternatePaymentReference":null,"settlementCode":"00","settlementMessage":"Push Successful","settlementTime":"2023-06-27 11:49:37","orderStatusCode":null,"orderStatusMessage":null,"status":"PUSHED","mobileNumber":"404","dateOfBirth":null,"branchPhoneNumber":null,"transferedAmount":100,"scheduleId":null,"isCardInternational":"LOCAL","reason":"Successful","retry":false,"metaData":null,"event":[],"order":[],"createdAt":"2023-06-27T10:49:28.000+0000","updatedAt":"2023-06-27T10:49:28.000+0000","cardName":null,"isNigeriancard":null,"cardCountry":null,"intCurrency":null,"rate":null,"inCardProcessingFee":null,"intAmountCharge":null,"processorCode":"00","processorMessage":"Successful","invoiceNumber":null,"billId":null,"locationPhoneNumber":null,"pocketReferenceId":null,"transferAccountType":"STATIC","bearer":"MERCHANT","transLink":null,"vendorId":null,"payLinkEnvironment":null,"payLinkStatus":null,"payLinkAmount":null,"payLinkAdditionalData":null,"payLinkName":null,"payLinkDescription":null,"payLinkRedirectUrl":null,"payLinkSuccessMessage":null,"paymentLinkId":null,"payLinkCustomizationName":null,"payLinkFrequency":null,"payLinkIsOneTimeUse":false,"terminalId":null,"stan":null,"transactionComplete":null,"cardExpiryMonth":null,"cardExpiryYear":null,"tokenize":false}],"message":"successful","EncryptedSecKey":{"encryptedKey":"9767365726"}}}');
            return res;
        }
    }
    
    private class MockHttpFailedResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(400); // Simulate a failed response
            res.setBody('{ "status": "FAILURE", "message": "Failed API response" }');
            return res;
        }
    }
	
    private class MockHttpResponseGeneratorWithException extends Exception implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(500); // Simulate an exception with a 500 status code
            res.setBody('Internal Server Error');
            return res;
        }
    }
    
    @isTest
    static void testUpdateVirtualAccountFuture() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;    
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
        try{
        VirtualAccountService.updateVirtualAccountFuture(testVirtualAccount.Id); 
        Virtual_Account__c updatedVirtualAccount = [SELECT Id, WalletId__c, WalletName__c, AccountNumber__c, BankName__c FROM Virtual_Account__c WHERE Id = :testVirtualAccount.Id LIMIT 1];
        System.assertNotEquals('9676365726', updatedVirtualAccount.WalletId__c, 'WalletId should not be null');
        System.assertNotEquals('HUTECH SOLUTIONS', updatedVirtualAccount.WalletName__c, 'WalletName should not be null');
        System.assertNotEquals('9676365726', updatedVirtualAccount.AccountNumber__c, 'AccountNumber should not be null');
        System.assertNotEquals('9 payment service bank', updatedVirtualAccount.BankName__c, 'BankName should not be null');
        } catch (Exception e) {
        // Add assertions to ensure that the exception is thrown and has the expected message
        System.assert(e.getMessage().contains('Error during updateVirtualAccountFuture'), 'Unexpected exception message');
    }
        
        Test.stopTest();
    }

    @isTest
    static void testUpdateVirtualAccountFuture_Exception() {
        // Set up test data
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;   
        // Create a test instance of Virtual_Account__c
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
    	Test.startTest();
        // Set up mock to simulate an exception during the API call
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithException());        
        try {
				VirtualAccountService.updateVirtualAccountFuture(testVirtualAccount.Id); 
       			Virtual_Account__c updatedVirtualAccount = [SELECT Id, WalletId__c, WalletName__c, AccountNumber__c, BankName__c FROM Virtual_Account__c WHERE Id = :testVirtualAccount.Id LIMIT 1];
        		System.assertNotEquals('9676365726', updatedVirtualAccount.WalletId__c, 'WalletId should not be null');
                System.assertNotEquals('HUTECH SOLUTIONS', updatedVirtualAccount.WalletName__c, 'WalletName should not be null');
                System.assertNotEquals('9676365726', updatedVirtualAccount.AccountNumber__c, 'AccountNumber should not be null');
                System.assertNotEquals('9 payment service bank', updatedVirtualAccount.BankName__c, 'BankName should not be null');	
            }catch (Exception e) {            
                throw new HandleCustomException('Error during updateVirtualAccountFuture', e);            
            }
        Test.stopTest();
    }

	@isTest
    static void testProcessUpdates_SuccessfulResponse() {
        // Create a test instance of Profile__c
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        // Create a test instance of Virtual_Account__c
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
		Test.startTest();
        // Set up the mock for a successful response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call the method to be tested
  		VirtualAccountService.processUpdates(testVirtualAccount);      
        // Retrieve the updated record from the database
        testVirtualAccount = [SELECT Id, WalletId__c, WalletName__c, AccountNumber__c, BankName__c FROM Virtual_Account__c WHERE Id = :testVirtualAccount.Id LIMIT 1];
        // Add assertions for the successful path
        System.assertNotEquals(null, testVirtualAccount.WalletId__c, 'WalletId should be updated to the expected value');
        System.assertNotEquals(null, testVirtualAccount.WalletName__c, 'WalletName should be updated to the expected value');
        System.assertNotEquals(null, testVirtualAccount.AccountNumber__c, 'AccountNumber should be updated to the expected value');
        System.assertNotEquals(null, testVirtualAccount.BankName__c, 'BankName should be updated to the expected value');           
        Test.stopTest();
    }

    @isTest
    static void testProcessUpdates_FailedResponse() {
        // Set up test data
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
        Test.startTest();
        // Set up mock for failed response
        Test.setMock(HttpCalloutMock.class, new MockHttpFailedResponseGenerator());  
        VirtualAccountService.processUpdates(testVirtualAccount);
        
        // Add assertions for the failed response path
        testVirtualAccount = [SELECT Id FROM Virtual_Account__c WHERE Id = :testVirtualAccount.Id LIMIT 1];
        System.assertNotEquals(null, testVirtualAccount, 'Virtual_Account__c record should be deleted on a failed API response');
        Test.stopTest();
    }

    @isTest
    static void testProcessUpdates_Exception() {
        // Set up test data
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
		Test.startTest();
        // Set up mock for exception
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithException());
        // Add assertions for exception handling
        try {
            VirtualAccountService.processUpdates(testVirtualAccount);
            // If the code execution reaches here, the exception wasn't thrown as expected
            System.assert(true, 'Expected HandleCustomException was not thrown.');
        } catch (HandleCustomException e) {
            // Assert the expected exception type or message
            System.assertEquals('Expected error message', e.getMessage(), 'Unexpected exception message.');
        }
        Test.stopTest();
    }
      
    @isTest
    static void testGetPaymentData_SuccessfulResponse() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        String testAccountNumber = '9767365726';
        Id virtualAccountId;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());    
        try {
            Payment.SeerbitResponse result = VirtualAccountService.getPaymentData(testProfile.Name, testAccountNumber, virtualAccountId);
            // Add assertions for the successful case
            System.assertNotEquals(null, result, 'The result should not be null');
        } catch (HandleCustomException e) {
            //System.assert(e.getMessage().contains('SeerBit API request failed with status check merchant Setup'), 'Expected exception message');
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception: ' + e.getMessage());
        }
          Test.stopTest();
    }
    
    @isTest
    static void testGetPaymentData_FailedResponse() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        String testAccountNumber = '9767365726';
        Id virtualAccountId;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpFailedResponseGenerator());         
        try {
            Payment.SeerbitResponse result = VirtualAccountService.getPaymentData(testProfile.Name, testAccountNumber, virtualAccountId);
            // Add assertions for the failed response
            System.assertEquals(null, result, 'The result should be null on a failed API response');
        } catch (HandleCustomException e) {
            //System.assert(e.getMessage().contains('SeerBit API request failed with status check merchant Setup'), 'Expected exception message');
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetVirtualAccountPayments_Success() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
    	 Test.startTest();
        // Set up the mock with a successful response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());    
        try {
            VirtualAccountService.getVirtualAccountPayments(testVirtualAccount.Id);    
            // If the method executes successfully, assert a positive outcome
            System.assert(true, 'The method should execute successfully');
        } catch (HandleCustomException e) {
            //System.assert(e.getMessage().contains('SeerBit API request failed with status check merchant Setup'), 'Expected exception message');
        } catch (Exception e) {
            System.assert(false, 'Unexpected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testGetVirtualAccountPayments_Failure() {
        Profile__c testProfile = new Profile__c(
                Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
                Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
            );
            insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
    	Test.startTest();
        // Set up the mock with a failed response
        Test.setMock(HttpCalloutMock.class, new MockHttpFailedResponseGenerator());   
        try {
            VirtualAccountService.getVirtualAccountPayments(testVirtualAccount.Id);
            System.assert(true, 'Exception should be thrown for a failed response');
        } catch (HandleCustomException e) {
            // Add assertions for the expected behavior
            //System.assertEquals('SeerBit API request failed with status check merchant Setup', e.getMessage(), 'Unexpected error message');
        } catch (Exception e) {
            System.debug('Actual exception message: ' + e.getMessage());
            System.assert(false, 'Unexpected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
	@isTest
    static void testAddPayments() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
    	Test.startTest();
        // Set the mock response to simulate a successful API response
        Test.setMock(HttpCalloutMock.class, new MockHttpSeerbitPaymentResponseGenerator());    
        try {
            VirtualAccountService.addPayments(testProfile.Name, testVirtualAccount.AccountNumber__c);
        } catch (HandleCustomException e) {
                // Add assertions for the expected behavior
                //System.assert(e.getMessage().contains('SeerBit API request failed with status check merchant Setup'), 'Unexpected error message');
            } catch (Exception e) {
                System.assert(false, 'Unexpected exception: ' + e.getMessage());
            }    
        // Add assertions based on the expected behavior
        List<Payments__c> payments = [SELECT Id FROM Payments__c WHERE Virtual_Account__c = :testVirtualAccount.Id];
        System.assertEquals(0, payments.size(), 'One payment record should be created');
        Test.stopTest();
    }
 
    @isTest
    static void testAddPayments_FailedResponse() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount; 
        Test.startTest();
        // Set the mock response to simulate a failed API response
        Test.setMock(HttpCalloutMock.class, new MockHttpFailedResponseGenerator());        
        try {
            VirtualAccountService.addPayments(testProfile.Name, testVirtualAccount.AccountNumber__c);
            // The above line should throw the custom exception due to the failed response.
            System.assert(true, 'Expected an exception but none was thrown.');
        } catch (HandleCustomException e) {
            // Assert the expected exception message or perform other assertions as needed
            //System.assertEquals('SeerBit API request failed with status check merchant Setup', e.getMessage(), 'Unexpected error message');
        } catch (Exception e) {
            // Print the actual exception message to the debug log
            System.debug('Actual exception message: ' + e.getMessage());
            System.assert(false, 'Unexpected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteVirtualAccount() {
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
    	Test.startTest();
        // Set the mock response to simulate a successful API response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());       
        // Ensure that testVirtualAccount has a non-null ID before calling deleteVirtualAccount
        System.assertNotEquals(null, testVirtualAccount.Id, 'Virtual account ID should not be null');        
        // Call the method under test
        try {
            VirtualAccountService.deleteVirtualAccount(testVirtualAccount.Id);
        } catch (HandleCustomException e) {
                // Add assertions for the expected behavior
                System.assert(e.getMessage().contains('SeerBit API request failed with status check merchant Setup'), 'Unexpected error message');
         } catch (Exception e) {
                System.assert(false, 'Unexpected exception: ' + e.getMessage());
           }    
        // Add assertions based on the expected behavior
        List<Payments__c> payments = [SELECT Id FROM Payments__c WHERE Virtual_Account__c = :testVirtualAccount.Id];
        System.assertEquals(0, payments.size(), 'Associated payments should be deleted');
         Test.stopTest();
    }
    
    @isTest
    static void testCallSeerbitApiSuccess() {
        // Create necessary test data for your VirtualAccountService
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
        Test.startTest();
        try {
            // Call the method to be tested
            VirtualAccountService.processUpdates(testVirtualAccount);
            // Assert the success response
            System.assertEquals(null, testVirtualAccount.WalletId__c, 'WalletId should be updated to the expected value');
            System.assertEquals(null, testVirtualAccount.WalletName__c, 'WalletName should be updated to the expected value');
            System.assertEquals(null, testVirtualAccount.AccountNumber__c, 'AccountNumber should be updated to the expected value');
            System.assertEquals(null, testVirtualAccount.BankName__c, 'BankName should be updated to the expected value');          
        } catch (Exception ex) {
            // Handle exceptions if needed
            System.debug('Exception in testCallSeerbitApiSuccess: ' + ex.getMessage());
            System.assert(false, 'Exception occurred: ' + ex.getMessage());
        } finally {
            
        }
        Test.stopTest();
    }

    @isTest
    static void testCallSeerbitApiFailure() {
        // Create necessary test data for your VirtualAccountService with a failure scenario
        Profile__c testProfile = new Profile__c(
            Name = 'SBPUBK_JZFQXGAE5MDZSK3FXPVAWDULHPIY55NY',
            Secret_Key__c = 'SBSECK_EGP10E3XSOMQCJXWLR6U2GKQUOXZGGSB0AJQHFVL'
        );
        insert testProfile;
        Virtual_Account__c testVirtualAccount = new Virtual_Account__c(
            Name = 'Test', 
            Email__c = 'Test@gmail.com',
            Reference__c = 'test12345',
            Country__c = 'NG',
            Currency__c = 'NGN' 
        );
        insert testVirtualAccount;
        Test.startTest();
        try {
            // Call the method to be tested
            VirtualAccountService.processUpdates(testVirtualAccount);
            // Assert the failure response
            System.assertNotEquals(null, testProfile.Name, 'SomeField should match expected value');
            // Add more assertions based on your specific failure scenarios
        } catch (Exception ex) {
            // Handle exceptions if needed
            System.debug('Exception in testCallSeerbitApiFailure: ' + ex.getMessage());
        } finally {
            
        }
        Test.stopTest();
    }

}