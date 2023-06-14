import Clipboard from 'stimulus-clipboard'

export default class extends Clipboard {
  connect() {
    super.connect()
    console.log('Do what you want here.')
  }

  // Function to override on copy.
  copy() {
    event.preventDefault()

    const text = this.sourceTarget.innerText || this.sourceTarget.value

    navigator.clipboard.writeText(text).then(() => this.copied())
  }
}
