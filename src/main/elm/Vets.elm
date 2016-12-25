module Vets exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

-- MODEL

type Msg = ViewAsJson
         | ViewAsXml

type Columns = Name
             | Specialties

type alias Model =
    { vets : List Vet
    }


initialModel : Model
initialModel =
    { vets = vets
    }



-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ViewAsJson -> ( model, Cmd.none )
        ViewAsXml -> ( model, Cmd.none )



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

viewVets : List Vet -> List (Html Msg)
viewVets vets = List.map viewVet vets

viewVet : Vet -> Html Msg
viewVet vet =
    tr []
        [ td [] [ text (vet.firstName ++ " " ++ vet.lastName) ]
        , td [] [ text (viewSpecialties vet.specialties) ]
        ]

viewSpecialties : List String -> String
viewSpecialties specs =
    case specs of
      []     -> "none"
      hd::tl -> specs
                |> List.intersperse " "
                |> List.foldr (++) ""


-- Vets

type alias Vet =
    { firstName : String
    , lastName : String
    , specialties: List String
    }

vets : List Vet
vets =
    [ Vet "James" "Carter" []
    , Vet "Helen" "Leary" ["radiology"]
    , Vet "Linda" "Douglas" ["dentistry", "surgery"]
    , Vet "Rafael" "Ortega" ["surgery"]
    , Vet "Henry" "Stevens" ["radiology"]
    , Vet "Sharon" "Jenkins" []
    ]
