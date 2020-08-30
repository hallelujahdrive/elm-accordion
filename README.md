![build](https://github.com/hallelujahdrive/elm-accordion/workflows/build/badge.svg)

# Elm Accordion

Simple Accordion for Elm.

This library adds an accordion element that toggles showing or hiding the content by increasing or decreasing its height.

## Getting started
### Installation
```
elm install hallelujahdrive/elm-croppie@1.0.0
```

This library relies on additional JavaScript and CSS. Your project must load them in one of the following ways.

### Embedding in HTML
The easy way is to add the following elements to your page:

```html
<link rel="stylesheet" type="text/css" href="https://unpkg.com/elm-accordion@1.0.0/dist/elm-accordion.min.css" />
<script src="https://unpkg.com/elm-accordion@1.0.0/dist/elm-accordion.min.js"></script>
```

### Using bundler
If you use bundler please instal the Javascript and CSS assets via npm:
```
npm install elm-accordion@1.0.0
```

Then in your Javascript add a following import:
```javascript
require("elm-accordio");
```

### Simple usage
```elm
import Accordion

type alias Model =
    Bool

type Msg
    = HeadClicked

view model =
    Accordion.accordion model
        []
        ( Accordion.head
            [ onClick HeadClicked ]
            [ text "Accordion head text content" ]
        )
        ( Accordion.body [] [ text "Accordion body content" ] )
```



## Browser support
This library is implemented using `custom elements`. Check the support status of [Custom Elements(V1)](https://caniuse.com/#feat=custom-elementsv1) for each broser.


## License
This library is licensed under [MIT](https://gtihub.com/elm-accordion/LICENSE).


## Contributions
Please submit your feedback using this library to [GitHub](htps://github.com/hallelujahdrive/elm-accirdion/issues).