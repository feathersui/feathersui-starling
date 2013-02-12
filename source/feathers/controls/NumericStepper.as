/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.utils.math.clamp;
	import feathers.utils.math.roundToNearest;

	import flash.events.TimerEvent;

	import flash.ui.Keyboard;

	import flash.utils.Timer;

	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the stepper's value changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Select a value between a minimum and a maximum by using increment and
	 * decrement buttons or typing in a value in a text input.
	 *
	 * @see http://wiki.starling-framework.org/feathers/numeric-stepper
	 */
	public class NumericStepper extends FeathersControl implements IFocusDisplayObject
	{
		/**
		 * @private
		 */
		private static const HELPER_TOUCHES_VECTOR:Vector.<Touch> = new <Touch>[];

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_TEXT_INPUT_FACTORY:String = "textInputFactory";

		/**
		 * The default value added to the <code>nameList</code> of the decrement
		 * button.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_DECREMENT_BUTTON:String = "feathers-numeric-stepper-decrement-button";

		/**
		 * The default value added to the <code>nameList</code> of the increment
		 * button.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_INCREMENT_BUTTON:String = "feathers-numeric-stepper-increment-button";

		/**
		 * The default value added to the <code>nameList</code> of the text
		 * input.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_TEXT_INPUT:String = "feathers-numeric-stepper-text-input";

		/**
		 * @private
		 */
		protected static function defaultDecrementButtonFactory():Button
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultIncrementButtonFactory():Button
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultTextInputFactory():TextInput
		{
			return new TextInput();
		}

		/**
		 * Constructor.
		 */
		public function NumericStepper()
		{
			this.addEventListener(FeathersEventType.FOCUS_IN, numericStepper_focusInHandler);
			this.addEventListener(FeathersEventType.FOCUS_OUT, numericStepper_focusOutHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, numericStepper_removedFromStageHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the decrement button.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var decrementButtonName:String = DEFAULT_CHILD_NAME_DECREMENT_BUTTON;

		/**
		 * The value added to the <code>nameList</code> of the increment button.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var incrementButtonName:String = DEFAULT_CHILD_NAME_INCREMENT_BUTTON;

		/**
		 * The value added to the <code>nameList</code> of the text input.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var textInputName:String = DEFAULT_CHILD_NAME_TEXT_INPUT;

		/**
		 * The decrement button sub-component.
		 */
		protected var decrementButton:Button;

		/**
		 * The increment button sub-component.
		 */
		protected var incrementButton:Button;

		/**
		 * The text input sub-component.
		 */
		protected var textInput:TextInput;

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _value:Number = 0;

		/**
		 * The value of the numeric stepper, between the minimum and maximum.
		 */
		public function get value():Number
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(newValue:Number):void
		{
			if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
			{
				newValue = roundToNearest(newValue, this._step);
			}
			newValue = clamp(newValue, this._minimum, this._maximum);
			if(this._value == newValue)
			{
				return;
			}
			this._value = newValue;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _minimum:Number = 0;

		/**
		 * The numeric stepper's value will not go lower than the minimum.
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}

		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			if(this._minimum == value)
			{
				return;
			}
			this._minimum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _maximum:Number = 0;

		/**
		 * The numeric stepper's value will not go higher than the maximum.
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}

		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _step:Number = 0;

		/**
		 * As the numeric stepper's buttons are pressed, the value is snapped to
		 * a multiple of the step.
		 */
		public function get step():Number
		{
			return this._step;
		}

		/**
		 * @private
		 */
		public function set step(value:Number):void
		{
			if(this._step == value)
			{
				return;
			}
			this._step = value;
		}

		/**
		 * @private
		 */
		protected var currentRepeatAction:Function;

		/**
		 * @private
		 */
		protected var _repeatTimer:Timer;

		/**
		 * @private
		 */
		protected var _repeatDelay:Number = 0.05;

		/**
		 * The time, in seconds, before actions are repeated. The first repeat
		 * happens after a delay that is five times longer than the following
		 * repeats.
		 */
		public function get repeatDelay():Number
		{
			return this._repeatDelay;
		}

		/**
		 * @private
		 */
		public function set repeatDelay(value:Number):void
		{
			if(this._repeatDelay == value)
			{
				return;
			}
			this._repeatDelay = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _decrementButtonFactory:Function;

		/**
		 * A function used to generate the numeric stepper's decrement button
		 * sub-component. This can be used to change properties on the decrement
		 * button when it is first created. For instance, if you are skinning
		 * Feathers components without a theme, you might use
		 * <code>decrementButtonFactory</code> to set skins and other styles on
		 * the decrement button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * @see #decrementButtonProperties
		 */
		public function get decrementButtonFactory():Function
		{
			return this._decrementButtonFactory;
		}

		/**
		 * @private
		 */
		public function set decrementButtonFactory(value:Function):void
		{
			if(this._decrementButtonFactory == value)
			{
				return;
			}
			this._decrementButtonFactory = value;
			this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customDecrementButtonName:String;

		/**
		 * A name to add to the numeric stepper's decrement button
		 * sub-component. Typically used by a theme to provide different skins
		 * to different numeric steppers.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #decrementButtonFactory
		 * @see #decrementButtonProperties
		 */
		public function get customDecrementButtonName():String
		{
			return this._customDecrementButtonName;
		}

		/**
		 * @private
		 */
		public function set customDecrementButtonName(value:String):void
		{
			if(this._customDecrementButtonName == value)
			{
				return;
			}
			this._customDecrementButtonName = value;
			this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _decrementButtonProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the numeric stepper's
		 * decrement button sub-component. The decrement button is a
		 * <code>feathers.controls.Button</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see feathers.controls.Button
		 */
		public function get decrementButtonProperties():Object
		{
			if(!this._decrementButtonProperties)
			{
				this._decrementButtonProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._decrementButtonProperties;
		}

		/**
		 * @private
		 */
		public function set decrementButtonProperties(value:Object):void
		{
			if(this._decrementButtonProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._decrementButtonProperties)
			{
				this._decrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._decrementButtonProperties = PropertyProxy(value);
			if(this._decrementButtonProperties)
			{
				this._decrementButtonProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _decrementButtonLabel:String = "-";

		/**
		 * The text displayed by the decrement button.
		 */
		public function get decrementButtonLabel():String
		{
			return this._decrementButtonLabel;
		}

		/**
		 * @private
		 */
		public function set decrementButtonLabel(value:String):void
		{
			if(this._decrementButtonLabel == value)
			{
				return;
			}
			this._decrementButtonLabel = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _incrementButtonFactory:Function;

		/**
		 * A function used to generate the numeric stepper's increment button
		 * sub-component. This can be used to change properties on the increment
		 * button when it is first created. For instance, if you are skinning
		 * Feathers components without a theme, you might use
		 * <code>incrementButtonFactory</code> to set skins and other styles on
		 * the increment button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * @see #incrementButtonProperties
		 */
		public function get incrementButtonFactory():Function
		{
			return this._incrementButtonFactory;
		}

		/**
		 * @private
		 */
		public function set incrementButtonFactory(value:Function):void
		{
			if(this._incrementButtonFactory == value)
			{
				return;
			}
			this._incrementButtonFactory = value;
			this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customIncrementButtonName:String;

		/**
		 * A name to add to the numeric stepper's increment button
		 * sub-component. Typically used by a theme to provide different skins
		 * to different numeric steppers.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #incrementButtonFactory
		 * @see #incrementButtonProperties
		 */
		public function get customIncrementButtonName():String
		{
			return this._customIncrementButtonName;
		}

		/**
		 * @private
		 */
		public function set customIncrementButtonName(value:String):void
		{
			if(this._customIncrementButtonName == value)
			{
				return;
			}
			this._customIncrementButtonName = value;
			this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _incrementButtonProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the numeric stepper's
		 * increment button sub-component. The increment button is a
		 * <code>feathers.controls.Button</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see feathers.controls.Button
		 */
		public function get incrementButtonProperties():Object
		{
			if(!this._incrementButtonProperties)
			{
				this._incrementButtonProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._incrementButtonProperties;
		}

		/**
		 * @private
		 */
		public function set incrementButtonProperties(value:Object):void
		{
			if(this._incrementButtonProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._incrementButtonProperties)
			{
				this._incrementButtonProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._incrementButtonProperties = PropertyProxy(value);
			if(this._incrementButtonProperties)
			{
				this._incrementButtonProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _incrementButtonLabel:String = "+";

		/**
		 * The text displayed by the increment button.
		 */
		public function get incrementButtonLabel():String
		{
			return this._incrementButtonLabel;
		}

		/**
		 * @private
		 */
		public function set incrementButtonLabel(value:String):void
		{
			if(this._incrementButtonLabel == value)
			{
				return;
			}
			this._incrementButtonLabel = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textInputFactory:Function;

		/**
		 * A function used to generate the numeric stepper's text input
		 * sub-component. This can be used to change properties on the text
		 * input when it is first created. For instance, if you are skinning
		 * Feathers components without a theme, you might use
		 * <code>textInputFactory</code> to set skins and text styles on the
		 * text input.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():TextInput</pre>
		 *
		 * @see #textInputProperties
		 */
		public function get textInputFactory():Function
		{
			return this._textInputFactory;
		}

		/**
		 * @private
		 */
		public function set textInputFactory(value:Function):void
		{
			if(this._textInputFactory == value)
			{
				return;
			}
			this._textInputFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customTextInputName:String;

		/**
		 * A name to add to the slider's thumb sub-component. Typically
		 * used by a theme to provide different skins to different sliders.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #textInputFactory
		 * @see #textInputProperties
		 */
		public function get customTextInputName():String
		{
			return this._customTextInputName;
		}

		/**
		 * @private
		 */
		public function set customTextInputName(value:String):void
		{
			if(this._customTextInputName == value)
			{
				return;
			}
			this._customTextInputName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _textInputProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the slider's thumb
		 * sub-component. The thumb is a <code>feathers.controls.Button</code>
		 * instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see feathers.controls.Button
		 */
		public function get textInputProperties():Object
		{
			if(!this._textInputProperties)
			{
				this._textInputProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._textInputProperties;
		}

		/**
		 * @private
		 */
		public function set textInputProperties(value:Object):void
		{
			if(this._textInputProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._textInputProperties)
			{
				this._textInputProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._textInputProperties = PropertyProxy(value);
			if(this._textInputProperties)
			{
				this._textInputProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const decrementButtonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
			const incrementButtonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
			const textInputFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_INPUT_FACTORY);

			if(decrementButtonFactoryInvalid)
			{
				this.createDecrementButton();
			}

			if(incrementButtonFactoryInvalid)
			{
				this.createIncrementButton();
			}

			if(textInputFactoryInvalid)
			{
				this.createTextInput();
			}

			if(decrementButtonFactoryInvalid || stylesInvalid)
			{
				this.refreshDecrementButtonStyles();
			}

			if(incrementButtonFactoryInvalid || stylesInvalid)
			{
				this.refreshIncrementButtonStyles();
			}

			if(textInputFactoryInvalid || stylesInvalid)
			{
				this.refreshTextInputStyles();
			}

			if(textInputFactoryInvalid || dataInvalid)
			{
				this.textInput.text = this._value.toString();
			}

			if(decrementButtonFactoryInvalid || stateInvalid)
			{
				this.decrementButton.isEnabled = this._isEnabled;
			}

			if(incrementButtonFactoryInvalid || stateInvalid)
			{
				this.incrementButton.isEnabled = this._isEnabled;
			}

			if(textInputFactoryInvalid || stateInvalid)
			{
				this.textInput.isEnabled = this._isEnabled;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(decrementButtonFactoryInvalid || incrementButtonFactoryInvalid || textInputFactoryInvalid ||
				dataInvalid || stylesInvalid || sizeInvalid)
			{
				this.layoutChildren();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			this.decrementButton.validate();
			this.incrementButton.validate();

			const oldTextInputWidth:Number = this.textInput.width;
			const oldTextInputHeight:Number = this.textInput.height;
			this.textInput.minWidth = this._minWidth - this.decrementButton.width - this.incrementButton.width;
			this.textInput.maxWidth = this._maxWidth - this.decrementButton.width - this.incrementButton.width;
			this.textInput.width = this.explicitWidth - this.decrementButton.width - this.incrementButton.width;
			this.textInput.height = this.explicitHeight;
			this.textInput.validate();

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this.decrementButton.width + this.textInput.width + this.incrementButton.width;
			}
			if(needsHeight)
			{
				newHeight = Math.max(this.decrementButton.height, this.incrementButton.height, this.textInput.height);
			}

			this.textInput.width = oldTextInputWidth;
			this.textInput.height = oldTextInputHeight;
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function decrement():void
		{
			this.value -= this._step;
		}

		/**
		 * @private
		 */
		protected function increment():void
		{
			this.value += this._step;
		}

		/**
		 * @private
		 */
		protected function createDecrementButton():void
		{
			if(this.decrementButton)
			{
				this.decrementButton.removeFromParent(true);
				this.decrementButton = null;
			}

			const factory:Function = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
			const decrementButtonName:String = this._customDecrementButtonName != null ? this._customDecrementButtonName : this.decrementButtonName;
			this.decrementButton = Button(factory());
			this.decrementButton.nameList.add(decrementButtonName);
			this.decrementButton.addEventListener(TouchEvent.TOUCH, decrementButton_touchHandler);
			this.addChild(this.decrementButton);
		}

		/**
		 * @private
		 */
		protected function createIncrementButton():void
		{
			if(this.incrementButton)
			{
				this.incrementButton.removeFromParent(true);
				this.incrementButton = null;
			}

			const factory:Function = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
			const incrementButtonName:String = this._customIncrementButtonName != null ? this._customIncrementButtonName : this.incrementButtonName;
			this.incrementButton = Button(factory());
			this.incrementButton.nameList.add(incrementButtonName);
			this.incrementButton.addEventListener(TouchEvent.TOUCH, incrementButton_touchHandler);
			this.addChild(this.incrementButton);
		}

		/**
		 * @private
		 */
		protected function createTextInput():void
		{
			if(this.textInput)
			{
				this.textInput.removeFromParent(true);
				this.textInput = null;
			}

			const factory:Function = this._textInputFactory != null ? this._textInputFactory : defaultTextInputFactory;
			const textInputName:String = this._customTextInputName != null ? this._customTextInputName : this.textInputName;
			this.textInput = TextInput(factory());
			this.textInput.nameList.add(textInputName);
			this.textInput.addEventListener(FeathersEventType.ENTER, textInput_enterHandler);
			this.textInput.addEventListener(FeathersEventType.FOCUS_OUT, textInput_focusOutHandler);
			this.addChild(this.textInput);
		}

		/**
		 * @private
		 */
		protected function refreshDecrementButtonStyles():void
		{
			for(var propertyName:String in this._decrementButtonProperties)
			{
				if(this.decrementButton.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._decrementButtonProperties[propertyName];
					this.decrementButton[propertyName] = propertyValue;
				}
			}
			this.decrementButton.label = this._decrementButtonLabel;
		}

		/**
		 * @private
		 */
		protected function refreshIncrementButtonStyles():void
		{
			for(var propertyName:String in this._incrementButtonProperties)
			{
				if(this.incrementButton.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._incrementButtonProperties[propertyName];
					this.incrementButton[propertyName] = propertyValue;
				}
			}
			this.incrementButton.label = this._incrementButtonLabel;
		}

		/**
		 * @private
		 */
		protected function refreshTextInputStyles():void
		{
			for(var propertyName:String in this._textInputProperties)
			{
				if(this.textInput.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._textInputProperties[propertyName];
					this.textInput[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layoutChildren():void
		{
			this.decrementButton.x = 0;
			this.decrementButton.y = 0;
			this.decrementButton.height = this.actualHeight;
			this.decrementButton.validate();

			this.incrementButton.y = 0;
			this.incrementButton.height = this.actualHeight;
			this.incrementButton.validate();
			this.incrementButton.x = this.actualWidth - this.incrementButton.width;

			this.textInput.x = this.decrementButton.width;
			this.textInput.width = this.incrementButton.x - this.textInput.x;
			this.textInput.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function startRepeatTimer(action:Function):void
		{
			this.currentRepeatAction = action;
			if(this._repeatDelay > 0)
			{
				if(!this._repeatTimer)
				{
					this._repeatTimer = new Timer(this._repeatDelay * 1000);
					this._repeatTimer.addEventListener(TimerEvent.TIMER, repeatTimer_timerHandler);
				}
				else
				{
					this._repeatTimer.reset();
					this._repeatTimer.delay = this._repeatDelay * 1000;
				}
				this._repeatTimer.start();
			}
		}

		/**
		 * @private
		 */
		protected function childProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function numericStepper_removedFromStageHandler(event:Event):void
		{
			this.touchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function numericStepper_focusInHandler(event:Event):void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function numericStepper_focusOutHandler(event:Event):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function textInput_enterHandler(event:Event):void
		{
			const newValue:Number = parseFloat(this.textInput.text);
			if(!isNaN(newValue))
			{
				this.value = newValue;
			}
		}

		/**
		 * @private
		 */
		protected function textInput_focusOutHandler(event:Event):void
		{
			const newValue:Number = parseFloat(this.textInput.text);
			if(!isNaN(newValue))
			{
				this.value = newValue;
			}
		}

		/**
		 * @private
		 */
		protected function decrementButton_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touches:Vector.<Touch> = event.getTouches(this.decrementButton, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}

			if(this.touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this.touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}

				if(!touch)
				{
					//end of hover
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					this._repeatTimer.stop();
					this.dispatchEventWith(FeathersEventType.END_INTERACTION);
				}
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
						this.decrement();
						this.startRepeatTimer(this.decrement);
						this.touchPointID = touch.id;
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}

		/**
		 * @private
		 */
		protected function incrementButton_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touches:Vector.<Touch> = event.getTouches(this.incrementButton, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}

			if(this.touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this.touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}

				if(!touch)
				{
					//end of hover
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					this._repeatTimer.stop();
					this.dispatchEventWith(FeathersEventType.END_INTERACTION);
				}
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
						this.increment();
						this.startRepeatTimer(this.increment);
						this.touchPointID = touch.id;
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.HOME)
			{
				this.value = this._minimum;
				return;
			}
			if(event.keyCode == Keyboard.END)
			{
				this.value = this._maximum;
				return;
			}
			if(event.keyCode == Keyboard.UP)
			{
				this.value += this._step;
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				this.value -= this._step;
			}
		}

		/**
		 * @private
		 */
		protected function repeatTimer_timerHandler(event:TimerEvent):void
		{
			if(this._repeatTimer.currentCount < 5)
			{
				return;
			}
			this.currentRepeatAction();
		}
	}
}
