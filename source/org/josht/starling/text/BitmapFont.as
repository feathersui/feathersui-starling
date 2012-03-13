package org.josht.starling.text
{
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	
	public class BitmapFont extends starling.text.BitmapFont
	{
		private var mBase:Number;
		
		public function BitmapFont(texture:Texture, fontXml:XML=null)
		{
			super(texture, fontXml);
			if(fontXml)
			{
				parseFontXml(fontXml);
			}
		}
		
		private function parseFontXml(fontXml:XML):void
		{
			mBase = parseFloat(fontXml.common.attribute("base"));
		}
		
		public function get base():Number { return mBase; }
		public function set base(value:Number):void { mBase = value; }
	}
}