module Game.Board exposing (..)

import Dict exposing (Dict)
import Game.Types exposing (..)


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


empty : Board
empty =
    Dict.empty


merge : Board -> Board -> Board
merge b1 b2 =
    Dict.union b1 b2


flip : Position -> Board -> Board
flip position board =
    let
        updateCell cell =
            { cell | isAlive = not cell.isAlive }
    in
        Dict.update position (Maybe.map updateCell) board
