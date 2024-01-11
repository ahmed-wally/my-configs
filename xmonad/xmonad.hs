import XMonad
import System.Exit ()
import XMonad.Util.SpawnOnce ( spawnOnce )
import Control.Monad ( join, when )
-----------------------------------------
import XMonad.Hooks.ManageDocks ( avoidStruts, docks, manageDocks, Direction2D(D, L, R, U) )
import XMonad.Hooks.ManageHelpers ( doFullFloat, isFullscreen )
import XMonad.Hooks.EwmhDesktops ( ewmh )
-----------------------------------------
import qualified XMonad.StackSet as W
-----------------------------------------
import qualified Data.Map        as M
import Data.Monoid ()
import Data.Maybe (maybeToList)
-----------------------------------------
import XMonad.Layout.Fullscreen ( fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull )
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Spacing ( spacingRaw, Border(Border), spacingWithEdge )
import XMonad.Layout.Gaps ( Direction2D(D, L, R, U), gaps, setGaps, GapMessage(DecGap, ToggleGaps, IncGap) )
import XMonad.Layout.NoBorders
-----------------------------------------
-- Defaults

myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth   = 2

-- "windows key" is usually mod4Mask and mod1Mask is "alt key"
--
myModMask       = mod1Mask

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#3b4252"
myFocusedBorderColor = "#bc96da"

addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
clipboardy :: MonadIO m => m () -- Don't question it 

-----------------------------------------
--take Screenshot and copy it
maimcopy = spawn "maim -s | xclip -selection clipboard -t image/png && notify-send \"Screenshot\" \"Copied to Clipboard\" -i flameshot"

--take Screenshot and save it
maimsave = spawn "maim -s ~/Desktop/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send \"Screenshot\" \"Saved to Desktop\" -i flameshot"
-----------------------------------------
rofi_launchpad = spawn "rofi -no-lazy-grab -show drun -modi run,drun,window -theme $HOME/.config/rofi/launcher/launchpad.rasi -drun-icon-theme \"candy-icons\" "
rofi_launcher = spawn "rofi -no-lazy-grab -show drun -modi run,drun,window -theme $HOME/.config/rofi/launcher/squared-material-red.rasi -drun-icon-theme \"candy-icons\" "

--Rofi clipboard history
clipboardy = spawn "rofi -modi \"\63053 :greenclip print\" -show \"\63053 \" -run-command '{cmd}' -theme $HOME/.config/rofi/launcher/simple-tokyonight.rasi"

--themes from https://github.com/newmanls/rofi-themes-collection
-----------------------------------------
--brightness
brightness_up = spawn "xrandr --output LVDS-1 --brightness $(echo \"$(xrandr --verbose | grep -i brightness | awk '{print $2}') + 0.1\" | bc)"

brightness_down = spawn "xrandr --output LVDS-1 --brightness $(echo \"$(xrandr --verbose | grep -i brightness | awk '{print $2}') - 0.1\" | bc)"
-----------------------------------------
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- lock screen
    , ((modm,               xK_F1    ), spawn "betterlockscreen -l")
    -- notes
    , ((modm,               xK_p    ), spawn "bash ~/.config/xmonad/scripts/notes.sh")
    -- rofi
    , ((modm,               xK_o     ), rofi_launchpad)
    , ((modm .|. shiftMask, xK_o     ), rofi_launcher)
    , ((modm .|. shiftMask, xK_a     ), clipboardy)
    -- brightness
    , ((modm .|. shiftMask, xK_equal     ), brightness_up)
    , ((modm .|. shiftMask, xK_minus     ), brightness_down)
    -- volume
	, ((modm,               xK_equal     ), spawn "amixer -q sset 'Master' 2%+")
	, ((modm,               xK_minus     ), spawn "amixer -q sset 'Master' 2%-")
    -- dmenu and surf browser
	, ((modm,               xK_d     ), spawn "dmenu_run -fn JetBrainsMono")
	, ((modm,               xK_s     ), spawn "surf start.duckduckgo.com/")
    -- Screenshot
    , ((0,                    xK_Print), maimcopy)
    , ((modm,                 xK_Print), maimsave)
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    -- toggle the polybar
    , ((modm,               xK_b     ), do spawn "pkill polybar")
    , ((modm .|. shiftMask, xK_b     ), spawn "polybar -q main -c ~/.config/polybar/forest/config.ini")
	-- GAPS!!!
    , ((modm .|. controlMask, xK_g), sendMessage $ ToggleGaps)               -- toggle all gaps
    , ((modm .|. shiftMask, xK_g), sendMessage $ setGaps [(L,20), (R,20), (U,40), (D,20)]) -- reset the GapSpec
    
    , ((modm .|. controlMask, xK_t), sendMessage $ IncGap 10 L)              -- increment the left-hand gap
    , ((modm .|. shiftMask, xK_t     ), sendMessage $ DecGap 10 L)           -- decrement the left-hand gap
    
    , ((modm .|. controlMask, xK_y), sendMessage $ IncGap 10 U)              -- increment the top gap
    , ((modm .|. shiftMask, xK_y     ), sendMessage $ DecGap 10 U)           -- decrement the top gap
    
    , ((modm .|. controlMask, xK_u), sendMessage $ IncGap 10 D)              -- increment the bottom gap
    , ((modm .|. shiftMask, xK_u     ), sendMessage $ DecGap 10 D)           -- decrement the bottom gap

    , ((modm .|. controlMask, xK_i), sendMessage $ IncGap 10 R)              -- increment the right-hand gap
    , ((modm .|. shiftMask, xK_i     ), sendMessage $ DecGap 10 R)           -- decrement the right-hand gap

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

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm .|. shiftMask, xK_F11     ), spawn "pkill -KILL -u $USER"   )

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
myLayout = ( tiled
         ||| mirrortiled ||| bsp ||| mirrorbsp ||| fullscreen )
         where

     -- default tiling algorithm partitions the screen into two panes with more adjustment
     tiled_template = withBorder 2 $ spacingWithEdge 1 $ ResizableTall nmaster delta ratio []
     
     tiled          = renamed [Replace "Tiled" ] $ avoidStruts $ tiled_template
     mirrortiled    = renamed [Replace "MTiled"] $ avoidStruts $ Mirror tiled_template

     -- Real fullscreen
     fullscreen     = renamed [Replace "Full"  ] $ noBorders $ Full 


     -- Selected window divides into two
     bsp_template   = withBorder 2 $ spacingWithEdge 1 $ emptyBSP 
     
     bsp            = renamed [Replace "BSP"   ] $ avoidStruts $        bsp_template
     mirrorbsp      = renamed [Replace "MBSP"  ] $ avoidStruts $ Mirror bsp_template


     -- The default number of windows in the master pane
     nmaster        = 1

     -- Default proportion of screen occupied by master pane
     ratio          = 1/2

     -- Percent of screen to increment by when resizing panes
     delta          = 3/100

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
myManageHook = fullscreenManageHook <+> manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen --> doFullFloat
                                 ]

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
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  spawnOnce "polybar -q main -c ~/.config/polybar/forest/config.ini" --https://github.com/adi1090x/polybar-themes
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "feh --bg-scale ~/wallpapers/wallpaper.jpg"
  spawnOnce "picom --experimental-backends"
  spawnOnce "greenclip daemon"
  spawnOnce "xfce4-power-manager --daemon"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ fullscreenSupport $ docks $ ewmh defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        manageHook = myManageHook, 
        layoutHook = gaps [(L,20), (R,20), (U,40), (D,20)] $ spacingRaw True (Border 2 2 2 2) True (Border 2 2 2 2) True $ smartBorders $ myLayout,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook >> addEWMHFullscreen
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'super'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
