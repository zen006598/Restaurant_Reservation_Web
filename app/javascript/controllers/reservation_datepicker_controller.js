import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.id = this.element.dataset.restaurant
    this.token = document.querySelector("meta[name='csrf-token']").content
  }
  connect(){
    fetch(`/restaurants/${this.id}`,{
      method: 'GET',
      headers: {
        "X-CSRF-Token": this.token,
      }
    }).then((resp) => resp.json())
    .then(({maxDate, disable, defaultDate}) => {
      flatpickr("#reservation-datepicker", {
        dateFormat: "Y-m-d",
        minDate: 'today',
        showMonths: 2,
        maxDate: maxDate,
        disable: disable,
        defaultDate: defaultDate
      })
    })
    .catch((e) => console.log(e, 'error'))
  }
}
