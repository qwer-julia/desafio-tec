import { Controller } from "@hotwired/stimulus"

// Toolbar that inserts Markdown syntax around the selection of a textarea.
export default class extends Controller {
  static targets = ["input"]

  bold() { this.#wrap("**", "**", "texto em negrito") }
  code() { this.#wrap("`", "`", "código") }
  codeBlock() { this.#wrap("\n```\n", "\n```\n", "seu código aqui") }
  heading1() { this.#prefixLine("# ") }
  heading2() { this.#prefixLine("## ") }
  heading3() { this.#prefixLine("### ") }
  list() { this.#prefixLine("- ") }

  #wrap(before, after, placeholder) {
    const input = this.inputTarget
    const { selectionStart: start, selectionEnd: end, value } = input
    const selected = value.slice(start, end) || placeholder
    input.setRangeText(before + selected + after, start, end)
    input.setSelectionRange(start + before.length, start + before.length + selected.length)
    input.focus()
  }

  #prefixLine(prefix) {
    const input = this.inputTarget
    const lineStart = input.value.lastIndexOf("\n", input.selectionStart - 1) + 1
    const cursor = input.selectionStart + prefix.length
    input.setRangeText(prefix, lineStart, lineStart)
    input.setSelectionRange(cursor, cursor)
    input.focus()
  }
}
