/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.data.IListCollection;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.motion.Fade;
	import feathers.motion.effectClasses.IEffectContext;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;
	import feathers.text.FontStylesSet;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.text.TextFormat;
	import starling.utils.Pool;

	/**
	 * The primary background to display behind the toast's content.
	 *
	 * <p>In the following example, the toast's background is set to an image:</p>
	 *
	 * <listing version="3.0">
	 * toast.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	[Style(name="backgroundSkin",type="starling.display.DisplayObject")]

	/**
	 * A style name to add to the toast's actions button group sub-component.
	 * Typically used by a theme to provide different styles to different toasts.
	 *
	 * <p>In the following example, a custom actions button group style name is
	 * passed to the toast:</p>
	 *
	 * <listing version="3.0">
	 * toast.customActionsStyleName = "my-custom-toast-actions";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( ButtonGroup ).setFunctionForStyleName( "my-custom-toast-actions", setCustomToastActionsStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_ACTIONS
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #actionsFactory
	 */
	[Style(name="customActionsStyleName",type="String")]

	/**
	 * A style name to add to the toast's message text renderer
	 * sub-component. Typically used by a theme to provide different styles
	 * to different toasts.
	 *
	 * <p>In the following example, a custom message style name is passed to
	 * the toast:</p>
	 *
	 * <listing version="3.0">
	 * toast.customMessageStyleName = "my-custom-toast-message";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-toast-message", setCustomToastMessageStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_MESSAGE
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #messageFactory
	 */
	[Style(name="customLabelStyleName",type="String")]

	/**
	 * The font styles used to display the toast's message when the button is
	 * disabled.
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * toast.disabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>messageFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 */
	[Style(name="disabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The font styles used to display the toast's message.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * toast.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>messageFactory</code> to set more advanced styles.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #disabledFontStyles
	 */
	[Style(name="fontStyles",type="starling.text.TextFormat")]

	/**
	 * The space, in pixels, between the message text renderer and the actions
	 * button group. Applies to either horizontal or vertical spacing, depending
	 * on the value of <code>actionsPosition</code>.
	 *
	 * <p>If <code>gap</code> is set to <code>Number.POSITIVE_INFINITY</code>,
	 * the message and actions will be positioned as far apart as possible. In
	 * other words, they will be positioned at the edges of the toast,
	 * adjusted for padding.</p>
	 *
	 * <p>The following example creates a gap of 50 pixels between the label
	 * and the icon:</p>
	 *
	 * <listing version="3.0">
	 * toast.gap = 50;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:iconPosition
	 * @see #style:minGap
	 */
	[Style(name="gap",type="Number")]

	/**
	 * If the value of the <code>gap</code> property is
	 * <code>Number.POSITIVE_INFINITY</code>, meaning that the gap will
	 * fill as much space as possible, the final calculated value will not be
	 * smaller than the value of the <code>minGap</code> property.
	 *
	 * <p>The following example ensures that the gap is never smaller than
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * toast.gap = Number.POSITIVE_INFINITY;
	 * toast.minGap = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:gap
	 */
	[Style(name="minGap",type="Number")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding of all sides of the toast
	 * is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * toast.padding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:paddingTop
	 * @see #style:paddingRight
	 * @see #style:paddingBottom
	 * @see #style:paddingLeft
	 */
	[Style(name="padding",type="Number")]

	/**
	 * The minimum space, in pixels, between the toast's top edge and the
	 * toast's content.
	 *
	 * <p>In the following example, the padding on the top edge of the
	 * toast is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * toast.paddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the toast's right edge and
	 * the toast's content.
	 *
	 * <p>In the following example, the padding on the right edge of the
	 * toast is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * toast.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the toast's bottom edge and
	 * the toast's content.
	 *
	 * <p>In the following example, the padding on the bottom edge of the
	 * toast is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * toast.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the toast's left edge and the
	 * toast's content.
	 *
	 * <p>In the following example, the padding on the left edge of the
	 * toast is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * toast.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * Dispatched when the toast is opened. This event is dispatched after the
	 * <code>openEffect</code> has completed, if one is defined.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.OPEN
	 *
	 * @see #openEffect
	 * @see #event:close starling.events.Event.CLOSE
	 */
	[Event(name="open",type="starling.events.Event")]

	/**
	 * Dispatched when the toast is closed. This event is dispatched after the
	 * <code>closeEffect</code> has completed, if one is defined.
	 *
	 * <p>The <code>data</code> property of the event object will contain
	 * the item from the <code>ButtonGroup</code> data provider for the button
	 * that is triggered. If no button is triggered, then the <code>data</code>
	 * property will be <code>null</code>.</p>
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The triggered button, or
	 *   <code>null</code></td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CLOSE
	 *
	 * @see #close()
	 * @see #closeEffect
	 * @see #event:open starling.events.Event.OPEN
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Displays a notification-like message in a popup over the rest of your
	 * app's content. May contain a message and optional actions, or completely
	 * custom content.
	 *
	 * <p>In the following example, a toast displaying a message and actions is
	 * triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 * 
	 * function button_triggeredHandler( event:Event ):void
	 * {
	 *     Toast.showMessageWithActions( "Item deleted", new ArrayCollection([{ label: "Undo" }]) );
	 * }</listing>
	 *
	 * <p><a href="https://feathersui.com/help/beta-policy.html" target="_blank"><strong>Beta Component:</strong></a> This is a new component, and its APIs
	 * may need some changes between now and the next version of Feathers to
	 * account for overlooked requirements or other issues. Upgrading to future
	 * versions of Feathers may involve manual changes to your code that uses
	 * this component. The
	 * <a href="https://feathersui.com/help/deprecation-policy.html" target="_blank">Feathers deprecation policy</a>
	 * will not go into effect until this component's status is upgraded from
	 * beta to stable.</p>
	 *
	 * @see ../../../help/toast.html How to use the Feathers Toast component
	 * @see #showMessage()
	 * @see #showMessageWithActions()
	 * @see #showContent()
	 *
	 * @productversion Feathers 4.0.0
	 */
	public class Toast extends FeathersControl
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * message text renderer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MESSAGE:String = "feathers-toast-message";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * actions button group.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ACTIONS:String = "feathers-toast-actions";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_ACTIONS_FACTORY:String = "actionsFactory";

		/**
		 * The default <code>IStyleProvider</code> for all <code>Toast</code>
		 * components.
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		private static var _maxVisibleToasts:int = 1;

		/**
		 * The maximum number of toasts that can be displayed simultaneously.
		 * Additional toasts will be queued up to display after the current
		 * toasts are removed.
		 */
		public static function get maxVisibleToasts():int
		{
			return _maxVisibleToasts;
		}

		/**
		 * @private
		 */
		public static function set maxVisibleToasts(value:int):void
		{
			if(_maxVisibleToasts == value)
			{
				return;
			}
			if(value <= 0)
			{
				throw new RangeError("maxVisibleToasts must be greater than 0.");
			}
			_maxVisibleToasts = value;
			while(_activeToasts.length < _maxVisibleToasts && _queue.length > 0)
			{
				showNextInQueue();
			}
		}

		/**
		 * @private
		 */
		private static var _queueMode:String = ToastQueueMode.CANCEL_TIMEOUT;

		/**
		 * Determines how timeouts are treated when toasts need to be queued up
		 * because there are already <code>maxVisibleToasts</code> visible.
		 * Either waits until the timeout is complete, or immediately closes an
		 * existing toast and shows the queued toast after the closing effect is
		 * done.
		 */
		public static function get queueMode():String
		{
			return _queueMode;
		}

		/**
		 * @private
		 */
		public static function set queueMode(value:String):void
		{
			_queueMode = value;
		}

		/**
		 * @private
		 */
		private static var _toastFactory:Function = defaultToastFactory;

		/**
		 * Used to create a new <code>Toast</code> instance in the
		 * <code>showMessage()</code>, <code>showMessageWithActions()</code>, or
		 * <code>showContent()</code> functions. Useful for customizing the
		 * styles of toasts without a theme.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Toast</pre>
		 *
		 * <p>The following example shows how to create a custom toast factory:</p>
		 *
		 * <listing version="3.0">
		 * Toast.toastFactory = function():Toast
		 * {
		 *     var toast:Toast = new Toast();
		 *     toast.backgroundSkin = new Image( texture );
		 *     toast.padding = 10;
		 *     return toast;
		 * };</listing>
		 *
		 * @see #showMessage()
		 * @see #showMessageWithStyles()
		 * @see #showContent()
		 */
		public static function get toastFactory():Function
		{
			return Toast._toastFactory;
		}

		/**
		 * @private
		 */
		public static function set toastFactory(value:Function):void
		{
			Toast._toastFactory = value;
		}

		/**
		 * @private
		 */
		private static var _containerFactory:Function = defaultContainerFactory;

		/**
		 * Create a container for toasts that is added to the pop-up manager.
		 * Useful for customizing the layout of toasts.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():DisplayObjectContainer</pre>
		 *
		 * <p>The following example shows how to create a custom toast container:</p>
		 *
		 * <listing version="3.0">
		 * Toast.containerFactory = function():DisplayObjectContainer
		 * {
		 *     var container:LayoutGroup = new LayoutGroup();
		 *     container.layout = new VerticalLayout();
		 *     return container;
		 * };</listing>
		 *
		 * @see #showMessage()
		 * @see #showMessageWithStyles()
		 * @see #showContent()
		 */
		public static function get containerFactory():Function
		{
			return Toast._containerFactory;
		}

		/**
		 * @private
		 */
		public static function set containerFactory(value:Function):void
		{
			Toast._containerFactory = value;
		}

		/**
		 * @private
		 */
		protected static var _activeToasts:Vector.<Toast> = new <Toast>[];

		/**
		 * @private
		 */
		protected static var _queue:Vector.<Toast> = new <Toast>[];

		/**
		 * @private
		 */
		protected static var _containers:Dictionary = new Dictionary(true);

		/**
		 * Shows a toast with custom content.
		 *
		 * @see #showMessage()
		 * @see #showMessageWithActions()
		 */
		public static function showContent(content:DisplayObject, timeout:Number = 4, toastFactory:Function = null):Toast
		{
			var factory:Function = toastFactory !== null ? toastFactory : Toast._toastFactory;
			if(factory === null)
			{
				factory = defaultToastFactory;
			}
			var toast:Toast = Toast(factory());
			toast.content = content;
			return showToast(toast, timeout);
		}

		/**
		 * Shows a toast with a simple text message.
		 *
		 * @see #showMessageWithActions()
		 * @see #showContent()
		 */
		public static function showMessage(message:String, timeout:Number = 4, toastFactory:Function = null):Toast
		{
			var factory:Function = toastFactory !== null ? toastFactory : Toast._toastFactory;
			if(factory === null)
			{
				factory = defaultToastFactory;
			}
			var toast:Toast = Toast(factory());
			toast.message = message;
			return showToast(toast, timeout);
		}

		/**
		 * Shows a toast with a text message and some action buttons.
		 *
		 * @see #showMessage()
		 * @see #showContent()
		 */
		public static function showMessageWithActions(message:String, actions:IListCollection, timeout:Number = 4, toastFactory:Function = null):Toast
		{
			var factory:Function = toastFactory !== null ? toastFactory : Toast._toastFactory;
			if(factory === null)
			{
				factory = defaultToastFactory;
			}
			var toast:Toast = Toast(factory());
			toast.message = message;
			toast.actions = actions;
			return showToast(toast, timeout);
		}

		/**
		 * Shows a toast instance.
		 *
		 * @see #showMessage()
		 * @see #showMessageWithActions()
		 * @see #showContent()
		 */
		public static function showToast(toast:Toast, timeout:Number):Toast
		{
			toast.timeout = timeout;
			if(_activeToasts.length >= _maxVisibleToasts)
			{
				_queue[_queue.length] = toast;
				if(_queueMode == ToastQueueMode.CANCEL_TIMEOUT)
				{
					var toastCount:int = _activeToasts.length;
					for(var i:int = 0; i < toastCount; i++)
					{
						var activeToast:Toast = _activeToasts[i];
						if(activeToast.timeout < Number.POSITIVE_INFINITY &&
							!activeToast.isClosing)
						{
							activeToast.close(activeToast.disposeOnSelfClose);
							break;
						}
					}
				}
				return toast;
			}
			_activeToasts[_activeToasts.length] = toast;
			toast.addEventListener(Event.CLOSE, toast_closeHandler);
			var container:DisplayObjectContainer = getContainerForStarling(Starling.current);
			container.addChild(toast);
			if(container is IValidating)
			{
				//validate the parent container before opening the toast because
				//we want to be sure that the toast is positioned properly in
				//the layout for things that may rely on the position, like
				//openEffect
				IValidating(container).validate();
			}
			toast.open();
			return toast;
		}

		/**
		 * @private
		 */
		protected static function showNextInQueue():void
		{
			if(_queue.length == 0)
			{
				return;
			}
			do
			{
				var toast:Toast = _queue.shift();
			}
			//keep skipping toasts that have a timeout
			while(_queueMode == ToastQueueMode.CANCEL_TIMEOUT &&
				_queue.length > 0 &&
				toast.timeout < Number.POSITIVE_INFINITY);
			showToast(toast, toast.timeout);
		}

		/**
		 * @private
		 */
		protected static function toast_closeHandler(event:Event):void
		{
			var toast:Toast = Toast(event.currentTarget);
			toast.removeEventListener(Event.CLOSE, toast_closeHandler);
			var index:int = _activeToasts.indexOf(toast);
			_activeToasts.removeAt(index);
			showNextInQueue();
		}

		/**
		 * @private
		 */
		protected static function getContainerForStarling(starling:Starling):DisplayObjectContainer
		{
			if(starling in Toast._containers)
			{
				return DisplayObjectContainer(Toast._containers[starling]);
			}
			var factory:Function = Toast._containerFactory !== null ? Toast._containerFactory : defaultContainerFactory;
			var container:DisplayObjectContainer = DisplayObjectContainer(factory());
			Toast._containers[starling] = container;
			container.addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):void
			{
				delete Toast._containers[starling];
			});
			PopUpManager.forStarling(starling).addPopUp(container, false, false);
			return container;
		}

		/**
		 * @private
		 */
		protected static function defaultToastFactory():Toast
		{
			return new Toast();
		}

		/**
		 * @private
		 */
		protected static function defaultContainerFactory():DisplayObjectContainer
		{
			var container:LayoutGroup = new LayoutGroup();
			container.autoSizeMode = AutoSizeMode.STAGE;
			var layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalAlign.BOTTOM;
			if(DeviceCapabilities.isPhone())
			{
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			}
			else
			{
				layout.horizontalAlign = HorizontalAlign.LEFT;
			}
			container.layout = layout;
			return container;
		}

		/**
		 * The default factory that creates the action button group. To use a
		 * different factory, you need to set <code>actionsFactory</code>
		 * to a <code>Function</code> instance.
		 */
		public static function defaultActionsFactory():ButtonGroup
		{
			return new ButtonGroup();
		}

		/**
		 * Constructor.
		 */
		public function Toast()
		{
			super();
			if(this._fontStylesSet === null)
			{
				this._fontStylesSet = new FontStylesSet();
				this._fontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
		}

		/**
		 * The value added to the <code>styleNameList</code> of the toast's
		 * message text renderer. This variable is <code>protected</code> so
		 * that sub-classes can customize the message style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_MESSAGE</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var messageStyleName:String = DEFAULT_CHILD_STYLE_NAME_MESSAGE;

		/**
		 * The value added to the <code>styleNameList</code> of the toast's
		 * actions button group. This variable is <code>protected</code> so
		 * that sub-classes can customize the actions style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_ACTIONS</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var actionsStyleName:String = DEFAULT_CHILD_STYLE_NAME_ACTIONS;

		/**
		 * The message text renderer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var messageTextRenderer:ITextRenderer = null;

		/**
		 * The actions button group sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var actionsGroup:ButtonGroup = null;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Toast.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _explicitMessageWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitMessageHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitMessageMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitMessageMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitMessageMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitMessageMaxHeight:Number;

		/**
		 * @private
		 */
		protected var _message:String = null;

		/**
		 * The toast's main text content.
		 */
		public function get message():String
		{
			return this._message;
		}

		/**
		 * @private
		 */
		public function set message(value:String):void
		{
			if(this._message == value)
			{
				return;
			}
			this._message = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _actions:IListCollection = null;

		/**
		 * The data provider of the toast's <code>ButtonGroup</code>.
		 */
		public function get actions():IListCollection
		{
			return this._actions;
		}

		/**
		 * @private
		 */
		public function set actions(value:IListCollection):void
		{
			if(this._actions == value)
			{
				return;
			}
			this._actions = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _explicitContentWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitContentHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMaxHeight:Number;

		/**
		 * @private
		 */
		protected var _content:DisplayObject = null;

		/**
		 * Optional custom content to display in the toast.
		 */
		public function get content():DisplayObject
		{
			return this._content;
		}

		/**
		 * @private
		 */
		public function set content(value:DisplayObject):void
		{
			if(this._content == value)
			{
				return;
			}
			if(this._content && this._content.parent == this)
			{
				this._content.removeFromParent(false);
			}
			this._content = value;
			if(this._content)
			{
				if(this._content is IFeathersControl)
				{
					IFeathersControl(this._content).initializeNow();
				}
				if(this._content is IMeasureDisplayObject)
				{
					var measureContent:IMeasureDisplayObject = IMeasureDisplayObject(this._content);
					this._explicitContentWidth = measureContent.explicitWidth;
					this._explicitContentHeight = measureContent.explicitHeight;
					this._explicitContentMinWidth = measureContent.explicitMinWidth;
					this._explicitContentMinHeight = measureContent.explicitMinHeight;
					this._explicitContentMaxWidth = measureContent.explicitMaxWidth;
					this._explicitContentMaxHeight = measureContent.explicitMaxHeight;
				}
				else
				{
					this._explicitContentWidth = this._content.width;
					this._explicitContentHeight = this._content.height;
					this._explicitContentMinWidth = this._explicitContentWidth;
					this._explicitContentMinHeight = this._explicitContentHeight;
					this._explicitContentMaxWidth = this._explicitContentWidth;
					this._explicitContentMaxHeight = this._explicitContentHeight;
				}
				this.addChild(this._content);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
			this.invalidate(INVALIDATION_FLAG_ACTIONS_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _startTime:int = -1;

		/**
		 * @private
		 */
		protected var _timeout:Number = Number.POSITIVE_INFINITY;

		/**
		 * The time, in seconds, when the toast will automatically close. Set
		 * to <code>Number.POSITIVE_INFINITY</code> to require the toast to be
		 * closed manually.
		 *
		 * @default Number.POSITIVE_INFINITY
		 */
		public function get timeout():Number
		{
			return this._timeout;
		}

		/**
		 * @private
		 */
		public function set timeout(value:Number):void
		{
			if(this._timeout == value)
			{
				return;
			}
			this._timeout = value;
			if(this._isOpen)
			{
				this.startTimeout();
			}
		}

		/**
		 * @private
		 */
		protected var _openEffectContext:IEffectContext = null;

		/**
		 * @private
		 */
		protected var _openEffect:Function = Fade.createFadeInEffect();

		/**
		 * An optional effect that is activated when the toast is opened.
		 *
		 * <p>In the following example, a open effect fades the toast's
		 * <code>alpha</code> property from <code>0</code> to <code>1</code>:</p>
		 *
		 * <listing version="3.0">
		 * toast.openEffect = Fade.createFadeBetweenEffect(0, 1);</listing>
		 *
		 * <p>A number of animated effects may be found in the
		 * <a href="../motion/package-detail.html">feathers.motion</a> package.
		 * However, you are not limited to only these effects. It's possible
		 * to create custom effects too.</p>
		 *
		 * <p>A custom effect function should have the following signature:</p>
		 * <pre>function(target:DisplayObject):IEffectContext</pre>
		 *
		 * <p>The <code>IEffectContext</code> is used by the component to
		 * control the effect, performing actions like playing the effect,
		 * pausing it, or cancelling it.</p>
		 *
		 * <p>Custom animated effects that use
		 * <code>starling.display.Tween</code> typically return a
		 * <code>TweenEffectContext</code>. In the following example, we
		 * recreate the <code>Fade.createFadeBetweenEffect()</code> used in the
		 * previous example.</p>
		 *
		 * <listing version="3.0">
		 * toast.closeEffect = function(target:DisplayObject):IEffectContext
		 * {
		 *     toast.alpha = 0;
		 *     var tween:Tween = new Tween(target, 0.5, Transitions.EASE_OUT);
		 *     tween.fadeTo(1);
		 *     return new TweenEffectContext(target, tween);
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#closeEffect
		 * @see #showToast()
		 * @see ../../../help/effects.html Effects and animation for Feathers components
		 * @see feathers.motion.effectClasses.IEffectContext
		 * @see feathers.motion.effectClasses.TweenEffectContext
		 */
		public function get openEffect():Function
		{
			return this._openEffect;
		}

		/**
		 * @private
		 */
		public function set openEffect(value:Function):void
		{
			if(this._openEffect == value)
			{
				return;
			}
			this._openEffect = value;
		}

		/**
		 * @private
		 */
		protected var _closeEffectContext:IEffectContext = null;

		/**
		 * @private
		 */
		protected var _closeEffect:Function = Fade.createFadeOutEffect();

		/**
		 * An optional effect that is activated when the toast is closed.
		 *
		 * <p>In the following example, a close effect fades the toast's
		 * <code>alpha</code> property from <code>1</code> to <code>0</code>:</p>
		 *
		 * <listing version="3.0">
		 * toast.closeEffect = Fade.createFadeBetweenEffect(1, 0);</listing>
		 *
		 * <p>A number of animated effects may be found in the
		 * <a href="../motion/package-detail.html">feathers.motion</a> package.
		 * However, you are not limited to only these effects. It's possible
		 * to create custom effects too.</p>
		 *
		 * <p>A custom effect function should have the following signature:</p>
		 * <pre>function(target:DisplayObject):IEffectContext</pre>
		 *
		 * <p>The <code>IEffectContext</code> is used by the component to
		 * control the effect, performing actions like playing the effect,
		 * pausing it, or cancelling it.</p>
		 *
		 * <p>Custom animated effects that use
		 * <code>starling.display.Tween</code> typically return a
		 * <code>TweenEffectContext</code>. In the following example, we
		 * recreate the <code>Fade.createFadeBetweenEffect()</code> used in the
		 * previous example.</p>
		 *
		 * <listing version="3.0">
		 * toast.closeEffect = function(target:DisplayObject):IEffectContext
		 * {
		 *     toast.alpha = 1;
		 *     var tween:Tween = new Tween(target, 0.5, Transitions.EASE_OUT);
		 *     tween.fadeTo(0);
		 *     return new TweenEffectContext(target, tween);
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#openEffect
		 * @see ../../../help/effects.html Effects and animation for Feathers components
		 * @see feathers.motion.effectClasses.IEffectContext
		 * @see feathers.motion.effectClasses.TweenEffectContext
		 */
		public function get closeEffect():Function
		{
			return this._closeEffect;
		}

		/**
		 * @private
		 */
		public function set closeEffect(value:Function):void
		{
			if(this._closeEffect == value)
			{
				return;
			}
			this._closeEffect = value;
		}

		/**
		 * @private
		 */
		protected var _fontStylesSet:FontStylesSet = null;

		/**
		 * @private
		 */
		public function get fontStyles():TextFormat
		{
			return this._fontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._fontStylesSet.format;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.format = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		public function get disabledFontStyles():TextFormat
		{
			return this._fontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set disabledFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._fontStylesSet.disabledFormat;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.disabledFormat = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _messageFactory:Function = null;

		/**
		 * A function used to instantiate the toast's message text renderer
		 * sub-component. By default, the toast will use the global text
		 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
		 * to create the message text renderer. The message text renderer must
		 * be an instance of <code>ITextRenderer</code>. This factory can be
		 * used to change properties on the message text renderer when it is
		 * first created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the message text
		 * renderer.
		 *
		 * <p>If you are not using a theme, the message factory can be used to
		 * provide skin the message text renderer with appropriate text styles.</p>
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, a custom message factory is passed to
		 * the toast:</p>
		 *
		 * <listing version="3.0">
		 * toast.messageFactory = function():ITextRenderer
		 * {
		 *     var messageRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *     messageRenderer.textFormat = new TextFormat( "_sans", 12, 0xff0000 );
		 *     return messageRenderer;
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see #message
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get messageFactory():Function
		{
			return this._messageFactory;
		}

		/**
		 * @private
		 */
		public function set messageFactory(value:Function):void
		{
			if(this._messageFactory == value)
			{
				return;
			}
			this._messageFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customMessageStyleName:String;

		/**
		 * @private
		 */
		public function get customMessageStyleName():String
		{
			return this._customMessageStyleName;
		}

		/**
		 * @private
		 */
		public function set customMessageStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customMessageStyleName === value)
			{
				return;
			}
			this._customMessageStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _actionsFactory:Function = null;

		/**
		 * A function used to generate the toast's button group sub-component.
		 * The button group must be an instance of <code>ButtonGroup</code>.
		 * This factory can be used to change properties on the button group
		 * when it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the button group.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():ButtonGroup</pre>
		 *
		 * <p>In the following example, a custom button group factory is
		 * provided to the toast:</p>
		 *
		 * <listing version="3.0">
		 * toast.actionsFactory = function():ButtonGroup
		 * {
		 *     return new ButtonGroup();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ButtonGroup
		 */
		public function get actionsFactory():Function
		{
			return this._actionsFactory;
		}

		/**
		 * @private
		 */
		public function set actionsFactory(value:Function):void
		{
			if(this._actionsFactory == value)
			{
				return;
			}
			this._actionsFactory = value;
			this.invalidate(INVALIDATION_FLAG_ACTIONS_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customActionsStyleName:String = null;

		/**
		 * @private
		 */
		public function get customActionsStyleName():String
		{
			return this._customActionsStyleName;
		}

		/**
		 * @private
		 */
		public function set customActionsStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customActionsStyleName === value)
			{
				return;
			}
			this._customActionsStyleName = value;
			this.invalidate(INVALIDATION_FLAG_ACTIONS_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _disposeFromCloseCall:Boolean = false;

		/**
		 * @private
		 */
		protected var _disposeOnSelfClose:Boolean = true;

		/**
		 * Determines if the toast will be disposed when <code>close()</code>
		 * is called internally. Close may be called internally in a variety of
		 * cases, depending on values such as <code>timeout</code> and
		 * <code>actions</code>. If set to <code>false</code>, you may reuse the
		 * toast later by passing it to <code>Toast.showToast()</code>.
		 *
		 * <p>In the following example, the toast will not be disposed when it
		 * closes itself:</p>
		 *
		 * <listing version="3.0">
		 * toast.disposeOnSelfClose = false;</listing>
		 *
		 * @default true
		 *
		 * @see #close()
		 * @see #disposeContent
		 */
		public function get disposeOnSelfClose():Boolean
		{
			return this._disposeOnSelfClose;
		}

		/**
		 * @private
		 */
		public function set disposeOnSelfClose(value:Boolean):void
		{
			this._disposeOnSelfClose = value;
		}

		/**
		 * @private
		 */
		public var _disposeContent:Boolean = true;

		/**
		 * Determines if the toast's content will be disposed when the toast
		 * is disposed. If set to <code>false</code>, the toast's content may
		 * be added to the display list again later.
		 *
		 * <p>In the following example, the toast's content will not be
		 * disposed when the toast is disposed:</p>
		 *
		 * <listing version="3.0">
		 * toast.disposeContent = false;</listing>
		 *
		 * @default true
		 *
		 * @see #disposeOnSelfClose
		 */
		public function get disposeContent():Boolean
		{
			return this._disposeContent;
		}

		/**
		 * @private
		 */
		public function set disposeContent(value:Boolean):void
		{
			this._disposeContent = value;
		}

		/**
		 * @private
		 */
		protected var _closeData:Object = null;

		/**
		 * @private
		 */
		protected var _isClosing:Boolean = false;

		/**
		 * Indicates if the toast is currently closing.
		 *
		 * @see #isOpening
		 * @see #isOpen
		 */
		public function get isClosing():Boolean
		{
			return this._isClosing;
		}

		/**
		 * @private
		 */
		protected var _isOpening:Boolean = false;

		/**
		 * Indicates if the toast is currently opening.
		 *
		 * @see #isClosing
		 */
		public function get isOpening():Boolean
		{
			return this._isOpening;
		}

		/**
		 * @private
		 */
		protected var _isOpen:Boolean = false;

		/**
		 * Indicates if the toast is currently open. Does not change from
		 * <code>false</code> to <code>true</code> until the open effect has
		 * completed. Similarly, does not change from <code>true</code> to
		 * <code>false</code> until the close effect has completed.
		 *
		 * @see #isOpening
		 * @see #isClosing
		 * @see #event:open starling.events.Event.OPEN
		 * @see #event:close starling.events.Event.CLOSE
		 */
		public function get isOpen():Boolean
		{
			return this._isOpen;
		}

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMaxHeight:Number;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundSkin === value)
			{
				return;
			}
			if(this._backgroundSkin !== null && this._backgroundSkin.parent === this)
			{
				//we need to restore these values so that they won't be lost the
				//next time that this skin is used for measurement
				this._backgroundSkin.width = this._explicitBackgroundSkinWidth;
				this._backgroundSkin.height = this._explicitBackgroundSkinHeight;
				if(this._backgroundSkin is IMeasureDisplayObject)
				{
					var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this._backgroundSkin);
					measureSkin.minWidth = this._explicitBackgroundSkinMinWidth;
					measureSkin.minHeight = this._explicitBackgroundSkinMinHeight;
					measureSkin.maxWidth = this._explicitBackgroundSkinMaxWidth;
					measureSkin.maxHeight = this._explicitBackgroundSkinMaxHeight;
				}
				this._backgroundSkin.removeFromParent(false);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin !== null)
			{
				if(this._backgroundSkin is IFeathersControl)
				{
					IFeathersControl(this._backgroundSkin).initializeNow();
				}
				if(this._backgroundSkin is IMeasureDisplayObject)
				{
					measureSkin = IMeasureDisplayObject(this._backgroundSkin);
					this._explicitBackgroundSkinWidth = measureSkin.explicitWidth;
					this._explicitBackgroundSkinHeight = measureSkin.explicitHeight;
					this._explicitBackgroundSkinMinWidth = measureSkin.explicitMinWidth;
					this._explicitBackgroundSkinMinHeight = measureSkin.explicitMinHeight;
					this._explicitBackgroundSkinMaxWidth = measureSkin.explicitMaxWidth;
					this._explicitBackgroundSkinMaxHeight = measureSkin.explicitMaxHeight;
				}
				else
				{
					this._explicitBackgroundSkinWidth = this._backgroundSkin.width;
					this._explicitBackgroundSkinHeight = this._backgroundSkin.height;
					this._explicitBackgroundSkinMinWidth = this._explicitBackgroundSkinWidth;
					this._explicitBackgroundSkinMinHeight = this._explicitBackgroundSkinHeight;
					this._explicitBackgroundSkinMaxWidth = this._explicitBackgroundSkinWidth;
					this._explicitBackgroundSkinMaxHeight = this._explicitBackgroundSkinHeight;
				}
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * @private
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * @private
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * @private
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * @private
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * @private
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._horizontalAlign === value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * @private
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalAlign === value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * @private
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _minGap:Number = 0;

		/**
		 * @private
		 */
		public function get minGap():Number
		{
			return this._minGap;
		}

		/**
		 * @private
		 */
		public function set minGap(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._minGap == value)
			{
				return;
			}
			this._minGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _actionsPosition:String = RelativePosition.RIGHT;

		[Inspectable(type="String",enumeration="top,right,bottom,left")]
		/**
		 * @private
		 */
		public function get actionsPosition():String
		{
			return this._actionsPosition;
		}

		/**
		 * @private
		 */
		public function set actionsPosition(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._actionsPosition === value)
			{
				return;
			}
			this._actionsPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._fontStylesSet !== null)
			{
				this._fontStylesSet.dispose();
				this._fontStylesSet = null;
			}
			var savedContent:DisplayObject = this._content;
			this.content = null;
			//remove the content safely if it should not be disposed
			if(savedContent !== null && this._disposeContent)
			{
				savedContent.dispose();
			}
			super.dispose();
		}

		/**
		 * @private
		 *
		 * @see #showToast()
		 */
		protected function open():void
		{
			if(this._isOpen || this._isOpening)
			{
				return;
			}
			if(this._suspendEffectsCount == 0 && this._closeEffectContext !== null)
			{
				this._closeEffectContext.interrupt();
				this._closeEffectContext = null;
			}
			if(this._openEffect !== null)
			{
				this._isOpening = true;
				this._openEffectContext = IEffectContext(this._openEffect(this));
				this._openEffectContext.addEventListener(Event.COMPLETE, openEffectContext_completeHandler);
				this._openEffectContext.play();
			}
			else
			{
				this.completeOpen();
			}
		}

		/**
		 * Closes the toast and optionally disposes it. If a
		 * <code>closeEffect</code> has been specified, it will be played.
		 *
		 * @see #closeEffect
		 */
		public function close(dispose:Boolean = true):void
		{
			this.closeToast(null, dispose);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
			var actionsInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ACTIONS_FACTORY);

			if(textRendererInvalid)
			{
				this.createMessage();
			}

			if(actionsInvalid)
			{
				this.createActions();
			}

			if(textRendererInvalid || dataInvalid)
			{
				if(this.messageTextRenderer)
				{
					this.messageTextRenderer.text = this._message;
				}
			}

			if(textRendererInvalid || stylesInvalid)
			{
				this.refreshMessageStyles();
			}

			if(actionsInvalid || dataInvalid)
			{
				if(this.actionsGroup)
				{
					this.actionsGroup.dataProvider = this._actions;
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutChildren();
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			var adjustedGap:Number = this._gap;
			if(adjustedGap == Number.POSITIVE_INFINITY)
			{
				adjustedGap = this._minGap;
			}

			resetFluidChildDimensionsForMeasurement(this._backgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundSkinWidth, this._explicitBackgroundSkinHeight,
				this._explicitBackgroundSkinMinWidth, this._explicitBackgroundSkinMinHeight,
				this._explicitBackgroundSkinMaxWidth, this._explicitBackgroundSkinMaxHeight);
			var measureSkin:IMeasureDisplayObject = this._backgroundSkin as IMeasureDisplayObject;

			resetFluidChildDimensionsForMeasurement(this._content,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitContentWidth, this._explicitContentHeight,
				this._explicitContentMinWidth, this._explicitContentMinHeight,
				this._explicitContentMaxWidth, this._explicitContentMaxHeight);
			var measureContent:IMeasureDisplayObject = this._content as IMeasureDisplayObject;

			if(this._content is IValidating)
			{
				IValidating(this._content).validate();
			}
			var messageSize:Point = Pool.getPoint();
			if(this.messageTextRenderer !== null)
			{
				this.refreshMessageTextRendererDimensions(true);
				this.messageTextRenderer.measureText(messageSize);
			}
			if(this.actionsGroup)
			{
				this.actionsGroup.validate();
			}
			if(this._backgroundSkin is IValidating)
			{
				IValidating(this._backgroundSkin).validate();
			}

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(this._content !== null)
				{
					if(measureContent !== null)
					{
						newMinWidth = measureContent.minWidth;
					}
					else
					{
						newMinWidth = this._content.width;
					}
				}
				else if(this.messageTextRenderer !== null)
				{
					newMinWidth = messageSize.x;
				}
				else
				{
					newMinWidth = 0;
				}
				if(this.actionsGroup !== null)
				{
					if(this.messageTextRenderer !== null) //both message and actions
					{
						if(this._actionsPosition !== RelativePosition.TOP &&
							this._actionsPosition !== RelativePosition.BOTTOM)
						{
							newMinWidth += adjustedGap;
							newMinWidth += this.actionsGroup.minWidth;
						}
						else //top or bottom
						{
							var iconMinWidth:Number = this.actionsGroup.minWidth;
							if(iconMinWidth > newMinWidth)
							{
								newMinWidth = iconMinWidth;
							}
						}
					}
					else //no message
					{
						newMinWidth = this.actionsGroup.minWidth;
					}
				}
				newMinWidth += this._paddingLeft + this._paddingRight;
				if(this._backgroundSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minWidth > newMinWidth)
						{
							newMinWidth = measureSkin.minWidth;
						}
					}
					else if(this._explicitBackgroundSkinMinWidth > newMinWidth)
					{
						newMinWidth = this._explicitBackgroundSkinMinWidth;
					}
				}
			}

			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(this._content !== null)
				{
					if(measureContent !== null)
					{
						newMinHeight = measureContent.minHeight;
					}
					else
					{
						newMinHeight = this._content.height;
					}
				}
				else if(this.messageTextRenderer !== null)
				{
					newMinHeight = messageSize.y;
				}
				else
				{
					newMinHeight = 0;
				}
				if(this.actionsGroup !== null)
				{
					if(this.messageTextRenderer !== null) //both message and actions
					{
						if(this._actionsPosition === RelativePosition.TOP ||
							this._actionsPosition === RelativePosition.BOTTOM)
						{
							newMinHeight += adjustedGap;
							newMinHeight += this.actionsGroup.minHeight;
						}
						else //left or right
						{
							var iconMinHeight:Number = this.actionsGroup.minHeight;
							if(iconMinHeight > newMinHeight)
							{
								newMinHeight = iconMinHeight;
							}
						}
					}
					else //no message
					{
						newMinHeight = this.actionsGroup.minHeight;
					}
				}
				newMinHeight += this._paddingTop + this._paddingBottom;
				if(this._backgroundSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minHeight > newMinHeight)
						{
							newMinHeight = measureSkin.minHeight;
						}
					}
					else if(this._explicitBackgroundSkinMinHeight > newMinHeight)
					{
						newMinHeight = this._explicitBackgroundSkinMinHeight;
					}
				}
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(this._content !== null)
				{
					newWidth = this._content.width;
				}
				else if(this.messageTextRenderer !== null)
				{
					newWidth = messageSize.x;
				}
				else
				{
					newWidth = 0;
				}
				if(this.actionsGroup !== null)
				{
					if(this.messageTextRenderer !== null) //both message and actions
					{
						if(this._actionsPosition !== RelativePosition.TOP &&
							this._actionsPosition !== RelativePosition.BOTTOM)
						{
							newWidth += adjustedGap + this.actionsGroup.width;
						}
						else if(this.actionsGroup.width > newWidth) //top or bottom
						{
							newWidth = this.actionsGroup.width;
						}
					}
					else //no message
					{
						newWidth = this.actionsGroup.width;
					}
				}
				newWidth += this._paddingLeft + this._paddingRight;
				if(this._backgroundSkin !== null &&
					this._backgroundSkin.width > newWidth)
				{
					newWidth = this._backgroundSkin.width;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(this._content !== null)
				{
					newHeight = this._content.height;
				}
				else if(this.messageTextRenderer !== null)
				{
					newHeight = messageSize.y;
				}
				else
				{
					newHeight = 0;
				}
				if(this.actionsGroup !== null)
				{
					if(this.messageTextRenderer !== null) //both message and actions
					{
						if(this._actionsPosition === RelativePosition.TOP ||
							this._actionsPosition === RelativePosition.BOTTOM)
						{
							newHeight += adjustedGap + this.actionsGroup.height;
						}
						else if(this.actionsGroup.height > newHeight) //left or right
						{
							newHeight = this.actionsGroup.height;
						}
					}
					else //no message
					{
						newHeight = this.actionsGroup.height;
					}
				}
				newHeight += this._paddingTop + this._paddingBottom;
				if(this._backgroundSkin !== null &&
					this._backgroundSkin.height > newHeight)
				{
					newHeight = this._backgroundSkin.height;
				}
			}

			Pool.putPoint(messageSize);

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		protected function refreshMessageTextRendererDimensions(forMeasurement:Boolean):void
		{
			if(this.actionsGroup !== null)
			{
				this.actionsGroup.validate();
			}
			if(!this.messageTextRenderer)
			{
				return;
			}
			var calculatedWidth:Number = this.actualWidth;
			var calculatedHeight:Number = this.actualHeight;
			if(forMeasurement)
			{
				calculatedWidth = this._explicitWidth;
				if(calculatedWidth !== calculatedWidth) //isNaN
				{
					calculatedWidth = this._explicitMaxWidth;
				}
				calculatedHeight = this._explicitHeight;
				if(calculatedHeight !== calculatedHeight) //isNaN
				{
					calculatedHeight = this._explicitMaxHeight;
				}
			}
			calculatedWidth -= (this._paddingLeft + this._paddingRight);
			calculatedHeight -= (this._paddingTop + this._paddingBottom);
			if(this.actionsGroup !== null)
			{
				var adjustedGap:Number = this._gap;
				if(adjustedGap == Number.POSITIVE_INFINITY)
				{
					adjustedGap = this._minGap;
				}
				if(this._actionsPosition === RelativePosition.LEFT ||
					this._actionsPosition === RelativePosition.RIGHT)
				{
					calculatedWidth -= (this.actionsGroup.width + adjustedGap);
				}
				if(this._actionsPosition === RelativePosition.TOP || this._actionsPosition === RelativePosition.BOTTOM)
				{
					calculatedHeight -= (this.actionsGroup.height + adjustedGap);
				}
			}
			if(calculatedWidth < 0)
			{
				calculatedWidth = 0;
			}
			if(calculatedHeight < 0)
			{
				calculatedHeight = 0;
			}
			if(calculatedWidth > this._explicitMessageMaxWidth)
			{
				calculatedWidth = this._explicitMessageMaxWidth;
			}
			if(calculatedHeight > this._explicitMessageMaxHeight)
			{
				calculatedHeight = this._explicitMessageMaxHeight;
			}
			this.messageTextRenderer.width = this._explicitMessageWidth;
			this.messageTextRenderer.height = this._explicitMessageHeight;
			this.messageTextRenderer.minWidth = this._explicitMessageMinWidth;
			this.messageTextRenderer.minHeight = this._explicitMessageMinHeight;
			this.messageTextRenderer.maxWidth = calculatedWidth;
			this.messageTextRenderer.maxHeight = calculatedHeight;
			this.messageTextRenderer.validate();
			if(!forMeasurement)
			{
				calculatedWidth = this.messageTextRenderer.width;
				calculatedHeight = this.messageTextRenderer.height;
				//setting all of these dimensions explicitly means that the text
				//renderer won't measure itself again when it validates, which
				//helps performance. we'll reset them when the toast needs to
				//measure itself.
				this.messageTextRenderer.width = calculatedWidth;
				this.messageTextRenderer.height = calculatedHeight;
				this.messageTextRenderer.minWidth = calculatedWidth;
				this.messageTextRenderer.minHeight = calculatedHeight;
			}
		}

		/**
		 * Creates and adds the <code>messageTextRenderer</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #message
		 * @see #messageTextRenderer
		 * @see #messageFactory
		 */
		protected function createMessage():void
		{
			if(this.messageTextRenderer)
			{
				this.removeChild(DisplayObject(this.messageTextRenderer), true);
				this.messageTextRenderer = null;
			}

			if(this._message === null)
			{
				return;
			}

			var factory:Function = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
			this.messageTextRenderer = ITextRenderer(factory());
			this.messageTextRenderer.wordWrap = true;
			var messageStyleName:String = this._customMessageStyleName != null ? this._customMessageStyleName : this.messageStyleName;
			var uiTextRenderer:IFeathersControl = IFeathersControl(this.messageTextRenderer);
			uiTextRenderer.styleNameList.add(messageStyleName);
			uiTextRenderer.touchable = false;
			this.addChild(DisplayObject(this.messageTextRenderer));
			this._explicitMessageWidth = this.messageTextRenderer.explicitWidth;
			this._explicitMessageHeight = this.messageTextRenderer.explicitHeight;
			this._explicitMessageMinWidth = this.messageTextRenderer.explicitMinWidth;
			this._explicitMessageMinHeight = this.messageTextRenderer.explicitMinHeight;
			this._explicitMessageMaxWidth = this.messageTextRenderer.explicitMaxWidth;
			this._explicitMessageMaxHeight = this.messageTextRenderer.explicitMaxHeight;
		}

		/**
		 * @private
		 */
		protected function refreshMessageStyles():void
		{
			if(!this.messageTextRenderer)
			{
				return;
			}
			this.messageTextRenderer.fontStyles = this._fontStylesSet;
		}

		/**
		 * Creates and adds the <code>actionsGroup</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #actionsGroup
		 * @see #actionsFactory
		 * @see #style:customActionsStyleName
		 */
		protected function createActions():void
		{
			if(this.actionsGroup)
			{
				this.actionsGroup.removeEventListener(Event.TRIGGERED, actionsGroup_triggeredHandler);
				this.removeChild(this.actionsGroup, true);
				this.actionsGroup = null;
			}

			if(this._actions === null)
			{
				return;
			}
			var factory:Function = this._actionsFactory !== null ? this._actionsFactory : defaultActionsFactory;
			if(factory === null)
			{
				return;
			}
			var actionsStyleName:String = this._customActionsStyleName != null ? this._customActionsStyleName : this.actionsStyleName;
			this.actionsGroup = ButtonGroup(factory());
			this.actionsGroup.styleNameList.add(actionsStyleName);
			this.actionsGroup.addEventListener(Event.TRIGGERED, actionsGroup_triggeredHandler);
			this.addChild(this.actionsGroup);
		}

		/**
		 * Positions and sizes the toast's content.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function layoutChildren():void
		{
			if(this._backgroundSkin)
			{
				this._backgroundSkin.width = this.actualWidth;
				this._backgroundSkin.height = this.actualHeight;
			}
			if(this._content)
			{
				this._content.x = this._paddingLeft;
				this._content.y = this._paddingTop;
				this._content.width = this.actualWidth - this._paddingLeft - this._paddingRight;
				this._content.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			}

			this.refreshMessageTextRendererDimensions(false);
			if(this.actionsGroup)
			{
				this.positionSingleChild(DisplayObject(this.messageTextRenderer));
				this.positionActionsRelativeToMessage();
			}
			else if(this.messageTextRenderer)
			{
				this.positionSingleChild(DisplayObject(this.messageTextRenderer));
			}
		}

		/**
		 * @private
		 */
		protected function positionSingleChild(displayObject:DisplayObject):void
		{
			if(this._horizontalAlign == HorizontalAlign.LEFT)
			{
				displayObject.x = this._paddingLeft;
			}
			else if(this._horizontalAlign == HorizontalAlign.RIGHT)
			{
				displayObject.x = this.actualWidth - this._paddingRight - displayObject.width;
			}
			else //center
			{
				displayObject.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - displayObject.width) / 2);
			}
			if(this._verticalAlign == VerticalAlign.TOP)
			{
				displayObject.y = this._paddingTop;
			}
			else if(this._verticalAlign == VerticalAlign.BOTTOM)
			{
				displayObject.y = this.actualHeight - this._paddingBottom - displayObject.height;
			}
			else //middle
			{
				displayObject.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - displayObject.height) / 2);
			}
		}

		/**
		 * @private
		 */
		protected function positionActionsRelativeToMessage():void
		{
			if(this._actionsPosition == RelativePosition.TOP)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.actionsGroup.y = this._paddingTop;
					this.messageTextRenderer.y = this.actualHeight - this._paddingBottom - this.messageTextRenderer.height;
				}
				else
				{
					if(this._verticalAlign == VerticalAlign.TOP)
					{
						this.messageTextRenderer.y += this.actionsGroup.height + this._gap;
					}
					else if(this._verticalAlign == VerticalAlign.MIDDLE)
					{
						this.messageTextRenderer.y += Math.round((this.actionsGroup.height + this._gap) / 2);
					}
					this.actionsGroup.y = this.messageTextRenderer.y - this.actionsGroup.height - this._gap;
				}
			}
			else if(this._actionsPosition == RelativePosition.RIGHT)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.messageTextRenderer.x = this._paddingLeft;
					this.actionsGroup.x = this.actualWidth - this._paddingRight - this.actionsGroup.width;
				}
				else
				{
					if(this._horizontalAlign == HorizontalAlign.RIGHT)
					{
						this.messageTextRenderer.x -= this.actionsGroup.width + this._gap;
					}
					else if(this._horizontalAlign == HorizontalAlign.CENTER)
					{
						this.messageTextRenderer.x -= Math.round((this.actionsGroup.width + this._gap) / 2);
					}
					this.actionsGroup.x = this.messageTextRenderer.x + this.messageTextRenderer.width + this._gap;
				}
			}
			else if(this._actionsPosition == RelativePosition.BOTTOM)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.messageTextRenderer.y = this._paddingTop;
					this.actionsGroup.y = this.actualHeight - this._paddingBottom - this.actionsGroup.height;
				}
				else
				{
					if(this._verticalAlign == VerticalAlign.BOTTOM)
					{
						this.messageTextRenderer.y -= this.actionsGroup.height + this._gap;
					}
					else if(this._verticalAlign == VerticalAlign.MIDDLE)
					{
						this.messageTextRenderer.y -= Math.round((this.actionsGroup.height + this._gap) / 2);
					}
					this.actionsGroup.y = this.messageTextRenderer.y + this.messageTextRenderer.height + this._gap;
				}
			}
			else if(this._actionsPosition == RelativePosition.LEFT)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.actionsGroup.x = this._paddingLeft;
					this.messageTextRenderer.x = this.actualWidth - this._paddingRight - this.messageTextRenderer.width;
				}
				else
				{
					if(this._horizontalAlign == HorizontalAlign.LEFT)
					{
						this.messageTextRenderer.x += this._gap + this.actionsGroup.width;
					}
					else if(this._horizontalAlign == HorizontalAlign.CENTER)
					{
						this.messageTextRenderer.x += Math.round((this._gap + this.actionsGroup.width) / 2);
					}
					this.actionsGroup.x = this.messageTextRenderer.x - this._gap - this.actionsGroup.width;
				}
			}

			if(this._actionsPosition == RelativePosition.LEFT || this._actionsPosition == RelativePosition.RIGHT)
			{
				if(this._verticalAlign == VerticalAlign.TOP)
				{
					this.actionsGroup.y = this._paddingTop;
				}
				else if(this._verticalAlign == VerticalAlign.BOTTOM)
				{
					this.actionsGroup.y = this.actualHeight - this._paddingBottom - this.actionsGroup.height;
				}
				else
				{
					this.actionsGroup.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.actionsGroup.height) / 2);
				}
			}
			else //top or bottom
			{
				if(this._horizontalAlign == HorizontalAlign.LEFT)
				{
					this.actionsGroup.x = this._paddingLeft;
				}
				else if(this._horizontalAlign == HorizontalAlign.RIGHT)
				{
					this.actionsGroup.x = this.actualWidth - this._paddingRight - this.actionsGroup.width;
				}
				else
				{
					this.actionsGroup.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - this.actionsGroup.width) / 2);
				}
			}
		}

		/**
		 * @private
		 */
		protected function startTimeout():void
		{
			if(this._timeout == Number.POSITIVE_INFINITY)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.toast_timeout_enterFrameHandler);
				return;
			}
			this._startTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.toast_timeout_enterFrameHandler);
		}

		/**
		 * @private
		 */
		protected function completeClose():void
		{
			var closeData:Object = this._closeData;
			var dispose:Boolean = this._disposeFromCloseCall;
			this._closeEffectContext = null;
			this._closeData = null;
			this._disposeFromCloseCall = false;
			this._isClosing = false;
			this._isOpen = false;
			//remove from parent before dispatching close so that the parent
			//layout is updated before any new toasts are added, but don't
			//dispose the toast yet!
			this.removeFromParent(false);
			this.dispatchEventWith(Event.CLOSE, false, closeData);
			if(dispose)
			{
				//dispose after the close event has been dispatched so that the
				//listeners aren't removed
				this.dispose();
			}
		}

		/**
		 * @private
		 */
		protected function completeOpen():void
		{
			this._openEffectContext = null;
			this._isOpening = false;
			this._isOpen = true;
			this.dispatchEventWith(Event.OPEN);
			this.startTimeout();
		}

		/**
		 * @private
		 */
		protected function toast_timeout_enterFrameHandler(event:Event):void
		{
			var totalTime:int = (getTimer() - this._startTime) / 1000;
			if(totalTime > this._timeout)
			{
				this.close(this._disposeOnSelfClose);
			}
		}

		/**
		 * @private
		 */
		protected function fontStyles_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function closeToast(data:Object, dispose:Boolean):void
		{
			if(!this.parent || this._isClosing)
			{
				return;
			}
			if(this._suspendEffectsCount == 0 && this._openEffectContext !== null)
			{
				this._openEffectContext.interrupt();
				this._openEffectContext = null;
			}
			this._isClosing = true;
			this._closeData = data;
			this._disposeFromCloseCall = dispose;
			this.removeEventListener(Event.ENTER_FRAME, this.toast_timeout_enterFrameHandler);
			if(this._closeEffect !== null)
			{
				this._closeEffectContext = IEffectContext(this._closeEffect(this));
				this._closeEffectContext.addEventListener(Event.COMPLETE, closeEffectContext_completeHandler);
				this._closeEffectContext.play();
			}
			else
			{
				this.completeClose();
			}
		}

		/**
		 * @private
		 */
		protected function actionsGroup_triggeredHandler(event:Event, data:Object):void
		{
			this.closeToast(data, this._disposeOnSelfClose);
		}

		/**
		 * @private
		 */
		protected function closeEffectContext_completeHandler(event:Event):void
		{
			this.completeClose();
		}

		/**
		 * @private
		 */
		protected function openEffectContext_completeHandler(event:Event):void
		{
			this.completeOpen();
		}
	}
}