module Accordion.Internal exposing
    ( Body(..)
    , Head(..)
    , Status(..)
    )

import Html exposing (Html)
import Set exposing (Set)


type Body msg
    = Body (Html.Attribute msg -> Html msg)


type Head msg
    = Head (Html msg)


type Status comparable
    = Multiple (Set comparable)
    | Single (Maybe comparable)
