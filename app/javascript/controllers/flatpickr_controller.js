import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect(){
    const id = this.element.dataset.restaurant
    const token = document.querySelector("meta[name='csrf-token']").content

    fetch(`/admin/restaurants/${id}/setting`,{
      method: 'GET',
      headers: {
        "X-CSRF-Token": token,
      }
    }).then((resp) => resp.json())
    .then(({_offDays, disableDayOfWeek}) => { 
      flatpickr("#datepicker", {
        mode: 'multiple',
        dateFormat: "Y-m-d",
        minDate: 'today',
        showMonths: 2,
        disable: [
          function(date) {
            const offDays = _offDays.map(e => e.day)
            return offDays.includes(date.getFullYear() + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getDate().toString().padStart(2, '0'));
          },
          function(date) {
            return disableDayOfWeek?.includes(date.getDay());
          }
        ]
      })  
    })
    .catch((e) => {
      console.log(e, 'error');
    })
  }
}