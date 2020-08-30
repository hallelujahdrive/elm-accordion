import "../elm-accordion.scss";

class ElmAccordion extends HTMLElement {

    head_: undefined | HTMLElement;
    body_: undefined | HTMLElement;

    open_: boolean;

    set open (open: boolean) {
        this.open_ = open;
        this.updateHeight();
    }

    constructor () {
        super ();
        this.open_ = false;
    }

    connectedCallback () {
        this.head_ = this.getElementsByTagName ("elm-accordion-head")[0] as HTMLElement;
        this.body_ = this.getElementsByTagName ("elm-accordion-body")[0] as HTMLElement;

        this.updateHeight();
    }

    disconnectedCallback () {
    }

    private updateHeight () {
        requestAnimationFrame (() => {
            if (this.body_) {
            
                if (this.open_) {
                    this.body_.style.height = this.body_.scrollHeight + "px";
                } else {
                    this.body_.style.height = "0px";
                }
            }
        });
    }
}

customElements.define ("elm-accordion", ElmAccordion);