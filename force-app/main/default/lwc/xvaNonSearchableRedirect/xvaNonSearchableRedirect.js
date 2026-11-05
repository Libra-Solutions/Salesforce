import { LightningElement, api, wire } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import getCashtraxRedirectAccountId from '@salesforce/apex/XVA_NonSearchableRedirectController.getCashtraxRedirectAccountId';

export default class XvaNonSearchableRedirect extends NavigationMixin(LightningElement)
{

    @api recordId;
    redirectResult = {
        shouldRedirect: false,
        redirectId: null,
        redirectName: null
    };
    displayNotice = false;
    displayUrl = '';

    @wire(getCashtraxRedirectAccountId , { recordId: '$recordId' }) 
    wiredRedirectAccountId({ error, data }) 
    {
        console.log('wired data:',data);
        if (data) 
        {
            this.redirectResult = data;
            if (this.redirectResult.shouldRedirect && this.redirectResult.redirectId)
                this.navigateToCashtraxAccount(this.redirectResult.redirectId);

            if (this.redirectResult.shouldRedirect === false && this.redirectResult.redirectName)
            {
                this.displayNotice = true;
                this.displayUrl = '/' + this.redirectResult.redirectId;
            }
        } 
        else if (error) 
        {
            console.error('Error fetching Cashtrax Redirect Account Id:', error);
        }
    }

    navigateToCashtraxAccount(accountId) 
    {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

}