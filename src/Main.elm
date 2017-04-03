module Main exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import Mouse
import Task
import Game.Board
import Game.Types exposing (..)
import Game.Update exposing (update)
import Game.View
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
    ( { board = Game.Board.empty
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


view : Model -> Html Msg
view model =
    Html.div []
        [ Game.View.view model
        , viewControls
        ]


viewControls : Html Msg
viewControls =
    Html.div [ class "controls" ]
        [ Html.input [ onInput UpdateSeed ] []
        , Html.button [ onClick ParseSeed ] [ Html.text "Parse" ]
        , Html.button [ onClick StartStop ] [ Html.text "Play" ]
        ]
