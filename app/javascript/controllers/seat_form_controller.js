import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets=['form', 'box']

  connect(){
    this.formTarget.addEventListener("click", e => this.formTarget.classList.add('hidden'))
    this.boxTarget.addEventListener("click", e => e.stopPropagation())
  }

  cancel(e){
    e.preventDefault()
    this.formTarget.classList.add('hidden')
  }
}