import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js" //needed for get operations from JS to Rails
let i = 0
let cursor = 0
let remaining =""

export default class extends Controller {

static targets = ["sizeSelect", "material", "input", "suggestions"]


	
  connect() {
    this.suggestionsTarget.style.display = "none";
  }

	matchange(event, material) {
		//let mat = event.target.selectedOptions[0].value.replace(/#/g, '%23') //replace function replaces "#" symbol with the %23 encoding of it to pass through a GET request.
		let mat = material
		console.log(mat)
		let target = this.sizeSelectTarget.id
		let size = this.sizeSelectTarget.value

		//console.log(target)
		get(`/materials/matchange?target=${target}&size=${size}&mat=${mat}`, { responseKind: "turbo-stream"})
	}

	sizechange(event) {
		let size = event.target.selectedOptions[0].value
		let mat = this.materialTarget.value.replace(/#/g, '%23')
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


	filterSuggestions(event) {
		//ignores backspace or delete keys		
		const key = event.key;
		const ignoredKeys = ["Backspace", "Delete", "Tab", "Shift", "ArrowRight", "ArrowLeft"]
		if (ignoredKeys.includes(key)) {
			return;
		}
		if(key != "ArrowDown") {
			cursor = this.inputTarget.selectionStart
			remaining = event.target.value.toLowerCase().slice(0,cursor);
			i = 0
		}
		//autocomplete functions if any other key is pressed
		const inputValue = event.target.value.toLowerCase().slice(0, remaining.length);
		const filteredSuggestions = this.suggestions.filter(suggestion =>
		  suggestion.toLowerCase().startsWith(inputValue)
		);
		if(key == "ArrowDown") {
			i = i + 1
			if(i >= filteredSuggestions.length) {
				i = 0
			}
			this.completeSuggestion(filteredSuggestions[i], remaining)
			return
		}
		this.completeSuggestion(filteredSuggestions[0], cursor) //autofills text box with first suggestion
		this.updateSuggestions(filteredSuggestions)
  	}

	updateSuggestions(suggestions) {
		this.suggestionsTarget.innerHTML = "";
		suggestions.forEach(suggestion => {
		  const suggestionItem = document.createElement("li");
		  suggestionItem.textContent = suggestion;
		  suggestionItem.addEventListener("mousedown", () => this.completeSuggestion(suggestion));
		  this.suggestionsTarget.appendChild(suggestionItem);
		});
		this.suggestionsTarget.style.display = suggestions.length > 0 ? "block" : "none";
	}

	completeSuggestion(suggestion, remaining) { //splits the input and first found suggestion, auto-highlighting the remainder to be typed manually
		const inputValue = this.inputTarget.value.toLowerCase();
		if( suggestion !== "undefined") {
			this.inputTarget.value = suggestion;
			console.log(suggestion)
			this.inputTarget.focus()
			this.inputTarget.setSelectionRange(cursor, suggestion.length);
		}
		this.matchange(undefined, suggestion)
	}

	get suggestions() {
		return JSON.parse(this.data.get("suggestions"))
	}

	unfocus() {
		this.suggestionsTarget.style.display = "none"
	}

	selectAll() { //selects all text in input field
		this.inputTarget.setSelectionRange(0, this.inputTarget.value.length)
	}
}