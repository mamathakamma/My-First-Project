public class SeerbitResponse{
        public String message;
        public Payload payload;
        public String code;

        // Inner class for payload
        public class Payload {
            public Integer InvoiceID;
            public String InvoiceNo;
        }
}