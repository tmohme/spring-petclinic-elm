module Main exposing (..)

import Html exposing (Attribute, Html, a, body, br, button, div, h2, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (Options, onClick, onWithOptions)
import Json.Decode as Decode
import Messages exposing (..)
import Navigation
import Owners.Owners as Owners
import Owners.Messages
import Page exposing (..)
import Routing exposing (..)
import View.Error
import View.Layout
import View.Welcome
import Vets



-- APP

main : Program Never AppModel Msg
main =
  Navigation.program
      UrlChange
      { init = init
      , view = view
      , update = update
      , subscriptions = \model -> Sub.none
      }


-- MODEL

type alias AppModel =
    { page : Page
    , ownersModel : Owners.Model
    , vetsModel : Vets.Model
    }

initialModel : AppModel
initialModel =
    { page = Home
    , ownersModel = Owners.initialModel
    , vetsModel = Vets.initialModel
    }


init : Navigation.Location -> (AppModel, Cmd Msg)
init location =
    (initialModel, Cmd.none)




-- UPDATE


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        MainMsg navMsg -> updateNavigation navMsg model

        OwnersMsg ownersMsg ->
            let
                ( updatedOwnersModel, ownersCmd ) = Owners.update ownersMsg model.ownersModel
            in
                ( { model | ownersModel = updatedOwnersModel }, Cmd.map OwnersMsg ownersCmd )

        VetsMsg vetsMsg ->
            let
                ( updatedVetsModel, vetsCmd ) = Vets.update vetsMsg model.vetsModel
            in
                ( { model | vetsModel = updatedVetsModel }, Cmd.map VetsMsg vetsCmd )

        UrlChange location ->
            let
                x = Debug.log "UrlChange location" location
            in
                urlChanged (parse location) model



updateNavigation : NavMsg -> AppModel -> ( AppModel, Cmd Msg )
updateNavigation navMsg model =
    let
        currentPage = Debug.log ("updateNavigation: " ++ (toString navMsg) ++ ", currently on page") model.page
        targetPage = Messages.targetPage navMsg
    in
        if (currentPage == targetPage)
        then (model, Cmd.none)
        else
            case navMsg of
                ToHome ->
                    ({model | page = Home}, pathFor Home |> Navigation.newUrl)

                ToFindOwners ->
                    let
                        ( updatedOwnersModel, ownersCmd ) = Owners.update Owners.Messages.ShowForm model.ownersModel
                        cmdBatch = Cmd.batch [pathFor FindOwnersForm |> Navigation.newUrl, Cmd.map OwnersMsg ownersCmd]
                        x = Debug.log "Navigation.newUrl(updateNavigation)" cmdBatch
                    in
                        ({model | page = FindOwnersForm, ownersModel = updatedOwnersModel}, cmdBatch)

                ToOwnersList ->
                    let
                        ( updatedOwnersModel, ownersCmd ) = Owners.update Owners.Messages.ShowList model.ownersModel
                        cmdBatch = Cmd.batch [pathFor OwnersList |> Navigation.newUrl, Cmd.map OwnersMsg ownersCmd]
                        x = Debug.log "Navigation.newUrl(updateNavigation)" cmdBatch
                    in
                        ({model | page = OwnersList, ownersModel = updatedOwnersModel}, cmdBatch)

                ToOwnerDetails ownerId ->
                    let
                        ( updatedOwnersModel, ownersCmd ) = Owners.update (Owners.Messages.ShowDetails ownerId) model.ownersModel
                        nextPage = OwnerDetails ownerId
                        cmdBatch = Cmd.batch [pathFor (OwnerDetails ownerId) |> Navigation.newUrl, Cmd.map OwnersMsg ownersCmd]
                        x = Debug.log "Navigation.newUrl(updateNavigation)" cmdBatch
                    in
                        ({model | page = nextPage, ownersModel = updatedOwnersModel}, cmdBatch)

                ToVets ->
                    let
                        vetsCmd = Cmd.map VetsMsg Vets.loadVets
                        cmdBatch = Cmd.batch [pathFor Vets |> Navigation.newUrl, vetsCmd]
                        x = Debug.log "Navigation.newUrl(updateNavigation)" cmdBatch
                    in
                        ({model | page = Vets}, cmdBatch)

                ToError ->
                    let
                        cmdBatch = Cmd.batch [pathFor Error |> Navigation.newUrl]
                        x = Debug.log "Navigation.newUrl(updateNavigation)" cmdBatch
                    in
                        ({model | page = Error}, cmdBatch)


urlChanged : NavMsg -> AppModel -> ( AppModel, Cmd Msg )
urlChanged navMsg model =
    let
        currentPage = Debug.log ("urlChanged: " ++ (toString navMsg) ++ ", currently on page") model.page
        targetPage = Messages.targetPage navMsg
    in
        if (currentPage == targetPage)
        then (model, Cmd.none)
        else
            case navMsg of
                ToHome ->
                    ({model | page = Home}, Cmd.none)

                ToFindOwners ->
                    let
                        ( updatedOwnersModel, ownersCmd ) = Owners.update Owners.Messages.ShowForm model.ownersModel
                    in
                        ({model | page = FindOwnersForm, ownersModel = updatedOwnersModel}, Cmd.map OwnersMsg ownersCmd)

                ToOwnersList ->
                    let
                        ( updatedOwnersModel, ownersCmd ) = Owners.update Owners.Messages.ShowList model.ownersModel
                    in
                        ({model | page = OwnersList, ownersModel = updatedOwnersModel}, Cmd.map OwnersMsg ownersCmd)

                ToOwnerDetails ownerId ->
                    let
                        ( updatedOwnersModel, ownersCmd ) = Owners.update (Owners.Messages.ShowDetails ownerId) model.ownersModel
                        nextPage = OwnerDetails ownerId
                    in
                        ({model | page = nextPage, ownersModel = updatedOwnersModel}, Cmd.map OwnersMsg ownersCmd)

                ToVets ->
                    ({model | page = Vets}, Cmd.map VetsMsg Vets.loadVets)

                ToError ->
                    ({model | page = Error}, Cmd.none)



-- VIEW
view : AppModel -> Html Msg
view model =
    View.Layout.view model.page (contentView model)

contentView : AppModel -> String -> Html Msg
contentView model imageRoot =
    case model.page of
        FindOwnersForm -> Html.map OwnersMsg Owners.viewForm
        OwnersList -> Html.map OwnersMsg (Owners.viewList model.ownersModel)
        OwnerDetails _ -> Html.map OwnersMsg (Owners.viewDetails model.ownersModel)
        Vets -> Html.map VetsMsg (Vets.view model.vetsModel)
        Home -> View.Welcome.view imageRoot
        Error -> View.Error.view imageRoot

