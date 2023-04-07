import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'noon', 'evening', 'midnight', 'morning', 'noonTitle', 'eveningTitle', 'midnightTitle', 'morningTitle', 'alert', 'timeField']

  connect(){
    this.alert = !!this.alertTarget.dataset.state
  }

  setTime(e){
    this.reset()

    let business_times = e.detail.business_times
    this.setTimeButton(business_times)
   
    this.toggleVisibility(this.midnightTarget, this.midnightTitleTarget) 
    this.toggleVisibility(this.morningTarget, this.morningTitleTarget) 
    this.toggleVisibility(this.noonTarget, this.noonTitleTarget) 
    this.toggleVisibility(this.eveningTarget, this.eveningTitleTarget) 
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
    const state = e.detail.state
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

  disableTimeButton(e){
    let unavailableTimes = e.detail.unavailableTime

    unavailableTimes = unavailableTimes.map(e => new Date(e * 1000).toString().replace(/\s/g, "_").substring(0, 21))
    console.log(unavailableTimes);
  }

  setTimeButton(business_times){
    business_times.forEach(e => {
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

