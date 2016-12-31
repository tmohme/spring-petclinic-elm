module ViewHelper exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (..)
import Html.Events exposing (Options, onClick, onWithOptions)
import Json.Decode as Decode
import Messages exposing (..)


onLinkClick : msg -> Attribute msg
onLinkClick msg =
    onWithOptions "click" noBubbling (Decode.succeed msg)

noBubbling : Options
noBubbling =
    { stopPropagation = True
    , preventDefault = True
    }
