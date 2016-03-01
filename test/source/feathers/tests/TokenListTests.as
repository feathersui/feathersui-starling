package feathers.tests
{
	import feathers.core.TokenList;

	import org.flexunit.Assert;

	public class TokenListTests
	{
		private static const TOKEN1:String = "token1";
		private static const TOKEN2:String = "token-two";
		private static const FAKE_TOKEN:String = "fake-token";
		private static const EMPTY_STRING:String = "";
		private static const DELIMITER:String = " ";
		
		private var _tokenList:TokenList;

		[Before]
		public function prepare():void
		{
			this._tokenList = new TokenList();
		}

		[After]
		public function cleanup():void
		{
			this._tokenList = null;
		}
		
		[Test]
		public function testEmptyValue():void
		{
			Assert.assertStrictlyEquals("Empty TokenList value is not empty string with no tokens", EMPTY_STRING, this._tokenList.value);
		}

		[Test]
		public function testEmptyLength():void
		{
			Assert.assertStrictlyEquals("Empty TokenList length is not 0 with no tokens", 0, this._tokenList.length);
		}

		[Test]
		public function testContainsWithoutAdding():void
		{
			Assert.assertFalse("TokenList contains() incorrectly returns true for a token that was not added", this._tokenList.contains(FAKE_TOKEN));
		}

		[Test]
		public function testContainsAfterAdding():void
		{
			this._tokenList.add(TOKEN1);
			Assert.assertTrue("TokenList contains() incorrectly returns false for a token that was added", this._tokenList.contains(TOKEN1));
		}

		[Test]
		public function testContainsAfterToggle():void
		{
			this._tokenList.toggle(TOKEN1);
			Assert.assertTrue("TokenList contains() incorrectly returns false for a token that was toggled", this._tokenList.contains(TOKEN1));
		}

		[Test]
		public function testContainsAfterToggleTwice():void
		{
			this._tokenList.toggle(TOKEN1);
			this._tokenList.toggle(TOKEN1);
			Assert.assertFalse("TokenList contains() incorrectly returns true for a token that was toggled twice", this._tokenList.contains(TOKEN1));
		}

		[Test]
		public function testValueAfterAdding():void
		{
			this._tokenList.add(TOKEN1);
			Assert.assertStrictlyEquals("TokenList value incorrect after adding one token", TOKEN1, this._tokenList.value);
		}

		[Test]
		public function testLengthAfterAdding():void
		{
			this._tokenList.add(TOKEN1);
			Assert.assertStrictlyEquals("TokenList value incorrect after adding one token", 1, this._tokenList.length);
		}

		[Test]
		public function testItemAfterAdding():void
		{
			this._tokenList.add(TOKEN1);
			Assert.assertStrictlyEquals("TokenList value incorrect after adding one token", TOKEN1, this._tokenList.item(0));
		}

		[Test]
		public function testContainsAfterAddingAndRemoving():void
		{
			this._tokenList.add(TOKEN1);
			this._tokenList.remove(TOKEN1);
			Assert.assertFalse("TokenList contains() incorrectly returns true for a token that was added, then removed", this._tokenList.contains(TOKEN1));
		}

		[Test]
		public function testValueAfterAddingAndRemoving():void
		{
			this._tokenList.add(TOKEN1);
			this._tokenList.remove(TOKEN1);
			Assert.assertStrictlyEquals("TokenList value incorrect after removing a token", EMPTY_STRING, this._tokenList.value);
		}

		[Test]
		public function testValueAfterAddingTwoTokens():void
		{
			this._tokenList.add(TOKEN1);
			this._tokenList.add(TOKEN2);
			Assert.assertStrictlyEquals("TokenList value incorrect after adding two tokens", TOKEN1 + DELIMITER + TOKEN2, this._tokenList.value);
		}

		[Test]
		public function testItemAfterAddingTwoTokens():void
		{
			this._tokenList.add(TOKEN1);
			this._tokenList.add(TOKEN2);
			Assert.assertStrictlyEquals("TokenList item(0) incorrect after adding two tokens", TOKEN1, this._tokenList.item(0));
			Assert.assertStrictlyEquals("TokenList item(1) incorrect after adding two tokens", TOKEN2, this._tokenList.item(1));
		}

		[Test]
		public function testLengthAfterAddingTwoTokens():void
		{
			this._tokenList.add(TOKEN1);
			this._tokenList.add(TOKEN2);
			Assert.assertStrictlyEquals("TokenList length incorrect after adding two tokens", 2, this._tokenList.length);
		}

		[Test]
		public function testContainsAfterSettingValueWithOneToken():void
		{
			this._tokenList.value = TOKEN1;
			Assert.assertTrue("TokenList contains() incorrectly returns false for a token that was set with value property", this._tokenList.contains(TOKEN1));
		}

		[Test]
		public function testContainsAfterSettingValueWithTwoTokens():void
		{
			this._tokenList.value = TOKEN1 + DELIMITER + TOKEN2;
			Assert.assertTrue("TokenList contains() incorrectly returns false for the first token that was set with value property", this._tokenList.contains(TOKEN1));
			Assert.assertTrue("TokenList contains() incorrectly returns false for the second token that was set with value property", this._tokenList.contains(TOKEN2));
		}
	}
}
