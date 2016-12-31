module Error exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)


view : String -> Html Msg
view imageRoot =
    div []
        [ img [src (imageRoot ++ "/pets.png")][]
        , h2 [] [text "Something happened..."]
        , p [] [text "<Exception message>"]
        ]
