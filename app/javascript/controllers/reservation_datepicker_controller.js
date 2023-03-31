import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect(){
    this.id = this.element.dataset.restaurant
    this.token = document.querySelector("meta[name='csrf-token']").content

    this.fetchBusinessTimes(new Date().toDateString())

    fetch(`/restaurants/${this.id}`,{
      method: 'GET',
      headers: {
        "X-CSRF-Token": this.token,
      }
    }).then((resp) => resp.json())
    .then(({enable_day}) => { 
      flatpickr("#reservation-datepicker", {
        dateFormat: "Y-m-d",
        minDate: 'today',
        showMonths: 2,
        enable: enable_day,
        defaultDate: 'today'
      })
    })
    .catch((e) => console.log(e, 'error'))
  }

  getBusinessTime(e){
    const day = e.currentTarget.value
   this.fetchBusinessTimes(day)
  }

  dispatchTime(business_times){
    this.dispatch('businessTime', {detail: {business_times: business_times}})
  }

  fetchBusinessTimes(day){
    fetch(`/restaurants/${this.id}/get_business_times`,{
      method: 'POST',
      headers: {
        "X-CSRF-Token": this.token,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify ({
        day: day
      })
    }).then((resp) => resp.json())
    .then(({business_times}) => {
      this.dispatchTime(business_times)
    })
    .catch((e) => console.log(e, 'error'))
  }
}
