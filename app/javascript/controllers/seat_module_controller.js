import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['edit']

  setSetting(){
    this.editTargets.forEach(link => {
      link.disabled = false
      link.classList.add('edit-link')
    })
  }

  setClose(){
    this.editTargets.forEach(link => {
      link.disabled = true
      link.classList.remove('edit-link')
    })
  }
}
