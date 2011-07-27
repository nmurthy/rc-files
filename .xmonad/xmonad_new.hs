import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe, runProcessWithInput)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import XMonad.Layout.Grid
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutHints
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane
import XMonad.Layout.Combo
import XMonad.Layout.WindowNavigation (Navigate(..), windowNavigation)
import XMonad.Config.Gnome
import XMonad.Actions.WindowBringer
import System.IO
import System.Process
import System.Environment
import System.FilePath

import Data.Monoid
import Data.Ratio
import Data.List
import Control.Monad

modm = mod4Mask

myKeys host =
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
    [ ((modm, xK_i), spawn (browser host))
    , ((modm, xK_t), spawn "gnome-terminal")
    , ((modm .|. shiftMask, xK_t), withFocused $ windows . W.sink)
    , ((modm, xK_Left),     sendMessage $ Move L)
    , ((modm, xK_Right),    sendMessage $ Move R)
    , ((modm, xK_BackSpace), namedScratchpadAction scratchpads "screen")   
    , ((modm, xK_n),        namedScratchpadAction scratchpads "notes")
    ] ++
    [ ((m, k), windows $ onCurrentScreen f i) |
        (i, k) <- zip normWorkspaces [xK_F1 .. xK_F6],
        (f, m) <- [(W.greedyView, 0), (W.shift, modm)]] ++
    [ ((m, k), windows $ onCurrentScreen f i) |
        (i, k) <- zip shiftWorkspaces [xK_F1 .. xK_F6],
        (f, m) <- [(W.greedyView, shiftMask), (W.shift, shiftMask .|. modm)]]
