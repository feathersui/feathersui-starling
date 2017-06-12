package feathers.tests
{
	import feathers.text.FontStylesSet;
	import starling.text.TextFormat;
	import org.flexunit.Assert;
	import starling.events.Event;

	public class FontStylesSetTests
	{
		private static const SAMPLE_STATE:String = "sample";
		private static const UNDEFINED_STATE:String = "noState";

		private var _fontStyles:FontStylesSet;

		[Before]
		public function prepare():void
		{
			this._fontStyles = new FontStylesSet();
		}

		[After]
		public function cleanup():void
		{
			this._fontStyles.dispose();
			this._fontStyles = null;
		}

		[Test]
		public function testSetFormatForState():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.setFormatForState(SAMPLE_STATE, format);
			var otherFormat:TextFormat = this._fontStyles.getFormatForState(SAMPLE_STATE);
			Assert.assertStrictlyEquals("FontStylesSet: getFormatForState() must return same value passed to setFormatForState().",
				format, otherFormat);
			otherFormat = this._fontStyles.getFormatForState(UNDEFINED_STATE);
			Assert.assertStrictlyEquals("FontStylesSet: getFormatForState() must return null for state that is undefined.",
				null, otherFormat);
		}

		[Test]
		public function testFormatAddAndRemoveEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.format = format;
			Assert.assertTrue("FontStylesSet: TextFormat add have Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
			this._fontStyles.dispose();
			Assert.assertFalse("FontStylesSet: TextFormat must remove Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
		}

		[Test]
		public function testFormatDispatchEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.format = format;
			var hasChanged:Boolean = false;
			this._fontStyles.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			format.bold = true;
			Assert.assertTrue("FontStylesSet: Must dispatch Event.CHANGE when TextFormat changes.",
				hasChanged);
		}

		[Test]
		public function testDisabledFormatAddAndRemoveEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.disabledFormat = format;
			Assert.assertTrue("FontStylesSet: TextFormat must add Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
			this._fontStyles.dispose();
			Assert.assertFalse("FontStylesSet: TextFormat must remove Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
		}

		[Test]
		public function testDisabledFormatDispatchEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.disabledFormat = format;
			var hasChanged:Boolean = false;
			this._fontStyles.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			format.bold = true;
			Assert.assertTrue("FontStylesSet: Must dispatch Event.CHANGE when TextFormat changes.",
				hasChanged);
		}

		[Test]
		public function testSelectedFormatAddAndRemoveEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.selectedFormat = format;
			Assert.assertTrue("FontStylesSet: TextFormat must add Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
			this._fontStyles.dispose();
			Assert.assertFalse("FontStylesSet: TextFormat must remove Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
		}

		[Test]
		public function testSelectedFormatDispatchEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.selectedFormat = format;
			var hasChanged:Boolean = false;
			this._fontStyles.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			format.bold = true;
			Assert.assertTrue("FontStylesSet: Must dispatch Event.CHANGE when TextFormat changes.",
				hasChanged);
		}

		[Test]
		public function testSetFormatForStateAddAndRemoveEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.setFormatForState(SAMPLE_STATE, format);
			Assert.assertTrue("FontStylesSet: TextFormat must add Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
			this._fontStyles.dispose();
			Assert.assertFalse("FontStylesSet: TextFormat must remove Event.CHANGE listener.",
				format.hasEventListener(Event.CHANGE));
		}

		[Test]
		public function testSetFormatForStateDispatchEvents():void
		{
			var format:TextFormat = new TextFormat();
			this._fontStyles.setFormatForState(SAMPLE_STATE, format);
			var hasChanged:Boolean = false;
			this._fontStyles.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			format.bold = true;
			Assert.assertTrue("FontStylesSet: Must dispatch Event.CHANGE when TextFormat changes.",
				hasChanged);
		}
	}	
}