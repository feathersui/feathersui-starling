---
title: How to use the Feathers Alert component  
author: Josh Tynjala

---
# How to use the Feathers `Alert` component

The [`Alert`](../api-reference/feathers/controls/Alert.html) class renders a window as a [pop-up](pop-ups.html) over all other content. Typically, an alert displays a header with a title, followed by some multiline, word-wrapped text, and a set of buttons to select different actions.

## The Basics

We create an `Alert` a bit differently than other components. Rather than calling a constructor, we call the static function [`Alert.show()`](../api-reference/feathers/controls/Alert.html#show()). Let's see how this works by displaying a simple message in an `Alert` when we touch a button. First, let's create the button:

``` code
var button:Button = new Button();
button.label = "Click Me";
button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
this.addChild( button );
```

Then, in the listener for the button's `Event.TRIGGERED` event, we create the alert:

``` code
function button_triggeredHandler( event:Event ):void
{
    var button:Button = Button( event.currentTarget );
    var alert:Alert = Alert.show( "I have something important to say", "Warning", new ListCollection(
    [
        { label: "OK", triggered: okButton_triggeredHandler }
    ]) );
}
```

Three arguments are required. The first is the alert's message. The second argument is the title displayed in the alert's header. Finally, a [`ListCollection`](../api-reference/feathers/data/ListCollection.html) of button data must be passed in to display in a [`ButtonGroup`](button-group.html).

In addition to listening for [`Event.TRIGGERED`](../api-reference/feathers/controls/Button.html#event:triggered) to be dispatched by individual buttons, you may also listen for [`Event.CLOSE`](../api-reference/feathers/controls/Alert.html#event:close) on the alert:

``` code
alert.addEventListener( Event.CLOSE, alert_closeHandler );
```

The event object's `data` property will contain the item from the `ButtonGroup` data provider that is associated with the button that was triggered:

``` code
function alert_closeHandler( event:Event, data:Object ):void
{
    if( data.label == "OK" )
    {
        // the OK button was clicked
    }
}
```

Additional, optional arguments are available for `Alert.show()`. Let's take a look at those next.

### Modality

Following the button group is the `isModal` argument. This determines whether there is an overlay between the alert and the rest of the display list. When an alert is modal, the overlay blocks touches to everything that appears under the alert. If the alert isn't modal, there will be no overlay to block the touch, and anything below the alert will remain interactive.

Alerts are displayed using the [`PopUpManager`](pop-ups.html). By default, modal overlays are managed by the `PopUpManager`, but you can give a custom overlay to all alerts (that will be different from other modal pop-ups) when you set the static property, [`overlayFactory`](../api-reference/feathers/controls/Alert.html#overlayFactory):

``` code
Alert.overlayFactory = function():DisplayObject
{
    var tiledBackground:Image = new Image( texture );
    tiledBackground.tileGrid = new Rectangle();
    return tiledBackground;
};
```

When [`PopUpManager.addPopUp()`](../api-reference/feathers/core/PopUpManager.html#addPopUp()) is called to show the alert, the custom overlay factory will be passed in as an argument.

### Centering

Following the modality is the `isCentered` argument. This determines if the alert will be globally centered on the Starling stage. If the alert or the stage is resized, the alert will be automatically repositioned to remain centered.

### Custom `Alert` factory

When an alert is created with `Alert.show()`, the function stored by the [`Alert.alertFactory()`](../api-reference/feathers/controls/Alert.html#alertFactory) property is called to instantiate an `Alert` instance. One of the final arguments of `Alert.show()` allows you to specify a custom alert factory. This let's you customize an individual alert to be different than other alerts. For instance, let's say that a particular alert should have different background skin than others. We might create an alert factory function like this:

``` code
function customAlertFactory():Alert
{
    var alert:Alert = new Alert();
    alert.styleNameList.add( "custom-alert" );
    return alert;
};
Alert.show( "I have something important to say", "Alert Title", new ListCollection({label: "OK"}), true, true, customAlertFactory );
```

If you're working with a [theme](themes.html), you can set a custom styling function for a `Alert` with the style name `"custom-alert"` to provide different skins for this alert.

## Skinning an `Alert`

The skins for an `Alert` control are divided into the header, the message text renderer, and the button group. Additionally, an alert may have background skins and various other styles. For full details about what skin and style properties are available, see the [Alert API reference](../api-reference/feathers/controls/Alert.html).

### Background skins and basic styles

We'll start the skinning process by giving our alert appropriate background skins.

``` code
alert.backgroundSkin = new Image( enabledTexture );
alert.backgroundDisabledSkin = new Image( disabledTexture );
```

The [`backgroundSkin`](../api-reference/feathers/controls/Scroller.html#backgroundSkin) property provides the default background for when the alert is enabled. The [`backgroundDisabledSkin`](../api-reference/feathers/controls/Scroller.html#disabledBackgroundSkin) is displayed when the alert is disabled. If the `backgroundDisabledSkin` isn't provided to a disabled alert, it will fall back to using the `backgroundSkin` in the disabled state.

Padding may be added around the edges of the alert. This padding is applied around the edges of the message text renderer, and is generally used to show a bit of the background as a border.

``` code
alert.paddingTop = 15;
alert.paddingRight = 20;
alert.paddingBottom = 15;
alert.paddingLeft = 20;
```

If all four padding values should be the same, you may use the [`padding`](../api-reference/feathers/controls/Scroller.html#padding) property to quickly set them all at once:

``` code
alert.padding = 20;
```

### Targeting an `Alert` in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( Alert ).defaultStyleFunction = setAlertStyles;
```

If you want to customize a specific alert to look different than the default, you may use a custom style name to call a different function:

``` code
alert.styleNameList.add( "custom-alert" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( Alert )
    .setFunctionForStyleName( "custom-alert", setCustomAlertStyles );
```

Trying to change the alert's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the alert was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the alert's properties directly.

### Skinning the header

This section only explains how to access the header sub-component. Please read [How to use the Feathers `Header` component](header.html) for full details about the skinning properties that are available on `Header` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`Alert.DEFAULT_CHILD_STYLE_NAME_HEADER`](../api-reference/feathers/controls/Alert.html#DEFAULT_CHILD_STYLE_NAME_HEADER) style name.

``` code
getStyleProviderForClass( Header )
    .setFunctionForStyleName( Alert.DEFAULT_CHILD_STYLE_NAME_HEADER, setAlertHeaderStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
alert.customHeaderStyleName = "custom-header";
```

You can set the styling function for the [`customHeaderStyleName`](../api-reference/feathers/controls/Panel.html#customHeaderStyleName) like this:

``` code
getStyleProviderForClass( Header )
    .setFunctionForStyleName( "custom-header", setAlertCustomHeaderStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`headerFactory`](../api-reference/feathers/controls/Panel.html#headerFactory) to provide skins for the alert's header:

``` code
alert.headerFactory = function():Header
{
    var header:Header = new Header();
    //skin the header here
    header.backgroundSkin = new Image( headerBackgroundTexture );
    return header;
}
```

Alternatively, or in addition to the `headerFactory`, you may use the [`headerProperties`](../api-reference/feathers/controls/Panel.html#headerProperties) to pass skins to the header.

``` code
alert.headerProperties.backgroundSkin = new Image( headerBackgroundTexture );
```

In general, you should only pass skins to the alert's header through `headerProperties` if you need to change skins after the header is created. Using `headerFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the buttons

This section only explains how to access the button group sub-component. Please read [How to use the Feathers `ButtonGroup` component](button-group.html) for full details about the skinning properties that are available on `ButtonGroup` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP`](../api-reference/feathers/controls/Alert.html#DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP) style name.

``` code
getStyleProviderForClass( ButtonGroup )
    .setFunctionForStyleName( Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP, setAlertButtonGroupStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
alert.customButtonGroupStyleName = "custom-button-group";
```

You can set the styling function for the [`customButtonGroupStyleName`](../api-reference/feathers/controls/Alert.html#customButtonGroupStyleName) like this:

``` code
getStyleProviderForClass( ButtonGroup )
    .setFunctionForStyleName( "custom-button-group", setAlertCustomButtonGroupStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`buttonGroupFactory`](../api-reference/feathers/controls/Alert.html#buttonGroupFactory) to provide skins for the alert's button group:

``` code
alert.buttonGroupFactory = function():Header
{
    var group:ButtonGroup = new ButtonGroup();
    //skin the button group here
    group.gap = 20;
    return group;
}
```

Alternatively, or in addition to the `buttonGroupFactory`, you may use the [`buttonGroupProperties`](../api-reference/feathers/controls/Alert.html#buttonGroupProperties) to pass skins to the button group.

``` code
alert.buttonGroupProperties.gap = 20;
```

In general, you should only pass skins to the alert's button group through `buttonGroupProperties` if you need to change skins after the button group is created. Using `buttonGroupFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the message text renderer

This section only explains how to access the message text renderer sub-component. Please read [Introduction to Feathers Text Renderers](text-renderers.html) for full details about how to style different kinds of Feathers text renderers.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE`](../api-reference/feathers/controls/Alert.html#DEFAULT_CHILD_STYLE_NAME) style name. In the following examples, we'll use a [`BitmapFontTextRenderer`](text-renderers.html), but other text renderers may be used instead, if desired.

``` code
getStyleProviderForClass( BitmapFontTextRenderer )
    .setFunctionForStyleName( Alert.DEFAULT_CHILD_STYLE_NAME_MESSAGE, setAlertMessageStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`messageFactory`](../api-reference/feathers/controls/Alert.html#messageFactory) to provide skins for the alert's message:

``` code
alert.messageFactory = function():ITextRenderer
{
    var message:BitmapFontTextRenderer = new BitmapFontTextRenderer();
    //skin the message here
    message.textFormat = new BitmapFontTextFormat( bitmapFont );
    return message;
}
```

Alternatively, or in addition to the `messageFactory`, you may use the [`messageProperties`](../api-reference/feathers/controls/Alert.html#messageProperties) to pass properties to the text renderer.

``` code
alert.messageProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
```

In general, you should only pass skins to the alert's message text renderer through `messageProperties` if you need to change skins after the message text renderer is created. Using `messageFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Customizing the `Alert` factories

If you're not using a theme, you can specify a factory to create the alert, including setting skins, in a couple of different ways. The first is to set the [`Alert.alertFactory`](../api-reference/feathers/controls/Alert.html#alertFactory) static property to a function that provides skins for the alert. This factory will be called any time that [`Alert.show()`](../api-reference/feathers/controls/Alert.html#show()) is used to create an alert.

``` code
function skinnedAlertFactory():Alert
{
    var alert:Alert = new Alert();
    alert.backgroundSkin = new Image( texture );
    // etc...
    return alert;
};
Alert.alertFactory = skinnedAlertFactory;
```

Another option is to pass an alert factory to `Alert.show()`. This allows you to create a specific alert differently than the default global `Alert.alertFactory`.

``` code
function skinnedAlertFactory():Alert
{
    var alert:Alert = new Alert();
    alert.backgroundSkin = new Image( texture );
    // etc...
    return alert;
};
Alert.show( message, title, buttons, isModal, isCentered, skinnedAlertFactory );
```

You should generally always skin the alerts with a factory or with a theme instead of passing the skins to the `Alert` instance returned by calling `Alert.show()`. If you skin an alert after `Alert.show()` is called, it may not be positioned or sized correctly anymore.

## Closing and disposal

The alert will automatically remove itself from the display list and dispose itself when one of its buttons is triggered. To manually close and dispose the alert without triggering a button, you may simply remove the alert from its parent:

``` code
alert.removeFromParent( true );
```

## Related Links

-   [`feathers.controls.Alert` API Documentation](../api-reference/feathers/controls/Alert.html)