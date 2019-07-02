---
title: When I try to change a Feathers component's skins, why do I always see the default skins?  
author: Josh Tynjala

---
# When I try to change a Feathers component's skins, why do I always see the default skins?

<aside class="info">Before Feathers 3.1, you needed to use an [`AddOnFunctionStyleProvider`](../../api-reference/feathers/skins/AddOnFunctionStyleProvider.html) or [extend the theme](../extending-themes.html) to customize a component's styles outside of a theme. Today, the architecture has been redesigned to allow developers to set styles anywhere, and the theme will not be allowed to replace them.

If you are using Feathers 3.1 or newer, **this document is considered obsolete**. It remains available to assist developers who need to support legacy apps that are still using older versions of Feathers.</aside>

If you're using a [theme](../themes.html), the theme won't pass any skins to a component until the component initializes. This usually happens when the component is added to the stage. If you try to pass skins to the component before it has initialized, the theme may end up replacing them.

There are two primary ways to modify a component's styles when using a theme.

## 1. Extend the theme

In general, it's considered a best practice to keep all of our skinning code inside the theme. If we want to style a component differently than the default provided by an example theme, we should subclass the theme and create a new *style name* for that type of component. This is called [extending the theme](../extending-themes.html). Once our new style name has been added to the theme, we can reuse it anywhere in our app. This helps us to avoid duplicating code, and we have a cleaner separation between the visual styles and the application logic or game mechanics.

For complete details and code examples, read [Extending Feathers themes](../extending-themes.html).

## 2. Use an `AddOnFunctionStyleProvider` for minor tweaks

If we're generally happy with the styles provided by the theme, but we want to make some minor tweaks for one instance of a component, we can use an [`AddOnFunctionStyleProvider`](../../api-reference/feathers/skins/AddOnFunctionStyleProvider.html). This class allows to us call an extra function after the theme has applied its styles.

Let's use an `AddOnFunctionStyleProvider` to add an icon to a `Button` component:

``` actionscript
function setExtraStyles( button ):void
{
    button.iconPosition = RelativePosition.TOP;
    button.defaultIcon = new Image( texture );
}
 
var button1:Button = new Button();
button1.label = "Click Me";
button1.styleProvider = new AddOnFunctionStyleProvider( button1.styleProvider, setExtraStyles );
this.addChild( button1 );
```

In the example above, the button will be styled first by the theme. We made this possible by passing the original value of the `styleProvider` property to our new `AddOnFunctionStyleProvider`. Next, the `AddOnFunctionStyleProvider` will call our `setExtraStyles()` function to create the icon and set its position.

## Related Links

-   [Skinning Feathers components](../skinning.html)

-   [Introduction to Feathers Themes](../themes.html)

-   [Extending Feathers Themes](../extending-themes.html)