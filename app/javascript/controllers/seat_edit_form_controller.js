import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets= ['title', 'capacity', 'submit']
  setSubmit(){
    if (this.titleTarget.value != '' && this.capacityTarget.value != '') {
      this.submitTarget.classList.remove('hidden')
    } else{
      this.submitTarget.classList.add('hidden')
    }
  }
}
