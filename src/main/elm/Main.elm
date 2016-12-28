module Main exposing (..)

import Html exposing (Attribute, Html, a, body, br, button, div, h2, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (Options, onClick, onWithOptions)
import Json.Decode as Decode
import Owners exposing (..)
import Navigation exposing (Location, program)
import Vets exposing(..)



-- APP

main : Program Never AppModel Msg
main =
  Navigation.program
      UrlChange
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }


-- MODEL

type Page
    = Home
    | Owners
    | Vets
    | Error

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



-- MESSAGES

type Msg
    = MainMsg NavMsg
    | OwnersMsg Owners.Msg
    | VetsMsg Vets.Msg
    | UrlChange Location

type NavMsg
    = ToHome
    | ToOwners
    | ToVets
    | ToError



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none



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

        UrlChange location -> ( model, Cmd.none )



updateNavigation : NavMsg -> AppModel -> ( AppModel, Cmd Msg )
updateNavigation navMsg model =
    case navMsg of
        ToHome ->
            ({model | page = Home}, Navigation.newUrl "/elm/index.html")

        ToOwners ->
            let
                ( updatedOwnersModel, ownersCmd ) = Owners.update Owners.NavigateTo model.ownersModel
                cmdBatch = Cmd.batch [Navigation.newUrl "/elm/owners/find", Cmd.map OwnersMsg ownersCmd]
            in
                ({model | page = Owners, ownersModel = updatedOwnersModel}, cmdBatch)

        ToVets ->
            let
                cmdBatch = Cmd.batch [Navigation.newUrl "/elm/vets.html", Cmd.map VetsMsg Vets.loadVets]
            in
                ({model | page = Vets}, cmdBatch)

        ToError ->
            ({model | page = Error}, Navigation.newUrl "/elm/oups")



-- VIEW

view : AppModel -> Html Msg
view model =

  let
    pathPrefix = "/elm"
    imagePathPrefix = "/resources/images"
    page = model.page
  in
    body []
        [ nav [class "navbar navbar-default"]
            [ div [class "container"]
                [ div [class "navbar-header"]
                    [ a [class "navbar-brand", (href (pathPrefix ++ "/index.html"))][]
                    , button [type_ "button", class "navbar-toggle", attribute "data-toggle" "collapse",  attribute "data-target" "#main-navbar"]
                        [ span [class "sr-only"][text "Toggle navigation"]
                        , span [class "icon-bar"] []
                        , span [class "icon-bar"] []
                        , span [class "icon-bar"] []
                        ]
                    ]

                , div [class "navbar-collapse collapse", id "main-navbar"]
                    [ ul [class "nav navbar-nav navbar-right"]
                        [ menuItem ToHome Home page (pathPrefix ++ "/index.html") "home page" "home" "Home"
                        , menuItem ToOwners Owners page (pathPrefix ++ "/owners/find") "find owners" "search" "Find owners"
                        , menuItem ToVets Vets page (pathPrefix ++ "/vets.html") "veterinarians" "th-list" "Veterinarians"
                        , menuItem ToError Error page (pathPrefix ++ "/oups") "trigger a RuntimeError to see how it is handled" "warning-sign" "Error"
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

menuItem : NavMsg -> Page -> Page -> String -> String -> String -> String -> Html Msg
menuItem navMsg activePage currentPage path title_ glyph text_ =
    li [classList
            [("active", currentPage == activePage)]
        ]
        [ a [ onLinkClick (MainMsg navMsg), href path, title title_]
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
