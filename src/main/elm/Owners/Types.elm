module Owners.Types exposing (..)

type alias Owners = List Owner
type alias Owner =
    { id : Int
    , firstName : String
    , lastName : String
    , address : String
    , city : String
    , telephone : String
    , pets : List Pet
    }

type alias Pets = List Pet
type alias Pet =
    { id : Int
    , name : String
    }
