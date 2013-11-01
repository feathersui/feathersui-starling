/**
 * Created with IntelliJ IDEA.
 * User: Jerry_Orta
 * Date: 11/1/13
 * Time: 8:04 AM
 * To change this template use File | Settings | File Templates.
 */
package feathers.controls {
import feathers.controls.text.StageTextTextEditorNoSoftKeyboard;
import feathers.core.ITextEditor;
import feathers.events.FeathersEventType;

import starling.display.DisplayObject;
import starling.events.Event;

public class TextInputNoSoftKeyboard extends TextInput {
    public function TextInputNoSoftKeyboard() {
        super();
    }

    /**
     * Creates and adds the <code>textEditor</code> sub-component and
     * removes the old instance, if one exists.
     *
     * <p>Meant for internal use, and subclasses may override this function
     * with a custom implementation.</p>
     *
     * @see #textEditor
     * @see #textEditorFactory
     */
    override protected function createTextEditor():void
    {
        if(this.textEditor)
        {
            this.removeChild(DisplayObject(this.textEditor), true);
            this.textEditor.removeEventListener(Event.CHANGE, textEditor_changeHandler);
            this.textEditor.removeEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
            this.textEditor.removeEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
            this.textEditor.removeEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
            this.textEditor = null;
        }

        const factory:Function = this._textEditorFactory != null ? this._textEditorFactory : defaultTextEditorFactoryNoSoftKeybaord;
        this.textEditor = ITextEditor(factory());
        this.textEditor.addEventListener(Event.CHANGE, textEditor_changeHandler);
        this.textEditor.addEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
        this.textEditor.addEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
        this.textEditor.addEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
        this.addChild(DisplayObject(this.textEditor));
    }

    /**
     * A function used by all UI controls that support text editor to
     * create an <code>ITextEditor</code> instance. You may replace the
     * default function with your own, if you prefer not to use the
     * <code>StageTextTextEditor</code>.
     *
     * <p>The function is expected to have the following signature:</p>
     * <pre>function():ITextEditor</pre>
     *
     * @see http://wiki.starling-framework.org/feathers/text-editors
     * @see feathers.core.ITextEditor
     */
    private static var defaultTextEditorFactoryNoSoftKeybaord:Function = function():ITextEditor
    {
        return new StageTextTextEditorNoSoftKeyboard();
    }


}
}
