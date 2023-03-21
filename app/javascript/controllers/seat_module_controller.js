import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['edit']
  setSetting(){
    this.editTargets.forEach(link => {
      link.classList.remove('hidden')
    })
  }

  setClose(){
    window.location.href = `seat_modules`;
  }
}
