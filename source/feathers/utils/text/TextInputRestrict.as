/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.text
{
	import flash.utils.Dictionary;

	/**
	 * Duplicates the functionality of the <code>restrict</code> property on
	 * <code>flash.text.TextField</code>.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of flash.text.TextField.restrict in Adobe's Flash Platform API Reference
	 */
	public class TextInputRestrict
	{
		/**
		 * @private
		 */
		protected static const REQUIRES_ESCAPE:Dictionary = new Dictionary();
		REQUIRES_ESCAPE[/\[/g] = "\\[";
		REQUIRES_ESCAPE[/\]/g] = "\\]";
		REQUIRES_ESCAPE[/\{/g] = "\\{";
		REQUIRES_ESCAPE[/\}/g] = "\\}";
		REQUIRES_ESCAPE[/\(/g] = "\\(";
		REQUIRES_ESCAPE[/\)/g] = "\\)";
		REQUIRES_ESCAPE[/\|/g] = "\\|";
		REQUIRES_ESCAPE[/\//g] = "\\/";
		REQUIRES_ESCAPE[/\./g] = "\\.";
		REQUIRES_ESCAPE[/\+/g] = "\\+";
		REQUIRES_ESCAPE[/\*/g] = "\\*";
		REQUIRES_ESCAPE[/\?/g] = "\\?";
		REQUIRES_ESCAPE[/\$/g] = "\\$";

		/**
		 * Constructor.
		 */
		public function TextInputRestrict(restrict:String = null)
		{
			this.restrict = restrict;
		}

		/**
		 * @private
		 */
		protected var _restrictStartsWithExclude:Boolean = false;

		/**
		 * @private
		 */
		protected var _restricts:Vector.<RegExp>

		/**
		 * @private
		 */
		private var _restrict:String;

		/**
		 * Indicates the set of characters that a user can input.
		 *
		 * <p>In the following example, the text is restricted to numbers:</p>
		 *
		 * <listing version="3.0">
		 * object.restrict = "0-9";</listing>
		 *
		 * @default null
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of flash.text.TextField.restrict in Adobe's Flash Platform API Reference
		 */
		public function get restrict():String
		{
			return this._restrict;
		}

		/**
		 * @private
		 */
		public function set restrict(value:String):void
		{
			if(this._restrict === value)
			{
				return;
			}
			this._restrict = value;
			if(value)
			{
				if(this._restricts)
				{
					this._restricts.length = 0;
				}
				else
				{
					this._restricts = new <RegExp>[];
				}
				if(this._restrict === "")
				{
					this._restricts.push(/^$/);
				}
				else if(this._restrict)
				{
					var startIndex:int = 0;
					var isExcluding:Boolean = value.indexOf("^") === 0;
					this._restrictStartsWithExclude = isExcluding;
					do
					{
						var nextStartIndex:int = value.indexOf("^", startIndex + 1);
						while(nextStartIndex !== -1 && value.charAt(nextStartIndex - 1) === "\\")
						{
							//this is an escaped caret, so skip it
							nextStartIndex = value.indexOf("^", nextStartIndex + 1);
						}
						if(nextStartIndex >= 0)
						{
							var partialRestrict:String = value.substr(startIndex, nextStartIndex - startIndex);
							this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
						}
						else
						{
							partialRestrict = value.substr(startIndex)
							this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
							break;
						}
						startIndex = nextStartIndex;
						isExcluding = !isExcluding;
					}
					while(true)
				}
			}
			else
			{
				this._restricts = null;
			}
		}

		/**
		 * Accepts a character code and determines if it is allowed or not.
		 */
		public function isCharacterAllowed(charCode:int):Boolean
		{
			if(!this._restricts)
			{
				return true;
			}
			var character:String = String.fromCharCode(charCode);
			var isExcluding:Boolean = this._restrictStartsWithExclude;
			var isIncluded:Boolean = isExcluding;
			var restrictCount:int = this._restricts.length;
			for(var i:int = 0; i < restrictCount; i++)
			{
				var restrict:RegExp = this._restricts[i];
				if(isExcluding)
				{
					isIncluded = isIncluded && restrict.test(character);
				}
				else
				{
					isIncluded = isIncluded || restrict.test(character);
				}
				isExcluding = !isExcluding;
			}
			return isIncluded;
		}

		/**
		 * Accepts a string of characters and filters out characters that are
		 * not allowed.
		 */
		public function filterText(value:String):String
		{
			if(!this._restricts)
			{
				return value;
			}
			var textLength:int = value.length;
			var restrictCount:int = this._restricts.length;
			for(var i:int = 0; i < textLength; i++)
			{
				var character:String = value.charAt(i);
				var isExcluding:Boolean = this._restrictStartsWithExclude;
				var isIncluded:Boolean = isExcluding;
				for(var j:int = 0; j < restrictCount; j++)
				{
					var restrict:RegExp = this._restricts[j];
					if(isExcluding)
					{
						isIncluded = isIncluded && restrict.test(character);
					}
					else
					{
						isIncluded = isIncluded || restrict.test(character);
					}
					isExcluding = !isExcluding;
				}
				if(!isIncluded)
				{
					value = value.substr(0, i) + value.substr(i + 1);
					i--;
					textLength--;
				}
			}
			return value;
		}

		/**
		 * @private
		 */
		protected function createRestrictRegExp(restrict:String, isExcluding:Boolean):RegExp
		{
			if(!isExcluding && restrict.indexOf("^") === 0)
			{
				//unlike regular expressions, which always treat ^ as excluding,
				//restrict uses ^ to swap between excluding and including.
				//if we're including, we need to remove ^ for the regexp
				restrict = restrict.substr(1);
			}
			//we need to do backslash first. otherwise, we'll get duplicates.
			//however, skip backslashes that are escaping -, ^, and \.
			restrict = restrict.replace(/\\(?=[^\-\^\\])/g, "\\\\");
			for(var key:Object in REQUIRES_ESCAPE)
			{
				var keyRegExp:RegExp = key as RegExp;
				var value:String = REQUIRES_ESCAPE[keyRegExp] as String;
				restrict = restrict.replace(keyRegExp, value);
			}
			return new RegExp("[" + restrict + "]");
		}
	}
}
