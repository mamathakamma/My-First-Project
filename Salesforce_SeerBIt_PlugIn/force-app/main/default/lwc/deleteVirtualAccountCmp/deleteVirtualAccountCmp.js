import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from 'lightning/refresh';
import deleteVirtualAccount  from '@salesforce/apex/VirtualAccountDataAccess.deleteVirtualAccount';
export default class DeleteVirtualAccountCmp extends LightningElement {

    refreshDetailPage() {
        console.log('Refreshing Detail Page');
        this.dispatchEvent(new RefreshEvent());  
    }
    @api recordId;
    deleteVirtualAccountFromAPI() {
        debugger;
        console.log('Refreshing Payment Information');
        deleteVirtualAccount({ virtualAccountId: this.recordId})
            .then(response => {
                debugger;
                if(response.success){
                    const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Virtual Account deleted.',
                    variant: 'success',
                    mode: 'success'
                    });
                    this.dispatchEvent(evt);
                    this.event1 = setTimeout(() => {
                        this.gotoListPage();
                    }, 5000);
                }
            })
            .catch(error => {
                debugger;
            });
    }
    gotoListPage(){
        window.location.href = window.location.origin+'/lightning/o/Virtual_Account__c/list';
    }
}