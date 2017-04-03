module Game.Types exposing (..)

import Mouse
import Dict exposing (Dict)
import Window exposing (Size)
import Time exposing (Time)


type alias Model =
    { board : Board
    , cellSize : Int
    , windowSize : Size
    , seed : String
    , started : Bool
    }


type alias Board =
    Dict Position Cell


type alias Position =
    ( Int, Int )


type alias Cell =
    { isAlive : Bool }


type Msg
    = NewWindowSize Size
    | UpdateSeed String
    | ParseSeed
    | Click Mouse.Position
    | StartStop
    | Tick Time
