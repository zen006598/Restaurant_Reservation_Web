import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect(){
    const id = this.element.dataset.restaurant
    const token = document.querySelector("meta[name='csrf-token']").content

    fetch(`/restaurants/${id}`,{
      method: 'GET',
      headers: {
        "X-CSRF-Token": token,
      }
    }).then((resp) => resp.json())
    .then(({enable_day}) => { 
      flatpickr("#reservation-datepicker", {
        dateFormat: "Y-m-d",
        minDate: 'today',
        showMonths: 2,
        enable: enable_day
      })  
    })
    .catch((e) => console.log(e, 'error'))
  }
}
