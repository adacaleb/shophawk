import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

export default class extends Controller {

static targets = ["sizeSelect", "material", "quoteSubmit", "quoteSubmit1", "quoteSubmit2", "quoteSubmit3", "quoteSubmit4", "quoteSubmit5", "quoteSubmit6", "quoteSubmit7"]
	
	connect() {
	    console.log("Hello, Caleb", this.element)
	  }

	matchange(event) {
		let mat = event.target.selectedOptions[0].value
		console.log(mat)
		let target = this.sizeSelectTarget.id
		let size = this.sizeSelectTarget.value
		//console.log(target)
		get(`/materials/matsizes?target=${target}&size=${size}&mat=${mat}`, { responseKind: "turbo-stream"})
	}

	sizechange(event) {
		let size = event.target.selectedOptions[0].value
		let mat = this.materialTarget.value
		console.log(mat)
		console.log(size)
		get(`/materials/matdata?size=${size}&mat=${mat}`, { responseKind: "turbo-stream"})
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
		//clears out the input boxes without having the refresh the page to submit another entry
		console.log("submitted")
		let size = this.sizeSelectTarget.value
		let mat = this.materialTarget.value
		let vendor = this.quoteSubmitTarget.value
		let target = this.sizeSelectTarget.id
		console.log(vendor)
		console.log(mat)
		console.log(size)

		get(`/materials/newquote?mat=${mat}&size=${size}&target=${target}`, { responseKind: "turbo-stream"})
//		this.quoteSubmitTarget.value = '';
//		this.quoteSubmit1Target.value = '';
//		this.quoteSubmit2Target.value = '';
//		this.quoteSubmit3Target.checked = false;
//		this.quoteSubmit4Target.checked = false;
//		this.quoteSubmit5Target.value = '';
//		this.quoteSubmit6Target.value = '';
	}

}