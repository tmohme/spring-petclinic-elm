module Messages exposing (..)

import Navigation exposing (Location)
import Owners.Messages exposing (Msg)
import Owners.Types exposing (Owner)
import Page exposing (..)
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

targetPage : NavMsg -> Page
targetPage navMsg =
    case navMsg of
        ToHome -> Home
        ToFindOwners -> FindOwnersForm
        ToOwnerDetails ownerId -> OwnerDetails ownerId
        ToOwnersList -> OwnersList
        ToVets -> Vets
        ToError -> Error
