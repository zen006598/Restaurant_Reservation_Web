import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['kid', 'adult']
  fetchQuantity() {
    this.id = this.element.dataset.restaurant
    this.token = document.querySelector("meta[name='csrf-token']").content
    const people_sum = +this.kidTarget.value + +this.adultTarget.value

    fetch(`/restaurants/${this.id}/get_available_seat`,{
      method: 'POST',
      headers: {
        "X-CSRF-Token": this.token,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify ({
        people_sum: people_sum
      })
    }).then((resp) => resp.json())
    .then(({alert}) => {
      if(alert === 'unavailable' ){
        this.dispatch('alert')
      }
    })
    .catch((e) => console.log(e, 'error'))
  }
}
