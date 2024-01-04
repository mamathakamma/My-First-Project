import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';
import getVirtualAccountPayments from '@salesforce/apex/VirtualAccountService.getVirtualAccountPayments';

export default class PaymentsCmp extends LightningElement {
    @api recordId;

    refreshDetailPage() {
        console.log('Refreshing Detail Page');

        // Call your API here or perform any other necessary action
        getVirtualAccountPayments({ virtualAccountId: this.recordId })
            .then(response => {
                console.log('API call successful');
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Data refreshed successfully',
                    variant: 'success'
                }));
                this.dispatchEvent(new RefreshEvent());
            })
            .catch(error => {
                console.error('API call failed', error);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: 'Failed to refresh data',
                    variant: 'error'
                }));
            });
    }
}