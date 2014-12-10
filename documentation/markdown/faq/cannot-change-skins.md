# FAQ: When I try to change a component's skins, why do I always see the default skins?

If you're using a [theme](../themes.html), it will listen for when new components are added to the display list. That's when the theme sets skins and other styling properties on the component. If you set properties on your components before you add them to the display list, the theme may change the properties that you just set.

In general, it's best to keep all of your skinning code inside the theme. If you want to style a component differently than the default provided by an existing theme, you should [extend the theme](../extending-themes.html). Once your new styles are part of the theme (don't worry, they're easy to add), you can reuse them anywhere in your app. No duplicated code, and you have a clean separation between the theme and your app's business logic.

------------------------------------------------------------------------

This is a detailed response to a [Frequently Asked Question](../faq.html) about [Feathers](../index.html).


