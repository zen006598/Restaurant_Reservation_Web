import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['show', 'title', 'list', 'button', 'frameList']
  unfold(){
    this.dispatch('unfold')
  }

  setList(e){
    const seatModuleTitle  = e.detail.detailInfo.seat_module
    const seats  = e.detail.detailInfo.seats


    this.setButton()
    this.titleTarget.innerText = seatModuleTitle
    this.listTarget.innerHTML = ''

    seats.forEach(e => {
      const seat_id = e.id
      const context = `
        <div class='flex items-center justify-between rounded bg-bgGray'>
        <div class='p-4'>
          <div class='text-lg font-bold'>${e.title}</div>
          <span class='text-xl'><i class="fa-solid fa-person"></i></span>
          <span class='text-2xl text-major'>${e.capacity}</span>
        </div>
        <div class='relative flex items-center h-full'>
          <i class="px-4 py-2 fa-solid fa-ellipsis-vertical text-slate-200 peer"></i>
          <div class='absolute top-0 right-0 hidden p-4 rounded bg-bgGray peer-hover:block hover:block'>
            <a href="/admin/seats/${seat_id}/edit">
              <div class="flex items-center justify-between hover:text-major">
                edit
                <i class="fa-solid fa-pen-to-square"></i>
              </div>
            </a>
            
            <a data-turbo-method="delete" data-message="Are you sure?" href="/admin/seats/${seat_id}">
              <div class="flex items-center justify-between text-red-600 hover:text-red-700">
                Delete
                <i class="ml-2 text-sm fa-solid fa-trash"></i>
              </div>
            </a>
          </div>
        </div>
      `
      this.listTarget.insertAdjacentHTML('afterbegin', context)
    })
  }

  setButton(){
    this.buttonTarget.classList.remove('hidden')
  }
}
