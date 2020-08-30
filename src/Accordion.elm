module Accordion exposing
    ( accordion
    , Head, head
    , Body, body
    )

{-| # Basic Usage

    import Accordion

    type alias Model =
        Bool

    type Msg
        = HeadClicked

    view model =
        Accordion.accordion model
            (Accordion.head
                [ onClick HeadClicked ]
                headChildren
            )
            (Accordion.body
                []
                bodyChildren
            )

    uodate msg model =
        case msg of
            HeadClicked ->
                ( not model
                , Cmd.none
                )


# Accodion

@docs accordion


# Accordion head

@docs Head, head


# Accordion body

@docs Body, body


# List of Accordions

-}

import Accordion.Internal as Internal exposing (Body(..), Head(..))
import Html exposing (Html)
import Html.Attributes exposing (attribute, class, classList, property, style)
import Json.Encode as Encode


{-| Accordion body type
-}
type alias Body msg =
    Internal.Body msg


{-| Accordion head type
-}
type alias Head msg =
    Internal.Head msg


{-| Accordion view function

  - `attributes` List of attributes
  - `head` An accordion head element
  - `body` An accordion body element
  - `open` Specify whether a dailog is open

-}
accordion : List (Html.Attribute msg) -> Head msg -> Body msg -> Bool -> Html msg
accordion attributes (Head head_) (Body body_) open =
    Html.node "elm-accordion"
        ([ accordionCsList open
         , expandedAttr open
         , openProp open
         ]
            ++ attributes
        )
        [ head_
        , body_ (hiddenAttr open)
        ]


accordionCsList : Bool -> Html.Attribute msg
accordionCsList open =
    classList
        [ ( "elm-accordion", True )
        , ( "elm-accordion--open", open )
        ]


expandedAttr : Bool -> Html.Attribute msg
expandedAttr open =
    attribute "aria-expanded"
        (if open then
            "true"

         else
            "false"
        )


openProp : Bool -> Html.Attribute msg
openProp open =
    property "open" <| Encode.bool open


hiddenAttr : Bool -> Html.Attribute msg
hiddenAttr open =
    attribute "aria-hidden"
        (if open then
            "false"

         else
            "true"
        )


{-| Accordion head constructor

  - `attributes` List of attributes
  - `children` List of child elements

-}
head : List (Html.Attribute msg) -> List (Html msg) -> Head msg
head attributes children =
    Head <|
        Html.node "elm-accordion-head"
            (headCs :: attributes)
            children


headCs : Html.Attribute msg
headCs =
    class "elm-accordion__head"


{-| Accordion body constructor

  - `attributes` List of attributes
  - `children` List of child elements

-}
body : List (Html.Attribute msg) -> List (Html msg) -> Body msg
body attributes children =
    Body <|
        \attr_ ->
            Html.node "elm-accordion-body"
                ([ bodyCs
                 , overflowAttr
                 , attr_
                 ]
                    ++ attributes
                )
                children


bodyCs : Html.Attribute msg
bodyCs =
    class "elm-accordion__body"


overflowAttr : Html.Attribute msg
overflowAttr =
    style "overflow" "hidden"
