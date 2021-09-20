import { LightningElement, track , api, wire} from 'lwc';
import getTripOptionData from '@salesforce/apex/Auwalk_cloneTripOptionHandlerApex.getTripOptionData';
import cloneTripOption from '@salesforce/apex/Auwalk_cloneTripOptionHandlerApex.cloneTripOption';

export default class Auswalk_tripclone extends LightningElement {

    @track tripOption;
    @track selectedBoxData=[];
    @api recordId;
    @track newOptionName;
    @track newPrice;
    @track newStartDate;
    @track newEndDate;
    @track newSingleOccupancyPrice;

    activeSectionMessage = 'Auswalk Trip Options Clone';

    connectedCallback() {
        console.log("Trip recordId", this.recordId);
        getTripOptionData({
           tripId:this.recordId
           //tripId:'a005D0000070EFSQA2'
        }).then(result => {
            this.tripOption=result;
            console.log('Here in line no 19 ABC------>'+JSON.stringify(this.tripOption));
        })
    }

    checkboxchangeHandler(event){
        console.log('Enter to event '+JSON.stringify(event.target.checked));
        let i=event.target.getAttribute('data-id2');
        console.log('value of i 26--->'+i);
        console.log('Checked Box Values Line 27==> '+JSON.stringify(this.tripOption[i]));

        if(event.target.checked){
        const checkboxData = {
            id:this.tripOption[i].recordId,
            name:this.tripOption[i].tripOptionName,
            price:this.tripOption[i].tripPrice,
            startDate:this.tripOption[i].optionStartDate,
            endDate:this.tripOption[i].optionEndDate,
        }

        this.selectedBoxData.push({
            id:this.tripOption[i].recordId,
            name:this.tripOption[i].tripOptionName,
            type:this.tripOption[i].tripTypeName,
            price:this.tripOption[i].tripPrice,
            startDate:this.tripOption[i].optionStartDate,
            SingleOccupancyPrice:this.tripOption[i].SingleOccupancyPrice,
            endDate:this.tripOption[i].optionEndDate,
        });

        //console.log('Line 51 Selected Trip Option Data ==> '+JSON.stringify(checkboxData));
       // console.log('Line 52 Selected Trip Option Data ==> '+JSON.stringify(checkboxData.name));
        console.log('Line 53 Selected Trip Option Data ==> '+JSON.stringify(this.selectedBoxData));


        for(var a=0;a<this.selectedBoxData.length;a++){
            //console.log('Line 45 Selected Trip Option Data ==> '+JSON.stringify(this.selectedBoxData[a].name));

            if(checkboxData.name!==this.selectedBoxData[a].name){
                console.log('Line 59 Selected Trip Option Data ==> '+JSON.stringify(checkboxData.name));
                console.log('Line 60 Fetch Name from Array ==> '+JSON.stringify(this.selectedBoxData[a].name));
                this.selectedBoxData.splice(a,1);
                console.log('After Splice line 62 '+JSON.stringify(this.selectedBoxData));
            }
        }
    }
}

optionNamChangeHandler(event){
    let inputboxNameValue = event.target.value;
    console.log('Line 70 -- inputboxOptionName > '+inputboxNameValue);
    this.newOptionName=inputboxNameValue;

}

priceChangeHandler(event){
    let inputboxPriceValue = event.target.value;
    console.log('Line 77 -- inputboxOptionName > '+inputboxPriceValue);
    this.newPrice = inputboxPriceValue;

}
startDateChangeHandler(event){
    let inputboxStartDateValue = event.target.value;
    console.log('Line 83 -- inputboxOptionName > '+inputboxStartDateValue);
    this.newStartDate =inputboxStartDateValue;

}
endDateChangeHandler(event){
    let inputboxEndDateValue = event.target.value;
    console.log('Line 89 -- inputboxOptionName > '+inputboxEndDateValue);
    this.newEndDate =inputboxEndDateValue;

}

SingleOccupancyPriceChangeHandler(event){
    let inputboxSingleOccupancyValue = event.target.value;
    console.log('Line 100 -- inputboxOptionName > '+inputboxSingleOccupancyValue);
    this.newSingleOccupancyPrice =inputboxSingleOccupancyValue;
}

cloneClickHandler(){

    let newSelectedBoxData = [...this.selectedBoxData];
    console.log('Line 135 newSelectedBoxData--> '+newSelectedBoxData.length);
    console.log('this.newOptionName '+this.newOptionName);

    newSelectedBoxData[0].name=this.newOptionName;
    newSelectedBoxData[0].price=this.newPrice;
    newSelectedBoxData[0].SingleOccupancyPrice=this.newSingleOccupancyPrice;
    newSelectedBoxData[0].startDate=this.newStartDate;
    newSelectedBoxData[0].endDate=this.newEndDate;
    
    console.log('Line No 142 update new data '+JSON.stringify(this.selectedBoxData));
    const newDataList = {
        optionRecordId:this.selectedBoxData[0].id,
        tripOptionNewName:this.selectedBoxData[0].name,
        price:this.selectedBoxData[0].price,
        startDate:this.selectedBoxData[0].startDate,
        endDate:this.selectedBoxData[0].endDate,
    }
    console.log('New Data List Line 153--> '+JSON.stringify(newDataList));

    cloneTripOption({
        Message:'Data From JavaScript',
        optionRecordId:this.selectedBoxData[0].id,
        tripOptionNewName:this.selectedBoxData[0].name,
        price:this.selectedBoxData[0].price,
        startDate:this.selectedBoxData[0].startDate,
        endDate:this.selectedBoxData[0].endDate,
        newSinglePrice:this.selectedBoxData[0].SingleOccupancyPrice,
        cloneDataList:JSON.stringify(this.selectedBoxData),
    }).then((result) => {
        if(result){
            const evt = new ShowToastEvent({
           
                message: 'Record is cloned successfully!',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            console.log('FromApex ',JSON.stringify(data));
    }
    }).catch(error => {
       console.log('Error in adding data '+error);
    });
    this.selectedBoxData = [];
}
cancelClickHandler(){
    console.log('In Cancel Click Event');
    this.tripOption = '';
}
}