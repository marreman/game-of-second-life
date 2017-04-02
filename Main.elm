module Main exposing (..)

import Task
import Html
import Collage exposing (..)
import Element
import Color
import Board
import Window


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { board : Board.Board
    , cellSize : Int
    , windowSize : Window.Size
    }


init =
    ( initModel, getWindowSize )


initModel : Model
initModel =
    { board = Board.empty
    , cellSize = 50
    , windowSize = Window.Size 0 0
    }


type Msg
    = NewWindowSize Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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


subscriptions model =
    Sub.none


getWindowSize =
    Task.perform NewWindowSize Window.size


view model =
    let
        { width, height } =
            model.windowSize
    in
        model.board
            |> Board.map (viewCell model)
            |> collage width height
            |> Element.toHtml


viewCell : Model -> Board.Position -> Board.Cell -> Form
viewCell model position cell =
    let
        parse ( x, y ) =
            ( toFloat (x * model.cellSize + model.cellSize // 2)
            , toFloat (y * model.cellSize + model.cellSize // 2)
            )
    in
        square (toFloat (model.cellSize - 1))
            |> filled Color.blue
            |> move (parse position)
