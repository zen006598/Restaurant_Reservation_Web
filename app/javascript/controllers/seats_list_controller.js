import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets=['form', 'new', 'inner', 'updateForm', 'frameId']

  connect(){
    document.querySelector("#seat-new").addEventListener("click", e => this.newTarget.classList.add('hidden'))
    this.innerTarget.addEventListener("click", e => e.stopPropagation())
  }
  
  show(e){
    const seatModuleId  = e.detail.detailInfo.seat_module_id
    this.setForm(seatModuleId)
  }

  cancel(e){
    e.preventDefault()
    this.newTarget.classList.add('hidden')
  }

  setForm(seatModuleId){
    let form = this.formTarget
    const action = `/admin/seat_modules/${seatModuleId}/seats`
    form.action = action
  }

  unfold(){
    this.newTarget.classList.remove('hidden')
  }

  setButton(){
    console.log(678);
  }
}
