---
title: Feathers 3.4 Migration Guide  
author: Josh Tynjala

---
# Feathers 3.3 Migration Guide

This guide explains how to migrate an application created with Feathers 3.3 to Feathers 3.4.

-   [Button focused state](#button-focused-state)

## Button focused state

In Feathers 3.4.0, a new button state constant has been added, [`ButtonState.FOCUSED`](../api-reference/feathers/controls/ButtonState.html#FOCUSED). It is used when a button is up, but it has been given focus by [the focus manager](focus-management.html).

In previous versions of Feathers, you might have set the skin or font styles for the up state, like this:

``` code
button.setSkinForState(ButtonState.UP, upSkin);
button.setFontStylesForState(ButtonState.UP, upFontStyles);
```

Starting in Feathers 3.4, you will also need to account for `ButtonState.FOCUSED`. There are two options:

### Option 1: Use `defaultSkin` and `fontStyles`

The `defaultSkin` and `fontStyles` properties work as fallbacks when explicit values haven't been set for a particular state. As a best practice, it's always recommended to set these styles so that the button is never left without skins or font styles:

``` code
button.defaultSkin = upSkin;
button.fontStyles = upFontStyles;
```

Then, you can customize styles for any state that needs to look different.

## Option 2: Set the skin and font styles for `ButtonState.FOCUSED` too

Alternatively, you can provide separate styles for this new state:

``` code
button.setSkinForState(ButtonState.UP, upSkin);
button.setSkinForState(ButtonState.FOCUSED, focusedSkin);
button.setFontStylesForState(ButtonState.UP, upFontStyles);
button.setFontStylesForState(ButtonState.FOCUSED, focusedFontStyles);
```

To quickly migrate without designing separate skins, it's recommended to use `defaultSkin` and `fontStyles`, as mentioned above in option 1. However, the following code is perfectly valid too:

``` code
button.setSkinForState(ButtonState.UP, upSkin);
button.setSkinForState(ButtonState.FOCUSED, upSkin);
button.setFontStylesForState(ButtonState.UP, upFontStyles);
button.setFontStylesForState(ButtonState.FOCUSED, upFontStyles);
```

## Related Links

-   [Feathers 3.3 Migration Guide](migration-guide-3.3.html)
-   [Feathers 3.1 Migration Guide](migration-guide-3.1.html)
-   [Feathers 3.0 Migration Guide](migration-guide-3.0.html)