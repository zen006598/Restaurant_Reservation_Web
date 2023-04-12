import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'noon', 'evening', 'midnight', 'morning', 'noonTitle', 'eveningTitle', 'midnightTitle', 'morningTitle', 'alert', 'timeField', 'datepicker', 'tableType', 'kid', 'adult']

  connect(){
    this.alert = !!this.alertTarget.dataset.state
    this.id = window.location.href.split('/').reverse()[0]
    this.token = document.querySelector("meta[name='csrf-token']").content
    this.reservationDate = this.datepickerTarget.dataset.defaultDate
    this.tableType = this.tableTypeTarget.value
    this.peopleSum = +this.kidTarget.value + +this.adultTarget.value
    this.fetchBusinessTimes()
  }

  sumQuantity() {
    this.peopleSum = +this.kidTarget.value + +this.adultTarget.value
    this.fetchBusinessTimes()
  }

  inputTableType(e){
    this.tableType = e.currentTarget.value
    this.fetchBusinessTimes()
  }

  inputReservationDate(e){
    this.reservationDate = e.currentTarget.value
    this.fetchBusinessTimes()
  }

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
    }).then((resp) => resp.json())
    .then(({businessTimes}) => {
      this.setTime(businessTimes)
    })
    .catch((e) => console.log(e, 'error'))
  }

  setTime(businessTimes){
    if(JSON.stringify(this.businessTimes) != JSON.stringify(businessTimes)){
      this.businessTimes = businessTimes
      this.reset()
      this.setTimeButton()
      this.toggleVisibility(this.midnightTarget, this.midnightTitleTarget) 
      this.toggleVisibility(this.morningTarget, this.morningTitleTarget) 
      this.toggleVisibility(this.noonTarget, this.noonTitleTarget) 
      this.toggleVisibility(this.eveningTarget, this.eveningTitleTarget)
    }
  }

  toggleVisibility(target, titleTarget) {
    titleTarget.classList.toggle('hidden', target.innerHTML.replace(/\s/g, '') == '')
  }  

  reset(){
    this.midnightTarget.innerHTML = ''
    this.morningTarget.innerHTML = ''
    this.noonTarget.innerHTML = ''
    this.eveningTarget.innerHTML = ''
  }

  setAlert(e){
    const state = e
    this.alert = state
    this.alertTarget.dataset.state = state

    this.toggleTimeField(this.alert)
    this.toggleAlert(this.alert)
  }

  toggleAlert(state){
    this.alertTarget.classList.toggle('hidden', state)
  }

  toggleTimeField(state){
    this.timeFieldTarget.classList.toggle('hidden', !state)
  }

  setTimeButton(){
    this.businessTimes.forEach(e => {
      const business_day = new Date(e * 1000).toDateString().replace(/\s/g, "_")
      const business_time = new Date(e * 1000).toLocaleTimeString('zh-TW', { hour12: false }).substring(0, 5)

      const button = `
        <span class='mb-8 md:mb-4'>
          <input type="radio" class='hidden peer' name='arrival_time' value=${business_day}_${business_time} id=${business_time}>
          <label for=${business_time} class='px-8 py-3 text-xl cursor-pointer peer-checked:bg-major peer-checked:text-white  border rounded hover:border-major '>${business_time}</label>
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
}

