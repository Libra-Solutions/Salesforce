import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getChildServiceLocations from '@salesforce/apex/ChildAccountController.getChildServiceLocations';

export default class ProviderServiceLocations extends NavigationMixin(LightningElement) {
    @api recordId;
    @track locations = [];
    @track hasLocations = false;
    @track locationCount = 0;
    @track isExpanded = true;
    get toggleIcon() {
    return this.isExpanded ? 'utility:chevronup' : 'utility:chevrondown';
}

get toggleLabel() {
    return this.isExpanded ? 'Hide' : 'Show';
}
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'button', typeAttributes: { label: { fieldName: 'Name' }, variant: 'base', name: 'view_record' } },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Street', fieldName: 'BillingStreet', type: 'text' },
        { label: 'City', fieldName: 'BillingCity', type: 'text' },
        { label: 'State', fieldName: 'BillingState', type: 'text' },
        { label: 'Zip', fieldName: 'BillingPostalCode', type: 'text' }
    ];

    @wire(getChildServiceLocations, { parentAccountId: '$recordId' })
    wiredLocations({ data, error }) {
        if (data) {
            this.locations = data;
            this.hasLocations = data.length > 0;
            this.locationCount = data.length;
        }
        if (error) {
            console.error(error);
        }
    }

    toggleExpanded() {
        this.isExpanded = !this.isExpanded;
    }

    handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                actionName: 'view'
            }
        });
    }
}