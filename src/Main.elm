module Main exposing (..)

import Html exposing (Html)
import Mouse
import Task
import Types exposing (..)
import Update exposing (update)
import Utils
import View exposing (view)
import Window


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Mouse.clicks Click
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { board = Utils.empty
      , cellSize = 50
      , windowSize = Window.Size 0 0
      , seed = """
    0 -1
    1 0
    -1 1
    0 1
    1 1
            """
      , started = False
      }
    , Task.perform NewWindowSize Window.size
    )

