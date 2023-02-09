import { Controller } from "@hotwired/stimulus" //
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

export default class extends Controller {

  //change(event) {
  //  console.log('ellos')
  //}


  WcChange(event) {
    console.log(event.target.selectedOptions[0].value)
    let wc = event.target.selectedOptions[0].value
    get('/runlists/stream?wc=${wc}', { responseKind: "turbo-stream"})
    
  }


}

  //   console.log(event.target.selectedOptions[0].value)
  //  let wc = event.target.selectedOptions[0].value
  
  //  get('/runlists/wc?WcChange=${WcChange}', {
  //   responseKind: "turbo-stream"