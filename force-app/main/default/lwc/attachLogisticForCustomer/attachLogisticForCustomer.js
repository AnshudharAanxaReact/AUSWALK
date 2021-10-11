import {LightningElement,api,wire,track} from 'lwc';
import getItineraryData from '@salesforce/apex/AttachLogisticForCustomer.getItineraryData';
import getOLIData from '@salesforce/apex/AttachLogisticForCustomer.getOLIData';
import deleteOrderLogistics from '@salesforce/apex/AttachLogisticForCustomer.deleteOrderLogistics';
import saveLogistic from '@salesforce/apex/AttachLogisticForCustomer.saveLogistic';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AttachLogisticForCustomer extends LightningElement {
    @track tableData;
    @track itinerary=[];
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
    @track isGeneric = true;
    @track options;
    @track orderlogistics = [];
    @track selectedOlList =[];
    @track generallogistics;
    @track roomSubtype = '';
    @track passengerQty = 0;
    @track selectedOliDataTable;
    @track glTrue = false;
    activeSectionMessage = '';
    
    connectedCallback() {
        console.log('orderid line 27getId=zx===>'+this.recordId);
        getOLIData({
            OrderId:this.recordId
            
        }).then(result => {
           // this.itinerary=result.ITR;
            this.options=result.OLI;
            console.log('Here in line no 37 OLI12-kl---->'+JSON.stringify(result));
          
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
         console.log('list---55 ',JSON.stringify(this.list));
        console.log('OLI Selected Data Line 56'+JSON.stringify(this.selectedOliDataTable));
      //  console.log('OLI Selected '+this.selectedOliDataTable.oliID);
    if(this.selectedOliDataTable){
    console.log('OLI Selected true');
    console.log('selectedOlListt Length'+JSON.stringify(this.selectedOlList));
    if(this.list.length > 0){
        saveLogistic({
            saveData: this.list,
            olirecordIDData:this.selectedOliDataTable.oliID,
            passtype:this.selectedOliDataTable.oliPassType,
            orderid:this.recordId,
            deleteorderLogistics:this.selectedOlList
    
        }).then((data)=>{
            
            const evt = new ShowToastEvent({
                message: 'Record is saved successfully!',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        
            const selectedEvent = new CustomEvent('selected', { detail: '' });
            // Dispatches the event for close popup window.
            this.dispatchEvent(selectedEvent);
            console.log('FromApex ',JSON.stringify(data));
            
    
        }).catch((error)=>{
            console.log('FromApex ',JSON.stringify(error));
        });
        this.list=[];  
    }else{
        const evt = new ShowToastEvent({
            message: 'No Data Is Available In Booking Supplier Record',
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }

    }else{
    console.log('OLI Selected false');
    const evt = new ShowToastEvent({
        message: 'Please select OLI',
        variant: 'error',
    });
    this.dispatchEvent(evt);
    }
        
        
    }

    oliSelectChangeHandler(event){
        this.list=[];  
        this.itinerary=[];
        console.log('Enter to event'+JSON.stringify(event.target.checked));
       
        let i=event.target.getAttribute('data-id2');
        this.roomSubtype=this.options[i].passengerType;
        this.passengerQty=this.options[i].passengerQuantity;
        console.log('value of i 83--->'+i);
        console.log('Checked Box Values Line 84==> '+JSON.stringify(this.options[i]));

        if(event.target.checked){
        this.selectedOliDataTable = {
            oliID:this.options[i].oliRecordId,
            oliName:this.options[i].value,
            oliPassType:this.options[i].passengerType,
        }
        console.log('Get OLI ID--->'+this.options[i].oliRecordId);
       
        getItineraryData({
            OrderId:this.recordId ,
            oliID:this.options[i].oliRecordId,
            oliPassType:this.options[i].passengerType,
            
        }).then(result => {
            this.itinerary=result.ITR;
            //  this.options=result.OLI;
            console.log('Here in line no underOli Abc------>');
            this.generallogistics=result.GLIBS;
            console.log('Here in lineGeneralLog-asasa---->'+JSON.stringify(this.generallogistics));
           console.log('Here in line no 37 OLI12------>'+JSON.stringify(result));
           this.orderlogistics=result.OLL;
            if(result.GLIBS.length>0){
                this.glTrue=true;
                console.log('GLis true------>');
            }
       /*     for(var m=0; m<this.itinerary.length; m++){
            //  console.log('underItinerary ABC------>'+this.itinerary[m].dayName);
                    if(this.itinerary[m].dayName =='Pre-Trip'){
                //    console.log('underDay1------>');
                this.isGeneric=false;
                        for(var acc =0;acc<this.itinerary[m].Accomodation.length;acc++){
                        //  console.log('SupplierTypee------>'+this.itinerary[m].Accomodation[acc].Name);
                        //  console.log('Information------>'+this.itinerary[m].Accomodation[acc].Roomtype[0].label);
                        
        this.list.push({
        SupplierType: 'Accomodation',
        Title: this.itinerary[m].Accomodation[acc].Name,
        Information : this.itinerary[m].Accomodation[acc].Roomtype[0].value ==undefined?'':this.itinerary[m].Accomodation[acc].Roomtype[0].value,
        Day: this.itinerary[m].dayName,
        Price:this.itinerary[m].Accomodation[acc].logisticPricing[0].price ==undefined?'':this.itinerary[m].Accomodation[acc].logisticPricing[0].price,
    });  


                        }


                    }

            }   */

        })

        console.log('Select Checkbox Data: Line 91 '+JSON.stringify(this.selectedOliDataTable));
    }
    }

    handleChange(event){ 
        console.log('Select itinerary Data: Line 91 '+JSON.stringify(this.itinerary));

        console.log('Enter to event'+event.target.checked);
        let i=event.target.getAttribute('data-id2');
        let j=event.target.getAttribute('data-id1');
        let type=event.target.getAttribute('data-id');
        console.log('value of i 100--->'+i);
        console.log('value of j 101--->'+j);
        console.log('value of type 102--->'+type);
        console.log('Iternary days===dayName.'+this.itinerary[i].dayName);
        if(event.target.checked){
    

        if(type=='Accomodation'){
            this.tableData=this.itinerary[i].Accomodation[j];  
            console.log('Accomodation ===>.'+JSON.stringify(this.itinerary[i].Accomodation[j])); 
            //  console.log('Logistics Pricing 110 ===>.'+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing[0].price));  
        }
            if(type=='Transport'){
                this.tableData=this.itinerary[i].Transport[j];
               // document.getElementById("inputid").value = 4000;  
                console.log('TransportShow 114 ===>.'+JSON.stringify(this.itinerary[i].Transport[j]));
            //    console.log('Logistics Pricing 115 ===>.'+JSON.stringify(this.itinerary[i].Transport[j].logisticPricing)); 
            }
            if(type=='TOur_Addon'){
            this.tableData=this.itinerary[i].TOur_Addon[j];
        
            }
            if(type=='Guide'){
            this.tableData=this.itinerary[i].Guide[j];
            }
            if(type=='Meal'){
            this.tableData=this.itinerary[i].Meal[j];
            // console.log('Logistics Pricing 126 ===>.'+JSON.stringify(this.itinerary[i].Meal[j].logisticPricing)); 
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
        console.log('transport 141 -->'+JSON.stringify(this.tableData));
        
        
        this.list.push({
            SupplierType: type,
            Title: this.tableData.Name,
            Information : this.tableData.Title,
            Day: this.itinerary[i].dayName,
        });
        console.log('List Details===>150'+JSON.stringify(this.list));
        }
        else{
        if(type=='Accomodation'){
            this.tableData=this.itinerary[i].Accomodation[j];  
            console.log('Accomodation 155 ===>.'+JSON.stringify(this.itinerary[i].Accomodation[j])); 
        }
            if(type=='Transport'){
                this.tableData=this.itinerary[i].Transport[j];
                console.log('TransportShow 159===>.'+JSON.stringify(this.itinerary[i].Transport[j]));
                
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
                console.log('Iternary loop 184-->'+this.itinerary[m].dayName+'List day----->'+this.list[m].Day);
                console.log('Iternary Name 185-->'+this.tableData.Name +'List Title----->'+this.list[m].Title);

            if( this.itinerary[i].dayName==this.list[m].Day && this.tableData.Name==this.list[m].Title)

            {
            console.log('list Start--');

                this.list.splice(m,1);
                console.log('listRemove 193--'+JSON.stringify(this.list));
            }
            }

        }
    }

    accLogisticPricingChangeHandler(event){
        let i=event.target.getAttribute('data-id2');
        let j=event.target.getAttribute('data-id1');
        let type=event.target.getAttribute('data-id');
        console.log('value of i Logistic Price--->'+i);
        console.log('value of j Logistic Price--->'+j);
        console.log('value of type Logistic Price--->'+type);

        let elementValue = event.target.value;
            console.log('Line 208 '+elementValue);

        if(type=='Accomodation'){
            console.log('Accomodation Price Line 213 ==>.'+JSON.stringify(this.itinerary[i].Accomodation[j]));
            console.log('Accomodation Price Line 214 ===>.'+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing));
            console.log('Logistic Pricing This.list-->'+JSON.stringify(this.list));

            console.log('List Length 217-->'+JSON.stringify(this.list.length));

            for(var m=0;m<this.list.length;m++){
                console.log('Line 203 '+JSON.stringify(this.list[m].Title));
                    if(this.itinerary[i].Accomodation[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedata -'+JSON.stringify(this.list[m]));
                        let newlist = [...this.list];
                        console.log('Logistic Pricing length '+this.itinerary[i].Accomodation[j].logisticPricing.length);
                        if(this.itinerary[i].Accomodation[j].logisticPricing.length>0){
                            for(var a=0;a<this.itinerary[i].Accomodation[j].logisticPricing.length;a++){
                                console.log('Logistic Pricing  '+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing[a]));
                                if(elementValue===this.itinerary[i].Accomodation[j].logisticPricing[a].value){
                                    console.log('Price of Selected Logistic pricingdsd '+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing[a].price));
                                  let checkvalue=true;

                                    for(var k=0;k<this.itinerary[i].Accomodation[j].priceCategoryList.length;k++){
                                        console.log('Line priceCategory '+this.list[m].priceCategory);
                                        console.log('Line priceCategory fromarray-----> '+this.itinerary[i].Accomodation[j].priceCategoryList[k].value);
                                          if(this.itinerary[i].Accomodation[j].priceCategoryList[k].value==this.list[m].priceCategory){
                                              console.log('Ander gya ');
                                              checkvalue=false;
                                             // console.log('Price of Selected Logistic pricing '+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing[a].price));
                                             if(this.itinerary[i].Accomodation[j].priceCategoryList[k].value =='Per Pax'){
                                              newlist[m].Price= this.itinerary[i].Accomodation[j].logisticPricing[a].price*this.passengerQty;
                                              newlist[m].lpValue=this.itinerary[i].Accomodation[j].logisticPricing[a].value;
                                             }else{
                                              newlist[m].Price= this.itinerary[i].Accomodation[j].logisticPricing[a].price;
                                              newlist[m].lpValue=this.itinerary[i].Accomodation[j].logisticPricing[a].value;
                                             }
                                          }
                                        
                                      }

                                      if(checkvalue){
                                        newlist[m].Price=this.itinerary[i].Accomodation[j].logisticPricing[a].price;
                                        newlist[m].lpValue=this.itinerary[i].Accomodation[j].logisticPricing[a].value; 
                                    }







                                }
                            }
                        }
                    }
                }
            console.log('Line 237 logistic price add '+JSON.stringify(this.list));
        }
        if(type=='Transport'){
            console.log('Transport Price Line 240 ==>.'+JSON.stringify(this.itinerary[i].Transport[j]));
            console.log('Transport Price Line 241 ===>.'+JSON.stringify(this.itinerary[i].Transport[j].logisticPricing));
            console.log('Logistic Pricing This.list-->'+JSON.stringify(this.list));

            console.log('List Length 215-->'+JSON.stringify(this.list.length));

            for(var m=0;m<this.list.length;m++){
                console.log('Line 247 '+JSON.stringify(this.list[m].Title));
                    if(this.itinerary[i].Transport[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedata -'+JSON.stringify(this.list[m]));
                        let newlist = [...this.list];
                        console.log('Logistic Pricing length '+this.itinerary[i].Transport[j].logisticPricing.length);
                        if(this.itinerary[i].Transport[j].logisticPricing.length>0){
                            for(var a=0;a<this.itinerary[i].Transport[j].logisticPricing.length;a++){
                                console.log('Logistic Pricing  '+JSON.stringify(this.itinerary[i].Transport[j].logisticPricing[a]));
                                if(elementValue===this.itinerary[i].Transport[j].logisticPricing[a].value){
                                    console.log('Price of Selected Logistic pricing '+JSON.stringify(this.itinerary[i].Transport[j].logisticPricing[a].price));
                                    
                                    newlist[m].Price=this.itinerary[i].Transport[j].logisticPricing[a].price;
                                }
                            }
                        }
                    }
                }
            console.log('Line 264 logistic price add '+JSON.stringify(this.list));
        }
        if(type=='Meal'){
            console.log('Meal Price Line 267 ==>.'+JSON.stringify(this.itinerary[i].Meal[j]));
            console.log('Meal Price Line 268 ===>.'+JSON.stringify(this.itinerary[i].Meal[j].logisticPricing));
            console.log('Meal Pricing This.list-->'+JSON.stringify(this.list));

            console.log('List Length 271-->'+JSON.stringify(this.list.length));

            for(var m=0;m<this.list.length;m++){
                console.log('Line 274 '+JSON.stringify(this.list[m].Title));
                    if(this.itinerary[i].Meal[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedata -'+JSON.stringify(this.list[m]));
                        let newlist = [...this.list];
                        console.log('Logistic Pricing length '+this.itinerary[i].Meal[j].logisticPricing.length);
                        if(this.itinerary[i].Meal[j].logisticPricing.length>0){
                            for(var a=0;a<this.itinerary[i].Meal[j].logisticPricing.length;a++){
                                console.log('Logistic Pricing  '+JSON.stringify(this.itinerary[i].Meal[j].logisticPricing[a]));
                                if(elementValue===this.itinerary[i].Meal[j].logisticPricing[a].value){
                                    console.log('Price of Selected Logistic pricing '+JSON.stringify(this.itinerary[i].Meal[j].logisticPricing[a].price));
                                    
                                    let checkvalue=true;

                                    for(var k=0;k<this.itinerary[i].Meal[j].priceCategoryList.length;k++){
                                        console.log('Line priceCategory '+this.list[m].priceCategory);
                                        console.log('Line priceCategory fromarray-----> '+this.itinerary[i].Meal[j].priceCategoryList[k].value);
                                          if(this.itinerary[i].Meal[j].priceCategoryList[k].value==this.list[m].priceCategory){
                                              console.log('Ander gya ');
                                              checkvalue=false;
                                             // console.log('Price of Selected Logistic pricing '+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing[a].price));
                                             if(this.itinerary[i].Meal[j].priceCategoryList[k].value =='Per Pax'){
                                              newlist[m].Price= this.itinerary[i].Meal[j].logisticPricing[a].price*this.passengerQty;
                                              newlist[m].lpValue=this.itinerary[i].Meal[j].logisticPricing[a].value;
                                             }else{
                                              newlist[m].Price= this.itinerary[i].Meal[j].logisticPricing[a].price;
                                              newlist[m].lpValue=this.itinerary[i].Meal[j].logisticPricing[a].value;
                                             }
                                          }
                                        
                                      }

                                      if(checkvalue){
                                        newlist[m].Price=this.itinerary[i].Meal[j].logisticPricing[a].price;
                                        newlist[m].lpValue=this.itinerary[i].Meal[j].logisticPricing[a].value; 
                                    }



                                   // newlist[m].Price=this.itinerary[i].Meal[j].logisticPricing[a].price;
                                }
                            }
                        }   
                    }
                }
            console.log('Line 291 logistic price add '+JSON.stringify(this.list));
        }

    }

    roomTypeChangeHandler(event){
        let i=event.target.getAttribute('data-id2');
        let j=event.target.getAttribute('data-id1');
        let type=event.target.getAttribute('data-id');
        console.log('value of i 185sdsd--->'+i);
        console.log('value of j 186--->'+j);
        console.log('value of type 187--->'+type);


        if(type=='Accomodation'){
            console.log('TLine 306===>.'+JSON.stringify(this.itinerary[i].Accomodation[j]));
            console.log('Line 307 ===>.'+JSON.stringify(this.itinerary[i].dayName));
            console.log('Line 308 ===>.'+JSON.stringify(this.itinerary[i].Accomodation[j].Roomtype.length));
            console.log('transport 309-->'+JSON.stringify(this.list));

            let elementValue = event.target.value;
            console.log('Line 312 '+elementValue);

        console.log('transport 314-->'+JSON.stringify(this.list.length));
        var room ='';
        for(var m=0;m<this.list.length;m++){
            console.log('Line 316 '+JSON.stringify(this.list[m].Title));
                if(this.itinerary[i].Accomodation[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                    console.log('Where We need changedata -'+JSON.stringify(this.list[m]));
                    let newlist = [...this.list];
                    newlist[m].Information=elementValue;
                        console.log('elementValue Room Type Length Line 224'+JSON.stringify(this.itinerary[i].Accomodation[j].Roomtype.length));
                        if(this.itinerary[i].Accomodation[j].Roomtype.length>0){
                            for(var a=0;a<this.itinerary[i].Accomodation[j].Roomtype.length;a++){
                                if(elementValue==this.itinerary[i].Accomodation[j].Roomtype[a].value){
                                        console.log('Line 227 Record ID Update-'+JSON.stringify(this.itinerary[i].Accomodation[j].Roomtype[a].rtRecordId));
                                        room=this.itinerary[i].Accomodation[j].Roomtype[a].rtRecordId
                                        newlist[m].roomTypeRecordId=this.itinerary[i].Accomodation[j].Roomtype[a].rtRecordId;
                                        var fields = this.itinerary[i].dayName.split(' - ');
                                        var date = fields[1];
                                        console.log('DateIti=======>'+date);
                                        var avlroom =[];
                                        avlroom=this.itinerary[i].Accomodation[j].Roomtype[a].availableRoomList;
                                        console.log('avlroomsdss=======>'+avlroom.length);
                                        if(avlroom.length > 0){
                                            for(var k=0;k<avlroom.length;k++){
                                                console.log('RoomDaterrr=======>'+avlroom[k].itiDate);
                                                if(date == avlroom[k].itiDate){
                                                    let itinerarylist =JSON.parse(JSON.stringify(this.itinerary));
                                                    itinerarylist[i].Accomodation[j].roomsAvailable=avlroom[k].availableRoom;
                                                    
                                                  //  console.log('itinerarylist ------>'+itinerarylist[i].Accomodation[j]);
                                                    console.log('itinerarylistrooms ------>'+ itinerarylist[i].Accomodation[j].roomsAvailable);
                                                    this.itinerary=itinerarylist;
                                                    newlist[m].availableRoom=avlroom[k].availableRoom;
                                                    newlist[m].allocationId=avlroom[k].recordId;
                                                }
    
                                            }
                                        }else{
                                            console.log('No Rooms Available ------>');
                                            let itinerarylist =JSON.parse(JSON.stringify(this.itinerary));
                                            newlist[m].availableRoom='';
                                            newlist[m].allocationId='';
                                                    itinerarylist[i].Accomodation[j].roomsAvailable='0';
                                                    this.itinerary=itinerarylist;
                                        }
                                }
                            }
                        }
            }
        }

      /*  console.log('passengertype----> '+this.roomSubtype);
        console.log('dayName----> '+this.itinerary[i].dayName);
        console.log('roomID----> '+this.room);
        getAvailableRoom({
            roomId:room,
            dateacc:this.itinerary[i].dayName,
            roomtype:this.roomSubtype
            
        }).then(result => {
            
            //  this.options=result.OLI;
            console.log('Here in line no underOli Abcss------>'+result);
            var fields = result.split(';');
            var avlroom = fields[0];
            var allocatId = fields[1];
            console.log('allocatId------>'+allocatId);
            let itinerarylist =JSON.parse(JSON.stringify(this.itinerary));
            itinerarylist[i].Accomodation[j].roomsAvailable=avlroom;
            
            console.log('itinerarylist ------>'+itinerarylist[i].Accomodation[j]);
            console.log('itinerarylistrooms ------>'+ itinerarylist[i].Accomodation[j].roomsAvailable);
            this.itinerary=itinerarylist;
        }).catch((error)=>{
            let itinerarylist =JSON.parse(JSON.stringify(this.itinerary));
            itinerarylist[i].Accomodation[j].roomsAvailable='0';
            this.itinerary=itinerarylist;
            console.log('FromApex ',JSON.stringify(error));
        });   */


        }



        console.log('transport 333-->'+JSON.stringify(this.list));
    }
    priceChangeHandler(event){
        let i=event.target.getAttribute('data-id2');
        let j=event.target.getAttribute('data-id1');
        let type=event.target.getAttribute('data-id');
        console.log('value of i 339--->'+i);
        console.log('value of j 340--->'+j);
        console.log('value of type 341--->'+type);

        let priceElement = event.target.value;
        console.log('Price Line 344 '+priceElement);

        if(type=='Accomodation'){
            console.log('TransportShow 347===>.'+JSON.stringify(this.itinerary[i].Accomodation[j]));
            console.log('TransportShow 348===>.'+JSON.stringify(this.itinerary[i].Accomodation[j].Name));
            console.log('transport 349-->'+JSON.stringify(this.list));
            console.log('transport 350-->'+JSON.stringify(this.list.length));

            for(var m=0;m<this.list.length;m++){
                console.log('Line 353 '+JSON.stringify(this.list[m].Title));
                    if(this.itinerary[i].Accomodation[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedata '+JSON.stringify(this.list[m]));
                        let newlist = [...this.list];
                        newlist[m].Price=priceElement;
             
                }
            }
        }
        if(type=='Transport'){
            for(var m=0;m<this.list.length;m++){
                console.log('Line 363 '+JSON.stringify(this.list[m].Title));
                    if(this.itinerary[i].Transport[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedata '+JSON.stringify(this.list[m]));
                        let newlist = [...this.list];
                        newlist[m].Price=priceElement;
                }
            }
        }
        if(type=='Meal'){
            for(var m=0;m<this.list.length;m++){
                console.log('Line 373 '+JSON.stringify(this.list[m].Title));
                    if(this.itinerary[i].Meal[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedata '+JSON.stringify(this.list[m]));
                        let newlist = [...this.list];
                        newlist[m].Price=priceElement;
                }
            }
        }
        console.log('transport 381-->'+JSON.stringify(this.list));  
    } 
    
    priceCategoryChangeHandler(event){
        let i=event.target.getAttribute('data-id2');
        let j=event.target.getAttribute('data-id1');
        let type=event.target.getAttribute('data-id');
        console.log('value of i 185sdsd--->'+i);
        console.log('value of j 186--->'+j);
        console.log('value of type 187--->'+type);
        let elementValue = event.target.value;
        console.log('value of elementValue--->'+elementValue);
        if(type=='Accomodation'){
            console.log('TransportShow 347===>.'+JSON.stringify(this.itinerary[i].Accomodation[j]));
            console.log('TransportShow 348===>.'+JSON.stringify(this.itinerary[i].Accomodation[j].Name));
            console.log('transport 349-->'+JSON.stringify(this.list));
            console.log('transport 350-->'+JSON.stringify(this.list.length));

            for(var m=0;m<this.list.length;m++){
              
                    if(this.itinerary[i].Accomodation[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedataaaa '+JSON.stringify(this.list[m]));
                        for(var a=0;a<this.itinerary[i].Accomodation[j].logisticPricing.length;a++){
                          console.log('Line 353dfd '+this.list[m].lpValue);
                            if(this.itinerary[i].Accomodation[j].logisticPricing[a].value==this.list[m].lpValue){
                                console.log('Ander gya ');
                                let newlist = [...this.list];
                               // console.log('Price of Selected Logistic pricing '+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing[a].price));
                               if(elementValue =='Per Pax'){
                                newlist[m].Price= this.itinerary[i].Accomodation[j].logisticPricing[a].price*this.passengerQty;
                                newlist[m].priceCategory= elementValue;
                               }else{
                                newlist[m].Price= this.itinerary[i].Accomodation[j].logisticPricing[a].price;
                                newlist[m].priceCategory= elementValue;
                               }
                            }
                        }
                    }
                       
                       
                }
            }
        

        if(type=='Meal'){
            console.log('TransportShow 347===>.'+JSON.stringify(this.itinerary[i].Meal[j]));
            console.log('TransportShow 348===>.'+JSON.stringify(this.itinerary[i].Meal[j].Name));
            console.log('transport 349-->'+JSON.stringify(this.list));
            console.log('transport 350-->'+JSON.stringify(this.list.length));

            for(var m=0;m<this.list.length;m++){
                console.log('Line 353 '+JSON.stringify(this.list[m].Title));
                if(this.itinerary[i].Meal[j].Name==this.list[m].Title && this.itinerary[i].dayName == this.list[m].Day){ 
                        console.log('Where We need changedata Meal '+JSON.stringify(this.list[m]));
                        for(var a=0;a<this.itinerary[i].Meal[j].logisticPricing.length;a++){
                            console.log('Line 353dfd '+this.list[m].lpValue);
                            console.log('Line logisticPricingValuefromarray '+this.itinerary[i].Meal[j].logisticPricing[a].value);
                              if(this.itinerary[i].Meal[j].logisticPricing[a].value==this.list[m].lpValue){
                                  console.log('Ander gya ');
                                  let newlist = [...this.list];
                                 // console.log('Price of Selected Logistic pricing '+JSON.stringify(this.itinerary[i].Accomodation[j].logisticPricing[a].price));
                                 if(elementValue =='Per Pax'){
                                  newlist[m].Price= this.itinerary[i].Meal[j].logisticPricing[a].price*this.passengerQty;
                                  newlist[m].priceCategory= elementValue;
                                 }else{
                                  newlist[m].Price= this.itinerary[i].Meal[j].logisticPricing[a].price;
                                  newlist[m].priceCategory= elementValue;
                                 }
                              }
                          }
                }
            }
        }



        console.log('transport 333-->'+JSON.stringify(this.list));
    }

    handleAddRecord(event){
        let j=event.target.getAttribute('data-id2');
        let i=event.target.getAttribute('data-id1');
        console.log('value of i 83--->'+i);
        console.log('value of j 83ac-ssdefeds-->'+j);
        var addData=[];
  // addData= this.itinerary[i].Accomodation[j].splice(j, 0,this.itinerary[i].Accomodation[j]);
  console.log('AddedData'+JSON.stringify(addData));
  console.log('AddedDapushhha'+JSON.stringify(this.itinerary[i].Accomodation[j].push(this.itinerary[i].Accomodation[j])));
 // addData= this.itinerary[i].Accomodation[j].push(this.itinerary[i].Accomodation[j]);
  console.log('AddedData'+JSON.stringify(addData));
  console.log('AddedDaa'+JSON.stringify(this.itinerary[i].Accomodation[j].push({'namddd':'Munesh'})));
    }
   
   
   
    handleContactDelete(event){
       
        console.log('valueee of deleted data i 83--->'+event.target.value);
        let i=event.target.getAttribute('data-id2');
        console.log('value of i 83--->'+i);
        this.selectedOlList.push({
        olId:event.target.value
        })
       
        console.log('start deletescdv'+this.selectedOlList);

        for(var m=0; m<this.itinerary.length; m++){
          //  console.log('ITI'+this.orderlogistics[i].Dateday +'--------'+this.itinerary[m].dayName);

           
            if(this.orderlogistics[i].Dateday==this.itinerary[m].dayName){
                 //For Accomodation Data
              //  console.log('checkValue ------>'+this.itinerary[m].dayName+'-----'+ this.orderlogistics[i].Dateday);


                if(this.orderlogistics[i].SupplierType == 'Accomodation'){
                    for(var k =0;k<this.itinerary[m].Accomodation.length;k++){
                        console.log('checkValueacccdsfsf ------>'+ this.itinerary[m].Accomodation[k].check);
                        if(this.orderlogistics[i].Title==this.itinerary[m].Accomodation[k].Name){
                            console.log('TitleMatch');
                        
                            let itinerarylist =JSON.parse(JSON.stringify(this.itinerary));
                            itinerarylist[m].Accomodation[k].check=false;
                            // console.log('itinerarylist ------>'+itinerarylist[i].Accomodation[j]);
                            console.log('itinerarylistrooms ------>'+ itinerarylist[m].Accomodation[k].check);
                            this.itinerary=itinerarylist;
                            console.log('Accomodation listupdate ------>'+ this.itinerary[m].Accomodation[k].check);
                        }
            
                        
                    }

                }else if(this.orderlogistics[i].SupplierType == 'Meal'){
                      //For Meal Data
                 //  console.log('checkValue ------>'+this.itinerary[m].dayName+'-----'+ this.orderlogistics[i].Dateday);
                   for(var t =0;t<this.itinerary[m].Meal.length;t++){
                       console.log('checkValueacccdsfsf ------>'+ this.itinerary[m].Meal[t].check);
                       console.log('Name ------>'+ this.itinerary[m].Meal[t].Name);
                       if(this.orderlogistics[i].Title==this.itinerary[m].Meal[t].Name){
                           console.log('TitleMatch for Meal    '+this.itinerary[m].Meal[t].Name);
                       
                           let itinerarylist =JSON.parse(JSON.stringify(this.itinerary));
                           itinerarylist[m].Meal[t].check=false;
                           this.itinerary=itinerarylist;

                           console.log('itinerarylistupdate ------>'+ this.itinerary[m].Meal[t].check);

                           console.log('itinerary ------>'+JSON.stringify(this.itinerary));
   
                       }                       
                   }

                }else if(this.orderlogistics[i].SupplierType == 'Transport'){
                    //For Transport Data
                 //console.log('checkValue ------>'+this.itinerary[m].dayName+'-----'+ this.orderlogistics[i].Dateday);
                 for(var k =0;k<this.itinerary[m].Transport.length;k++){
                     console.log('checkValueacccdsfsf ------>'+ this.itinerary[m].Transport[k].check);
                     if(this.orderlogistics[i].Title==this.itinerary[m].Transport[k].Name){
                         console.log('TitleMatch for TRansport'+this.itinerary[m].Transport[k].Name);
                     
                         let itinerarylist =JSON.parse(JSON.stringify(this.itinerary));
                         itinerarylist[m].Transport[k].check=false;
                         // console.log('itinerarylist ------>'+itinerarylist[i].Transport[j]);
                         console.log('itinerarylistrooms ------>'+ itinerarylist[m].Transport[k].check);
                         this.itinerary=itinerarylist;
 
                     }                       
                 }

              }
              

                
            }  
        }


        this.orderlogistics = this.orderlogistics.filter(rowId => rowId.RecordId !== event.target.value);
        console.log('After Delete this newdatasfd'+JSON.stringify(Newdata));
        
     }

     

}