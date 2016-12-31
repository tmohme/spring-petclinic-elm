module Messages exposing (..)

import Navigation exposing (Location)
import Owners exposing (Msg)
import Vets exposing (Msg)

type Msg
    = MainMsg NavMsg
    | OwnersMsg Owners.Msg
    | VetsMsg Vets.Msg
    | UrlChange Location

type NavMsg
    = ToHome
    | ToOwners
    | ToVets
    | ToError
