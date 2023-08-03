import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

export default class extends Controller {

static targets = ["sizeSelect", "material"]
	
//	connect() {
//	    console.log("Hello, Caleb", this.element)
//	  }

	matchange(event) {
		let mat = event.target.selectedOptions[0].value.replace(/#/g, '%23') //replace function replaces "#" symbol with the %23 encoding of it to pass through a GET request.
		console.log(mat)
		let target = this.sizeSelectTarget.id
		let size = this.sizeSelectTarget.value

		//console.log(target)
		get(`/materials/matchange?target=${target}&size=${size}&mat=${mat}`, { responseKind: "turbo-stream"})
	}

	sizechange(event) {
		let size = event.target.selectedOptions[0].value.replace(/#/g, '%23')
		let mat = this.materialTarget.value
		console.log(mat)
		console.log(size)
		get(`/materials/sizechange?size=${size}&mat=${mat}`, { responseKind: "turbo-stream"})
	}

	orderedcheckbox(event) {
		let id = event.currentTarget.id
		console.log(id)
		get(`/materials/orderedCheckBox?id=${id}`)

	}

	sawcutcheckbox(event) {
		let id = event.currentTarget.id
		console.log(id)
		get(`/materials/sawcutCheckBox?id=${id}`)
	}

	quoteSubmit() {
		//sends needed info for turbo_stream to save and refresh page with empty quote fields
		let size = this.sizeSelectTarget.value
		let mat = this.materialTarget.value.replace(/#/g, '%23')
		let target = this.sizeSelectTarget.id
		get(`/materials/newquote?mat=${mat}&size=${size}&target=${target}`, { responseKind: "turbo-stream"})
	}

}