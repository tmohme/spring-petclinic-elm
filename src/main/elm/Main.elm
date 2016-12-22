-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/user_input/buttons.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
  beginnerProgram { model = model, view = view, update = update }


type Msg = Increment | Decrement

type alias Model = Int

model : Model
model =
    0

update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =

  let
    rootUrl = "file:///Users/thomas/Documents/SWDevelopment/elm/spring-petclinic-elm"
    classesUrl = rootUrl ++ "/target/classes"
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
                        [ menuItem (rootUrl ++ "/") "home" "home page" "home" "Home"
                        , menuItem (rootUrl ++ "/owners/find") "owners" "find owners" "search" "Find owners"
                        , menuItem (rootUrl ++ "/vets.html") "vets" "veterinarians" "th-list" "Veterinarians"
                        , menuItem (rootUrl ++ "/oups") "error" "trigger a RuntimeError to see how it is handled" "warning-sign" "Error"
                        ]
                    ]
                ]
            ]

        , div [class "container-fluid"]
            [ div [class "container xd-container"]
                [ text "here comes the content"]
            , br [][]
            , br [][]
            , div [class "container"]
                [ div [class "row"]
                    [ div [class "col-12 text-center"]
                        [ img [src (classesUrl ++ "/static/resources/images/spring-pivotal-logo.png"),alt "Sponsored by Pivotal"] []
                        ]
                    ]
                ]
            ]
        ]

menuItem : String -> String -> String -> String -> String -> Html Msg
menuItem path active title_ glyph text_ =
    li [class "active"]
        [ a [href path, title title_]
            [ span [class ("glyphicon  glyphicon-" ++ glyph), attribute "aria-hidden" "true"] []
            , span [][text text_]
            ]
        ]
