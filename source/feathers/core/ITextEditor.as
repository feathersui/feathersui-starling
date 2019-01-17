/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.text.FontStylesSet;

	import flash.geom.Point;

	/**
	 * Dispatched when the text property changes.
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
	 * @see #text
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user presses the Enter key while the editor has focus.
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
	 * @eventType feathers.events.FeathersEventType.ENTER
	 */
	[Event(name="enter",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor receives focus.
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
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor loses focus.
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
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * Dispatched when the soft keyboard is activated. Not all text editors will
	 * activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATE
	 */
	[Event(name="softKeyboardActivate",type="starling.events.Event")]

	/**
	 * Dispatched when the soft keyboard is deactivated. Not all text editors
	 * will activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_DEACTIVATE
	 */
	[Event(name="softKeyboardDectivate",type="starling.events.Event")]

	/**
	 * Handles the editing of text.
	 *
	 * @see feathers.controls.TextInput
	 * @see ../../../help/text-editors.html Introduction to Feathers text editors
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface ITextEditor extends IFeathersControl, ITextBaselineControl
	{
		/**
		 * The text displayed by the editor.
		 */
		function get text():String;

		/**
		 * @private
		 */
		function set text(value:String):void;

		/**
		 * Determines if the entered text will be masked so that it cannot be
		 * seen, such as for a password input.
		 */
		function get displayAsPassword():Boolean;

		/**
		 * @private
		 */
		function set displayAsPassword(value:Boolean):void;

		/**
		 * The maximum number of characters that may be entered.
		 */
		function get maxChars():int;

		/**
		 * @private
		 */
		function set maxChars(value:int):void;

		/**
		 * Limits the set of characters that may be entered.
		 */
		function get restrict():String;

		/**
		 * @private
		 */
		function set restrict(value:String):void;

		/**
		 * Determines if the text is editable.
		 * 
		 * @see #isSelectable
		 */
		function get isEditable():Boolean;

		/**
		 * @private
		 */
		function set isEditable(value:Boolean):void;

		/**
		 * If the <code>isEditable</code> property is set to <code>false</code>,
		 * the <code>isSelectable</code> property determines if the text is
		 * selectable. If the <code>isEditable</code> property is set to
		 * <code>true</code>, the text will always be selectable.
		 *
		 * @see #isEditable
		 */
		function get isSelectable():Boolean;

		/**
		 * @private
		 */
		function set isSelectable(value:Boolean):void;

		/**
		 * Determines if the owner should call <code>setFocus()</code> on
		 * <code>TouchPhase.ENDED</code> or on <code>TouchPhase.BEGAN</code>.
		 * This is a hack because <code>StageText</code> doesn't like being
		 * assigned focus on <code>TouchPhase.BEGAN</code>. In general, most
		 * text editors should simply return <code>false</code>.
		 *
		 * @see #setFocus()
		 */
		function get setTouchFocusOnEndedPhase():Boolean;

		/**
		 * The index of the first character of the selection. If no text is
		 * selected, then this is the value of the caret index. This value will
		 * always be smaller than <code>selectionEndIndex</code>.
		 * 
		 * @see #selectionEndIndex
		 */
		function get selectionBeginIndex():int;

		/**
		 * The index of the last character of the selection. If no text is
		 * selected, then this is the value of the caret index. This value will
		 * always be larger than <code>selectionBeginIndex</code>.
		 *
		 * @see #selectionBeginIndex
		 */
		function get selectionEndIndex():int;

		/**
		 * The internal font styles used to render the text that are passed down
		 * from the parent component. Generally, most developers will set font
		 * styles on the parent component.
		 *
		 * <p>Warning: The <code>fontStyles</code> property may be ignored if
		 * more advanced styles defined by the text renderer implementation have
		 * been set.</p>
		 * 
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 */
		function get fontStyles():FontStylesSet;

		/**
		 * @private
		 */
		function set fontStyles(value:FontStylesSet):void;

		/**
		 * Gives focus to the text editor. Includes an optional position which
		 * may be used by the text editor to determine the cursor position. The
		 * position may be outside of the editors bounds.
		 */
		function setFocus(position:Point = null):void;

		/**
		 * Removes focus from the text editor.
		 */
		function clearFocus():void;

		/**
		 * Sets the range of selected characters. If both values are the same,
		 * the text insertion position is changed and nothing is selected.
		 */
		function selectRange(startIndex:int, endIndex:int):void;

		/**
		 * Measures the text's bounds (without a full validation, if
		 * possible).
		 */
		function measureText(result:Point = null):Point;
	}
}
