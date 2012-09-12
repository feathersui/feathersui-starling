/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.core
{
	/**
	 * A list of space-delimited tokens.
	 */
	public class TokenList
	{
		/**
		 * Constructor.
		 */
		public function TokenList()
		{
		}

		/**
		 * @private
		 * Storage for the tokens.
		 */
		protected var names:Vector.<String> = new <String>[];

		/**
		 * The tokens formated with space delimiters.
		 */
		public function get value():String
		{
			return names.join(" ");
		}

		/**
		 * @private
		 */
		public function set value(value:String):void
		{
			this.names.length = 0;
			this.names = Vector.<String>(value.split(" "));
		}

		/**
		 * The number of tokens in the list.
		 */
		public function get length():int
		{
			return this.names.length;
		}

		/**
		 * Returns the token at the specified index, or null, if there is no
		 * token at that index.
		 */
		public function item(index:int):String
		{
			if(index < 0 || index >= this.names.length)
			{
				return null;
			}
			return this.names[index];
		}

		/**
		 * Adds a token to the list. If the token already appears in the list,
		 * it will not be added again.
		 */
		public function add(name:String):void
		{
			const index:int = this.names.indexOf(name);
			if(index >= 0)
			{
				return;
			}
			this.names.push(name);
		}

		/**
		 * Removes a token from the list, if the token is in the list. If the
		 * token doesn't appear in the list, this call does nothing.
		 */
		public function remove(name:String):void
		{
			const index:int = this.names.indexOf(name);
			if(index < 0)
			{
				return;
			}
			this.names.splice(index,  1);
		}

		/**
		 * The token is added to the list if it doesn't appear in the list, or
		 * it is removed from the list if it is already in the list.
		 */
		public function toggle(name:String):void
		{
			const index:int = this.names.indexOf(name);
			if(index < 0)
			{
				this.names.push(name);
			}
			else
			{
				this.names.splice(index,  1);
			}
		}

		/**
		 * Determines if the specified token is in the list.
		 */
		public function contains(name:String):Boolean
		{
			return this.names.indexOf(name) >= 0;
		}

	}
}
