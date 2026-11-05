import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import saveHuntListRows from '@salesforce/apex/HuntListCsvUploadController.saveHuntListRows';

export default class HuntListCsvUploader extends NavigationMixin(LightningElement) {
    fileName = '';
    rows = [];
    uploadErrors = [];
    isUploading = false;

    requiredHeaders = [
        'Firm Name',
        'Firm Address',
        'Postal Code',
        'City',
        'State',
        'Firm Location ID',
        'Category',
        'Oasis Dir',
        'PM Director',
        'Total Orig - YTD',
        'Previous Yr Forecast Orig',
        'Current Year Budget Orig',
        'CMS',
        'CMS Integrated',
        'How many cases per month does your law firm utilize non-healthcare medical liens on?',
        'How many cases per month does your law firm utilize pre-set funding on?',
        "Who's the pre-lit manager?",
        "Who's the litigation manager?",
        'Who is the case manager lead?',
        'Who handles medical map/provider decisions?',
        'Who handles pre-set funding decisions?',
        'Does law firm use competitors for PM or PF?'
    ];

    get uploadDisabled() {
        return this.rows.length === 0 || this.isUploading;
    }

    get jsonPreview() {
        const previewRows = this.rows.slice(0, 2);
        return JSON.stringify(previewRows, null, 2);
    }

    get hasUploadErrors() {
        return this.uploadErrors.length > 0;
    }

    handleFileChange(event) {
        const file = event.target.files && event.target.files[0];
        if (!file) {
            return;
        }

        this.fileName = file.name;
        this.uploadErrors = [];
        const reader = new FileReader();
        reader.onload = () => {
            try {
                const csvText = String(reader.result || '');
                const parsedRows = this.parseCsv(csvText);
                this.validateHeaders(parsedRows.headers);
                this.rows = parsedRows.rows;
            this.uploadErrors = [];
                console.log('Parsed CSV Rows:', this.rows);

                this.showToast(
                    'CSV Parsed',
                    `Converted CSV to JavaScript array with ${this.rows.length} row(s).`,
                    'success'
                );
            } catch (error) {
                this.rows = [];
                this.uploadErrors = [];
                this.showToast('CSV Error', this.getErrorMessage(error), 'error');
            }
        };
        reader.onerror = () => {
            this.rows = [];
            this.uploadErrors = [];
            this.showToast('File Error', 'Unable to read the selected file.', 'error');
        };

        reader.readAsText(file);
    }

    async handleUpload() {
        if (this.rows.length === 0) {
            this.uploadErrors = [];
            this.showToast('Nothing to Upload', 'Upload a CSV file first.', 'warning');
            return;
        }

        this.isUploading = true;
        try {
            const result = await saveHuntListRows({ rowsJson: JSON.stringify(this.rows) });
            const message = `Processed ${result.totalRows} row(s). Success: ${result.successCount}, Errors: ${result.errorCount}.`;

            this.uploadErrors = result.errorCount > 0 ? result.errors || [] : [];

            this.showToast('Upload Complete', message, result.errorCount > 0 ? 'warning' : 'success');
        } catch (error) {
            this.uploadErrors = [];
            this.showToast('Upload Failed', this.getErrorMessage(error), 'error');
        } finally {
            this.isUploading = false;
        }
    }

    handleOpenHuntListView() {
        this[NavigationMixin.Navigate](
            {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Hunt_List__c',
                    actionName: 'list'
                },
                state: {
                    filterName: 'Recent'
                }
            }
        );
    }

    parseCsv(csvText) {
        const rows = [];
        let currentCell = '';
        let currentRow = [];
        let inQuotes = false;

        const pushCell = () => {
            currentRow.push(currentCell);
            currentCell = '';
        };

        const pushRow = () => {
            if (currentRow.length > 0 && currentRow.some((cell) => cell.trim() !== '')) {
                rows.push(currentRow.map((cell) => cell.trim()));
            }
            currentRow = [];
        };

        const normalized = csvText.replace(/\r\n/g, '\n').replace(/\r/g, '\n');

        for (let i = 0; i < normalized.length; i += 1) {
            const char = normalized[i];
            const next = normalized[i + 1];

            if (char === '"') {
                if (inQuotes && next === '"') {
                    currentCell += '"';
                    i += 1;
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (char === ',' && !inQuotes) {
                pushCell();
            } else if (char === '\n' && !inQuotes) {
                pushCell();
                pushRow();
            } else {
                currentCell += char;
            }
        }

        pushCell();
        pushRow();

        if (rows.length === 0) {
            throw new Error('The CSV is empty.');
        }

        const headers = rows[0];
        const dataRows = rows.slice(1);
        const output = dataRows.map((row) => {
            const rowObject = {};
            headers.forEach((header, index) => {
                rowObject[header] = row[index] || '';
            });
            return rowObject;
        });

        return { headers, rows: output };
    }

    validateHeaders(headers) {
        const normalize = (value) => String(value || '').trim().toLowerCase();
        const headerSet = new Set(headers.map(normalize));

        const missing = this.requiredHeaders.filter(
            (expected) => !headerSet.has(normalize(expected))
        );

        if (missing.length > 0) {
            throw new Error(`Missing required CSV column(s): ${missing.join(', ')}`);
        }
    }

    getErrorMessage(error) {
        if (error && error.body && error.body.message) {
            return error.body.message;
        }
        if (error && error.message) {
            return error.message;
        }
        return 'Unknown error';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}