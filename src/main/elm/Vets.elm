module Vets exposing(..)

import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import Http
import Time

import HttpBuilder exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


-- MODEL

type Msg = Loaded (Result Http.Error Vets)
         | ViewAsJson
         | ViewAsXml

type Columns = Name
             | Specialties

type alias Vets = List Vet

type alias Model =
    { vets : Vets
    }


initialModel : Model
initialModel =
    { vets = []
    }



-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ViewAsJson -> ( model, Cmd.none )
        ViewAsXml -> ( model, Cmd.none )
        Loaded (Err error) -> ( model, Cmd.none )
        Loaded (Ok loadedVets) -> ( Model loadedVets, Cmd.none )



-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ h2 [] [text "Veterinarians"]
        , table [class "table table-striped"]
            [ thead []
                [ tr []
                    [ th [] [text "Name"]
                    , th [] [text "Specialties"]
                    ]
                ]
            , tbody [] (viewVets model.vets)
            ]
        , table [class "table-buttons"]
            [ tr []
                [ td []
                    [ button [onClick ViewAsXml] [ text "View as XML" ]
                    , button [onClick ViewAsJson] [ text "View as JSON" ]
                    ]
                ]
            ]
        ]

viewVets : Vets -> List (Html Msg)
viewVets vets = List.map viewVet vets

viewVet : Vet -> Html Msg
viewVet vet =
    tr []
        [ td [] [ text (vet.firstName ++ " " ++ vet.lastName) ]
        , td [] [ text (viewSpecialties vet.specialties) ]
        ]

viewSpecialties : List Specialty -> String
viewSpecialties specialties =
    case specialties of
      []     -> "none"
      hd::tl -> specialties
                |> List.map .name
                |> List.intersperse " "
                |> List.foldr (++) ""


-- Vets

type alias Vet =
    { id : Int
    , firstName : String
    , lastName : String
    , specialties: List Specialty
    }

type alias Specialty =
    { id: Int
    , name : String
    }


-- HTTP

loadVets : Cmd Msg
loadVets =
    HttpBuilder.get "http://localhost:8080/vets.json"
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson vetsDecoder)
        |> send (\result -> Loaded result)

vetsDecoder : Decoder Vets
vetsDecoder = field "vetList" (list vetDecoder)

vetDecoder : Decoder Vet
vetDecoder =
  decode Vet
    |> required "id" int
    |> required "firstName" string
    |> required "lastName" string
    |> required "specialties" specialtiesDecoder

specialtiesDecoder : Decoder (List Specialty)
specialtiesDecoder = list specialityDecoder

specialityDecoder : Decoder Specialty
specialityDecoder =
    decode Specialty
        |> required "id" int
        |> required "name" string
