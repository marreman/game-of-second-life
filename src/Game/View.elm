module Game.View exposing (view)

import Collage
import Color
import Dict
import Element
import Game.Types exposing (..)
import Html exposing (Html)


view : Model -> Html Msg
view model =
    let
        { width, height } =
            model.windowSize
    in
        model.board
            |> Dict.map (viewCell model)
            |> Dict.toList
            |> List.map Tuple.second
            |> Collage.collage width height
            |> Element.toHtml


viewCell : Model -> Position -> Cell -> Collage.Form
viewCell model position cell =
    let
        parse ( x, y ) =
            ( toFloat (x * model.cellSize + model.cellSize // 2)
            , toFloat (y * model.cellSize + model.cellSize // 2)
            )

        opacity cellView =
            if cell.isAlive then
                cellView
            else
                Collage.alpha 0.5 cellView
    in
        Collage.square (toFloat (model.cellSize - 1))
            |> Collage.filled Color.blue
            |> Collage.move (parse position)
            |> opacity
