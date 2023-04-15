import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['button']

  connect() {
    this.id = this.element.dataset.restaurant
    this.token = document.querySelector("meta[name='csrf-token']").content
    this.fetch_date()
  }

  disable_off_day(enableDayOfWeek){

    this.buttonTargets.filter(day => {
      if(enableDayOfWeek.includes(+day.firstElementChild.value)){
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
    .then(({enableDayOfWeek}) => {
      this.disable_off_day(enableDayOfWeek)
    })
    .catch((e) => {
      console.log(e, 'error');
    })
  }
}
