/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils
{
	import feathers.system.DeviceCapabilities;
	import feathers.utils.math.roundDownToNearest;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import starling.core.Starling;

	/**
	 * Automatically manages the Starling view port and stage dimensions to
	 * create an appropriate <code>contentScaleFactor</code> value for the
	 * current mobile device using the screen density (sometimes referred to as
	 * DPI or PPI). The stage and view port will be resized without
	 * letterboxing. Additionally, the view port and stage will be automatically
	 * updated if the native stage resizes or changes orientation.
	 * 
	 * <p>The <code>contentScaleFactor</code> values calculated by this class
	 * are based on a combination of the screen density buckets supported by
	 * Google Android and the native scale factors used for Apple's iPhone:</p>
	 * 
	 * <table>
	 * <tr><th>Name</th><th>Density</th><th>Scale Factor</th></tr>
	 * <tr><td>ldpi</td><td>120</td><td>0.75</td></tr>
	 * <tr><td>mdpi</td><td>160</td><td>1</td></tr>
	 * <tr><td>hdpi</td><td>240</td><td>1.5</td></tr>
	 * <tr><td>xhdpi</td><td>320</td><td>2</td></tr>
	 * <tr><td>xxhdpi</td><td>480</td><td>3</td></tr>
	 * <tr><td>xxxhdpi</td><td>640</td><td>4</td></tr>
	 * </table>
	 * 
	 * <p>The density values in the table above are approximate. The screen
	 * density of an iPhone 5 is 326, so it uses the scale factor from the
	 * "xhdpi" bucket because 326 is closer to 320 than it is to 480.</p>
	 * 
	 * <p>Providing textures for every scale factor is optional. Textures from
	 * another scale factor can be automatically scaled to fit the current scale
	 * factor. For instance, since "ldpi" devices with a low screen density
	 * typically aren't manufactured anymore, "mdpi" textures will probably be
	 * "good enough" for these legacy devices, if your app encounters one. The
	 * larger textures will be automatically scaled down, and the app will look
	 * the same as it would if you were using lower resolution textures.</p>
	 * 
	 * <p>Special behavior has been implemented for iPads to give them scale
	 * factors of <code>1</code> and <code>2</code>, just like native apps.
	 * Using Android's rules for DPI buckets, non-Retina iPads would have been
	 * "ldpi" devices and Retina iPads would have been "mdpi" devices. However,
	 * because it makes more sense to make Starling use the same scale factor as
	 * native apps on iPad, this class makes a special exception just for them.</p>
	 * 
	 * <p>The following example demonstrates how to use
	 * <code>ScreenDensityScaleFactorManager</code>:</p>
	 * 
	 * <listing version="3.0">
	 * this._starling = new Starling( RootClass, this.stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE );
	 * this._scaler = new ScreenDensityScaleFactorManager(this._starling);</listing>
	 * 
	 * <p>When using this class, you should not attempt to manually resize the
	 * Starling view port or stage manually. This class manages their dimensions
	 * automatically on its own.</p>
	 */
	public class ScreenDensityScaleFactorManager
	{
		/**
		 * @private
		 */
		protected static const IOS_TABLET_DENSITY_SCALE_FACTOR:Number = 1.23484848484848;

		/**
		 * Constructor.
		 */
		public function ScreenDensityScaleFactorManager(starling:Starling)
		{
			var nativeStage:Stage = starling.nativeStage;
			this._starling = starling;
			this._calculatedScaleFactor = this.calculateScaleFactor();
			this.updateStarlingStageDimensions();
			//this needs top priority because we don't want Starling's listener
			//to get this event first use have bad dimensions.
			nativeStage.addEventListener(Event.RESIZE, nativeStage_resizeHandler, false, int.MAX_VALUE, true);
		}

		/**
		 * @private
		 */
		protected var _starling:Starling;

		/**
		 * @private
		 */
		protected var _calculatedScaleFactor:Number;
		
		/**
		 * @private
		 */
		protected function calculateScaleFactor():Number
		{
			var nativeStage:Stage = this._starling.nativeStage;
			var screenDensity:Number = DeviceCapabilities.dpi;
			//workaround because these rules derived from Android's behavior
			//would "incorrectly" give iPads a lower scale factor than iPhones
			//when both devices have the same scale factor natively.
			if(Capabilities.version.indexOf("IOS") >= 0 && DeviceCapabilities.isTablet(nativeStage))
			{
				screenDensity *= IOS_TABLET_DENSITY_SCALE_FACTOR;
			}
			var bucket:ScreenDensityBucket = BUCKETS[0];
			if(screenDensity <= bucket.density)
			{
				return bucket.scale;
			}
			var previousBucket:ScreenDensityBucket = bucket;
			var bucketCount:int = BUCKETS.length;
			for(var i:int = 1; i < bucketCount; i++)
			{
				bucket = BUCKETS[i];
				if(screenDensity > bucket.density)
				{
					previousBucket = bucket;
					continue;
				}
				var midDPI:Number = (bucket.density + previousBucket.density) / 2;
				if(screenDensity < midDPI)
				{
					return previousBucket.scale;
				}
				return bucket.scale;
			}
			return bucket.scale;
		}

		/**
		 * @private
		 */
		protected function updateStarlingStageDimensions():void
		{
			var nativeStage:Stage = this._starling.nativeStage;
			var needsToBeDivisibleByTwo:Boolean = int(this._calculatedScaleFactor) != this._calculatedScaleFactor;
			var starlingStageWidth:Number = int(nativeStage.stageWidth / this._calculatedScaleFactor);
			if(needsToBeDivisibleByTwo)
			{
				starlingStageWidth = roundDownToNearest(starlingStageWidth, 2);
			}
			this._starling.stage.stageWidth = starlingStageWidth;
			var starlingStageHeight:Number = int(nativeStage.stageHeight / this._calculatedScaleFactor);
			if(needsToBeDivisibleByTwo)
			{
				starlingStageHeight = roundDownToNearest(starlingStageHeight, 2);
			}
			this._starling.stage.stageHeight = starlingStageHeight;
			
			var viewPort:Rectangle = this._starling.viewPort;
			viewPort.width = starlingStageWidth * this._calculatedScaleFactor;
			viewPort.height = starlingStageHeight * this._calculatedScaleFactor;
			try
			{
				this._starling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}

		/**
		 * @private
		 */
		protected function nativeStage_resizeHandler(event:Event):void
		{
			this.updateStarlingStageDimensions();
		}
	}
}

class ScreenDensityBucket
{
	public function ScreenDensityBucket(dpi:Number, scale:Number)
	{
		this.density = dpi;
		this.scale = scale;
	}
	
	public var density:Number;
	public var scale:Number;
}


var BUCKETS:Vector.<ScreenDensityBucket> = new <ScreenDensityBucket>
[
	new ScreenDensityBucket(120, 0.75), //ldpi
	new ScreenDensityBucket(160, 1), //mdpi
	new ScreenDensityBucket(240, 1.5), //hdpi
	new ScreenDensityBucket(320, 2), //xhdpi
	new ScreenDensityBucket(480, 3), //xxhdpi
	new ScreenDensityBucket(640, 4) ///xxxhpi
];