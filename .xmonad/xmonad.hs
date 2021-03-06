-- xmonad config file.
-- author: Nikhil Murthy (nikhil.murthy@gmail.com)

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.ManageHook
import XMonad.Util.Run
import Data.List
import Data.Monoid
import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

main = do
    spawn . show $ myRightBar
    spawnPipe . show $ mySecondaryBar
    dzen <- spawnPipe . show $ myLeftBar

    xmonad $ defaultConfig {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook dzen,
        startupHook        = myStartupHook
    } 

-- preferred terminal
myTerminal = "urxvt"
-- focus follows mouse
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
-- border width
myBorderWidth   = 1
-- mod mask
myModMask       = mod1Mask
-- num lock mask
myNumlockMask   = mod2Mask
-- default workspaces
myWorkspaces = [  "1:irc",
                  "2:www",
                  "3:music",
                  "4:misc",
                  "5:code",
                  "6",
                  "7",
                  "8",
                  "9" ]
-----------------------------------------------------------------------
-- Color, font, and iconpath definitions
-- 
-- Border Colors, unfocused and focused respectively
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

myFont = "Droid Sans:size=8"

colorWhite  = "#ffffff"
colorRed    = "#ff0000"
colorGrey0  = "#303030"
colorGrey1  = "#606060"
colorGrey2  = "#909090"
    
colorFG = colorGrey1
colorBG = colorGrey0

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
barHeight       = 17
monitorWidth    = 1920
leftBarWidth    = 700
rightBarWidth   = monitorWidth - leftBarWidth
secondMonitorWidth = 1600

data TextAlign = LeftAlign | RightAlign | Centered
instance Show TextAlign where
    show LeftAlign = "l"
    show RightAlign = "r"
    show Centered = "c"

data Dzen = Dzen {
    x_offset    :: Int,
    y_offset    :: Int,
    width       :: Int,
    height      :: Int,
    alignment   :: TextAlign,
    font        :: String,
    fg_color    :: String,
    bg_color    :: String,
    input       :: String
}
instance Show Dzen where
    show dzen = let Dzen {
            x_offset    = x,
            y_offset    = y,
            width       = w,
            height      = h,
            alignment   = a,
            font        = f,
            fg_color    = fg,
            bg_color    = bg,
            input       = i
        } = dzen
     in trim . unwords $ [i, "dzen2", "-p", "-fn", quote f, "-fg", quote fg,
        "-bg", quote bg, "-ta", show a, "-x", show x, "-y", show y, "-w",
        show w, "-h", show h, "-e 'onstart=lower'"]

        where 
            quote :: String -> String
            quote s = "'" ++ s++ "'"

myLeftBar   = Dzen 0 0 leftBarWidth barHeight LeftAlign myFont colorFG colorBG []
myRightBar  = Dzen leftBarWidth 0 rightBarWidth barHeight RightAlign myFont colorFG colorBG "conky -c ~/.dzen_conkyrc |"
mySecondaryBar = Dzen (leftBarWidth + rightBarWidth) 0 secondMonitorWidth barHeight LeftAlign myFont colorFG colorBG []

myLogHook h = (dynamicLogWithPP $ defaultPP 
    {   ppCurrent           = dzenColor colorGrey0 colorGrey2 . pad,
        ppHidden            = dzenFG colorGrey2 . pad,
        ppHiddenNoWindows   = dzenFG colorGrey1 . pad,
        ppLayout            = dzenFG colorGrey1 . pad,
        ppUrgent            = myWrap colorRed "{" "}" . pad,
        ppTitle             = myWrap colorGrey2 "[ " " ]" . shorten 40,
        ppWsSep             = "",
        ppSep               = "  ",
        ppOutput            = hPutStrLn h
    }) >> updatePointer (Relative 0.95 0.95)
    
    where
        dzenFG c = dzenColor c ""
        myWrap c l r = wrap (dzenFG c l) (dzenFG c r)

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    , ((modm .|. shiftMask, xK_o     ), shiftNextScreen >> nextScreen)
    , ((modm              , xK_o     ), nextScreen)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((modm .|. shiftMask, xK_o), (windows W.shift) (screenWorkspace 

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen                  --> doFullFloat ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()
