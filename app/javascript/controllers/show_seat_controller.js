import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  }
  show(e){
    e.preventDefault()
    const seatModuleId = e.currentTarget.dataset.seatModule
    this.fetch_date(seatModuleId)
  }

  fetch_date(seatModuleId){
    
    fetch(`/admin/seat_modules/${seatModuleId}/`,{
      method: 'GET',
      headers: {
        "X-CSRF-Token": this.token,
      }
    }).then(resp => resp.json())
    .then((resp) => {
      this.addEvent('showSeats', resp)
    })
    .catch((e) => {
      console.log(e, 'error');
    })
  }

  addEvent(title, detailInfo){
    this.dispatch(title)
    this.dispatch(title, {detail: {detailInfo}})
  }
}
