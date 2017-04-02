module Types exposing (..)

import Window exposing (Size)
import Dict exposing (Dict)


type alias Model =
    { board : Board
    , cellSize : Int
    , windowSize : Size
    , seed : String
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
