---
title: Media player controls  
author: Josh Tynjala

---
# Media player controls

Media players can have many different types of sub-components for customizing the playback behavior. Buttons might pause or play the media, switch to full screen mode, or mute the volume. Sliders might seek to a different time or change the volume. The [`SoundPlayer`](sound-player.html) and [`VideoPlayer`](video-player.html) components may be customized with a number of these controls. Let's look at which ones are available in Feathers.

## `FullScreenToggleButton`

The [`FullScreenToggleButton`](../api-reference/feathers/media/FullScreenToggleButton.html) class is a special toggle button component that controls whether a video player is displayed in full screen mode or not.

``` actionscript
var button:FullScreenToggleButton = new FullScreenToggleButton();
videoPlayer.addChild( button );
```

## `MuteToggleButton`

The [`MuteToggleButton`](../api-reference/feathers/media/MuteToggleButton.html) class is a special toggle button component that controls whether the media player's audio is muted or not.

``` actionscript
var button:MuteToggleButton = new MuteToggleButton();
mediaPlayer.addChild( button );
```

## `PlayPauseToggleButton`

The [`PlayPauseToggleButton`](../api-reference/feathers/media/PlayPauseToggleButton.html) class is a special toggle button component that controls whether the media player's media is playing or paused.

``` actionscript
var button:PlayPauseToggleButton = new PlayPauseToggleButton();
mediaPlayer.addChild( button );
```

## `SeekSlider`

The [`SeekSlider`](../api-reference/feathers/media/SeekSlider.html) class is a special slider component that displays and changes the current time of the playing media.

``` actionscript
var slider:SeekSlider = new SeekSlider();
mediaPlayer.addChild( slider );
```

## `TimeLabel`

The [`TimeLabel`](../api-reference/feathers/media/TimeLabel.html) class is a special label component that displays the current time, the remaining time, or the total time of the playing media. It can also display the current time and the total time together.

``` actionscript
var label:TimeLabel = new TimeLabel();
label.displayMode = TimeLabel.DISPLAY_MODE_CURRENT_TIME;
mediaPlayer.addChild( label );
```

## `VolumeSlider`

The [`VolumeSlider`](../api-reference/feathers/media/VolumeSlider.html) class is a special slider component that changes the current volume of the playing media.

``` actionscript
var slider:VolumeSlider = new VolumeSlider();
mediaPlayer.addChild( slider );
```

## Related Links

-   [How to use the Feathers `SoundPlayer` component](sound-player.html)

-   [How to use the Feathers `VideoPlayer` component](video-player.html)