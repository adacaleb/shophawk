import { Controller } from "@hotwired/stimulus" //
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

// let currentSlide = 1

export default class extends Controller {



  connect() {
  console.log("connected")
  }

  next() {
    let currentSlide = this.data.get("slide") //get data from slideshow_controller about current slide. do it this way to manage state
    let path = this.data.get("path")
    currentSlide = parseInt(currentSlide) + 1 //partseInt converts string to number
    if (currentSlide > 5) {
      currentSlide = 1
    }
    get(`/slideshows/slides/?nextbtn=${currentSlide}`, { responseKind: "turbo-stream"}) //loads next turbostream

    console.log(`${currentSlide}`)

  }



}


//  slideNumber = slideNumber + 1
//  console.log(`${slideNumber}`)
