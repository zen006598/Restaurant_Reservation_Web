import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize(){   
     flatpickr("#datepicker", {
      mode: 'multiple',
      dateFormat: "Y-m-d",
      minDate: 'today',
      showMonths: 2,
      disable: []
    }) 
  }
  connect(){
    const id = this.element.dataset.restaurant
    const token = document.querySelector("meta[name='csrf-token']").content

    fetch(`/admin/restaurants/${id}/setting`,{
      method: 'GET',
      headers: {
        "X-CSRF-Token": token,
      }
    }).then((resp) => resp.json())
    .then(({off_days, off_days_of_week}) => { 
      flatpickr("#datepicker", {
        mode: 'multiple',
        dateFormat: "Y-m-d",
        minDate: 'today',
        showMonths: 2,
        disable: [
          function(date) {
            const offDays = off_days.map(e => e.day)
            return offDays.includes(date.getFullYear() + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getDate().toString().padStart(2, '0'));
          },
          function(date) {
            return off_days_of_week?.includes(date.getDay());
          }
        ]
      })  
    })
    .catch(() => {
      console.log("error!!");
    })

  }
}