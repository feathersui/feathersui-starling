/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * A list of space-delimited tokens. Obviously, since they are delimited by
	 * spaces, tokens cannot contain spaces.
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
		 * The tokens formatted with space delimiters.
		 *
		 * @default ""
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
