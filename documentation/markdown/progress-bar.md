# How to use the Feathers ProgressBar Component

The `ProgressBar` class displays a visual indicator of how much of a task has been completed.

## The Basics

Let's start out by creating a progress bar, giving it some values, and adding it to the display list.

``` code
var progress:ProgressBar = new ProgressBar();
progress.minimum = 0;
progress.maximum = 100;
progress.value = 10;
this.addChild( progress );
```

The `minimum` and `maximum` properties set the range of the progress bar. The `value` property must be a value between the minimum and maximum.

By default, the progress bar direction is horizontal. You can change the `direction` property to make the progress bar vertically-oriented instead.

``` code
progress.direction = ProgressBar.DIRECTION_VERTICAL;
```

## Skinning a Progress Bar

A progress bar provides a number of properties that can be used to customize its appearance. For full details about what skin and style properties are available, see the [ProgressBar API reference](http://feathersui.com/documentation/feathers/controls/ProgressBar.html). We'll look at a few of the most common properties below.

The `backgroundSkin` and `fillSkin` properties are used to customize the appearance of the progress bar.

``` code
var backgroundSkin:Scale9Image = new Scale9Image( backgroundTextures );
backgroundSkin.width = 150;
progress.backgroundSkin = backgroundSkin;
 
var fillSkin:Scale9Image = new Scale9Image( fillTextures );
fillSkin.width = 20;
progress.fillSkin = fillSkin;
```

Notice that we're setting width values on the skins before passing them in. For the background, we're doing this so that the initial width of the progress bar is at least 150 pixels wide. We can still set the `width` property on the progress bar directly to a smaller or a larger value, if we'd prefer. However, if we don't set the progress bar's width explicitly, the progress bar knows to automatically calculate it's dimensions from the size of the background skin.

For the fill skin, we want to ensure that the fill is never smaller than 20 pixels. Perhaps the fill is a rounded rectangle, so the edges need to be at least 10 pixels wide before they start to overlap or distort. We want to avoid that, so we set the width of the `fillSkin` to inform the progress bar that this is the width that corresponds to the value of the `minimum` property. In other words, if the `value` property is equal to the `minimum` property (in this case, if they are `0`), then the fill skin will be 20 pixels wide. As the `value` property increases toward `100`, the fill skin's width will increase up to 150 pixels.

Additionally, two other skin properties, `backgroundDisabledSkin` and `fillDisabledSkin`, may be used to give a progress bar a different appearance when it is disabled. These skins are optional. For instance, if the `backgroundDisabledSkin` is not provided, the regular `backgroundSkin` will be used when `isEnabled` is false.

Like many components, the progress bar has padding values. These can be used to add space between the edge of the background and the edge of the fill. For instance, you might want to display part of the background as a border around the fill.

``` code
progress.paddingTop = 2;
progress.paddingRight = 3;
progress.paddingBottom = 2;
progress.paddingLeft = 3;
```

### Targeting a ProgressBar in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( ProgressBar ).defaultStyleFunction = setProgressBarStyles;
```

If you want to customize a specific progress bar to look different than the default, you may use a custom style name to call a different function:

``` code
progress.styleNameList.add( "custom-progress-bar" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( ProgressBar )
    .setFunctionForStyleName( "custom-progress-bar", setCustomProgressBarStyles );
```

Trying to change the progress bar's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the progress bar was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the progress bar's properties directly.

## Related Links

-   [ProgressBar API Documentation](http://feathersui.com/documentation/feathers/controls/ProgressBar.html)

For more tutorials, return to the [Feathers Documentation](start.html).


