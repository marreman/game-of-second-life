module Board exposing (..)

import Dict exposing (Dict)


type alias Board =
    Dict Position Cell


type alias Position =
    ( Int, Int )


type alias Cell =
    { isAlive : Bool }


create : Int -> Int -> Board
create w h =
    let
        width =
            List.range (w // -2) (w // 2 - 1)

        height =
            List.range (h // -2) (h // 2 - 1)
    in
        Dict.fromList <|
            List.concatMap
                (\x ->
                    List.map
                        (\y ->
                            ( ( x, y ), Cell False )
                        )
                        height
                )
                width


-- get : Position -> Board -> Maybe Cell
-- get position board =
--     Dict.get position board


map f board =
    board
        |> Dict.map f
        |> Dict.toList
        |> List.map Tuple.second
