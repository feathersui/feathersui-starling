package org.josht.starling.foxhole.controls
{
	import org.osflash.signals.ISignal;

	import starling.display.DisplayObject;

	public interface IPopUpContentManager
	{
		function get onClose():ISignal;
		function open(content:DisplayObject, source:DisplayObject):void;
		function close():void;
		function dispose():void;
	}
}
