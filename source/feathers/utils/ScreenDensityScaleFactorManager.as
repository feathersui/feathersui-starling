/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils
{
	import feathers.system.DeviceCapabilities;
	import feathers.utils.display.ScreenDensityScaleCalculator;
	import feathers.utils.math.roundDownToNearest;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.utils.SystemUtil;

	/**
	 * Automatically manages the Starling view port and stage dimensions to
	 * create an appropriate <code>contentScaleFactor</code> value for the
	 * current mobile device while filling the whole screen without letterboxing
	 * (no black bars!). Additionally, if the mobile device changes orientation,
	 * or if the desktop native window resizes,
	 * <code>ScreenDensityScaleFactorManager</code> will automatically resize
	 * Starling based on the new dimensions.
	 * 
	 * <p>When using <code>ScreenDensityScaleFactorManager</code>, the Starling
	 * stage dimensions will not be exactly the same on all devices. When
	 * comparing two different phones, the stage dimensions will be similar, but
	 * may not be perfectly equal. For example, the stage dimensions on an
	 * Apple iPhone 5 in portrait orientation will be 320x568, but the stage
	 * dimensions on a Google Nexus 5 will be 360x640. With this in mind, be
	 * sure to use "fluid" layouts to account for the differences.</p>
	 * 
	 * <p>It's also important to understand that tablets will have much larger
	 * Starling stage dimensions than phones.
	 * <code>ScreenDensityScaleFactorManager</code> is designed to behave more
	 * like native apps where tablets often display extra navigation or data
	 * that wouldn't be able to fit on a smaller phone screen. For example, on
	 * an Apple iPad, the stage dimensions will be 768x1024. This is much larger
	 * than the two phones we compared previously.</p>
	 *
	 * <p>The following example demonstrates how to instantiate
	 * <code>ScreenDensityScaleFactorManager</code>:</p>
	 *
	 * <listing version="3.0">
	 * this._starling = new Starling( RootClass, this.stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE );
	 * this._scaler = new ScreenDensityScaleFactorManager(this._starling);</listing>
	 * 
	 * <strong>How <code>contentScaleFactor</code> is calculated</strong>
	 * 
	 * <p>The device's screen density (sometimes referred to as DPI or PPI) is
	 * used to calculate an appropriate <code>contentScaleFactor</code> value.
	 * The calculation is inspired by native apps on Google's Android operating
	 * system where "density-independent pixels" are used for layout. You might
	 * consider this an advanced form of the techniques described in
	 * <a href="http://wiki.starling-framework.org/manual/multi-resolution_development">Starling Multi-Resolution Development</a>.</p>
	 * 
	 * <p>The following chart shows how different screen densities map to
	 * different <code>contentScaleFactor</code> values on both iOS and Android:</p>
	 * 
	 * <table class="innertable">
	 * <tr><th>Android</th><th>iOS</th><th>Density</th><th>Scale Factor</th></tr>
	 * <tr><td>ldpi</td><td></td><td>120</td><td>0.75</td></tr>
	 * <tr><td>mdpi</td><td>non-Retina (&#64;1x)</td><td>160</td><td>1</td></tr>
	 * <tr><td>hdpi</td><td></td><td>240</td><td>1.5</td></tr>
	 * <tr><td>xhdpi</td><td>Retina (&#64;2x)</td><td>320</td><td>2</td></tr>
	 * <tr><td>xxhdpi</td><td>Retina HD (&#64;3x)</td><td>480</td><td>3</td></tr>
	 * <tr><td>xxxhdpi</td><td></td><td>640</td><td>4</td></tr>
	 * </table>
	 * 
	 * <p>The density values in the table above are approximate. The screen
	 * density of an iPhone 5 is 326, so it uses the scale factor from the
	 * "xhdpi" bucket because 326 is closer to 320 than it is to 480.</p>
	 *
	 * <p>Note: Special behavior has been implemented for iPads to give them
	 * scale factors of <code>1</code> and <code>2</code>, just like native
	 * apps. Using Android's rules for DPI buckets, non-Retina iPads would have
	 * been "ldpi" devices (scale factor <code>0.75</code>) and Retina iPads
	 * would have been "hdpi" devices (scale factor <code>1.5</code>). However,
	 * because it makes more sense for Starling to use the same scale factor as
	 * native apps on iPad, this class makes a special exception just for
	 * them.</p>
	 * 
	 * <strong>Loading Assets</strong>
	 * 
	 * <p>After creating <code>ScreenDensityScaleFactorManager</code>, you can
	 * use Starling's <code>contentScaleFactor</code> property to determine
	 * which set of assets to load:</p>
	 *
	 * <listing version="3.0">
	 * if( Starling.current.contentScaleFactor > 1 )
	 * {
	 *     assetManager.scaleFactor = 2;
	 *     var assets2x:File = File.applicationDirectory.resolvePath( "assets/2x" );
	 *     assetManager.enqueue( assets2x );
	 * }
	 * else
	 * {
	 *     assetManager.scaleFactor = 1;
	 *     var assets1x:File = File.applicationDirectory.resolvePath( "assets/1x" );
	 *     assetManager.enqueue( assets1x );
	 * }</listing>
	 * 
	 * <p>Providing assets for every scale factor is optional because Starling
	 * will automatically resize any textures that have been given a different
	 * <code>scale</code> than the current <code>contentScaleFactor</code> when
	 * they are rendered to the screen.</p>
	 * 
	 * <p>For example, since "ldpi" devices with a low screen density typically
	 * aren't manufactured anymore, it might not be worth spending time
	 * designing a set of assets specifically for scale factor 0.75. Instead,
	 * you can probably load the higher quality "mdpi" textures when a legacy
	 * device is encountered where <code>ScreenDensityScaleFactorManager</code>
	 * chooses a <code>contentScaleFactor</code> of 0.75. As long as the "mdpi"
	 * textures are given a scale of 1 when they are created, Starling will know
	 * how to automatically resize them on a device where the calculated
	 * <code>contentScaleFactor</code> is lower than 1. Larger textures will
	 * be automatically scaled down, and the app will look the same as it would
	 * if you were using lower resolution textures. Your app will end up using a
	 * bit more memory at runtime than strictly necessary on these devices, but
	 * you won't need to include as many image files with your app, so its
	 * download size will be smaller.</p>
	 * 
	 * <p>Similarly, lower resolution textures can be scaled up on devices with
	 * a higher <code>contentScaleFactor</code>. It is said that the human eye
	 * starts to have difficulty perceiving every individual pixel when a
	 * device's screen density is higher than 300 DPI. Depending on your app's
	 * requirements, assets for scale factor 4 (and often, also scale factor 3)
	 * may not be strictly necessary. You can often load assets for scale factor
	 * 2 on these higher-density devices because the difference is so difficult
	 * to see with the naked eye.</p>
	 * 
	 * @see http://wiki.starling-framework.org/manual/multi-resolution_development Starling Multi-Resolution Development
	 *
	 * @productversion Feathers 2.2.0
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
			this._scaleSelector = new ScreenDensityScaleCalculator();
			this._scaleSelector.addScaleForDensity(120, 0.75);	//ldpi
			this._scaleSelector.addScaleForDensity(160, 1);		//mdpi
			this._scaleSelector.addScaleForDensity(240, 1.5);	//hdpi
			this._scaleSelector.addScaleForDensity(320, 2);		//xhdpi
			this._scaleSelector.addScaleForDensity(480, 3);		//xxhdpi
			this._scaleSelector.addScaleForDensity(640, 4);		//xxxhpi

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
		protected var _scaleSelector:ScreenDensityScaleCalculator;

		/**
		 * @private
		 */
		protected function calculateScaleFactor():Number
		{
			//if DeviceCapabilities.dpi has been customized, we assume that a
			//mobile device is being simulated. since Animate CC doesn't let you
			//customize Capabilities.screenDPI, and SystemUtil.isDesktop
			//incorrectly returns true when testing in Animate CC, this is a
			//hacky way to make it work for those who prefer to use Animate CC.
			if(SystemUtil.isDesktop && DeviceCapabilities.dpi == Capabilities.screenDPI)
			{
				//Starling will handle nativeStage.contentsScaleFactor
				return 1;
			}
			var nativeStage:Stage = this._starling.nativeStage;
			var screenDensity:Number = DeviceCapabilities.dpi;
			if(Capabilities.os.indexOf("tvOS") != -1)
			{
				//tvOS devices report a lower DPI than Android TV devices
				//for the same resolution
				screenDensity *= 2;
			}
			else if(Capabilities.version.indexOf("IOS") != -1 &&
				DeviceCapabilities.isTablet(nativeStage))
			{
				//workaround because these rules derived from Android's behavior
				//would "incorrectly" give iPads a lower scale factor than iPhones
				//when both devices have the same scale factor natively.
				screenDensity *= IOS_TABLET_DENSITY_SCALE_FACTOR;
			}
			return this._scaleSelector.getScale(screenDensity);
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