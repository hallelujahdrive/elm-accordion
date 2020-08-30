module Accordion.List exposing
    ( Status
    , isOpen
    , multiOpen
    , singleOpen
    , update
    )

{-| The status of multiple accordions can be managed collectively and linked.
# Basic usage
    import Accordion
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


# Status
@docs Status, multiOpen, singleOpen

# Update Status
@docs update

# Check status
@docs isOpen
-}

import Accordion.Internal as Internal exposing (Status(..))
import Set


{-| Multiple accordions status type

-}
type alias Status comparable =
    Internal.Status comparable


{-| Initialize multiple open Status.

- `values` List of values associated with open accordions(e.g. List of `id`).
-}
multiOpen : List comparable -> Status comparable
multiOpen keys =
    Set.fromList keys
        |> Multiple


{-| Initialize single open Status.

- `value` A value of associated with open accoedion(e.g. `id`).
-}
singleOpen : Maybe comparable -> Status comparable
singleOpen key =
    Single key


{-| Toggle the state of the argument value.
-}
update : comparable -> Status comparable -> Status comparable
update key status =
    case status of
        Multiple keys ->
            Multiple <|
                if Set.member key keys then
                    Set.remove key keys

                else
                    Set.insert key keys

        Single oldKey ->
            Single <|
                if Just key == oldKey then
                    Nothing

                else
                    Just key


{-| Check value status if it is open.
-}
isOpen : comparable -> Status comparable -> Bool
isOpen key status =
    case status of
        Multiple keys ->
            Set.member key keys

        Single key_ ->
            Just key == key_
