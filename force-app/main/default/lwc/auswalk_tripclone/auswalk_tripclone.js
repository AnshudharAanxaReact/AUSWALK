import { LightningElement, track , api, wire} from 'lwc';
import getTripOptionData from '@salesforce/apex/Auswalk_tripcloneApexHandler.getTripOptionData';
import cloneTripOption from '@salesforce/apex/Auswalk_tripcloneApexHandler.cloneTripOption';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Auswalk_tripclone extends LightningElement {

    @track tripOption;
    @track tripOptiontableData;
    @track triplist=[];
    @track Itinerary;
    @api recordId;
    @track getNewTripOptionInfo=[];
    @track inputTextValue;
    @track inputFromDateValue;
    @track inputToDateValue;

    activeSectionMessage = 'Trip Options Clone';

    connectedCallback() {
        console.log("Trip recordId", this.recordId);
        getTripOptionData({
           tripId:this.recordId
           //tripId:'a005D0000070EFSQA2'
        }).then(result => {
            this.tripOption=result;
            console.log('Here in line no 13 ABC------>'+JSON.stringify(this.tripOption));
        })

    }

    cloneHandleClick(){

        console.log('list---34 ',JSON.stringify(this.triplist));

        cloneTripOption({
            cloneDataList: JSON.stringify(this.triplist)
        }).then((result) => {
            if(result){
                const evt = new ShowToastEvent({
               
                    message: 'Record is saved successfully!',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
           
             
                console.log('FromApex ',JSON.stringify(data));
        }
        }).catch(error => {
           console.log('Error in adding data '+error);
        });
        this.triplist = [];
    }
    checkboxchangeHandler(event){
        console.log('Enter to event '+event.target.checked);
        let i=event.target.getAttribute('data-id2');
        console.log('value of i 22--->'+i);
        let type=event.target.getAttribute('data-id');
        console.log('value of type 26--->'+type);

       console.log('Trip Option '+this.tripOption[i].tripOptionName);
       console.log('Trip Option Line 29 '+this.tripOption[i].showitinerary);
       console.log('Trip Option Line 30 '+JSON.stringify(this.tripOption[i].Itinerary));
        
        if(event.target.checked){
        if(type=='option'){
            this.tripOptiontableData=this.tripOption[i];
           // console.log('tripOptiontableData line 70.'+JSON.stringify(this.tripOptiontableData.tripOptionName));
        }

        this.triplist.push({
            optionname:this.tripOptiontableData.tripOptionName,
            optiontype:this.tripOptiontableData.tripTypeName,
            optionprise:this.tripOptiontableData.tripPrice,
            optionNewName:'',
            optionNewFromDate:'',
            optionNewToDate:'',
        });
        console.log('triplist line 82 '+JSON.stringify(this.triplist));
       console.log('triplist line 46 '+JSON.stringify(this.tripOptiontableData.Itinerary));
    }

    else{
        console.log('tripOption Line 86 '+JSON.stringify(this.tripOption[i]));
        this.tripOptiontableData=this.tripOption[i];
        console.log('tripOptiontableData line 51'+JSON.stringify(this.tripOptiontableData));
       console.log('triplist line 87 '+this.triplist.length);

        for(var t=0;t<this.triplist.length;t++){
            console.log('triplist line 90 '+JSON.stringify(this.triplist[t].optionname));
            console.log('triplist line 91 '+JSON.stringify(this.tripOption[i].tripOptionName));

            if(this.tripOption[i].tripOptionName == this.triplist[t].optionname){
                this.triplist.splice(t,1);
             console.log('triplist line 95 '+JSON.stringify(this.triplist));
            }
        }

    }
}

NameChangeHandler(event){
    let i = event.target.value;
    console.log('Line number 104 inputOptionName ==> '+i);
    this.inputTextValue=i;

}
fromDateChangeHandler(event){
    let i = event.target.value;
    console.log('Line number 111 inputOptionName ==> '+i);
    this.inputFromDateValue=i;
}
toDateChangeHandler(event){
    let i = event.target.value;
    console.log('Line number 116 inputOptionName ==> '+i);
    this.inputToDateValue=i;
}
addNewDataHandler(){   
    console.log('triplist line 120 '+JSON.stringify(this.triplist));
    console.log('triplist line 121 '+JSON.stringify(this.triplist.length));

    let newtriplist = [...this.triplist];
    //console.log('triplist line 124 '+JSON.stringify(this.newtriplist.optionNewName));

    newtriplist[0].optionNewName=this.inputTextValue;
    newtriplist[0].optionNewFromDate=this.inputFromDateValue;
    newtriplist[0].optionNewToDate=this.inputToDateValue;

    console.log('triplist line 130 '+JSON.stringify(this.triplist));

}
}