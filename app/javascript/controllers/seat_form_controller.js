import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets=['form', 'box', 'title', 'capacity', 'submit', 'type']

  connect(){
    this.formTarget.addEventListener("click", e => this.formTarget.classList.add('hidden'))
    this.boxTarget.addEventListener("click", e => e.stopPropagation())
  }

  cancel(){
    this.formTarget.classList.add('hidden')
  }

  setSubmit(){
    const isAllFieldsValid = this.titleTarget.value && this.capacityTarget.value && this.typeTarget.value;
    this.submitTarget.classList.toggle('hidden', !isAllFieldsValid);
  }
}