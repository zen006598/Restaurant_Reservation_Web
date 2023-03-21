import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['submit']

  setSubmit(e){
    const isValid = (e.detail === 'valid')
    this.submitTarget.disabled = !isValid
    this.submitTarget.classList.toggle('disabled-button', !isValid)
    this.submitTarget.classList.toggle('major-button', isValid)
  }
}
