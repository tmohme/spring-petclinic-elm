module Routing exposing (..)

import Messages exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (Parser, oneOf, s, (</>))



type Page
    = Home
    | FindOwners
    | OwnersList
    | Vets
    | Error



routeParser : Parser (NavMsg -> a) a
routeParser =
    oneOf
        [ UrlParser.map ToHome homeParser
        , UrlParser.map ToFindOwners findOwnersParser
        , UrlParser.map ToOwnersList ownersListParser
        , UrlParser.map ToVets vetsParser
        , UrlParser.map ToError errorParser
        ]

errorParser : Parser a a
errorParser = (s "elm") </> (s "oups")

findOwnersParser : Parser a a
findOwnersParser = (s "elm") </> (s "owners") </> (s "find")

homeParser : Parser a a
homeParser =
    oneOf
        [ s "elm"
        , (s "elm") </> (s "index.html")
        ]

ownersListParser : Parser a a
ownersListParser = (s "elm") </> (s "owners")

vetsParser : Parser a a
vetsParser = (s "elm") </> (s "vets.html")

parse : Navigation.Location -> NavMsg
parse location =
    let
        l = Debug.log "location: " location
        parsed = Debug.log "parsed: " (UrlParser.parsePath routeParser location)
    in
        case parsed of
            Nothing -> ToHome
            Just aNavMsg -> aNavMsg


pathFor : Page -> String
pathFor page =
    "/elm" ++
    case page of
        Home -> "/index.html"
        FindOwners -> "/owners/find"
        OwnersList -> "/owners"
        Vets -> "/vets.html"
        Error -> "/oups"
