import { Controller } from "@hotwired/stimulus" //
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

// let currentSlide = 1
//let amount = 3000;
//let slideloop = setInterval(() => this.next(), 3000);
let currentSlideShow = 1 //Starting slide for slidetimer
let slideTimer //Defines Timer ID for use in other functions

export default class extends Controller {



//  connect() {
//  }
//
  start() {
    clearTimeout(slideTimer) //stops timer with ID "slideTimer"
    //let currentSlide = this.data.get("slide") //get data from slideshow_controller about current slide. do it this way to manage state
    currentSlideShow = parseInt(currentSlideShow) + 1 //partseInt converts string to number
    if (currentSlideShow > 7) {
      currentSlideShow = 1
    }
    get(`/slideshows/slides/?nextbtn=${currentSlideShow}`, { responseKind: "turbo-stream"}) //loads next turbostream
    console.log(`${currentSlideShow}`)    
    slideTimer = setTimeout(() => this.start(), 7000); //starts timer to progress to next slide
  }

  stop() {
    clearTimeout(slideTimer) //stops timer with ID "slideTimer"
    get(`/slideshows`)
    console.log("Slideshow Stopped")
  }

  next() {
    let currentSlide = this.data.get("slide") //get data from slideshow_controller about current slide. do it this way to manage state
    let path = this.data.get("path")
    currentSlide = parseInt(currentSlide) + 1 //partseInt converts string to number
    if (currentSlide > 7) {
      currentSlide = 1
    }
    get(`/slideshows/slides/?nextbtn=${currentSlide}`, { responseKind: "turbo-stream"}) //loads next turbostream

    console.log(`${currentSlide}`)
  }


  previous() {
    let currentSlide = this.data.get("slide") //get data from slideshow_controller about current slide. do it this way to manage state
    let path = this.data.get("path")
    currentSlide = parseInt(currentSlide) - 1 //partseInt converts string to number
    if (currentSlide < 1) {
      currentSlide = 7
    }
    get(`/slideshows/slides/?nextbtn=${currentSlide}`, { responseKind: "turbo-stream"}) //loads next turbostream

    console.log(`${currentSlide}`)

  }


}

