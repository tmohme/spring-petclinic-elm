module Messages exposing (..)

import Navigation exposing (Location)
import Owners.Messages exposing (Msg)
import Vets exposing (Msg)

type Msg
    = MainMsg NavMsg
    | OwnersMsg Owners.Messages.Msg
    | VetsMsg Vets.Msg
    | UrlChange Location

type NavMsg
    = ToHome
    | ToFindOwners
    | ToOwnersList
    | ToVets
    | ToError
