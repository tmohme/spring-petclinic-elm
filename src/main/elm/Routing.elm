module Routing exposing (..)

import Messages exposing (..)
import Navigation exposing (Location)
import Owners.Types exposing (Owner)
import Page exposing (..)
import UrlParser exposing (Parser, int, oneOf, s, (</>))


routeParser : Parser (NavMsg -> a) a
routeParser =
    oneOf
        [ UrlParser.map ToHome homeParser
        , UrlParser.map ToFindOwners findOwnersParser
        , UrlParser.map ToOwnersList ownersListParser
        , UrlParser.map ToOwnerDetails ownerDetailsParser
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

ownerDetailsParser : Parser (Int -> a) a
ownerDetailsParser = (s "elm") </> (s "owners") </> int

vetsParser : Parser a a
vetsParser = (s "elm") </> (s "vets.html")

parse : Navigation.Location -> NavMsg
parse location =
    let
        l = Debug.log "Routing.parse: location" location
        parsed = Debug.log "Routing.parse: parsed" (UrlParser.parsePath routeParser location)
    in
        case parsed of
            Nothing -> ToHome
            Just aNavMsg -> aNavMsg


pathFor : Page -> String
pathFor page =
    "/elm" ++
    case page of
        Home -> "/index.html"
        FindOwnersForm -> "/owners/find"
        OwnersList -> "/owners"
        OwnerDetails ownerId -> "/owners/" ++ (toString ownerId)
        Vets -> "/vets.html"
        Error -> "/oups"
