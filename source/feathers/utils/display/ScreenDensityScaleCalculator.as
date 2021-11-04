/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.display
{
	import flash.errors.IllegalOperationError;

	/**
	 * Selects a value for <code>contentScaleFactor</code> based on the screen
	 * density (sometimes called DPI or PPI).
	 *
	 * @productversion Feathers 3.1.0
	 */
	public class ScreenDensityScaleCalculator
	{
		/**
		 * Constructor.
		 */
		public function ScreenDensityScaleCalculator()
		{
		}

		/**
		 * @private
		 */
		protected var _buckets:Vector.<ScreenDensityBucket> = new <ScreenDensityBucket>[];

		/**
		 * Adds a new scale for the specified density.
		 *
		 * <listing version="3.0">
		 * selector.addScaleForDensity( 160, 1 );
		 * selector.addScaleForDensity( 240, 1.5 );
		 * selector.addScaleForDensity( 320, 2 );
		 * selector.addScaleForDensity( 480, 3 );</listing>
		 */
		public function addScaleForDensity(density:int, scale:Number):void
		{
			var bucketCount:int = this._buckets.length;
			for(var i:int = 0; i < bucketCount; i++)
			{
				var bucket:ScreenDensityBucket = this._buckets[i];
				if(bucket.density > density)
				{
					break;
				}
				if(bucket.density == density)
				{
					throw new ArgumentError("Screen density cannot be added more than once: " + density);
				}
			}
			this._buckets.insertAt(i, new ScreenDensityBucket(density, scale));
		}

		/**
		 * Removes a scale that was added with
		 * <code>addScaleForDensity()</code>.
		 *
		 * <listing version="3.0">
		 * selector.addScaleForDensity( 320, 2 );
		 * selector.removeScaleForDensity( 320 );</listing>
		 */
		public function removeScaleForDensity(density:int):void
		{
			var bucketCount:int = this._buckets.length;
			for(var i:int = 0; i < bucketCount; i++)
			{
				var bucket:ScreenDensityBucket = this._buckets[i];
				if(bucket.density == density)
				{
					this._buckets.removeAt(i);
					return;
				}
			}
		}

		/**
		 * Returns the ideal <code>contentScaleFactor</code> value for the
		 * specified density.
		 */
		public function getScale(density:int):Number
		{
			if(this._buckets.length == 0)
			{
				throw new IllegalOperationError("Cannot choose scale because none have been added");
			}
			var bucket:ScreenDensityBucket = this._buckets[0];
			if(density <= bucket.density)
			{
				return bucket.scale;
			}
			var previousBucket:ScreenDensityBucket = bucket;
			var bucketCount:int = this._buckets.length;
			for(var i:int = 1; i < bucketCount; i++)
			{
				bucket = this._buckets[i];
				if(density > bucket.density)
				{
					previousBucket = bucket;
					continue;
				}
				var midDPI:Number = (bucket.density + previousBucket.density) / 2;
				if(density < midDPI)
				{
					return previousBucket.scale;
				}
				return bucket.scale;
			}
			return bucket.scale;
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