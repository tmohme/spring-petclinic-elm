module Welcome exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)


view : String -> Html Msg
view imageRoot =
    div []
        [ h2 [] [text "Welcome"]
        , div [class "row"]
            [ div [class "col-md-12"]
                [ img [class "img-responsive", src (imageRoot ++ "/pets.png")] []
                ]
            ]
        ]
