module Main exposing (..)

import Html
import Collage exposing (..)
import Element
import Color
import Board


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { board : Board.Board
    , sizes :
        { cell : Int
        , canvas :
            { width : Int
            , height : Int
            }
        }
    }


init =
    ( initModel, Cmd.none )


initModel =
    { board = Board.create 10 10
    , sizes =
        { cell = 20
        , canvas =
            { width = 500
            , height = 500
            }
        }
    }


update msg model =
    model ! []


subscriptions model =
    Sub.none


view model =
    let
        { width, height } = model.sizes.canvas
    in
        model.board
            |> Board.map (viewCell model)
            |> collage width height
            |> Element.toHtml


viewCell : Model -> Board.Position -> Board.Cell -> Form
viewCell model position cell =
    let
        parse ( x, y ) =
            ( toFloat (x * model.sizes.cell)
            , toFloat (y * model.sizes.cell)
            )
    in
        square (toFloat (model.sizes.cell - 1))
            |> filled Color.blue
            |> move (parse position)
