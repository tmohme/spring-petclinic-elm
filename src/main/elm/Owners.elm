module Owners exposing(..)

import Html exposing (..)
import Html.Attributes exposing (class, maxlength, size, style, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Time

import Debug exposing (..)
import HttpBuilder exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


-- MODEL

type Msg = NavigateTo
         | FindOwner
         | FoundOwners (Result Http.Error Owners)
         | AddOwner
         | LastName String

type State = Form
           | List

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

type alias Model =
    { lastName : String
    , state : State
    , owners : Owners
    }


initialModel : Model
initialModel =
    { lastName = ""
    , state = Form
    , owners = []
    }



-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NavigateTo -> ( initialModel, Cmd.none )
        LastName lastName -> ({model | lastName = lastName}, Cmd.none)
        FindOwner -> ({ model | state = List }, findOwners model.lastName)
        FoundOwners (Err msg) -> ( model, Cmd.none )
        FoundOwners (Ok owners) -> ( { model | owners = owners }, Cmd.none )
        AddOwner -> (model, Cmd.none)



-- VIEW

view : Model -> Html Msg
view model =
    case model.state of
        Form -> viewForm
        List -> viewList model


viewForm : Html Msg
viewForm =
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
                    [ button
                        [class "btn btn-default", onClick FindOwner, type_ "button" ]
                        [text "Find Owner"]
                    ]
                ]
            ]
        , br [][]
        , button [class "btn btn-default", onClick AddOwner][ text "Add Owner"]
        ]

viewList : Model -> Html Msg
viewList model =
    div []
        [ h2 [] [ text "Owners" ]
        , table [class "table table-striped"]
            [ thead []
                [ tr []
                    [ th [style [("width", "150px")]] [ text "Name" ]
                    , th [style [("width", "200px")]] [ text "Address" ]
                    , th [] [ text "City" ]
                    , th [style [("width", "120px")]] [ text "Telephone" ]
                    , th [] [ text "Pets" ]
                    ]
                ]
            , tbody [] (viewOwnerRows model.owners)
            ]
        ]

viewOwnerRows : Owners -> List (Html Msg)
viewOwnerRows owners =
    owners
    |> List.map viewOwnerRow

viewOwnerRow : Owner -> Html Msg
viewOwnerRow owner =
    tr []
        [ td [] [ text (owner.firstName ++ " " ++ owner.lastName) ]
        , td [] [ text owner.address]
        , td [] [ text owner.city]
        , td [] [ text owner.telephone]
        , td [] [ text (petNames owner)]
        ]

petNames : Owner -> String
petNames owner =
    owner.pets
    |> List.map .name
    |> List.intersperse " "
    |> List.foldr (++) ""



-- HTTP

findOwners : String -> Cmd Msg
findOwners lastName =
  let
    url =
      "http://localhost:8080/owners.json?lastName=" ++ lastName
  in
    Http.send FoundOwners (Http.get url ownersDecoder)


ownersDecoder : Decoder Owners
ownersDecoder = field "ownerList" (list ownerDecoder)

ownerDecoder : Decoder Owner
ownerDecoder =
  decode Owner
    |> required "id" int
    |> required "firstName" string
    |> required "lastName" string
    |> required "address" string
    |> required "city" string
    |> required "telephone" string
    |> required "pets" (list petDecoder)

petDecoder : Decoder Pet
petDecoder =
  decode Pet
    |> required "id" int
    |> required "name" string
