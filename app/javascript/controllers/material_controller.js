import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

export default class extends Controller {

static targets = ["sizeSelect", "material"]
	
	connect() {
	    console.log("Hello, Caleb", this.element)
	  }

	matchange(event) {
		let mat = event.target.selectedOptions[0].value
		console.log(mat)
		let target = this.sizeSelectTarget.id
		let size = this.sizeSelectTarget.value
		//console.log(target)
		get(`materials/matsizes?target=${target}&size=${size}&mat=${mat}`, { responseKind: "turbo-stream"})
	}

	sizechange(event) {
		let size = event.target.selectedOptions[0].value
		let mat = this.materialTarget.value
		console.log(mat)
		console.log(size)
		get(`materials/matdata?size=${size}&mat=${mat}`, { responseKind: "turbo-stream"})
	}

	orderedcheckbox(event) {
		let id = event.currentTarget.id
		console.log(id)
		get(`/materials/orderedCheckBox?id=${id}`)

	}

}