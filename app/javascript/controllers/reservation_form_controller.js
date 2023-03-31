import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'noon', 'evening', 'midnight', 'morning', 'noonTitle', 'eveningTitle', 'midnightTitle', 'morningTitle', 'alert']

  setTime(e){
    this.reset()
    let business_times = e.detail.business_times

    business_times.forEach(e => {
      e.forEach( e => {
        const business_day = new Date(e * 1000).toDateString().replace(/\s/g, "_")
        const business_time = new Date(e * 1000).toLocaleTimeString('en-US', { hour12: false }).substring(0, 5)

        const button = `
          <span class='mb-8 md:mb-4'>
            <input type="radio" class='hidden peer' name='#' value=${business_day}_${business_time} id=${business_time}>
            <label for=${business_time} class='px-8 py-3 text-xl cursor-pointer peer-checked:bg-major peer-checked:text-white  border rounded hover:border-major '>${business_time}</label>
          </span>
        `
        if ('00:00'<= business_time && business_time < '06:00'){
          this.midnightTitleTarget.classList.remove('hidden')
          this.midnightTarget.classList.remove('hidden')
          this.midnightTarget.insertAdjacentHTML('beforeend', button)
        }else if('06:00'<= business_time && business_time < '11:00'){
          this.morningTitleTarget.classList.remove('hidden')
          this.morningTarget.classList.remove('hidden')
          this.morningTarget.insertAdjacentHTML('beforeend', button)
        }else if ('11:00'<= business_time && business_time < '18:00'){
          this.noonTitleTarget.classList.remove('hidden')
          this.noonTarget.classList.remove('hidden')
          this.noonTarget.insertAdjacentHTML('beforeend', button)
        }else if ('18:00'<= business_time && business_time < '24:00'){
          this.eveningTitleTarget.classList.remove('hidden')
          this.eveningTarget.classList.remove('hidden')
          this.eveningTarget.insertAdjacentHTML('beforeend', button)
        }
      })
    })
  }

  reset(){
    this.alertTarget.classList.add('hidden')

    this.midnightTitleTarget.classList.add('hidden')
    this.midnightTarget.classList.add('hidden')
    this.midnightTarget.innerHTML = ''

    this.morningTitleTarget.classList.add('hidden')
    this.morningTarget.classList.add('hidden')
    this.morningTarget.innerHTML = ''

    this.noonTitleTarget.classList.add('hidden')
    this.noonTarget.classList.add('hidden')
    this.noonTarget.innerHTML = ''

    this.eveningTitleTarget.classList.add('hidden')
    this.eveningTarget.classList.add('hidden')
    this.eveningTarget.innerHTML = ''
  }

  setAlert(){
    this.reset()
    this.alertTarget.classList.remove('hidden')
  }
}

