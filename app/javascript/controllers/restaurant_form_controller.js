import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['name', 'submit', 'tel', 'address', 'text', 'headcountLabel', 'headcount', 'dayOfWeek']

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
  
  setHeadcount(e){
    const value = +e.target.value;
    const state = value === 0
    this.textTarget.classList.toggle('text-slate-300', state);
    this.headcountLabelTarget.classList.toggle('text-slate-300', state);
    this.headcountTarget.classList.toggle('text-slate-300', state);
    this.headcountTarget.disabled = state;
    this.headcountTarget.value = state ? 99 : this.headcountTarget.value;
  }
}
