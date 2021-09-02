import {LightningElement,api,wire,track} from 'lwc';
import getItineraryData from '@salesforce/apex/Auswalk_Logistic.getItineraryData';


export default class AttachLogistics extends LightningElement {
    @track itinerary;
    @api recordId;
    @track AccomodationData;
    @track TransportData;
    @track TOur_AddonData;
    @track GuideData;
    @track MealData;
    @track Aus_MiscData;
    @track NationalParkData;
    @track HscData;
  

    activeSectionMessage = '';
   
    connectedCallback() {
        getItineraryData({
            OrderId:'this.recordId'
        }).then(result => {
            this.itinerary=result;
            console.log('Here in line no 13 ABC------>'+JSON.stringify(this.itinerary));
        })

       
       
    }

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    handleSetActiveSectionC() {
        const accordion = this.template.querySelector('.example-accordion');

        accordion.activeSectionName = 'C';
    }
    handleChange(event){
        console.log('Enter to event');
       let i=event.target.getAttribute('data-id2');
       let j=event.target.getAttribute('data-id1');
       let type=event.target.getAttribute('data-id');
       console.log('value of i 46--->'+i);
       console.log('value of j 47--->'+j);
       console.log('value of type 48--->'+type);
       if(type=='Accomodation'){
       this.AccomodationData=this.itinerary[i].Accomodation[j];
       console.log('value of AccomodationDATA 51--->'+JSON.stringify(this.AccomodationData));
       }
       if(type=='Transport'){
        this.TransportData=this.itinerary[i].Transport[j];
    }
    if(type=='TOur_Addon'){
        this.TOur_AddonData=this.itinerary[i].TOur_Addon[j];
    }
    if(type=='Guide'){
        this.GuideData=this.itinerary[i].Guide[j];
    }
    if(type=='Meal'){
        this.MealData=this.itinerary[i].Meal[j];
    }
    if(type=='Aus_Misc'){
        this.Aus_MiscData=this.itinerary[i].Aus_Misc[j];
    }
    if(type=='NationalPark'){
        this.NationalParkData=this.itinerary[i].NationalPark[j];
    }
    if(type=='Hsc'){
        this.HscData=this.itinerary[i].Hsc[j];
    } 
    }

    
}