import NestedForm from 'stimulus-rails-nested-form'

export default class extends NestedForm {
  static targets = ['title', 'submit']
  connect() {
    super.connect()
  }

  setSubmit(){
    const titleValue = this.titleTarget.value;
    this.submitTarget.disabled = !titleValue;
    this.submitTarget.classList.toggle('major-button', titleValue);
    this.submitTarget.classList.toggle('disabled-button', !titleValue);
  }
}