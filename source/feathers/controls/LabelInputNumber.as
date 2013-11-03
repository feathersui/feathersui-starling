package feathers.controls
{
	import feathers.controls.Label;
	
	public class LabelInputNumber extends Label
	{
		public function LabelInputNumber()
		{
			super();
		}


        public function set value( value:Number ):void {
            this.text = String( value );
        }

        public function get value():Number {
            return Number( this.text );
        }
	}


}