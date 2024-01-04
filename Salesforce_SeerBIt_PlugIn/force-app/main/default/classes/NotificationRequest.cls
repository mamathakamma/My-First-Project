global class NotificationRequest {

    public List<NotificationRequestItem> notificationItems;

    public class NotificationRequestItem {
        public String eventType;
        public String eventDate;
        public String eventId;
        public Data data;

        public NotificationRequestItem(String eventType, String eventDate, String eventId, Data data) {
            this.eventType = eventType;
            this.eventDate = eventDate;
            this.eventId = eventId;
            this.data = data;
        }
    }

    public class Data {
        public Decimal amount;
        public String country;
        public String creditAccountName;
        public String creditAccountNumber;
        public String currency_z;
        public String email;
        public String externalReference;
        public String fullname;
        public String gatewayCode;
        public String code;
        public String internalRef;
        public String gatewayMessage;
        public String mobile;
        public String narration;
        public String origin;
        public String originatorAccountnumber;
        public String originatorName;
        public String publicKey;
        public String reference;
        public String reason;

        public Data(Decimal amount, String country, String creditAccountName, String creditAccountNumber, String currency_z,
                    String email, String externalReference, String fullname, String gatewayCode, String code, String internalRef,
                    String gatewayMessage, String mobile, String narration, String origin, String originatorAccountnumber,
                    String originatorName, String publicKey, String reference, String reason) {
            this.amount = amount;
            this.country = country;
            this.creditAccountName = creditAccountName;
            this.creditAccountNumber = creditAccountNumber;
            this.currency_z = currency_z;
            this.email = email;
            this.externalReference = externalReference;
            this.fullname = fullname;
            this.gatewayCode = gatewayCode;
            this.code = code;
            this.internalRef = internalRef;
            this.gatewayMessage = gatewayMessage;
            this.mobile = mobile;
            this.narration = narration;
            this.origin = origin;
            this.originatorAccountnumber = originatorAccountnumber;
            this.originatorName = originatorName;
            this.publicKey = publicKey;
            this.reference = reference;
            this.reason = reason;
        }
    }
}