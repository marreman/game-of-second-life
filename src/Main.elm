module Main exposing (..)

import Game.Board
import Game.Types exposing (..)
import Game.Update
import Game.View
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import Mouse
import Task
import Time
import Window


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { board = Game.Board.empty
      , cellSize = 20
      , windowSize = Window.Size 0 0
      , seed = ""
      , started = False
      }
    , Task.perform NewWindowSize Window.size
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( Game.Update.update msg model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.started then
        Sub.batch
            [ Mouse.clicks Click
            , Time.every (Time.second / 10) Tick
            ]
    else
        Mouse.clicks Click


view : Model -> Html Msg
view model =
    Html.div []
        [ Game.View.view model
        , viewControls model
        ]


viewControls : Model -> Html Msg
viewControls model =
    Html.div [ class "controls" ]
        [ Html.button [ onClick StartStop ]
            [ if model.started then
                Html.text "■"
              else
                Html.text "▶"
            ]
        ]
