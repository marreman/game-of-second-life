module Game.Parse exposing (parse)

import Game.Types exposing (..)
import Dict exposing (Dict)


parse : String -> Board
parse seed =
    seed
        |> String.split "\n"
        |> List.map String.trim
        |> List.filter (\r -> not <| String.isEmpty r)
        |> List.map parsePair
        |> List.map (\pos -> ( pos, Cell True ))
        |> Dict.fromList


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
