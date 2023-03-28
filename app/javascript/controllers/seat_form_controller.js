import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets=['form', 'box', 'title', 'capacity', 'submit']

  connect(){
    this.formTarget.addEventListener("click", e => this.formTarget.classList.add('hidden'))
    this.boxTarget.addEventListener("click", e => e.stopPropagation())
  }

  cancel(){
    this.formTarget.classList.add('hidden')
  }

  setSubmit(){
    if (this.titleTarget.value != '' && this.capacityTarget.value != '') {
      this.submitTarget.classList.remove('hidden')
    } else{
      this.submitTarget.classList.add('hidden')
    }
  }
}