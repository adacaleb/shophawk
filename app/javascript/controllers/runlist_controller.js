import { Controller } from "@hotwired/stimulus" //
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

export default class extends Controller {
  changeWc(event) {
    console.log(event.target.selectedOptions[0].value) //displays selection in browser console
    let wc = event.target.selectedOptions[0].value //assigns selection to a variable
    get(`/runlists/activerunlist?wc=${wc}`, { responseKind: "turbo-stream"}) //runs this route passing on the "wc" variable as a param, asks for turbo-stream in response
  }

    changedepartment(event) {
    console.log(event.target.selectedOptions[0].value) //displays selection in browser console
    let department = event.target.selectedOptions[0].value //assigns selection to a variable
    get(`/runlists/changedepartment?department=${department}`, { responseKind: "turbo-stream"}) //runs this route passing on the "wc" variable as a param, asks for turbo-stream in response
  }

  checkBoxUpdate(event) {
    let id = event.currentTarget.id //"event.currentTarget" displays all attributes. ".id" is the attribute I'm grabbing. 
    console.log(id)
    get(`/runlists/checkboxsubmit?id=${id}`) //sends value of ID to checkboxsubmit controller method to toggle state in DB
  }

}
