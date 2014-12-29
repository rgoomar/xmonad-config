import System.IO
import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.SetWMName
import XMonad.Config.Desktop
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Grid
import XMonad.Layout.Maximize
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import Data.Ratio ((%))
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myTerminal = "xfce4-terminal"
myBorderWidth = 1

-- Custom Keyboard Shortcuts
myKeys (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm,               xK_p), spawn "dmenu_run")
    , ((modm .|. shiftMask, xK_p), spawn "xfce4-appfinder")
    , ((modm .|. shiftMask, xK_q), spawn "xfce4-session-logout")
    , ((modm, xK_Return),          spawn "xfce4-terminal")
    , ((modm .|. shiftMask, xK_h), spawn "sh ~/HoN/hon.sh")
    , ((modm .|. controlMask, xK_l), spawn "i3lock")
    -- Spotify
    , ((0, xF86XK_AudioPlay),      spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
    , ((0, xF86XK_AudioStop),      spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop")
    , ((0, xF86XK_AudioPrev),      spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
    , ((0, xF86XK_AudioNext),      spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
    ]

myManageHook = composeAll
    [ className =? "MPlayer"           --> doFloat
    , className =? "Gimp"              --> doFloat
    , className =? "Xfce4-appfinder"   --> doFloat
    , className =? "Xfrun4"            --> doFloat
    , className =? "Skype"             --> doShift "4"
    , className =? "Heroes of Newerth" --> doShift "5"
    , className =? "Heroes of Newerth" --> doFullFloat
    , resource  =? "desktop_window"    --> doIgnore
    , resource  =? "kdesktop"          --> doIgnore
    {-, isFullscreen                     --> doFullFloat-}
    ]

-- Skype Layout
myIMLayout = withIM (1%6) skype Grid
    where
      skype = And (ClassName "Skype") (Role "")
-- Custom Layouts
myLayout = onWorkspace "4" myIMLayout $ smartBorders $ maximize (tiled) ||| Mirror tiled ||| noBorders Full
  where
      tiled   = Tall nmaster delta ratio
      nmaster = 1
      ratio   = 1/2
      delta   = 3/100

main = xmonad xfceConfig
    { terminal        = myTerminal
    , modMask         = mod4Mask
    , keys            = myKeys <+> keys defaultConfig
    , workspaces      = myWorkspaces
    , manageHook      = manageDocks <+> myManageHook
    , layoutHook      = avoidStruts $ myLayout
    , borderWidth     = myBorderWidth
    -- Java Fix
    , startupHook     = setWMName "LG3D"
    -- Fix Full screen issues
    , handleEventHook = XMonad.Hooks.EwmhDesktops.fullscreenEventHook
    }
