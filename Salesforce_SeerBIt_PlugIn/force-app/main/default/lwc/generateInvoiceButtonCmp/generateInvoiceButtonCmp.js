import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generateInvoice from '@salesforce/apex/InvoiceService.generateInvoice';
import resendInvoice from '@salesforce/apex/InvoiceService.resendInvoice';
import { RefreshEvent } from 'lightning/refresh';
export default class GenerateInvoiceButton extends LightningElement {
    @api recordId;

    generateInvoice() {
        generateInvoice({ invoiceId: this.recordId })
            .then(result => {
                console.log('Invoice generated successfully:', result);

                // Handle the successful response
                // Update your invoice record with the received data
                const invoiceEvent = new CustomEvent('invoicereceived', {
                    detail: result,
                });
                this.dispatchEvent(invoiceEvent);

                // Display a success toast message
                this.showSuccessToast('Invoice generated successfully');

                // Update the flag to indicate that the invoice has been generated
                this.isInvoiceGenerated = true;
						
                this.dispatchEvent(new RefreshEvent());

            })
            .catch(error => {
                console.error('Error generating invoice:', error);

                // Display an error toast message
                this.showErrorToast('Failed to generate invoice');
            });
    }

    showSuccessToast(message) {
        const event = new ShowToastEvent({
            title: 'Success',
            message: message,
            variant: 'success',
        });
        this.dispatchEvent(event);
    }

    showErrorToast(message) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error',
        });
        this.dispatchEvent(event);
    }
//Resend		
		 handleResendInvoice() {
        debugger;
        resendInvoice({ invoiceId: this.recordId })
            .then(result => {
                console.log(result);
                this.showSuccessToast('Invoice Resent Successfully!');

            })
            .catch(error => {
                console.error(error);
                this.showErrorToast('Error Resending Invoice');
            });
    }
    showSuccessToast(message) {
        const event = new ShowToastEvent({
            title: 'Success',
            message: message,
            variant: 'success',
        });
        this.dispatchEvent(event);
    }

    showErrorToast(message) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error',
        });
        this.dispatchEvent(event);
    }
    connectedCallback() {
        debugger;
    }
	


}