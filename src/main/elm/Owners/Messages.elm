module Owners.Messages exposing (..)

import Http
import Owners.Types exposing (Owners, Owner)


type Msg = ShowForm
         | ShowList
         | ShowDetails Int
         | FindOwners
         | FoundOwners (Result Http.Error Owners)
         | FindOwner Int
         | FoundOwner (Result Http.Error Owner)
         | AddOwner
         | LastName String

