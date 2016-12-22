-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/user_input/buttons.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
  beginnerProgram { model = model, view = view, update = update }


type NavMsg = ToHome | ToOwners | ToVets | ToOups
type Page = Home | Owners | Vets | Oups

type alias Model =
    { page : Page
    }


model : Model
model =
    { page = Home
    }


update : NavMsg -> Model -> Model
update msg model =
    case msg of
        ToHome ->
            {model | page = Home}
        ToOwners ->
            {model | page = Owners}
        ToVets ->
            {model | page = Vets}
        ToOups ->
            {model | page = Oups}


view : Model -> Html NavMsg
view model =

  let
    rootUrl = "file:///Users/thomas/Documents/SWDevelopment/elm/spring-petclinic-elm"
    classesUrl = rootUrl ++ "/target/classes"
    imageRoot = classesUrl ++ "/static/resources/images"
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
                        [ menuItem ToHome (rootUrl ++ "/") "home" "home page" "home" "Home"
                        , menuItem ToOwners (rootUrl ++ "/owners/find") "owners" "find owners" "search" "Find owners"
                        , menuItem ToVets (rootUrl ++ "/vets.html") "vets" "veterinarians" "th-list" "Veterinarians"
                        , menuItem ToOups (rootUrl ++ "/oups") "error" "trigger a RuntimeError to see how it is handled" "warning-sign" "Error"
                        ]
                    ]
                ]
            ]

        , div [class "container-fluid"]
            [ div [class "container xd-container"]
                [ welcomeView model.page "Welcome" imageRoot]
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

menuItem : NavMsg -> String -> String -> String -> String -> String -> Html NavMsg
menuItem msg path active title_ glyph text_ =
    li [class "active"]
        [ a [href path, title title_]
            [ span [class ("glyphicon  glyphicon-" ++ glyph), attribute "aria-hidden" "true"] []
            , span [][text text_]
            ]
        , button [onClick msg]
            [ span [class ("glyphicon  glyphicon-" ++ glyph), attribute "aria-hidden" "true"] []
            , span [][text ("button-" ++ text_)]
            ]
        ]

welcomeView : Page -> String -> String -> Html NavMsg
welcomeView page welcome imageRoot =
    div []
        [ h2 [] [text (welcome ++ " on page " ++ (toString page))]
        , div [class "row"]
            [ div [class "col-md-12"]
                [ img [class "img-responsive", src (imageRoot ++ "/pets.png")] []
                ]
            ]
        ]
