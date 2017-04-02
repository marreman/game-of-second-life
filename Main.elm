module Main exposing (..)

import Task
import Html exposing (Html)
import Html.Events exposing (onInput, onClick)
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
    , rawSeed : String
    }


init =
    ( initModel, getWindowSize )


initModel : Model
initModel =
    { board = Board.empty
    , cellSize = 50
    , windowSize = Window.Size 0 0
    , rawSeed = """
0 -1
1 0
-1 1
0 1
1 1
        """
    }


type Msg
    = NewWindowSize Window.Size
    | UpdateSeed String
    | ParseSeed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateSeed seed ->
            model ! []

        ParseSeed ->
            { model
                | board = Board.merge (parse model.rawSeed) model.board
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


parse : String -> Board.Board
parse seed =
    seed
        |> String.split "\n"
        |> List.map String.trim
        |> List.filter (\r -> not <| String.isEmpty r)
        |> List.map parsePair
        |> List.map (\pos -> ( pos, Board.Cell True ))
        |> Board.fromList
        |> Debug.log "root"


parsePair : String -> Board.Position
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


subscriptions model =
    Sub.none


getWindowSize =
    Task.perform NewWindowSize Window.size


view : Model -> Html Msg
view model =
    Html.div []
        [ viewControls
        , viewBoard model
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
