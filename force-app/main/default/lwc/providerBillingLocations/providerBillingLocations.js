import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ACCOUNT_TYPE from '@salesforce/schema/Account.Type';
import getChildBillingLocations from '@salesforce/apex/ChildAccountController.getChildBillingLocations';

export default class ProviderBillingLocations extends NavigationMixin(LightningElement) {
    @api recordId;
    @track locations = [];
    @track hasLocations = false;
    @track locationCount = 0;
    @track isExpanded = true;

    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_TYPE] })
    currentAccount;

    get isEnterpriseLocation() {
        return getFieldValue(this.currentAccount.data, ACCOUNT_TYPE) === 'Provider: Enterprise';
    }

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

    @wire(getChildBillingLocations, { parentAccountId: '$recordId' })
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