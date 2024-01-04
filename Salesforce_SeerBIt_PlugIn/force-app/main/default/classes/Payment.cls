public class Payment{

  public class seerbitResponse {
        public String status;
        public seerbitData data;
    }

  public class seerbitData {
        public String code;
        public List<seerbitPayload> payload;
        public String message;
    }

  public class seerbitPayload {
        public String id;
        public String fullName;
        public String publicKey;
        public Decimal amount;  
        public String country;
        //public String currency;
        public String email;
        public String invoiceNumber;
        public String paymentDate;
        public String paymentLinkId;
        public String paymentLinkReference;
        public String paymentReference;
        public String paymentStatus;
        public String reason;
        public String updatedAt; 
        public String payLinkCustomizationName; 
        public String status; 
    }

}