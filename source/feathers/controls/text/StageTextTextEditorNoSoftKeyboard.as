/**
 * Created with IntelliJ IDEA.
 * User: jerryorta
 * Date: 11/1/13
 * Time: 2:58 AM
 * To change this template use File | Settings | File Templates.
 */
package feathers.controls.text {
    import flash.events.SoftKeyboardEvent;
    
    import feathers.events.FeathersEventType;

    public class StageTextTextEditorNoSoftKeyboard extends StageTextTextEditor {
        public function StageTextTextEditorNoSoftKeyboard() {
            super();
        }

        /**
         * Creates and adds the <code>stageText</code> instance.
         *
         * <p>Meant for internal use, and subclasses may override this function
         * with a custom implementation.</p>
         */
        override protected function createStageText():void
        {
            super.createStageText();
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, stageText_softKeyboardActivatingHandler);

        }

        /**
         *
         * @private
         */
        protected function stageText_softKeyboardActivatingHandler(event:SoftKeyboardEvent):void
        {
            event.preventDefault();
            event.stopPropagation();

//            this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE, true);
        }

    }
}
