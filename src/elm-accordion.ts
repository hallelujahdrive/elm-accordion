import "../elm-accordion.scss";

class ElmAccordion extends HTMLElement {
  head_: undefined | HTMLElement;
  body_: undefined | HTMLElement;

  open_: boolean;

  set open(open: boolean) {
    this.open_ = open;
    this.updateHeight();
  }

  constructor() {
    super();
    this.open_ = false;
  }

  connectedCallback() {
    this.head_ = this.getElementsByTagName(
      "elm-accordion-head"
    )[0] as HTMLElement;
    this.body_ = this.getElementsByTagName(
      "elm-accordion-body"
    )[0] as HTMLElement;

    this.body_.addEventListener(
      "transitionend",
      this.transitionEndFunc.bind(this)
    );

    this.updateHeight();
  }

  disconnectedCallback() {
    this.body_?.removeEventListener(
      "transitionend",
      this.transitionEndFunc.bind(this)
    );
  }

  private updateHeight() {
    requestAnimationFrame(() => {
      if (this.body_) {
        this.body_.style.height = this.body_.scrollHeight + "px";
        if (!this.open_) {
          requestAnimationFrame(() => {
            this.body_ && (this.body_.style.height = "0px");
          });
        }
      }
    });
  }

  private transitionEndFunc() {
    this.body_ && (this.body_.style.height = this.open_ ? "auto" : "0px");
  }
}

customElements.define("elm-accordion", ElmAccordion);
