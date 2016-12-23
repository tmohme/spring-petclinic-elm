module Owners exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

-- MODEL

type Msg = FindOwner
         | AddOwner
         | LastName String

type alias Model =
    { lastName : String
    }


initialModel : Model
initialModel =
    { lastName = ""
    }



-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        LastName lastName -> ({model | lastName = lastName}, Cmd.none)
        _ -> ( model, Cmd.none )



-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ h2 [] [text "Find Owners"]
        , Html.form [class "form-horizontal"]
            [ div [class "form-group"]
                [ div [class "control-group"]
                    [ label [class "col-sm-2 control-label"] [text "Last name"]
                    , div [class "col-sm-10"]
                        [ input [class "form-control", onInput LastName, size 30, maxlength 80] []
                        ]
                    ]
                ]
            , div [class "form-group"]
                [ div [class "col-sm-offset-2 col-sm-10"]
                    [ button [class "btn btn-default", onClick FindOwner, type_ "button" ] [text "Find Owner"]
                    ]
                ]
            ]
        , br [][]
        , button [class "btn btn-default", onClick AddOwner][ text "Add Owner"]
        ]
