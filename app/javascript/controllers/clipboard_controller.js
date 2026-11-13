import Clipboard from 'stimulus-clipboard'

export default class extends Clipboard {
  static values = { rich: Boolean }

  async copy(event) {
    event.preventDefault()

    const text = this.sourceTarget.innerText || this.sourceTarget.value

    if (this.richValue && navigator.clipboard.write && typeof ClipboardItem !== 'undefined') {
      try {
        await navigator.clipboard.write([new ClipboardItem({
          'text/html': new Blob([this.sourceTarget.innerHTML], { type: 'text/html' }),
          'text/plain': new Blob([text], { type: 'text/plain' })
        })])
        this.copied()
        return
      } catch {
        // Some browsers reject HTML clipboard writes but still allow plain text.
      }
    }

    await navigator.clipboard.writeText(text)
    this.copied()
  }
}
