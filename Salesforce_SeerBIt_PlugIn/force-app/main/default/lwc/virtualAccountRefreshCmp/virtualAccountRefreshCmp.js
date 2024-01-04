import { LightningElement, wire, api ,track} from 'lwc';
import { refreshApex } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation'; // Import NavigationMixin
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';

export default class VirtualAccountRefreshCmp extends LightningElement {
    @api recordId;
		@track loading = true;
    event1;
    shouldAutoRefresh = true; // Flag to control auto-refresh
		
    connectedCallback() {
      /*this.event1 = setInterval(() => {
            this.updateAccountInformation();
        }, 5); */
				// Set to 100 milliseconds for more frequent updates
				 setTimeout(() => {
            this.loading = false;
						 this.updateAccountInformation();
						  this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                  attributes: {
                    recordId: this.recordId,
                    objectApiName: 'Virtual_Account__c',
                    actionName: 'view',
                },
            });
        }, 3000);
    }
		
    updateAccountInformation() {
        if (this.shouldAutoRefresh) {
            //console.log('Updating Account Information');
             this.dispatchEvent(new RefreshEvent());
						 //this.shouldAutoRefresh = false;
						//   this.loading = false; // Show loader
        }
    }
}