public class SeerbitRequest {
        public String publicKey;
        public String orderNo;
        public String dueDate;
        public String currency_z;
        public String receiversName;
        public String customerEmail;
        public List<InvoiceItem> invoiceItems;

        // Constructor to initialize the public key
        public SeerbitRequest(String publicKey) {
            this.publicKey = publicKey;
        }

        // Inner class for invoice items
        public class InvoiceItem {
            public String itemName;
            public Integer quantity;
            public Decimal rate;
            public Decimal tax;
        }
}