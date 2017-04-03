module View exposing (view)

import Html exposing (Html)
import Html.Events exposing (onInput, onClick)
import Collage exposing (..)
import Element
import Color
import Utils
import Types exposing (..)


view : Model -> Html Msg
view model =
    Html.div []
        -- [ viewControls
        [ viewBoard model
        ]


viewControls : Html Msg
viewControls =
    Html.div []
        [ Html.input [ onInput UpdateSeed ] []
        , Html.button [ onClick ParseSeed ] [ Html.text "Parse" ]
        ]


viewBoard : Model -> Html Msg
viewBoard model =
    let
        { width, height } =
            model.windowSize
    in
        model.board
            |> Utils.map (viewCell model)
            |> collage width height
            |> Element.toHtml


viewCell : Model -> Position -> Cell -> Form
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
                alpha 0.5 cellView
    in
        square (toFloat (model.cellSize - 1))
            |> filled Color.blue
            |> move (parse position)
            |> opacity
