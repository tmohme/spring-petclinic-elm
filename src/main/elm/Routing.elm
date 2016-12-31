module Routing exposing
    (..)

import Messages exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (Parser, oneOf, s, (</>))



type Page
    = Home
    | FindOwners
    | Vets
    | Error



routeParser : Parser (NavMsg -> a) a
routeParser =
    oneOf
        [ UrlParser.map ToHome homeParser
        , UrlParser.map ToFindOwners ownersParser
        , UrlParser.map ToVets vetsParser
        , UrlParser.map ToError errorParser
        ]

homeParser : Parser a a
homeParser =
    oneOf
        [ s "elm"
        , (s "elm") </> (s "index.html")
        ]

ownersParser : Parser a a
ownersParser = (s "elm") </> (s "owners") </> (s "find")

vetsParser : Parser a a
vetsParser = (s "elm") </> (s "vets.html")

errorParser : Parser a a
errorParser = (s "elm") </> (s "oups")

parse : Navigation.Location -> NavMsg
parse location =
    case (UrlParser.parsePath routeParser location) of
        Nothing -> ToHome
        Just aNavMsg -> aNavMsg


pathFor : Page -> String
pathFor page =
    "/elm" ++
    case page of
        Home -> "/index.html"
        FindOwners -> "/owners/find"
        Vets -> "/vets.html"
        Error -> "/oups"
