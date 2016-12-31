module Owners.Messages exposing (..)

import Http
import Owners.Types


type Msg = ShowForm
         | ShowList
         | FindOwner
         | FoundOwners (Result Http.Error Owners.Types.Owners)
         | AddOwner
         | LastName String

