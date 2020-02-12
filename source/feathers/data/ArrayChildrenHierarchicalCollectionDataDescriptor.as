/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	/**
	 * A hierarchical data descriptor where children are defined as arrays in a
	 * property defined on each branch. The property name defaults to <code>"children"</code>,
	 * but it may be customized.
	 *
	 * <p>The basic structure of the data source takes the following form. The
	 * root must always be an Array.</p>
	 * <pre>
	 * [
	 *     {
	 *         text: "Branch 1",
	 *         children:
	 *         [
	 *             { text: "Child 1-1" },
	 *             { text: "Child 1-2" }
	 *         ]
	 *     },
	 *     {
	 *         text: "Branch 2",
	 *         children:
	 *         [
	 *             { text: "Child 2-1" },
	 *             { text: "Child 2-2" },
	 *             { text: "Child 2-3" }
	 *         ]
	 *     }
	 * ]</pre>
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ArrayChildrenHierarchicalCollectionDataDescriptor implements IHierarchicalCollectionDataDescriptor
	{
		/**
		 * Constructor.
		 */
		public function ArrayChildrenHierarchicalCollectionDataDescriptor()
		{
		}

		/**
		 * The field used to access the Array of a branch's children.
		 */
		public var childrenField:String = "children";

		/**
		 * @inheritDoc
		 */
		public function getLength(data:Object, ...rest:Array):int
		{
			var branch:Array = data as Array;
			var indexCount:int = rest.length;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}

			return branch.length;
		}

		/**
		 * @inheritDoc
		 */
		public function getLengthAtLocation(data:Object, location:Vector.<int> = null):int
		{
			var branch:Array = data as Array;
			if(location !== null)
			{
				var indexCount:int = location.length;
				for(var i:int = 0; i < indexCount; i++)
				{
					var index:int = location[i];
					branch = branch[index][childrenField] as Array;
				}
			}
			return branch.length;
		}

		/**
		 * @inheritDoc
		 */
		public function getItemAt(data:Object, index:int, ...rest:Array):Object
		{
			rest.insertAt(0, index);
			var branch:Array = data as Array;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			var lastIndex:int = rest[indexCount] as int;
			return branch[lastIndex];
		}

		/**
		 * @inheritDoc
		 */
		public function getItemAtLocation(data:Object, location:Vector.<int>):Object
		{
			if(location === null || location.length == 0)
			{
				return null;
			}
			var branch:Array = data as Array;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + location);
				}
			}
			var lastIndex:int = location[indexCount];
			return branch[lastIndex];
		}

		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:Object, item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			var branch:Array = data as Array;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			var lastIndex:int = rest[indexCount] as int;
			branch[lastIndex] = item;
		}

		/**
		 * @inheritDoc
		 */
		public function setItemAtLocation(data:Object, item:Object, location:Vector.<int>):void
		{
			if(location === null || location.length == 0)
			{
				throw new RangeError("Branch not found at location: " + location);
			}
			var branch:Array = data as Array;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + location);
				}
			}
			var lastIndex:int = location[indexCount];
			branch[lastIndex] = item;
		}

		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:Object, item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			var branch:Array = data as Array;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			var lastIndex:int = rest[indexCount] as int;
			branch.insertAt(lastIndex, item);
		}

		/**
		 * @inheritDoc
		 */
		public function addItemAtLocation(data:Object, item:Object, location:Vector.<int>):void
		{
			if(location === null || location.length == 0)
			{
				throw new RangeError("Branch not found at location: " + location);
			}
			var branch:Array = data as Array;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + location);
				}
			}
			var lastIndex:int = location[indexCount];
			branch.insertAt(lastIndex, item);
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAt(data:Object, index:int, ...rest:Array):Object
		{
			rest.insertAt(0, index);
			var branch:Array = data as Array;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			var lastIndex:int = rest[indexCount] as int;
			return branch.removeAt(lastIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAtLocation(data:Object, location:Vector.<int>):Object
		{
			if(location === null || location.length == 0)
			{
				throw new RangeError("Branch not found at location: " + location);
			}
			var branch:Array = data as Array;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + location);
				}
			}
			var lastIndex:int = location[indexCount];
			return branch.removeAt(lastIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAll(data:Object):void
		{
			var branch:Array = data as Array;
			branch.length = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function getItemLocation(data:Object, item:Object, result:Vector.<int> = null, ...rest:Array):Vector.<int>
		{
			if(!result)
			{
				result = new <int>[];
			}
			else
			{
				result.length = 0;
			}
			var branch:Array = data as Array;
			var restCount:int = rest.length;
			for(var i:int = 0; i < restCount; i++)
			{
				var index:int = rest[i] as int;
				result[i] = index;
				branch = branch[index][childrenField] as Array;
			}

			var isFound:Boolean = this.findItemInBranch(branch, item, result);
			if(!isFound)
			{
				result.length = 0;
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function isBranch(node:Object):Boolean
		{
			if(node === null)
			{
				return false;
			}
			return node.hasOwnProperty(this.childrenField) && node[this.childrenField] is Array;
		}

		/**
		 * @private
		 */
		protected function findItemInBranch(branch:Array, item:Object, result:Vector.<int>):Boolean
		{
			var index:int = branch.indexOf(item);
			if(index >= 0)
			{
				result.push(index);
				return true;
			}

			var branchLength:int = branch.length;
			for(var i:int = 0; i < branchLength; i++)
			{
				var branchItem:Object = branch[i];
				if(this.isBranch(branchItem))
				{
					result.push(i);
					var isFound:Boolean = this.findItemInBranch(branchItem[childrenField] as Array, item, result);
					if(isFound)
					{
						return true;
					}
					result.pop();
				}
			}
			return false;
		}
	}
}
