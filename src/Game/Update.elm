module Game.Update exposing (update)

import Dict
import Game.Types exposing (..)
import Game.Board as Board
import Game.Parse as Parse


update : Msg -> Model -> Model
update msg model =
    case Debug.log "msg" msg of
        Tick _ ->
            { model | board = evolve model.board }

        StartStop ->
            { model | started = True }

        UpdateSeed seed ->
            { model | seed = seed }

        ParseSeed ->
            { model
                | board = Board.merge (Parse.parse model.seed) model.board
            }

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

        Click mousePosition ->
            let
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
                { model | board = Board.flip position model.board }


evolve : Board -> Board
evolve board =
    Dict.map (evolveCell board) board


evolveCell : Board -> Position -> Cell -> Cell
evolveCell board position cell =
    getAdjacent position
        |> List.map (\p -> Dict.get p board)
        |> List.map
            (Maybe.map
                (\c ->
                    if c.isAlive then
                        1
                    else
                        0
                )
            )
        |> List.map (Maybe.withDefault 0)
        |> List.sum
        |> (\points ->
                if cell.isAlive && 2 <= points && points <= 3 then
                    { cell | isAlive = True }
                else if not cell.isAlive && points == 3 then
                    { cell | isAlive = True }
                else
                    { cell | isAlive = False }
           )


getAdjacent : Position -> List Position
getAdjacent ( x, y ) =
    deltaPositions
        |> List.map (\( dx, dy ) -> ( x + dx, y + dy ))


deltaPositions : List Position
deltaPositions =
    [ ( -1, -1 )
    , ( -1, 0 )
    , ( -1, 1 )
    , ( 0, 1 )
    , ( 1, 1 )
    , ( 1, 0 )
    , ( 1, -1 )
    , ( 0, -1 )
    ]
