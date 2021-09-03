import {LightningElement,api,wire,track} from 'lwc';
import getItineraryData from '@salesforce/apex/Auswalk_Logistic.getItineraryData';
import saveLogistic from '@salesforce/apex/Auswalk_Logistic.saveLogistic';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AttachLogistics extends LightningElement {
    @track tableData;
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
    @track list=[];
    @track isChecked = false;

    

  activeSectionMessage = '';
   
    connectedCallback() {
        console.log('orderid line 34====>'+this.recordId);
        getItineraryData({
            OrderId:this.recordId
            
           
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
    saveClick(){
        console.log('list---51 ',JSON.stringify(this.list));
        saveLogistic({
            saveData: this.list
            
        }).then((data)=>{
          
            const evt = new ShowToastEvent({
               
                message: 'Record is saved successfully!',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        
         
            console.log('FromApex ',JSON.stringify(data));
            
    
        }).catch((error)=>{
            console.log('FromApex ',JSON.stringify(error));
        });
        this.list=[];
        
    }
    handleChange(event){
        console.log('Enter to event'+event.target.checked);
       let i=event.target.getAttribute('data-id2');
       let j=event.target.getAttribute('data-id1');
       let type=event.target.getAttribute('data-id');
       console.log('value of i 46--->'+i);
       console.log('value of j 47--->'+j);
       console.log('value of type 48--->'+type);
       console.log('Iternary days===dayName.'+this.itinerary[i].dayName);
       if(event.target.checked){
 

        if(type=='Accomodation'){
            this.tableData=this.itinerary[i].Accomodation[j];  
            console.log('TransportShow 9===>.'+JSON.stringify(this.itinerary[i].Accomodation[j])); 
        }
            if(type=='Transport'){
                this.tableData=this.itinerary[i].Transport[j];
                console.log('TransportShow 9===>.'+JSON.stringify(this.itinerary[i].Transport[j]));
              
         }
         if(type=='TOur_Addon'){
            this.tableData=this.itinerary[i].TOur_Addon[j];
     
         }
         if(type=='Guide'){
            this.tableData=this.itinerary[i].Guide[j];
         }
         if(type=='Meal'){
            this.tableData=this.itinerary[i].Meal[j];
         }
         if(type=='Aus_Misc'){
            this.tableData=this.itinerary[i].Aus_Misc[j];
         }
         if(type=='NationalPark'){
            this.tableData=this.itinerary[i].NationalPark[j];
         }
         if(type=='Hsc'){
            this.tableData=this.itinerary[i].Hsc[j];
         } 
           
        
           
       /* this.TransportData=this.itinerary[i].type[j];*/
       console.log('transport91-->'+JSON.stringify(this.tableData));
        
        
       this.list.push({
            SupplierType: type,
            Title: this.tableData.Name,
            Information : this.tableData.Comments,
            Day: this.itinerary[i].dayName
        });
        console.log('List Details===>70'+JSON.stringify(this.list));
       }
       else{
        if(type=='Accomodation'){
            this.tableData=this.itinerary[i].Accomodation[j];  
            console.log('TransportShow 9===>.'+JSON.stringify(this.itinerary[i].Accomodation[j])); 
        }
            if(type=='Transport'){
                this.tableData=this.itinerary[i].Transport[j];
                console.log('TransportShow 9===>.'+JSON.stringify(this.itinerary[i].Transport[j]));
              
         }
         if(type=='TOur_Addon'){
            this.tableData=this.itinerary[i].TOur_Addon[j];
     
         }
         if(type=='Guide'){
            this.tableData=this.itinerary[i].Guide[j];
         }
         if(type=='Meal'){
            this.tableData=this.itinerary[i].Meal[j];
         }
         if(type=='Aus_Misc'){
            this.tableData=this.itinerary[i].Aus_Misc[j];
         }
         if(type=='NationalPark'){
            this.tableData=this.itinerary[i].NationalPark[j];
         }
         if(type=='Hsc'){
            this.tableData=this.itinerary[i].Hsc[j];

         }
           for(var m=0; m<this.list.length; m++)
           {
              console.log('Iternary loop 135-->'+this.itinerary[m].dayName+'List day----->'+this.list[m].Day);
              console.log('Iternary Name 136-->'+this.tableData.Name +'List Title----->'+this.list[m].Title);

           if( this.itinerary[i].dayName==this.list[m].Day && this.tableData.Name==this.list[m].Title)

           {
            console.log('list Start--');

             this.list.splice(m,1);
             console.log('listRemove 138--'+JSON.stringify(this.list));
           }
           }

       }

       
      
    }

    
}