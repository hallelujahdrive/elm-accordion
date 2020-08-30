module Accordion.ListTest exposing (..)

import Accordion.Internal exposing (Status(..))
import Accordion.List as AccordionList
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, list, maybe, string)
import Set
import Test exposing (..)


status : Test
status =
    describe "Test of Accoridon.List module"
        [ fuzz (maybe int) "Test of singleOpen Status Int" <|
            \randomGeneratedMaybeString ->
                AccordionList.singleOpen randomGeneratedMaybeString
                    |> (\status_ ->
                            case status_ of
                                Single maybeString ->
                                    Expect.equal maybeString randomGeneratedMaybeString

                                _ ->
                                    Expect.fail "Expected Single only"
                       )
        , fuzz (list int) "Test of multiOpen Status Int" <|
            \randomGeneratedList ->
                AccordionList.multiOpen randomGeneratedList
                    |> (\status_ ->
                            case status_ of
                                Multiple strings ->
                                    Expect.equal strings (Set.fromList randomGeneratedList)

                                _ ->
                                    Expect.fail "Expected Multiple only"
                       )
        , fuzz (maybe float) "Test of singleOpen Status Float" <|
            \randomGeneratedMaybeString ->
                AccordionList.singleOpen randomGeneratedMaybeString
                    |> (\status_ ->
                            case status_ of
                                Single maybeString ->
                                    Expect.equal maybeString randomGeneratedMaybeString

                                _ ->
                                    Expect.fail "Expected Single only"
                       )
        , fuzz (list float) "Test of multiOpen Status Float" <|
            \randomGeneratedList ->
                AccordionList.multiOpen randomGeneratedList
                    |> (\status_ ->
                            case status_ of
                                Multiple strings ->
                                    Expect.equal strings (Set.fromList randomGeneratedList)

                                _ ->
                                    Expect.fail "Expected Multiple only"
                       )
        , fuzz (maybe string) "Test of singleOpen Status String" <|
            \randomGeneratedMaybeString ->
                AccordionList.singleOpen randomGeneratedMaybeString
                    |> (\status_ ->
                            case status_ of
                                Single maybeString ->
                                    Expect.equal maybeString randomGeneratedMaybeString

                                _ ->
                                    Expect.fail "Expected only Single"
                       )
        , fuzz (list string) "Test of multiOpen Status String" <|
            \randomGeneratedList ->
                AccordionList.multiOpen randomGeneratedList
                    |> (\status_ ->
                            case status_ of
                                Multiple strings ->
                                    Expect.equal strings (Set.fromList randomGeneratedList)

                                _ ->
                                    Expect.fail "Expected only Multiple"
                       )
        ]


isOpen : Test
isOpen =
    describe "Test of isOpen"
        [ fuzz singleOpen "Test of singleOpen" <|
            \( randomGeneratedOpen, randomGeneratedFalse ) ->
                AccordionList.singleOpen randomGeneratedOpen
                    |> (\status_ ->
                            case ( randomGeneratedOpen, randomGeneratedFalse ) of
                                ( Just open_, Just closed_ ) ->
                                    Expect.all
                                        [ \s -> Expect.true "Expect true" (AccordionList.isOpen open_ s)
                                        , \s ->
                                            if open_ == closed_ then
                                                Expect.pass

                                            else
                                                Expect.false "Expect false" (AccordionList.isOpen closed_ s)
                                        ]
                                        status_

                                _ ->
                                    Expect.pass
                       )
        , fuzz multiOpen "Test of multiOpen" <|
            \( randomGeneratedOpen, randomGeneratedClosed ) ->
                AccordionList.multiOpen randomGeneratedOpen
                    |> (\status_ ->
                            Expect.all
                                [ \s ->
                                    List.map
                                        (\open_ -> AccordionList.isOpen open_ s)
                                        randomGeneratedOpen
                                        |> (\res ->
                                                if List.member False res then
                                                    Expect.fail "Expect all true"

                                                else
                                                    Expect.pass
                                           )
                                , \s ->
                                    let
                                        test_ list_ =
                                            case list_ of
                                                head :: tail ->
                                                    if List.member head randomGeneratedOpen || not (AccordionList.isOpen head s) then
                                                        test_ tail

                                                    else
                                                        Expect.fail "Expect only false"

                                                [] ->
                                                    Expect.pass
                                    in
                                    test_ randomGeneratedClosed
                                ]
                                status_
                       )
        ]


update : Test
update =
    describe "Test of update"
        [ fuzz updateFuzz "Test of singleOpen Status update" <|
            \( randomGeneratedOpen, randomGeneratedClosed ) ->
                AccordionList.singleOpen (Just randomGeneratedOpen)
                    |> (\status_ ->
                            Expect.all
                                [ \s ->
                                    AccordionList.update randomGeneratedOpen s
                                        |> (\s_ ->
                                                case s_ of
                                                    Single maybeString ->
                                                        Expect.notEqual (Just randomGeneratedOpen) maybeString

                                                    _ ->
                                                        Expect.fail "Expect only Single"
                                           )
                                , \s ->
                                    AccordionList.update randomGeneratedClosed s
                                        |> (\s_ ->
                                                case s_ of
                                                    Single maybeString ->
                                                        if randomGeneratedOpen == randomGeneratedClosed then
                                                            Expect.pass

                                                        else
                                                            Expect.equal (Just randomGeneratedClosed) maybeString

                                                    _ ->
                                                        Expect.fail "Expect only Single"
                                           )
                                ]
                                status_
                       )
        , fuzz updateFuzz "Test of multiOpen Status update" <|
            \( randomGeneratedOpen, randomGeneratedClosed ) ->
                AccordionList.multiOpen [ randomGeneratedOpen ]
                    |> (\status_ ->
                            Expect.all
                                [ \s ->
                                    AccordionList.update randomGeneratedOpen s
                                        |> (\s_ ->
                                                case s_ of
                                                    Multiple strings ->
                                                        Expect.false "Expect false" (Set.member randomGeneratedOpen strings)

                                                    _ ->
                                                        Expect.fail "Expect only Multiple"
                                           )
                                , \s ->
                                    AccordionList.update randomGeneratedClosed s
                                        |> (\s_ ->
                                                case s_ of
                                                    Multiple strings ->
                                                        if randomGeneratedOpen == randomGeneratedClosed then
                                                            Expect.pass

                                                        else
                                                            Expect.true "Expect true" (Set.member randomGeneratedClosed strings)

                                                    _ ->
                                                        Expect.fail "Expect only Multiple"
                                           )
                                , \s ->
                                    AccordionList.update randomGeneratedClosed s
                                        |> (\s_ ->
                                                case s_ of
                                                    Multiple strings ->
                                                        if randomGeneratedOpen == randomGeneratedClosed then
                                                            Expect.pass

                                                        else
                                                            Expect.true "Expect true" (Set.member randomGeneratedOpen strings)

                                                    _ ->
                                                        Expect.fail "Expect only Multiple"
                                           )
                                ]
                                status_
                       )
        ]


singleOpen : Fuzzer ( Maybe String, Maybe String )
singleOpen =
    Fuzz.map2 (\a b -> ( a, b ))
        (maybe string)
        (maybe string)


multiOpen : Fuzzer ( List String, List String )
multiOpen =
    Fuzz.map2 (\a b -> ( a, b ))
        (list string)
        (list string)


updateFuzz : Fuzzer ( String, String )
updateFuzz =
    Fuzz.map2 (\a b -> ( a, b )) string string
