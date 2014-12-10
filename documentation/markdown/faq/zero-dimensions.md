# FAQ: When I try to access the width or height properties of a Feathers component, why do I get 0?

If you haven't set the `width` and `height` explicitly, a Feathers component will automatically resize itself to what is considered its “ideal” dimensions based on its skins and other properties. However, a component won't measure itself immediately after you set its properties.

A Feathers component will *invalidate* when you change one of its properties. The change you made to the property will be queued up to be processed immediately before Starling renders the next frame. During this time, you can change any number of other properties, and all of the changes will be processed in one batch in time to display them to the user. This can help to improve performance quite a bit.

If you can't wait until the next frame, and you need to the component to measure itself immediately and process any other property changes, you can call the `validate()` function yourself:

``` code
label.text = "hello";
trace( label.width ); // 0
label.validate();       // validate yourself, right this instant!
trace( label.width ); // 150 (or an appropriate value for the current font)
```

As you can see, changing the `text` property on the `Label` component doesn't immediately update its `width` property. When we check it the first time, its value is `0`. Normally, the label would wait until Starling renders before it processes all of its changed properties, but we've manually called the `validate()` function to force that to happen immediately. Afterwards, the `width` property has been updated, and we can use it in our layout code.

A component must be on the display list for `validate()` to work. A call to `validate()` does nothing if the component doesn't have access to the stage.

------------------------------------------------------------------------

This is a detailed response to a [Frequently Asked Question](../faq.html) about [Feathers](../index.html).


