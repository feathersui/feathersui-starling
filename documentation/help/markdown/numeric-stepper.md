---
title: How to use the Feathers NumericStepper component  
author: Josh Tynjala

---
# How to use the Feathers `NumericStepper` component

The [`NumericStepper`](../api-reference/feathers/controls/NumericStepper.html) component displays a numeric value between a minimum and maximum. The value may be changed by pressing the increment or decrement [buttons](button.html). If editing is enabled (typically not enabled on mobile), the value may be changed by typing a value into a [text input](text-input.html).

<figure>
<img src="images/numeric-stepper.png" srcset="images/numeric-stepper@2x.png 2x" alt="Screenshot of a Feathers NumericStepper component" />
<figcaption>A `NumericStepper` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

## The Basics

First, let's create a `NumericStepper` control, set up its range of values, and add it to the display list.

``` code
var stepper:NumericStepper = new NumericStepper();
stepper.minimum = 0;
stepper.maximum = 100;
stepper.value = 50;
this.addChild( stepper );
```

The [`value`](../api-reference/feathers/controls/NumericStepper.html#value) property indicates the current value of the stepper, while the [`minimum`](../api-reference/feathers/controls/NumericStepper.html#minimum) and [`maximum`](../api-reference/feathers/controls/NumericStepper.html#maximum) properties establish a range of possible values. We can further control the stepper's behavior with the [`step`](../api-reference/feathers/controls/NumericStepper.html#step) property:

``` code
stepper.step = 1;
```

The `step` property controls how the numeric stepper's value is rounded as the user interacts with it. If we set the stepper's `step` to `1`, as we do above, the stepper will increment on whole numbers only, and it cannot have a value like `4.5`, for instance.

Add a listener to the [`Event.CHANGE`](../api-reference/feathers/controls/NumericStepper.html#event:change) event to know when the `value` property changes:

``` code
stepper.addEventListener( Event.CHANGE, stepper_changeHandler );
```

The listener might look something like this:

``` code
function stepper_changeHandler( event:Event ):void
{
    var stepper:NumericStepper = NumericStepper( event.currentTarget );
    trace( "stepper.value changed:", stepper.value);
}
```

## Skinning a `NumericStepper`

The skins for a `NumericStepper` control are divided into three parts. There are the increment and decrement buttons and the text input. There are a few different layout modes that control where the buttons are placed relative to the text input. For full details about what skin and style properties are available, see the [`NumericStepper` API reference](../api-reference/feathers/controls/NumericStepper.html). We'll look at a few of the most common properties below.

### Layout Modes

The numeric stepper's layout can be customized to place the buttons in different locations. In the example below, we place the buttons on the right side of the text input, stacked vertically, like you see with many desktop numeric steppers using [`StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL`](../api-reference/feathers/controls/StepperButtonLayoutMode.html#RIGHT_SIDE_VERTICAL):

``` code
stepper.buttonLayoutMode = StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL;
```

There are two additional options for [`buttonLayoutMode`](../api-reference/feathers/controls/NumericStepper.html#buttonLayoutMode). You can use [`StepperButtonLayoutMode.SPLIT_HORIZONTAL`](../api-reference/feathers/controls/StepperButtonLayoutMode.html#SPLIT_HORIZONTAL) to place the decrement button on the left side of the text input and the increment button button on the right side. Similarly, you can use [`StepperButtonLayoutMode.SPLIT_VERTICAL`](../api-reference/feathers/controls/StepperButtonLayoutMode.html#SPLIT_VERTICAL) to place the increment button on top of the text input and the decrement button on the bottom.

### Skinning the Decrement Button

This section only explains how to access the decrement button sub-component. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON`](../api-reference/feathers/controls/NumericStepper.html#DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON) style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON, setNumericStepperDecrementButtonStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
stepper.customDecrementButtonStyleName = "custom-decrement-button";
```

You can set the function for the [`customDecrementButtonStyleName`](../api-reference/feathers/controls/NumericStepper.html#customDecrementButtonStyleName) like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-decrement-button", setNumericStepperCustomDecrementButtonStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`decrementButtonFactory`](../api-reference/feathers/controls/NumericStepper.html#decrementButtonFactory) to provide skins for the numeric stepper's decrement button:

``` code
stepper.decrementButtonFactory = function():Button
{
    var button:Button = new Button();
    //skin the decrement button here
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    return button;
}
```

### Skinning the Increment Button

This section only explains how to access the increment button sub-component. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

The numeric stepper's increment button may be skinned similarly to the decrement button. The style name to use with [themes](themes.html) is [`NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON`](../api-reference/feathers/controls/NumericStepper.html#DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON) or you can customize the style name with [`customIncrementButtonStyleName`](../api-reference/feathers/controls/NumericStepper.html#customIncrementButtonStyleName). If you aren't using a theme, then you can use [`incrementButtonFactory`](../api-reference/feathers/controls/NumericStepper.html#incrementButtonFactory) and [`incrementButtonProperties`](../api-reference/feathers/controls/NumericStepper.html#incrementButtonProperties).

If your decrement button and increment buttons don't have icons, you can use [`decrementButtonLabel`](../api-reference/feathers/controls/NumericStepper.html#decrementButtonLabel) and [`incrementButtonLabel`](../api-reference/feathers/controls/NumericStepper.html#incrementButtonLabel) to set the button labels:

``` code
stepper.decrementButtonLabel = "-";
stepper.incrementButtonLabel = "+";
```

### Skinning the Text Input

This section only explains how to access the text input sub-component. Please read [How to use the Feathers `TextInput` component](text-input.html) for full details about the skinning properties that are available on `TextInput` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT`](../api-reference/feathers/controls/NumericStepper.html#DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT) style name.

``` code
getStyleProviderForClass( TextInput )
    .setFunctionForStyleName( NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT, setNumericStepperTextInputStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
stepper.customTextInputStyleName = "custom-text-input";
```

You can set the function for the [`customTextInputStyleName`](../api-reference/feathers/controls/NumericStepper.html#customTextInputStyleName) like this:

``` code
getStyleProviderForClass( TextInput )
    .setFunctionForStyleName( "custom-text-input", setNumericStepperCustomTextInputStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`textInputFactory`](../api-reference/feathers/controls/NumericStepper.html#textInputFactory) provide skins for the numeric stepper's text input:

``` code
stepper.textInputFactory = function():TextInput
{
    var input:TextInput = new TextInput();
    //skin the text input here
    input.backgroundSkin = new Image( backgroundTexture );
    input.padding = 20;
    return input;
}
```

<aside class="info">On mobile devices with touch screens, you should generally set [`isEditable`](../api-reference/feathers/controls/TextInput.html#isEditable) on the numeric stepper's text input to `false` because editing the text may be frustrating or confusing for users. The touch surface for the text input is very small and close to the buttons, so accuracy can be an issue. Moreover, on iOS, a clear button is displayed when a text input has focus, meaning that there will be very little space to display the text for editing.

In this situation, think of the text input as a label that simply displays the value.</aside>

## Related Links

-   [`feathers.controls.NumericStepper` API Documentation](../api-reference/feathers/controls/NumericStepper.html)