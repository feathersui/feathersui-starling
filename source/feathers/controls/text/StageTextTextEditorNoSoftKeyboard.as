/**
 * Created with IntelliJ IDEA.
 * User: jerryorta
 * Date: 11/1/13
 * Time: 2:58 AM
 * To change this template use File | Settings | File Templates.
 */
package feathers.controls.text {
    import feathers.text.StageTextField;

    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.SoftKeyboardEvent;
    import flash.utils.getDefinitionByName;

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
            this._stageTextIsComplete = false;
            var StageTextType:Class;
            var initOptions:Object;
            try
            {
                StageTextType = Class(getDefinitionByName("flash.text.StageText"));
                const StageTextInitOptionsType:Class = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
                initOptions = new StageTextInitOptionsType(this._multiline);
            }
            catch(error:Error)
            {
                StageTextType = StageTextField;
                initOptions = { multiline: this._multiline };
            }
            this.stageText = new StageTextType(initOptions);
            this.stageText.visible = false;
            this.stageText.addEventListener(flash.events.Event.CHANGE, stageText_changeHandler);
            this.stageText.addEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
            this.stageText.addEventListener(KeyboardEvent.KEY_UP, stageText_keyUpHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, stageText_softKeyboardActivateHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, stageText_softKeyboardActivatingHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, stageText_softKeyboardDeactivateHandler);
            this.stageText.addEventListener(flash.events.Event.COMPLETE, stageText_completeHandler);
            this.invalidate();
        }

        /**
         *
         * @private
         */
        protected function stageText_softKeyboardActivatingHandler(event:SoftKeyboardEvent):void
        {
            event.preventDefault();
            event.stopPropagation();
        }

    }
}
