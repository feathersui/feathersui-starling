package feathers.examples.todos
{
	import flash.utils.IExternalizable;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public class TodoItem implements IExternalizable
	{
		public function TodoItem(description:String = null, isCompleted:Boolean = false)
		{
			this.description = description;
			this.isCompleted = isCompleted;
		}

		public var description:String;
		public var isCompleted:Boolean;

		public function writeExternal(output:IDataOutput):void
		{
			output.writeBoolean(this.isCompleted);
			output.writeUTF(this.description);
		}

		public function readExternal(input:IDataInput):void
		{
			this.isCompleted = input.readBoolean();
			this.description = input.readUTF();
		}
	}
}
