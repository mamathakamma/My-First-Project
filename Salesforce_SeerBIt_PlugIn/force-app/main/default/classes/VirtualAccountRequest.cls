public class VirtualAccountRequest {    
            public String publicKey;
            public String fullName;
            public String bankVerificationNumber;
            public String currency_Z;
            public String country;
            public String reference;
            public String email;

            public VirtualAccountRequest(String publicKey,String fullName, String bankVerificationNumber, String currency_Z, String country, String reference, String email) {
                        this.publicKey = publicKey;
                        this.fullName = fullName;
                        this.bankVerificationNumber = bankVerificationNumber;
                        this.currency_Z = currency_Z;
                        this.country = country;
                        this.reference = reference;
                        this.email = email;
                    }
}