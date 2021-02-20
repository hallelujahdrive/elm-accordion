module AccordionTest exposing (..)

import Accordion
import Fuzz exposing ( bool)
import Html.Attributes as Attrs
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, style, tag)


accordion : Test
accordion =
    describe "Test of  Accordion node"
        [ fuzz bool "Accordion has expected attributes" <|
            \randomGeneratedBool ->
                Accordion.accordion []
                    (Accordion.head [] [])
                    (Accordion.body [] [])
                    randomGeneratedBool
                    |> Query.fromHtml
                    |> Query.has
                        [ if randomGeneratedBool then
                            classes [ "elm-accordion", "elm-accordion--open" ]

                          else
                            class "elm-accordion"
                        , tag "elm-accordion"
                        , attribute
                            (Attrs.attribute "aria-expanded" <|
                                if randomGeneratedBool then
                                    "true"

                                else
                                    "false"
                            )
                        ]
        , fuzz bool "Accordion.Head has expected attributes" <|
            \randomGeneratedBool ->
                Accordion.accordion []
                    (Accordion.head [] [])
                    (Accordion.body [] [])
                    randomGeneratedBool
                    |> Query.fromHtml
                    |> Query.find [ tag "elm-accordion-head" ]
                    |> Query.has [ class "elm-accordion__head" ]
        , fuzz bool "Accordion.Body has expected attributes" <|
            \randomGeneratedBool ->
                Accordion.accordion []
                    (Accordion.head [] [])
                    (Accordion.body [] [])
                    randomGeneratedBool
                    |> Query.fromHtml
                    |> Query.find [ tag "elm-accordion-body" ]
                    |> Query.has
                        [ class "elm-accordion__body"
                        , style "overflow" "hidden"
                        , attribute
                            (Attrs.attribute "aria-hidden" <|
                                if randomGeneratedBool then
                                    "false"

                                else
                                    "true"
                            )
                        ]
        ]
