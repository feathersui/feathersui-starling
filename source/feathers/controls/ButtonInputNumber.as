/**
 * Created with IntelliJ IDEA.
 * User: jerryorta
 * Date: 9/7/13
 * Time: 6:47 PM
 * To change this template use File | Settings | File Templates.
 */
package feathers.controls {
    import feathers.controls.Button;

    public class ButtonInputNumber extends Button {

        /**
         * An alternate name to use with Button to allow a theme to give it
         * a more prominent, "call-to-action" style. If a theme does not provide
         * a skin for the call-to-action button, the theme will automatically
         * fall back to using the default button skin.
         *
         * <p>An alternate name should always be added to a component's
         * <code>nameList</code> before the component is added to the stage for
         * the first time.</p>
         *
         * <p>In the following example, the call-to-action style is applied to
         * a button:</p>
         *
         * <listing version="3.0">
         * var button:Button = new Button();
         * button.nameList.add( Button.ALTERNATE_NAME_GRAPH_AXIS_INPUT_BUTTON );
         * this.addChild( button );</listing>
         *
         * @see feathers.core.IFeathersControl#nameList
         */
        public static const ALTERNATE_NAME_GRAPH_AXIS_INPUT_BUTTON:String = "feathers-graph-axis-input-button";

        /**
         * Identifier for the button's up state. Can be used for styling purposes.
         *
         * @see #stateToSkinFunction
         * @see #stateToIconFunction
         * @see #stateToLabelPropertiesFunction
         */
        public static const STATE_UP:String = "up";

        /**
         * Identifier for the button's down state. Can be used for styling purposes.
         *
         * @see #stateToSkinFunction
         * @see #stateToIconFunction
         * @see #stateToLabelPropertiesFunction
         */
        public static const STATE_DOWN:String = "down";

        /**
         * Identifier for the button's hover state. Can be used for styling purposes.
         *
         * @see #stateToSkinFunction
         * @see #stateToIconFunction
         * @see #stateToLabelPropertiesFunction
         */
        public static const STATE_HOVER:String = "hover";

        /**
         * Identifier for the button's disabled state. Can be used for styling purposes.
         *
         * @see #stateToSkinFunction
         * @see #stateToIconFunction
         * @see #stateToLabelPropertiesFunction
         */
        public static const STATE_DISABLED:String = "disabled";

        public function ButtonInputNumber() {
            super();
        }

        public function set value( value:Number ):void {
            this.label = String( value );
        }

        public function get value():Number {
            return Number( this.label );
        }
    }
}
