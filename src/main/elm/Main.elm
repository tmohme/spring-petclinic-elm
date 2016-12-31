module Main exposing (..)

import Html exposing (Attribute, Html, a, body, br, button, div, h2, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (Options, onClick, onWithOptions)
import Json.Decode as Decode
import Messages exposing (..)
import Navigation
import Owners
import Routing exposing (..)
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
            updateNavigation (parse location) model



updateNavigation : NavMsg -> AppModel -> ( AppModel, Cmd Msg )
updateNavigation navMsg model =
    case navMsg of
        ToHome ->
            if model.page /= Home
            then ({model | page = Home}, pathFor Home |> Navigation.newUrl)
            else (model, Cmd.none)

        ToOwners ->
            let
                ( updatedOwnersModel, ownersCmd ) = Owners.update Owners.NavigateTo model.ownersModel
                cmdBatch = Cmd.batch [pathFor Owners |> Navigation.newUrl, Cmd.map OwnersMsg ownersCmd]
            in
                if model.page /= Owners
                then ({model | page = Owners, ownersModel = updatedOwnersModel}, cmdBatch)
                else (model, Cmd.none)

        ToVets ->
            let
                cmdBatch = Cmd.batch [pathFor Vets |> Navigation.newUrl, Cmd.map VetsMsg Vets.loadVets]
            in
                if model.page /= Vets
                then ({model | page = Vets}, cmdBatch)
                else (model, Cmd.none)

        ToError ->
            if model.page /= Error
            then ({model | page = Error}, pathFor Error |> Navigation.newUrl)
            else (model, Cmd.none)



-- VIEW

view : AppModel -> Html Msg
view model =

  let
    imagePathPrefix = "/resources/images"
    page = model.page
  in
    body []
        [ nav [class "navbar navbar-default"]
            [ div [class "container"]
                [ div [class "navbar-header"]
                    [ a [class "navbar-brand", (href (pathFor Home))][]
                    , button [type_ "button", class "navbar-toggle", attribute "data-toggle" "collapse",  attribute "data-target" "#main-navbar"]
                        [ span [class "sr-only"][text "Toggle navigation"]
                        , span [class "icon-bar"] []
                        , span [class "icon-bar"] []
                        , span [class "icon-bar"] []
                        ]
                    ]

                , div [class "navbar-collapse collapse", id "main-navbar"]
                    [ ul [class "nav navbar-nav navbar-right"]
                        [ menuItem ToHome Home page "home page" "home" "Home"
                        , menuItem ToOwners Owners page "find owners" "search" "Find owners"
                        , menuItem ToVets Vets page "veterinarians" "th-list" "Veterinarians"
                        , menuItem ToError Error page "trigger a RuntimeError to see how it is handled" "warning-sign" "Error"
                        ]
                    ]
                ]
            ]

        , div [class "container-fluid"]
            [ div [class "container xd-container"]
                [ contentView model imagePathPrefix ]
            , br [][]
            , br [][]
            , div [class "container"]
                [ div [class "row"]
                    [ div [class "col-12 text-center"]
                        [ img [src (imagePathPrefix ++ "/spring-pivotal-logo.png"),alt "Sponsored by Pivotal"] []
                        ]
                    ]
                ]
            ]
        ]

menuItem : NavMsg -> Page -> Page -> String -> String -> String -> Html Msg
menuItem navMsg targetPage currentPage title_ glyph text_ =
    li [classList
            [("active", targetPage == currentPage)]
        ]
        [ a [ onLinkClick (MainMsg navMsg), href (pathFor targetPage), title title_]
            [ span [class ("glyphicon  glyphicon-" ++ glyph), attribute "aria-hidden" "true"] []
            , span [][text text_]
            ]
        ]


contentView : AppModel -> String -> Html Msg
contentView model imageRoot =
    case model.page of
        Owners -> Html.map OwnersMsg (Owners.view model.ownersModel)
        Vets -> Html.map VetsMsg (Vets.view model.vetsModel)
        Home -> welcomeView imageRoot
        Error -> errorView imageRoot



welcomeView : String -> Html Msg
welcomeView imageRoot =
    div []
        [ h2 [] [text "Welcome"]
        , div [class "row"]
            [ div [class "col-md-12"]
                [ img [class "img-responsive", src (imageRoot ++ "/pets.png")] []
                ]
            ]
        ]

errorView : String -> Html Msg
errorView imageRoot =
    div []
        [ img [src (imageRoot ++ "/pets.png")][]
        , h2 [] [text "Something happened..."]
        , p [] [text "<Exception message>"]
        ]

onLinkClick : Msg -> Attribute Msg
onLinkClick msg =
    onWithOptions "click" noBubbling (Decode.succeed msg)

noBubbling : Options
noBubbling =
    { stopPropagation = True
    , preventDefault = True
    }
