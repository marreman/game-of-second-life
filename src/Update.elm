module Update exposing (update)

import Types exposing (..)
import Utils

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateSeed seed ->
            { model | seed = seed } ! []

        ParseSeed ->
            { model
                | board = Utils.merge (parse model.seed) model.board
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
                    , board = Utils.create cols rows
                }
                    ! []


parse : String -> Board
parse seed =
    seed
        |> String.split "\n"
        |> List.map String.trim
        |> List.filter (\r -> not <| String.isEmpty r)
        |> List.map parsePair
        |> List.map (\pos -> ( pos, Cell True ))
        |> Utils.fromList
        |> Debug.log "root"


parsePair : String -> Position
parsePair pair =
    let
        toTuple xs =
            case xs of
                [ x, y ] ->
                    ( x, y )

                _ ->
                    ( "0", "0" )

        parseInt ( x, y ) =
            ( String.toInt x |> Result.withDefault 0
            , String.toInt y |> Result.withDefault 0
            )
    in
        pair
            |> String.split " "
            |> toTuple
            |> parseInt
