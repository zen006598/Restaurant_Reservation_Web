import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['name', 'submit', 'tel', 'address']

  connect(){
    this.setSubmit()
  }

  setSubmit(){
    const { nameTarget, telTarget, addressTarget, submitTarget } = this
    const shouldShowSubmit = nameTarget.value !== "" && telTarget.value !== "" && addressTarget.value !== ""
    submitTarget.classList.toggle("hidden", !shouldShowSubmit)
  }

  cancel(){
    window.location.replace("/admin/restaurants");
  }
}
