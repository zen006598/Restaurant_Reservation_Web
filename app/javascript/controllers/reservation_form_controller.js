import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'noon', 'evening', 'midnight', 'morning', 'noonTitle', 'eveningTitle', 'midnightTitle', 'morningTitle', 'alert', 'timeField', 'datepicker', 'tableType', 'kid', 'adult', 'submit']

  initialize(){
    this.id = window.location.href.split('/').reverse()[0]
    this.token = document.querySelector("meta[name='csrf-token']").content

    this.alert = false
    this.submit = false
    this.maximumCapacity = this.alertTarget.dataset.maximumCapacity
    this.reservationDate = this.datepickerTarget.dataset.defaultDate
    this.setAlert()
    this.setPeopleSum()
    this.setTableType()
  }

  connect(){
    this.fetchBusinessTimes()
  }
  // input info
  sumQuantity(){
    this.setPeopleSum()
    this.setAlert()
    this.toggleSubmit()
    this.toggleAlert()
    this.toggleTimeField()
    this.fetchBusinessTimes()
  }

  inputTableType(){
    this.setTableType()
    this.fetchBusinessTimes()
  }

  inputReservationDate(e){
    this.reservationDate = e.currentTarget.value
    this.fetchBusinessTimes()
  }
  // fetch
  fetchBusinessTimes(){
    fetch(`/restaurants/${this.id}/get_business_times`, {
      method: 'POST',
      headers: {
        "X-CSRF-Token": this.token,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify ({
        reservationDate: this.reservationDate,
        tableType: this.tableType,
        peopleSum: this.peopleSum
      })
    }).then(resp => resp.json())
    .then(({businessTimes}) => this.setTime(businessTimes))
    .catch(e => console.log(e, 'error'))
  }
  // set
  setPeopleSum(){
    this.peopleSum = +this.kidTarget.value + +this.adultTarget.value
  }

  setTableType(){
    this.tableType = this.tableTypeTarget.value
  }

  setAlert(){
    this.alert = this.peopleSum > this.maximumCapacity
  }

  setTime(businessTimes){
    if(JSON.stringify(this.businessTimes) == JSON.stringify(businessTimes)){return}
    this.businessTimes = businessTimes
    this.reset()
    this.setSubmit(false)
    this.setTimeButton()
    const timeSections = [
      { target: this.midnightTarget, title: this.midnightTitleTarget },
      { target: this.morningTarget, title: this.morningTitleTarget },
      { target: this.noonTarget, title: this.noonTitleTarget },
      { target: this.eveningTarget, title: this.eveningTitleTarget },
    ]
    timeSections.forEach(({ target, title }) => this.toggleVisibility(target, title))
  }
  
  setTimeButton(){
    this.businessTimes.forEach(e => {
      const business_day = new Date(e * 1000).toDateString().replace(/\s/g, "_")
      const business_time = new Date(e * 1000).toLocaleTimeString('zh-TW', { hour12: false }).substring(0, 5)

      const button = `
        <span class='mb-8 md:mb-4'>
          <input type="radio" class='hidden peer time-button' name='arrival_time' value=${business_day}_${business_time} id=${business_time}
                  data-reservation-form-target='button'
                  data-action='input->reservation-form#setSubmit'>
          <label for=${business_time} class='time-button px-8 py-3 text-xl cursor-pointer peer-checked:bg-major peer-checked:text-white  border rounded hover:border-major'>${business_time}</label>
        </span>
      `
      switch (true) {
        case ('00:00' <= business_time && business_time < '06:00'):
          this.midnightTarget.insertAdjacentHTML('beforeend', button);
          break
        case ('06:00' <= business_time && business_time < '11:00'):
          this.morningTarget.insertAdjacentHTML('beforeend', button)
          break
        case ('11:00' <= business_time && business_time < '18:00'):
          this.noonTarget.insertAdjacentHTML('beforeend', button)
          break
        case ('18:00' <= business_time && business_time < '24:00'):
          this.eveningTarget.insertAdjacentHTML('beforeend', button)
          break
      }
    })
  }

  setSubmit(state){
    this.submit = Boolean(state)
    this.toggleSubmit()
  }
  // toggle
  toggleAlert(){
    this.alertTarget.classList.toggle('hidden', !this.alert)
  }

  toggleVisibility(target, title) {
    title.classList.toggle('hidden', target.innerHTML == '')
  }  

  toggleTimeField(){
    this.timeFieldTarget.classList.toggle('hidden', this.alert)
  }

  toggleSubmit(){
    const classToAdd = this.submit && !this.alert ? 'major-button' : 'disabled-button';
    const classToRemove = this.submit && !this.alert ? 'disabled-button' : 'major-button';
  
    this.submitTarget.classList.replace(classToRemove, classToAdd)
    this.submitTarget.classList.toggle('cursor-pointer', this.submit && !this.alert)
    this.submitTarget.disabled = !this.submit || this.alert;
  }

  // reset
  reset(){
    this.midnightTarget.innerHTML = ''
    this.morningTarget.innerHTML = ''
    this.noonTarget.innerHTML = ''
    this.eveningTarget.innerHTML = ''
  }
}

