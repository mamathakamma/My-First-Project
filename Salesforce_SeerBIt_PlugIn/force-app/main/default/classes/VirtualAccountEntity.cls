public class VirtualAccountEntity {

// variables 
    private String fullName { get; set; }
    private String accountNumber { get; set; }
   // private String amount { get; set; }
    private String bankName { get; set; }
    private String currency_z { get; set; }
    private String country { get; set; }
    private String reference { get; set; }
    private String email { get; set; }
    private String walletId { get; set; }
    private String walletName { get; set; }

    public VirtualAccountEntity(String fullName, String accountNumber, String amount,
                                String bankName, String currency_z, String country,
                                String reference, String email, String walletId, String walletName) {
        this.fullName = fullName;
        this.accountNumber = accountNumber;
       // this.amount = amount;
        this.bankName = bankName;
        this.currency_z = currency_z;
        this.country = country;
        this.reference = reference;
        this.email = email;
        this.walletId = walletId;
        this.walletName = walletName;
    }

    // Getter and Setter methods for each property
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }



    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getCurrency() {
        return currency_z;
    }

    public void setCurrency(String currency_z) {
        this.currency_z = currency_z;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getWalletId() {
        return walletId;
    }

    public void setWalletId(String walletId) {
        this.walletId = walletId;
    }

    public String getWalletName() {
        return walletName;
    }

    public void setWalletName(String walletName) {
        this.walletName = walletName;
    }
}