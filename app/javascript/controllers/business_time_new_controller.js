import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['new']

  initialize(){
    this.state = true
    this.id = String(document.URL).split('/')[5]
  }

  setState(){
    this.state = !this.state
  }

  unfold(){
    this.setState()
    this.newTarget.classList.toggle('hidden', this.state)
  }

  cancel(e){
    e.preventDefault()
    window.location.replace(`/admin/restaurants/${this.id}/setting`)
  }
}
