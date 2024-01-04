import { LightningElement, wire, api } from 'lwc';
import { refreshApex } from 'lightning/uiRecordApi';
//import updateVirtualAccountAura from '@salesforce/apex/VirtualAccountDataAccess.updateVirtualAccountAura';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';

export default class WebhookAutoRefreshCmp extends LightningElement {
    @api  recordId;
    event1;
    shouldAutoRefresh = true; // Flag to control auto-refresh

    connectedCallback() {
        this.event1 = setInterval(() => {
            this.updateAccountInformation();
        }, 3000); // Set to 100 milliseconds for more frequent updates
    }
		
    updateAccountInformation() {
        if (this.shouldAutoRefresh) {
             this.dispatchEvent(new RefreshEvent());
						 //this.shouldAutoRefresh = false; 
        }
    }
}