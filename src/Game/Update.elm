module Game.Update exposing (update)

import Game.Types exposing (..)
import Game.Board as Board
import Game.Parse as Parse


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartStop ->
            { model | started = True } ! []

        UpdateSeed seed ->
            { model | seed = seed } ! []

        ParseSeed ->
            { model
                | board = Board.merge (Parse.parse model.seed) model.board
            }
                ! []

        NewWindowSize size ->
            let
                rows =
                    size.height // model.cellSize

                cols =
                    size.width // model.cellSize
            in
                { model
                    | windowSize = size
                    , board = Board.create cols rows
                }
                    ! []

        Click mousePosition ->
            let
                newBoard =
                    Board.update position model.board

                position =
                    ( round <| (x - ww / 2 + cs / 2) / cs - 1
                    , round <| (y - wh / 2 + cs / 2) / cs * -1
                    )

                ww =
                    toFloat model.windowSize.width

                wh =
                    toFloat model.windowSize.height

                cs =
                    toFloat model.cellSize

                x =
                    toFloat mousePosition.x

                y =
                    toFloat mousePosition.y
            in
                { model | board = newBoard } ! []
