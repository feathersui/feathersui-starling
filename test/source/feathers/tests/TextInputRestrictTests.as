package feathers.tests
{
	import org.flexunit.Assert;
	import feathers.utils.text.TextInputRestrict;

	public class TextInputRestrictTests
	{
		[Test]
		public function testIsCharacterAllowedWithNullRestrict():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict();
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character with null restrict",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character with null restrict",
				restrict.isCharacterAllowed("A".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character with null restrict",
				restrict.isCharacterAllowed("0".charCodeAt(0)));
		}

		[Test]
		public function testIsCharacterAllowedWithSingleCharacter():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict("a");
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character that is the only one allowed",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character that is not allowed",
				restrict.isCharacterAllowed("b".charCodeAt(0)));
		}

		[Test]
		public function testIsCharacterAllowedWithExcludedSingleCharacter():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict("^a");
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character that is excluded",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character that is not excluded",
				restrict.isCharacterAllowed("b".charCodeAt(0)));
		}

		[Test]
		public function testIsCharacterAllowedWithRange():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict("a-z");
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("k".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character not in range a-z",
				restrict.isCharacterAllowed("A".charCodeAt(0)));
		}

		[Test]
		public function testIsCharacterAllowedWithExcludedRange():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict("^a-z");
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character in excluded range a-z",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character in excluded range a-z",
				restrict.isCharacterAllowed("k".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character not in excluded range a-z",
				restrict.isCharacterAllowed("A".charCodeAt(0)));
		}

		[Test]
		public function testIsCharacterAllowedWithMultipleRanges():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict("a-z0-9");
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("k".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range 0-9",
				restrict.isCharacterAllowed("3".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range 0-9",
				restrict.isCharacterAllowed("9".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character not in range",
				restrict.isCharacterAllowed("Z".charCodeAt(0)));
		}

		[Test]
		public function testIsCharacterAllowedWithMultipleRangesAndOneExcluded():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict("a-z^k-p");
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("g".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character in excluded range k-p",
				restrict.isCharacterAllowed("k".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character in excluded range k-p",
				restrict.isCharacterAllowed("m".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character not in range",
				restrict.isCharacterAllowed("9".charCodeAt(0)));
			Assert.assertFalse("TextInputRestrict: incorrectly allowed character not in range a-z",
				restrict.isCharacterAllowed("Z".charCodeAt(0)));
		}

		//issue #1605
		[Test]
		public function testIsCharacterAllowedWithRangeAndEscapedCharacters():void
		{
			var restrict:TextInputRestrict = new TextInputRestrict("a-z\\-\\^\\\\");
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("a".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded character in range a-z",
				restrict.isCharacterAllowed("g".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded allowed escaped character",
				restrict.isCharacterAllowed("-".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded allowed escaped character",
				restrict.isCharacterAllowed("^".charCodeAt(0)));
			Assert.assertTrue("TextInputRestrict: incorrectly excluded allowed escaped character",
				restrict.isCharacterAllowed("\\".charCodeAt(0)));
		}
	}
}
