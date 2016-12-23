module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Owners exposing (..)



-- APP

main : Program Never AppModel Msg
main =
  program
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }



-- MODEL

type Page = Home | Owners | Vets | Error

type alias AppModel =
    { rootUrl : String
    , page : Page
    , ownersModel : Owners.Model
    }

initialModel : AppModel
initialModel =
    { rootUrl = "file:///Users/thomas/Documents/SWDevelopment/elm/spring-petclinic-elm"
    , page = Home
    , ownersModel = Owners.initialModel
    }


init : (AppModel, Cmd Msg)
init =
    (initialModel, Cmd.none)



-- MESSAGES

type NavMsg
    = ToHome
    | ToOwners
    | ToVets
    | ToError

type Msg
    = MainMsg NavMsg
    | OwnersMsg Owners.Msg



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



updateNavigation : NavMsg -> AppModel -> ( AppModel, Cmd Msg )
updateNavigation navMsg model =
    case navMsg of
        ToHome ->
            ({model | page = Home}, Cmd.none)
        ToOwners ->
            ({model | page = Owners}, Cmd.none)
        ToVets ->
            ({model | page = Vets}, Cmd.none)
        ToError ->
            ({model | page = Error}, Cmd.none)


view : AppModel -> Html Msg
view model =

  let
    rootUrl = model.rootUrl
    classesUrl = model.rootUrl ++ "/target/classes"
    imageRoot = classesUrl ++ "/static/resources/images"
    page = model.page
  in
    body []
        [ nav [class "navbar navbar-default"]
            [ div [class "container"]
                [ div [class "navbar-header"]
                    [ a [class "navbar-brand", (href (rootUrl ++ "index.html"))][]
                    , button [type_ "button", class "navbar-toggle", attribute "data-toggle" "collapse",  attribute "data-target" "#main-navbar"]
                        [ span [class "sr-only"][text "Toggle navigation"]
                        , span [class "icon-bar"] []
                        , span [class "icon-bar"] []
                        , span [class "icon-bar"] []
                        ]
                    ]

                , div [class "navbar-collapse collapse", id "main-navbar"]
                    [ ul [class "nav navbar-nav navbar-right"]
                        [ menuItem ToHome Home page (rootUrl ++ "/") "home page" "home" "Home"
                        , menuItem ToOwners Owners page (rootUrl ++ "/owners/find") "find owners" "search" "Find owners"
                        , menuItem ToVets Vets page (rootUrl ++ "/vets.html") "veterinarians" "th-list" "Veterinarians"
                        , menuItem ToError Error page (rootUrl ++ "/oups") "trigger a RuntimeError to see how it is handled" "warning-sign" "Error"
                        ]
                    ]
                ]
            ]

        , div [class "container-fluid"]
            [ div [class "container xd-container"]
                [ contentView model imageRoot ]
            , br [][]
            , br [][]
            , div [class "container"]
                [ div [class "row"]
                    [ div [class "col-12 text-center"]
                        [ img [src (imageRoot ++ "/spring-pivotal-logo.png"),alt "Sponsored by Pivotal"] []
                        ]
                    ]
                ]
            ]
        ]

menuItem : NavMsg -> Page -> Page -> String -> String -> String -> String -> Html Msg
menuItem msg activePage currentPage path title_ glyph text_ =
    li [classList
            [("active", currentPage == activePage)]
        ]
        [ a [href path, title title_]
            [ span [class ("glyphicon  glyphicon-" ++ glyph), attribute "aria-hidden" "true"] []
            , span [][text text_]
            ]
        , button [onClick (MainMsg msg)]
            [ span [class ("glyphicon  glyphicon-" ++ glyph), attribute "aria-hidden" "true"] []
            , span [][text ("button-" ++ text_)]
            ]
        ]


contentView : AppModel -> String -> Html Msg
contentView model imageRoot =
    case model.page of
        Owners -> Html.map OwnersMsg (Owners.view model.ownersModel)
        _ -> welcomeView model.page "Welcome" imageRoot



welcomeView : Page -> String -> String -> Html Msg
welcomeView page welcome imageRoot =
    div []
        [ h2 [] [text (welcome ++ " on page " ++ (toString page))]
        , div [class "row"]
            [ div [class "col-md-12"]
                [ img [class "img-responsive", src (imageRoot ++ "/pets.png")] []
                ]
            ]
        ]
