import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js" //needed for get operations from JS to Rails

export default class extends Controller {
	static targets = ["sizeSelect"]
	
	matchange(event) {
	
	let mat = event.target.selectedOptions[0].value
	console.log(mat)
	let target = this.sizeSelectTarget.id
	//console.log(target)

	get(`materials/matsizes?target=${target}&mat=${mat}`, { responseKind: "turbo-stream"})

	}

	sizechange(event) {
		let size = event.target.selectedOptions[0].value
		console.log(size)

		get(`materials/matdata?size=${size}`, { responseKind: "turbo-stream"})
	}

}