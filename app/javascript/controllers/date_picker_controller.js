import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['submit']
  setSubmit(){
    this.submitTarget.classList.remove('hidden')
  }
}
