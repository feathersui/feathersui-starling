/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.SystemUtil;

	[Event(name="change",type="starling.events.Event")]
	[Event(name="update",type="starling.events.Event")]

	/**
	 * Displays a list of color swatches.
	 */
	public class ColorSwatchList extends List implements IColorControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>ColorSwatchList</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultItemRendererFactory():IListItemRenderer
		{
			return new ColorSwatchItemRenderer();
		}

		/**
		 * Constructor.
		 */
		public function ColorSwatchList()
		{
			super();
			this.itemRendererFactory = defaultItemRendererFactory;
			this.addEventListener(TouchEvent.TOUCH, colorSwatchList_touchHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ColorSwatchList.globalStyleProvider;
		}

		/**
		 * The selected color value.
		 *
		 * @default 0
		 */
		public function get color():uint
		{
			if(this._selectedIndex < 0)
			{
				return 0;
			}
			return ColorSwatchData(this.selectedItem).color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._dataProvider === null)
			{
				return;
			}
			var itemCount:int = this._dataProvider.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:ColorSwatchData = this._dataProvider.getItemAt(i) as ColorSwatchData;
				if(item === null)
				{
					continue;
				}
				if(item.color === value)
				{
					this.selectedIndex = i;
					break;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			var columnCount:int = 6;
			if(SystemUtil.isDesktop)
			{
				columnCount = 18;
			}
			if(this._layout === null)
			{
				var layout:TiledRowsLayout = new TiledRowsLayout();
				layout.requestedColumnCount = columnCount;
				if(!SystemUtil.isDesktop)
				{
					layout.requestedRowCount = 6;
				}
				layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
				this.layout = layout;
				this.snapToPages = true;
			}
			if(this._dataProvider === null)
			{
				if(SystemUtil.isDesktop)
				{
					this.populateDesktopColors();
				}
				else
				{
					this.populateMobileColors();
				}
			}
			super.initialize();
		}

		/**
		 * @private
		 */
		protected function populateDesktopColors():void
		{
			var values:Vector.<ColorSwatchData> = new <ColorSwatchData>[];
			var index:int = 0;
			for(var i:int = 0; i <= 0xff; i += 0x0f)
			{
				var color:uint = (i << 16) + (i << 8) + i;
				values[index] = new ColorSwatchData(color);
				index++;
			}
			for(i = 0; i <= 0xff; i += 0x33)
			{
				for(var j:int = 0; j <= 0x66; j += 0x33)
				{
					for(var k:int = 0; k <= 0xff; k += 0x33)
					{
						color = (j << 16) + (k << 8) + i;
						values[index] = new ColorSwatchData(color);
						index++;
					}
				}
			}
			for(i = 0; i <= 0xff; i += 0x33)
			{
				for(j = 0x99; j <= 0xff; j += 0x33)
				{
					for(k = 0; k <= 0xff; k += 0x33)
					{
						color = (j << 16) + (k << 8) + i;
						values[index] = new ColorSwatchData(color);
						index++;
					}
				}
			}
			this.dataProvider = new ListCollection(values);
		}

		/**
		 * @private
		 */
		protected function populateMobileColors():void
		{
			var values:Vector.<ColorSwatchData> = new <ColorSwatchData>[];
			var index:int = 0;
			for(var i:int = 0; i <= 0xff; i += 0x0f)
			{
				var color:uint = (i << 16) + (i << 8) + i;
				values[index] = new ColorSwatchData(color);
				index++;
			}
			var primaryColors:Vector.<uint> = new <uint>
			[
				0x0000ff, 0x0055ff, 0x00aaff, 0x00ffff,
				0x00ffaa, 0x00ff55, 0x00ff00, 0x55ff00,
				0xaaff00, 0xffff00, 0xffaa00, 0xff5500,
				0xff0000, 0xff0055, 0xff00aa, 0xff00ff,
				0xaa00ff, 0x5500ff
			];
			for(i = 0; i < primaryColors.length; i++)
			{
				color = primaryColors[i];
				values[index] = new ColorSwatchData(color);
				index++;
			}
			for(i = 0; i <= 0xff; i += 0x33)
			{
				for(var j:int = 0; j <= 0x66; j += 0x33)
				{
					for(var k:int = 0; k <= 0xff; k += 0x33)
					{
						color = (i << 16) + (k << 8) + j;
						values[index] = new ColorSwatchData(color);
						index++;
					}
				}
				for(j = 0x99; j <= 0xff; j += 0x33)
				{
					for(k = 0; k <= 0xff; k += 0x33)
					{
						color = (i << 16) + (k << 8) + j;
						values[index] = new ColorSwatchData(color);
						index++;
					}
				}
			}
			this.dataProvider = new ListCollection(values);
		}

		/**
		 * @private
		 */
		protected function colorSwatchList_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch === null)
			{
				//hover out
				this.dispatchEventWith(Event.UPDATE);
				return;
			}
			if(touch.phase !== TouchPhase.HOVER)
			{
				return;
			}
			var target:DisplayObject = touch.target;
			while(target !== this && !(target is ColorSwatchItemRenderer) && this.contains(target))
			{
				target = target.parent;
			}
			if(target === this)
			{
				this.dispatchEventWith(Event.UPDATE);
				return;
			}
			var itemRenderer:ColorSwatchItemRenderer = ColorSwatchItemRenderer(target);
			var swatch:ColorSwatchData = ColorSwatchData(itemRenderer.data);
			this.dispatchEventWith(Event.UPDATE, false, swatch.color);
		}
	}
}
