import Clipboard from 'stimulus-clipboard'

export default class extends Clipboard {
  copy(event) {
    event.preventDefault()

    const text = this.sourceTarget.innerText || this.sourceTarget.value

    navigator.clipboard.writeText(text).then(() => this.copied())
  }
}
