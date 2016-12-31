module Owners.Owners exposing(..)

import Html exposing (..)
import Html.Attributes exposing (class, href, maxlength, size, style, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Time

import Debug exposing (..)
import HttpBuilder exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Messages
import Navigation
import Owners.Messages exposing (..)
import Owners.Types exposing (..)
import Routing exposing (..)
import ViewHelper exposing (..)


-- MODEL

type alias Model =
    { lastName : String
    , owner : Maybe Owner
    , owners : Owners
    }


initialModel : Model
initialModel =
    { lastName = ""
    , owner = Nothing
    , owners = []
    }



-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ShowForm -> ( initialModel, Cmd.none )
        ShowList -> ( {model | owner = Nothing}, Cmd.none )
        ShowDetails ownerId -> ( model, findOwner ownerId )
        LastName lastName -> ({model | lastName = lastName}, Cmd.none)
        FindOwners -> ( model, findOwners model.lastName)
        FoundOwners (Err msg) -> ( model, Cmd.none )
        FoundOwners (Ok owners) -> ( { model | owners = owners }, pathFor OwnersList |> Navigation.newUrl )
        FoundOwner (Err msg) -> ( model, Cmd.none )
        FoundOwner (Ok owner) -> ( { model | owner = Just owner }, pathFor (OwnerDetails owner.id) |> Navigation.newUrl )
        AddOwner -> (model, Cmd.none)



-- VIEWs

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
                        [class "btn btn-default", onClick FindOwners, type_ "button" ]
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
        [ a [ onLinkClick (ShowDetails owner.id)
            , href (pathFor (OwnerDetails owner.id))]
            [text (fullName owner)]
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


viewDetails : Model -> Html Msg
viewDetails model =
    let
        owner = Maybe.withDefault defaultOwner model.owner
    in
        div []
            [ h2 [] [text "Owner Information"]
            , table [class "table table-striped"]
                [ tr []
                    [ th [] [text "Name"]
                    , td []
                        [ b [] [text (owner.firstName ++ " " ++ owner.lastName)]
                        ]
                    ]
                , tr []
                    [ th [] [text "Address"]
                    , td [] [text owner.address]
                    ]
                , tr []
                    [ th [] [text "City"]
                    , td [] [text owner.city]
                    ]
                , tr []
                    [ th [] [text "Telephone"]
                    , td [] [text owner.telephone]
                    ]
                ]
            , a [class "btn btn-default"] [text "Edit Owner"]
            , a [class "btn btn-default"] [text "Add New Pet"]
            , br [] []
            , br [] []
            , br [] []
            , h2 [] [text "Pets and Visits"]
            , table [class "table table-striped"] []
            ]
{-
    <table class="table table-striped" th:object="${owner}">
      <tr>
        <th>Name</th>
        <td><b th:text="*{firstName + ' ' + lastName}"></b></td>
      </tr>
      <tr>
        <th>Address</th>
        <td th:text="*{address}" /></td>
      </tr>
      <tr>
        <th>City</th>
        <td th:text="*{city}" /></td>
      </tr>
      <tr>
        <th>Telephone</th>
        <td th:text="*{telephone}" /></td>
      </tr>
    </table>

    <a th:href="@{{id}/edit(id=${owner.id})}" class="btn btn-default">Edit
      Owner</a>
    <a th:href="@{{id}/pets/new(id=${owner.id})}" class="btn btn-default">Add
      New Pet</a>

    <h2>Pets and Visits</h2>

    <table class="table table-striped">

      <tr th:each="pet : ${owner.pets}">
        <td valign="top">
          <dl class="dl-horizontal">
            <dt>Name</dt>
            <dd th:text="${pet.name}" /></dd>
            <dt>Birth Date</dt>
            <dd
              th:text="${#calendars.format(pet.birthDate, 'yyyy-MM-dd')}" /></dd>
            <dt>Type</dt>
            <dd th:text="${pet.type}" /></dd>
          </dl>
        </td>
        <td valign="top">
          <table class="table-condensed">
            <thead>
              <tr>
                <th>Visit Date</th>
                <th>Description</th>
              </tr>
            </thead>
            <tr th:each="visit : ${pet.visits}">
              <td th:text="${#calendars.format(visit.date, 'yyyy-MM-dd')}"></td>
              <td th:text="${visit?.description}"></td>
            </tr>
            <tr>
              <td><a
                th:href="@{{ownerId}/pets/{petId}/edit(ownerId=${owner.id},petId=${pet.id})}">Edit
                  Pet</a></td>
              <td><a
                th:href="@{{ownerId}/pets/{petId}/visits/new(ownerId=${owner.id},petId=${pet.id})}">Add
                  Visit</a></td>
            </tr>
          </table>
        </td>
      </tr>

    </table>

-}

-- HTTP

findOwners : String -> Cmd Msg
findOwners lastName =
  let
    url =
      "http://localhost:8080/owners.json?lastName=" ++ lastName
  in
    Http.send FoundOwners (Http.get url ownersDecoder)

findOwner : Int -> Cmd Msg
findOwner id =
  let
    url =
      "http://localhost:8080/owners.json/" ++ toString id
  in
    Http.send FoundOwner (Http.get url ownerDecoder)

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
