import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.id = window.location.href.split('/').reverse()[0]
    this.token = document.querySelector("meta[name='csrf-token']").content
  }

  setTable(e){
    const tableType = e.target.value
    this.fetchTable(tableType)
  }

  fetchTable(tableType){
    fetch(`/restaurants/${this.id}/get_unavailable_time`, {
      method: 'POST',
      headers: {
        "X-CSRF-Token": this.token,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify ({
        tableType: tableType,
        choiceDate: this.choiceDate
      })
    }).then((resp) => resp.json())
    .then(({fully_occupied_time }) => {
      this.dispatchUnavailableTime(fully_occupied_time)
    })
    .catch((e) => console.log(e, 'error'))
  }

  dispatchUnavailableTime(fully_occupied_time){
    this.dispatch('unavailableTime', {detail: {unavailableTime: fully_occupied_time}})
  }

  getChoiceDate(e){
    this.choiceDate = e.detail.choiceDate
  }
}
