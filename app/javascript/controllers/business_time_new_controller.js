import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['new', 'titleInput', 'submit', 'plus', 'timeField']
  connect(){
    this.state = false
  }
  setState(){
    this.state = !this.state
  }
  unfold(){
    this.setState()
    if(this.state){
      this.newTarget.classList.remove('hidden')
    }else{
      this.newTarget.classList.add('hidden')
    }
  }
  getTitle(){
    this.setSubmit()
  }
  setSubmit(){
    if(this.titleInputTarget.value){
      this.submitTarget.disabled = false
      this.submitTarget.classList.replace('disabled-button', 'major-button')
    }else{
      this.submitTarget.disabled = true
      this.submitTarget.classList.replace('major-button', 'disabled-button')
    }
  }
  addColumn(e){
    e.preventDefault()
    const column = this.timeFieldTarget.innerHTML
    this.timeFieldTarget.insertAdjacentHTML('beforebegin', column)
  }
  cancel(e){
    e.preventDefault()
    this.setSubmit()
    this.unfold()
  }
}
