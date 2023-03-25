import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['edit', 'delete', 'show']
  setSetting(){
    this.editTargets.forEach(e => {e.classList.remove('hidden')})
    this.deleteTargets.forEach(e => {e.classList.remove('hidden')})
    this.showTargets.forEach(e => {e.classList.add('hidden')})
  }

  setClose(){
    window.location.href = `seat_modules`
  }
}
