module Messages exposing (..)

import Navigation exposing (Location)
import Owners.Messages exposing (Msg)
import Owners.Types exposing (Owner)
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
    | ToOwnerDetails Int
    | ToVets
    | ToError
