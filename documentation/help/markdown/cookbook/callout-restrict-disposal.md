---
title: How to close a Callout without disposing it (or without disposing its content)  
author: Josh Tynjala

---
# How to close a `Callout` without disposing it (or without disposing its content)

Normally, a [`Callout`](../callout.html) component will dispose itself (and its content) as soon as you close it. However, sometimes we might want to reuse it again, or we might want to reuse its content in another `Callout` (or elsewhere).

## Close without disposing content

The [`disposeContent`](../../api-reference/feathers/controls/Callout.html#disposeContent) property may be set to `false` to tell the `Callout` that the content should be preserved when the `Callout` closes. Let's create a `Label` that we will show in a `Callout` every time that a `Button` is triggered.

We'll start with a simple class that extends [`LayoutGroup`](../layout-group.html) and we'll create the `Label`, the `Button`, and add a listener for `Event.TRIGGERED` to the `Button`:

``` code
public class Example extends LayoutGroup
{
	public function Example()
	{
		super();
		this.autoSizeMode = AutoSizeMode.STAGE;
	}

	private var _label:Label;
	private var _button:Button;

	override protected function initialize():void
	{
		this.layout = new AnchorLayout();

		this._label = new Label();
		this._label = "Hello World";

		var buttonLayoutData:AnchorLayoutData = new AnchorLayoutData();
		buttonLayoutData.horizontalCenter = 0;
		buttonLayoutData.verticalCenter = 0;
		this._button = new Button();
		this._button.label = "Click Me";
		this._button.layoutData = buttonLayoutData;
		this._button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
		this.addChild( this._button );
	}

	private function button_triggeredHandler( event:Event ):void
	{

	}
}
```

Next, in the event listener, we'll show the `Label` in a `Callout`:

``` code
var callout:Callout = Callout.show( this._label, this._button );
callout.disposeContent = false;
```

By setting [`disposeContent`](../../api-reference/feathers/controls/Callout.html#disposeContent) to `false`, the same `Label` will be reused every time while a different `Callout` shows it. Each `Callout` will still dispose itself when it closes, of course. Only its content will be preserved.

We have one last thing to remember; we need to ensure that the `Label` is disposed eventually, so let's override `dispose()` on the `LayoutGroup`:

``` code
override public function dispose():void
{
	if( this._label )
	{
		this._label.dispose();
		this._label = null;
	}
	super.dispose();
}
```

## Close without disposing itself

This time around, let's keep showing the same `Callout` every time that the `Button` is triggered. We'll be using the the [`disposeOnSelfClose`](../../api-reference/feathers/controls/Callout.html#disposeOnSelfClose) property.

Again, we'll start with a simple class:

``` code
public class Example extends LayoutGroup
{
	public function Example()
	{
		super();
		this.autoSizeMode = AutoSizeMode.STAGE;
	}

	private var _callout:Callout;
	private var _button:Button;

	override protected function initialize():void
	{
		this.layout = new AnchorLayout();

		var buttonLayoutData:AnchorLayoutData = new AnchorLayoutData();
		buttonLayoutData.horizontalCenter = 0;
		buttonLayoutData.verticalCenter = 0;
		this._button = new Button();
		this._button.label = "Click Me";
		this._button.layoutData = buttonLayoutData;
		this._button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
		this.addChild( this._button );
	}

	private function button_triggeredHandler( event:Event ):void
	{

	}
}
```

Notice that we haven't created the `Label` or the `Callout` yet. Let's do that now in the event listener:

``` code
if( this._callout )
{
	PopUpManager.addPopUp( this._callout, true, false );
}
else
{
	var label:Label = new Label();
	label.text = "Hello World";
	this._callout = Callout.show( label, this._button );
	this._callout.disposeOnSelfClose = false;
}
```

The [`disposeOnSelfClose`](../../api-reference/feathers/controls/Callout.html#disposeOnSelfClose) property ensures that the `Callout` will not dispose itself when closed. Since the `Callout` isn't getting disposed, its content won't be disposed yet either. When we want to show it again, we simply need to add it back to the [`PopUpManager`](../pop-ups.html).

Similar to the previous example, we should make sure that the `Callout` gets disposed when our `LayoutGroup` is disposed.

``` code
override public function dispose():void
{
	if( this._callout )
	{
		this._callout.dispose();
		this._callout = null;
	}
	super.dispose();
}
```

As long as the `disposeContent` property is set to the default value of `true`, the `Label` will be disposed too, since it is a child of the `Callout`.

## Related Links

-   [How to use the Feathers `Callout` component](../callout.html)

-   [How to stop a `Callout` from closing automatically after touch or keyboard input](callout-stop-closing-automatically.html)
