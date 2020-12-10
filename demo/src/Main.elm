module Main exposing (main)

import Accordion
import Accordion.List as AccordionList
import Browser
import Html exposing (Html, text)
import Html.Attributes exposing (checked, class, href, id, rel, target, type_)
import Html.Events exposing (onCheck, onClick)


version =
    "1.0.2"


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { simpleOpen : Bool
    , simpleCodeOpen : Bool
    , customizedOpen : Bool
    , customizedCodeStatus : AccordionList.Status String
    , listOpen : Bool
    , listMultiOpen : Bool
    , listStatus : AccordionList.Status String
    }


type Example
    = Customized
    | List_


init : () -> ( Model, Cmd Msg )
init _ =
    ( { simpleOpen = False
      , simpleCodeOpen = True
      , customizedOpen = False
      , customizedCodeStatus =
            AccordionList.multiOpen [ "customized-elm-code-accordion" ]
      , listOpen = True
      , listMultiOpen = False
      , listStatus = AccordionList.singleOpen Nothing
      }
    , Cmd.none
    )


type Msg
    = SwitchToggled
    | Toggled String
    | UpdateStatus Example String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SwitchToggled ->
            ( { model
                | listMultiOpen = not model.listMultiOpen
                , listStatus =
                    if model.listMultiOpen then
                        AccordionList.singleOpen Nothing

                    else
                        AccordionList.multiOpen []
              }
            , Cmd.none
            )

        Toggled id_ ->
            ( case id_ of
                "simple-accordion" ->
                    { model | simpleOpen = not model.simpleOpen }

                "simple-code-accordion" ->
                    { model | simpleCodeOpen = not model.simpleCodeOpen }

                "customized-accordion" ->
                    { model | customizedOpen = not model.customizedOpen }

                "list-code-accordion" ->
                    { model | listOpen = not model.listOpen }

                _ ->
                    model
            , Cmd.none
            )

        UpdateStatus example id_ ->
            case example of
                Customized ->
                    ( { model
                        | customizedCodeStatus = AccordionList.update id_ model.customizedCodeStatus
                      }
                    , Cmd.none
                    )

                List_ ->
                    ( { model
                        | listStatus = AccordionList.update id_ model.listStatus
                      }
                    , Cmd.none
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Accordion - Simple Accordion for Elm"
    , body = body model
    }


body : Model -> List (Html Msg)
body model =
    [ header
    , page model
    , footer
    ]


header : Html Msg
header =
    Html.header []
        [ Html.div [ class "header-wrapper" ]
            [ Html.nav [ class "header-nav" ]
                [ Html.a [ href "#getting-started" ] [ text "Getting started" ]
                , Html.a [ href "#documentation" ] [ text "Documentation" ]
                , Html.a [ href "#example" ] [ text "Examples" ]
                , Html.a [ href "#browser-support" ] [ text "About" ]
                ]
            , Html.div [ class "header-title-container" ]
                [ Html.h2 [ class "header-title" ] [ text "Elm Accordion" ]
                , Html.p [ class "header-caption" ]
                    [ text "The simple accordion for Elm" ]
                ]
            , Html.div [ class "header-buttons-container" ]
                [ Html.a
                    [ class "outlined-button"
                    , href "https://elm-packages/hallelujahdrive/elm-accordion/latest"
                    , rel "noopener"
                    , target "_new"
                    ]
                    [ text "Elm Packages" ]
                , Html.a
                    [ class "outlined-button"
                    , href "https://github.com/hallelujahdrive/elm-accordion"
                    , rel "noopener"
                    , target "_new"
                    ]
                    [ text "GitHub" ]
                ]
            ]
        ]


page : Model -> Html Msg
page model =
    Html.main_ [ class "page-container" ]
        [ Html.p [] [ text "This library adds an accordion element that toggles showing or hiding the content by increasing or decreasing its height." ]
        , gettingStarted
        , documentation
        , examples model
        , browserSupport
        , license
        , contributions
        ]


gettingStarted : Html Msg
gettingStarted =
    Html.section [ id "getting-started" ]
        [ Html.h4 [ class "section-title" ] [ text "Getting started" ]
        , installation
        , simpleUsage
        ]


installation : Html Msg
installation =
    Html.section
        [ id "installation"
        , class "subsection"
        ]
        [ Html.h5 [ class "section-title" ] [ text "Installation" ]
        , preCode "elm" ("elm install hallelujahdrive/elm-accordion@" ++ version)
        , Html.hr [] []
        , Html.p [] [ text "This library relies on additional JavaScript and CSS. Your project must load them in one of the following ways." ]
        , Html.div [ class "subsubsection" ]
            [ Html.h6 [ class "subsubsection-title" ] [ text "Embedding in HTML" ]
            , Html.p [] [ text "The easy way is to add the following elements to your page:" ]
            , preCode "html" embeddingCode
            ]
        , Html.div [ class "subsubsection" ]
            [ Html.h6 [ class "subsubsection-title" ] [ text "Using bundler" ]
            , Html.p [] [ text "If you want to use a bundler like webpack you can install the package from npm:" ]
            , preCode "javascript" ("npm install elm-accordion@" ++ version)
            , Html.p [] [ text "And in your Javascript add the following import:" ]
            , preCode "javascript" """require("elm-accordion/dist/elm-accordion.min.js");
require("elm-accordion/dist/elm-accordion.min.css");
"""
            ]
        ]


simpleUsage : Html Msg
simpleUsage =
    Html.section
        [ id "simple-usage"
        , class "subsection"
        ]
        [ Html.h5 [ class "subsection-title" ] [ text "Simple Usage" ]
        , Html.p []
            [ text "Write code like the following. Check the "
            , Html.a [ href "#documentation" ] [ text "Documentation" ]
            , text " for more information on the module."
            ]
        , preCode "elm" usageCode
        ]


documentation : Html Msg
documentation =
    Html.section [ id "documentation" ]
        [ Html.h4 [ class "section-title" ] [ text "Documentation" ]
        , accordionDoc
        , accordionListDoc
        ]


accordionDoc : Html Msg
accordionDoc =
    Html.section [ class "subsection" ]
        [ Html.h5 [ class "subsection-title" ] [ text "Accordion" ]
        , Html.div
            [ id "accordion"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ functionToken "accordion"
                    , collon
                    , token "List (Attribute msg)"
                    , arrow
                    , linkToken "Head"
                    , space
                    , token "msg"
                    , arrow
                    , linkToken "Body"
                    , space
                    , token "msg"
                    , arrow
                    , token "Bool"
                    , arrow
                    , token "Html msg"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Accordion view function." ]
                , Html.ul []
                    [ Html.li []
                        [ Html.code [] [ text "attributes" ]
                        , text " List of attributes"
                        ]
                    , Html.li []
                        [ Html.code [] [ text "head" ]
                        , text " An accordion head element."
                        ]
                    , Html.li []
                        [ Html.code [] [ text "body" ]
                        , text " An accordion body element."
                        ]
                    , Html.li []
                        [ Html.code [] [ text "open" ]
                        , text " Specify whether a dailog is open"
                        ]
                    ]
                ]
            ]
        , Html.h6 [ class "subsubsection-title" ] [ text "Accordion Head" ]
        , Html.div
            [ id "Head"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ typeKeyword_
                    , aliasKeyword_
                    , functionToken "Head"
                    , space
                    , token "msg"
                    , equal
                    ]
                , Html.div []
                    [ tab
                    , token "Head msg"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Accordion head type" ]
                ]
            ]
        , Html.div
            [ id "head"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ functionToken "head"
                    , collon
                    , token "List (Attribute msg)"
                    , arrow
                    , token "List (Html msg)"
                    , arrow
                    , linkToken "Head"
                    , space
                    , token "msg"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Accordion head constructor" ]
                , Html.ul []
                    [ Html.li []
                        [ Html.code [] [ text "attributes" ]
                        , Html.span [] [ text " List of attributes" ]
                        ]
                    , Html.li []
                        [ Html.code [] [ text "children" ]
                        , Html.span [] [ text " List of child elements" ]
                        ]
                    ]
                ]
            ]
        , Html.h6 [ class "subsubsection-title" ] [ text "Accordion Body" ]
        , Html.div [ class "doc-block" ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ typeKeyword_
                    , aliasKeyword_
                    , functionToken "Body"
                    , space
                    , token "msg"
                    , equal
                    ]
                , Html.div []
                    [ tab
                    , token "Body msg"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Accordion body type" ]
                ]
            ]
        , Html.div [ class "doc-block" ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ functionToken "body"
                    , collon
                    , token "List (Attribute msg)"
                    , arrow
                    , token "List (Html msg)"
                    , arrow
                    , linkToken "Body"
                    , space
                    , token "msg"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Accordion body constructor" ]
                , Html.ul []
                    [ Html.li []
                        [ Html.code [] [ text "attributes" ]
                        , Html.span [] [ text " List of attributes" ]
                        ]
                    , Html.li []
                        [ Html.code [] [ text "children" ]
                        , Html.span [] [ text " List of child elements" ]
                        ]
                    ]
                ]
            ]
        ]


accordionListDoc : Html Msg
accordionListDoc =
    Html.section [ class "subsection" ]
        [ Html.h5 [ class "subsection-title" ] [ text "Accordion.List" ]
        , Html.p [] [ text "The status of multiple accordions can be managed collectively and linked." ]
        , Html.h6 [ class "subsubsection-title" ] [ text "Status" ]
        , Html.div
            [ id "Multiple accordions Status"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ typeKeyword_
                    , aliasKeyword_
                    , functionToken "Status"
                    , space
                    , token "comparable"
                    , equal
                    ]
                , Html.div []
                    [ tab
                    , token "Status comparable"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Multiple accordions status type" ]
                ]
            ]
        , Html.div
            [ id "multiOpen"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ functionToken "multiOpen"
                    , collon
                    , token "List comparable"
                    , arrow
                    , linkToken "Status"
                    , space
                    , token "comparable"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Initialize multiple open Status." ]
                , Html.ul []
                    [ Html.li []
                        [ Html.code [] [ text "values" ]
                        , text " List of values associated with open accordions(e.g. List of "
                        , Html.code [] [ text "id" ]
                        , text ")."
                        ]
                    ]
                ]
            ]
        , Html.div
            [ id "singleOpen"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ functionToken "singleOpen"
                    , collon
                    , token "Maybe comparable"
                    , arrow
                    , linkToken "Status"
                    , space
                    , token "comparable"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Initialize single open Status." ]
                , Html.ul []
                    [ Html.li []
                        [ Html.code [] [ text "value" ]
                        , text " A value of associated with open accordion(e.g. "
                        , Html.code [] [ text "id" ]
                        , text ")."
                        ]
                    ]
                ]
            ]
        , Html.h6 [ class "subsubsection-title" ] [ text "Update Status" ]
        , Html.div
            [ id "update"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ functionToken "update"
                    , collon
                    , token "comparable"
                    , arrow
                    , linkToken "Status"
                    , space
                    , token "comparable"
                    , arrow
                    , linkToken "Status"
                    , space
                    , token "comparable"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Toggle the state of the argument value." ]
                ]
            ]
        , Html.h6 [ class "subsubsection-title" ] [ text "Check status" ]
        , Html.div
            [ id "isOpen"
            , class "doc-block"
            ]
            [ Html.div [ class "doc-header" ]
                [ Html.div []
                    [ functionToken "isOpen"
                    , collon
                    , token "comparable"
                    , arrow
                    , linkToken "Status"
                    , space
                    , token "comparable"
                    , arrow
                    , token "Bool"
                    ]
                ]
            , Html.div [ class "doc-comment" ]
                [ Html.p [] [ text "Check value status if it is open." ]
                ]
            ]
        ]


examples : Model -> Html Msg
examples model =
    Html.section [ id "examples" ]
        [ Html.h4 [ class "section-title" ] [ text "Examples" ]
        , simpleExample model
        , customizedExample model
        , listExample model
        ]


simpleExample : Model -> Html Msg
simpleExample { simpleOpen, simpleCodeOpen } =
    Html.section
        [ id "simple-example"
        , class "subsection"
        ]
        [ Html.h5 [ class "subsection-title" ] [ text "Simple Accordion" ]
        , Html.p [] [ text "Simple accordion with text content only." ]
        , Html.div [ class "example-container" ]
            [ Accordion.accordion [ id "simple-accordion" ]
                (Accordion.head [ onClick (Toggled "simple-accordion") ]
                    [ text "Let's click this text" ]
                )
                (Accordion.body [] [ text "Simple accordion body content" ])
                simpleOpen
            ]
        , Html.div [ class "code-conteiner" ]
            [ Accordion.accordion
                [ id "simple-code-accordion"
                , class "code-accordion"
                ]
                (Accordion.head
                    [ class "code-accordion__head"
                    , onClick (Toggled "simple-code-accordion")
                    ]
                    [ text "Elm code:"
                    , Html.span [ class "code-accordion__head__tail" ]
                        [ Html.i [ class "material-icons" ] [ text "arrow_drop_down" ]
                        ]
                    ]
                )
                (Accordion.body [ class "code-accordion__body" ] [ preCode "elm" simpleCode ])
                simpleCodeOpen
            ]
        ]


customizedExample : Model -> Html Msg
customizedExample { customizedOpen, customizedCodeStatus } =
    let
        accordion_ { id_, label_, lang_, code_ } =
            codeAccordion customizedCodeStatus Customized id_ label_ lang_ code_
    in
    Html.section
        [ id "customized-example"
        , class "subsection"
        ]
        [ Html.h5 [ class "subsection-title" ] [ text "Accordion customization" ]
        , Html.p []
            [ text "You can set any element on the head and body of the accordion. If you want to change the style of the open accordion, specify "
            , Html.code [] [ text ".elm-accordion--open" ]
            , text " in the class selector."
            ]
        , Html.div [ class "example-container" ]
            [ Accordion.accordion
                [ id "customized-accordion"
                , class "example-accordion"
                ]
                (Accordion.head
                    [ class "example-accordion__head"
                    , onClick (Toggled "customized-accordion")
                    ]
                    (exampleHeadChildren "Customized accordion")
                )
                (Accordion.body [ class "example-accordion__body" ]
                    [ Html.ul [] <|
                        List.map
                            (\i -> Html.li [] [ text ("Text line " ++ String.fromInt i) ])
                        <|
                            List.range 1 5
                    ]
                )
                customizedOpen
            ]
        , Html.div [ class "code-container" ] <|
            List.map accordion_
                [ { id_ = "customized-elm-code-accordion"
                  , label_ = "Elm code:"
                  , lang_ = "elm"
                  , code_ = customizedElmCode
                  }
                , { id_ = "customized-css-code-accordion"
                  , label_ = "CSS code:"
                  , lang_ = "css"
                  , code_ = customizedCssCode
                  }
                ]
        ]


listExample : Model -> Html Msg
listExample { listOpen, listMultiOpen, listStatus } =
    let
        id_ index_ =
            "list-accordion" ++ String.fromInt index_

        accordion_ index_ =
            Accordion.accordion
                [ id (id_ index_)
                , class "example-accordion"
                ]
                (Accordion.head
                    [ class "example-accordion__head"
                    , onClick (UpdateStatus List_ <| id_ index_)
                    ]
                    (exampleHeadChildren <| "Accordion " ++ String.fromInt index_)
                )
                (Accordion.body [ class "example-accordion__body" ]
                    [ Html.p [] [ text lipsum ] ]
                )
                (AccordionList.isOpen (id_ index_) listStatus)
    in
    Html.section
        [ id "list-example"
        , class "subsection"
        ]
        [ Html.h5 [ class "subsection-title" ] [ text "List of accordions" ]
        , Html.p [] [ text "Controls the status of multiple Accordions collectively." ]
        , Html.div [ class "example-container" ] <|
            Html.span [ class "switch-container" ]
                [ toggleSwitch listMultiOpen
                , text "Multipe open"
                ]
                :: List.map accordion_ (List.range 1 5)
        , Html.div [ class "code-container" ]
            [ Accordion.accordion
                [ id "list-code-accordion"
                , class "code-accordion"
                ]
                (Accordion.head
                    [ class "code-accordion__head"
                    , onClick (Toggled "list-code-accordion")
                    ]
                    [ text "Elm code:"
                    , Html.span [ class "code-accordion__head__tail" ]
                        [ Html.i [ class "material-icons" ] [ text "arrow_drop_down" ]
                        ]
                    ]
                )
                (Accordion.body [ class "code-accordion__body" ] [ preCode "elm" listCode ])
                listOpen
            ]
        ]


browserSupport : Html Msg
browserSupport =
    Html.section [ id "browser-support" ]
        [ Html.h4 [ class "section-title" ] [ text "Browser support" ]
        , Html.p []
            [ text "This library is implemented using "
            , Html.code [] [ text "custom elements" ]
            , text ". Check the support status of "
            , Html.a
                [ href "https://caniuse.com/#feat=custom-elementsv1"
                , rel "noopener"
                , target "_new"
                ]
                [ text "Custom Elements(V1)" ]
            , text " for each broser. "
            ]
        ]


license : Html Msg
license =
    Html.section [ id "license" ]
        [ Html.h4 [ class "section-title" ] [ text "License" ]
        , Html.p []
            [ text "This library is licensed under "
            , Html.a
                [ href "https://gtihub.com/elm-accordion/LICENSE"
                , rel "noopener"
                , target "_new"
                ]
                [ text "MIT License" ]
            , text "."
            ]
        ]


contributions : Html Msg
contributions =
    Html.section [ id "contributuins" ]
        [ Html.h4 [ class "section-title" ] [ text "Contributions" ]
        , Html.p []
            [ text "Please submit your feedback using this library to "
            , Html.a
                [ href "htps://github.com/hallelujahdrive/elm-accirdion/issues"
                , rel "noopener"
                , target "_new"
                ]
                [ text "GitHub" ]
            , text "."
            ]
        ]


preCode : String -> String -> Html Msg
preCode language code =
    let
        languageClass =
            class <| "language-" ++ language
    in
    Html.pre [ languageClass ]
        [ Html.code [ languageClass ] [ text code ]
        ]


accordionHeadChildren : String -> String -> List (Html Msg)
accordionHeadChildren class_ label =
    [ text label
    , Html.span [ class <| class_ ++ "__head__tail" ]
        [ Html.i [ class "material-icons" ] [ text "arrow_drop_down" ]
        ]
    ]


exampleHeadChildren : String -> List (Html Msg)
exampleHeadChildren label =
    accordionHeadChildren "example-accordion" label


codeAccordion : AccordionList.Status String -> Example -> String -> String -> String -> String -> Html Msg
codeAccordion status example id_ label lang code =
    Accordion.accordion
        [ id id_
        , class "code-accordion"
        ]
        (Accordion.head
            [ class "code-accordion__head"
            , onClick (UpdateStatus example id_)
            ]
            (accordionHeadChildren "code-accordion" label)
        )
        (Accordion.body [ class "code-accordion__body" ] [ preCode lang code ])
        (AccordionList.isOpen id_ status)


toggleSwitch : Bool -> Html Msg
toggleSwitch open =
    Html.label [ class "toggle-switch" ]
        [ Html.input
            [ checked open
            , type_ "checkbox"
            , onCheck (\_ -> SwitchToggled)
            ]
            []
        , Html.span [] []
        ]


arrow : Html Msg
arrow =
    token " -> "


collon : Html Msg
collon =
    token " : "


equal : Html Msg
equal =
    token " = "


space : Html Msg
space =
    text " "


tab : Html Msg
tab =
    text "    "


token : String -> Html Msg
token token_ =
    Html.span [ class "doc-token" ] [ text token_ ]


linkToken : String -> Html Msg
linkToken token_ =
    Html.a
        [ class "doc-token-link"
        , href ("#" ++ token_)
        ]
        [ text token_ ]


functionToken : String -> Html Msg
functionToken token_ =
    Html.a
        [ class "doc-token-link--bold"
        , href ("#" ++ token_)
        ]
        [ text token_ ]


typeKeyword_ : Html Msg
typeKeyword_ =
    keywordToken "type "


aliasKeyword_ : Html Msg
aliasKeyword_ =
    keywordToken "alias "


keywordToken : String -> Html Msg
keywordToken keyword_ =
    Html.span [ class "doc-token-keyword" ] [ text keyword_ ]


footer : Html Msg
footer =
    Html.footer []
        [ Html.div [ class "footer-wrapper" ]
            [ text "©hallelujahdrive 2020" ]
        ]


usageCode =
    """import Accordion

type alias Model = Bool

type Msg = Toggled

update msg model =
    case msg of
        Toggled ->
            ( model = not model
            , Cmd.none
            )

view model =
    Accordion.accordion
        []
        ( Accordion.head
            [ onClick  Toggled ]
            [ text "Accordion head content" ]
        )
        ( Accordion.body [] [ text "Accordion body content" ] )
        model
"""


embeddingCode =
    """<link rel="stylesheet" type="text/css" href="https://unpkg.com/elm-accordion@""" ++ version ++ """/dist/elm-accordion.min.css" />
<script src="https://unpkg.com/elm-accordion@""" ++ version ++ """/dist/elm-accordion.min.js"></script>
"""


simpleCode =
    """import Accordion

type alias Model = Bool

type Msg = Toggled

update msg model =
    case msg of
        Toggled ->
            ( model = not model
            , Cmd.none
            )

view model =
    Accordion.accordion
        []
        ( Accordion.head
            [ onClick Toggled ]
            [ text "Let's click this text" ]
        )
        ( Accordion.body [] [ text "Simple accordion body content" ] )
        model
"""


customizedElmCode =
    """import Accordion

type alias Model = Bool

type Msg = Toggled

update msg model =
    case msg of
        Toggled ->
            ( model = not model
            , Cmd.none
            )

view model =
    Accordion.accordion
        [ class "example-accordion" ]
        ( Accordion.head
            [ class "example-accordion__head"
            , onClick Toggled
            ]
            [ text "Customized accordion"
            , Html.span [ class "example-accordion__head__tail" ]
                [ Html.i [ class "material-icons" ] [ text "arrow_drop_down" ]
                ]
            ]
        )
        ( Accordion.body [ class "example-accordion__body" ]
            [ Html.ul [] <|
                List.map
                    (\\i -> Html.li [] [ text ("Text line "  ++ String.fromInti) ])
                    (List.range 1 5)
            ]
        )
        model
"""


customizedCssCode =
    """/* You need to import material-icons(https://google.github.io/material-design-icons/). */
.example-accordion__body {
    background-color: #eceff1;
}
    
.example-accordion__head {
    align-items: center;
    background-color: #ff4525;
    color: #fff;
    cursor: pointer;
    display: flex;
    height: 48px;
    padding: 0 16px;
}

.example-accordion__head__tail {
    margin-left: auto;
}
        
.example-accordion__head__tail i {
        transition: transform .15s cubic-bezier(0.4, 0.2, 0, 0.1);
    }
}

.example-accordion__body > * {
    margin: 0.75em;
}

.elm-accordion--open .example-accordion__head {
    background-color: #ff1744;
    transition: background-color .15s cubic-bezier(0.4, 0.2, 0, 0.1);
}

.elm-accordion--open .example-accordion__head__tail i {
    transform: rotate(180deg);
}
"""


listCode =
    """import Accordion
import Accordion.List as AccordionList

type alias model =
    { multiOpen : Bool
    , status : AccordionList.Status String
    }

type Msg
    = Toggled
    | UpdateAccordion String

update msg model =
    case msg of
        Toggled ->
            ({ model
                | multiOpen = not model.multiOpen
                , status =
                    if model.multiOpen then
                        AccordionList.singleOpen Nothing
                    else
                        AccordionList.multiOpen []
             }
            , Cmd.none
            )
        
        UpdateStatus id_ ->
            ( { model | AccordionList.uodate id_ model.status }
            , Cmd.none
            )

view model =
    let
        id_ index_ =
            "example-accordion-" ++ String.fromInt index_

        accordion_ index_ =
            Accordion.accordion [ id (id_ index_) ]
                ( Accordion.head
                    [ onClick (UpdateStatus <| id_ index_) ]
                    headChildren
                )
                ( Accordion.body [] bodyChildren )
                ( AccordionList.isOpen (id_ index_) model.status )
    in
    Html.div []
        List.map accordion_ <|
            List.range 1 5
"""


lipsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
