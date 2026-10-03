import { Controller } from "@hotwired/stimulus"

// Live preview: rebuilds the layer stack (base, one costume, accessories on top) from the form inputs.
export default class extends Controller {
  static targets = ["stage"]

  connect() {
    this.template = this.stageTarget.querySelector("img")
    this.update()
  }

  update() {
    const checked = [...this.element.querySelectorAll("input:checked[data-layer]")]
    const costume = checked.find((input) => input.type === "radio")
    const accessories = checked.filter((input) => input.type === "checkbox")
    const names = ["neutro", costume?.dataset.layer, ...accessories.map((input) => input.dataset.layer)].filter(Boolean)

    this.stageTarget.replaceChildren(...names.map((name) => {
      const img = this.template.cloneNode()
      img.src = `/avatar/${name}.png`
      img.dataset.layer = name
      return img
    }))
  }
}
