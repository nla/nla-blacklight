// app/javascript/blacklight-frontend/custom_checkbox_submit.js
import CheckboxSubmit from 'blacklight-frontend/checkbox_submit';

export default class CCheckboxSubmit extends CheckboxSubmit {


  clicked(evt) {
    this.spanTarget.innerHTML = this.form.getAttribute('data-inprogress')
    this.labelTarget.setAttribute('disabled', 'disabled');
    this.checkboxTarget.setAttribute('disabled', 'disabled');
    fetch(this.formTarget.getAttribute('action'), {
      body: new FormData(this.formTarget),
      method: this.formTarget.getAttribute('method').toUpperCase(),
      headers: {
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector('meta[name=csrf-token]')?.content
      }
    }).then((response) => {
      if (response.ok) return response.json();
      return Promise.reject('response was not ok')
    }).then((json) => {
      this.labelTarget.removeAttribute('disabled')
      this.checkboxTarget.removeAttribute('disabled')
      this.checkboxTarget.focus()
      this.updateStateFor(!this.checked)
      this.bookmarksCounter().forEach(counter => {
        counter.innerHTML = json.bookmarks.count;
      });
    }).catch((error) => {
      this.handleError(error)
    })
  }


  get checked() {
    return (this.form.querySelectorAll('input[name=_method][value=delete]').length != 0)
  }

  get formTarget() {
    return this.form
  }

  get labelTarget() {
    return this.form.querySelector('[data-ccheckboxsubmit-target="label"]')
  }

  get checkboxTarget() {
    return this.form.querySelector('[data-ccheckboxsubmit-target="checkbox"]')
  }

  get spanTarget() {
    return this.form.querySelector('[data-ccheckboxsubmit-target="span"]')
  }

  bookmarksCounter() {
    return document.querySelectorAll('[data-role="bookmark-counter"]')
  }

  handleError() {
    alert("Unable to save the bookmark at this time.")
  }

  updateStateFor(state) {
    this.checkboxTarget.checked = state

    if (state) {
      this.labelTarget.classList.add('checked')
      //Set the Rails hidden field that fakes an HTTP verb
      //properly for current state action.
      this.formTarget.querySelector('input[name=_method]').value = 'delete'
      this.spanTarget.innerHTML = this.form.getAttribute('data-present')
    } else {
      this.labelTarget.classList.remove('checked')
      this.formTarget.querySelector('input[name=_method]').value = 'put'
      this.spanTarget.innerHTML = this.form.getAttribute('data-absent')
    }
  }
}
