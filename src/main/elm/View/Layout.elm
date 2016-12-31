module View.Layout exposing (..)

import Html exposing (Attribute, Html, a, body, br, button, div, h2, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (Options, onClick, onWithOptions)
import Json.Decode as Decode
import Messages exposing (..)
import Routing exposing (..)

view : Page -> (String -> Html Msg) -> Html Msg
view page contentView =

  let
    imagePathPrefix = "/resources/images"
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
            [ div [class "container xd-container"] [ contentView imagePathPrefix ]
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


onLinkClick : Msg -> Attribute Msg
onLinkClick msg =
    onWithOptions "click" noBubbling (Decode.succeed msg)

noBubbling : Options
noBubbling =
    { stopPropagation = True
    , preventDefault = True
    }
