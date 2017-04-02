module Main exposing (..)

import Task
import Html exposing (Html)
import Window
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Utils


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { board = Utils.empty
      , cellSize = 80
      , windowSize = Window.Size 0 0
      , seed = """
    0 -1
    1 0
    -1 1
    0 1
    1 1
            """
      }
    , Task.perform NewWindowSize Window.size
    )

