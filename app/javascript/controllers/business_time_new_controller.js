import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['new', 'titleInput', 'submit', 'plus', 'timeField', 'dayOfWeek']

  initialize(){
    this.state = false
    this.id = String(document.URL).split('/')[5]
    this.token
  }

  connect(){
    this.fetch_date()
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
    console.log(e);
    e.preventDefault()
    window.location.replace(`/admin/restaurants/${this.id}/setting`)
  }

  disable_off_day(disable_day_of_week){
    this.dayOfWeekTargets.filter(day => {
      if(disable_day_of_week.includes(+day.firstElementChild.value)){
        day.firstElementChild.disabled = true
        day.lastElementChild.classList.add('disabled-button')
        day.lastElementChild.disabled = true
      }
      if(day.firstElementChild.checked === true){
        day.firstElementChild.disabled = false
        day.lastElementChild.classList.remove('disabled-button')
      }
    })
  }

  fetch_date(){
    fetch(`/admin/restaurants/${this.id}/setting`,{
      method: 'GET',
      headers: {
        "X-CSRF-Token": this.token,
      }
    }).then(resp => resp.json())
    .then(({off_days_of_week, assigned_day_of_week}) => {
      const disable_day_of_week = off_days_of_week.concat(assigned_day_of_week)
      this.disable_off_day(disable_day_of_week)
    })
    .catch((e) => {
      console.log(e);
    })
  }

  
}
