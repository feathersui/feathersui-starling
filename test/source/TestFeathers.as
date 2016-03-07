package
{
	import feathers.tests.BasicButtonInternalStateTests;
	import feathers.tests.BasicButtonMeasurementTests;
	import feathers.tests.BasicButtonTests;
	import feathers.tests.BitmapFontTextEditorFocusTests;
	import feathers.tests.BottomDrawerPopUpContentManagerTests;
	import feathers.tests.ButtonFocusTests;
	import feathers.tests.ButtonGroupDataProviderEventsTests;
	import feathers.tests.ButtonGroupTests;
	import feathers.tests.ButtonInternalStateTests;
	import feathers.tests.ButtonMeasurementTests;
	import feathers.tests.ButtonTests;
	import feathers.tests.CalloutPopUpContentManagerTests;
	import feathers.tests.CalloutTests;
	import feathers.tests.ComponentLifecycleTests;
	import feathers.tests.DateTimeSpinnerTests;
	import feathers.tests.DefaultListItemRendererInternalStateTests;
	import feathers.tests.DrawersMeasurementTests;
	import feathers.tests.DrawersTests;
	import feathers.tests.DropDownPopUpContentManagerTests;
	import feathers.tests.FlowLayoutTests;
	import feathers.tests.FocusManagerEnabledTests;
	import feathers.tests.FocusManagerTests;
	import feathers.tests.GroupedListDataProviderTests;
	import feathers.tests.GroupedListFactoryIDFunctionTests;
	import feathers.tests.GroupedListRendererAddRemoveTests;
	import feathers.tests.GroupedListTests;
	import feathers.tests.HorizontalSpinnerLayoutTests;
	import feathers.tests.ImageLoaderInternalStateTests;
	import feathers.tests.ImageLoaderTests;
	import feathers.tests.ImageSkinTests;
	import feathers.tests.InvalidateTests;
	import feathers.tests.KeyToSelectTests;
	import feathers.tests.KeyToTriggerTests;
	import feathers.tests.LabelMeasurementTests;
	import feathers.tests.LayoutGroupHorizontalLayoutTests;
	import feathers.tests.LayoutGroupInternalStateTests;
	import feathers.tests.LayoutGroupTests;
	import feathers.tests.LayoutGroupVerticalLayoutTests;
	import feathers.tests.ListCollectionWithArrayTests;
	import feathers.tests.ListFactoryIDFunctionTests;
	import feathers.tests.ListRendererAddRemoveTests;
	import feathers.tests.ListTests;
	import feathers.tests.LongPressTests;
	import feathers.tests.MinAndMaxDimensionsTests;
	import feathers.tests.PageIndicatorMeasurementTests;
	import feathers.tests.PickerListTests;
	import feathers.tests.PopUpManagerFocusManagerTests;
	import feathers.tests.PopUpManagerTests;
	import feathers.tests.ProgressBarMeasurementTests;
	import feathers.tests.ProgressBarTests;
	import feathers.tests.RadioTests;
	import feathers.tests.ScreenNavigatorTests;
	import feathers.tests.ScrollBarHorizontalTests;
	import feathers.tests.ScrollContainerTests;
	import feathers.tests.ScrollerTests;
	import feathers.tests.SimpleScrollBarHorizontalTests;
	import feathers.tests.SliderHorizontalTests;
	import feathers.tests.StackScreenNavigatorTests;
	import feathers.tests.StageTextTextEditorFocusTests;
	import feathers.tests.TabBarEmptyDataProviderTests;
	import feathers.tests.TabBarTests;
	import feathers.tests.TapToSelectTests;
	import feathers.tests.TapToTriggerTests;
	import feathers.tests.TextAreaFocusTests;
	import feathers.tests.TextAreaInternalStateTests;
	import feathers.tests.TextAreaTests;
	import feathers.tests.TextBlockTextEditorFocusTests;
	import feathers.tests.TextFieldTextEditorFocusTests;
	import feathers.tests.TextInputFocusTests;
	import feathers.tests.TextInputInternalStateTests;
	import feathers.tests.TextInputMeasurementTests;
	import feathers.tests.TextInputTests;
	import feathers.tests.TextureCacheTests;
	import feathers.tests.TiledColumnsLayoutTests;
	import feathers.tests.TiledRowsLayoutTests;
	import feathers.tests.ToggleButtonFocusTests;
	import feathers.tests.ToggleButtonTests;
	import feathers.tests.ToggleGroupTests;
	import feathers.tests.ToggleSwitchTests;
	import feathers.tests.TokenListTests;
	import feathers.tests.VerticalCenteredPopUpContentManagerTests;
	import feathers.tests.VerticalLayoutTests;
	import feathers.tests.VerticalSpinnerLayoutTests;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.System;

	import org.flexunit.internals.TraceListener;
	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.FlexUnitCore;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	[SWF(width="960",height="640",frameRate="60",backgroundColor="#4a4137")]
	public class TestFeathers extends flash.display.Sprite
	{
		public static var starlingRoot:starling.display.Sprite;

		public function TestFeathers()
		{
			if(this.stage)
			{
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
			}

			this.loaderInfo.addEventListener(flash.events.Event.COMPLETE, loaderInfo_completeHandler);
		}

		private var _starling:Starling;
		private var _flexunit:FlexUnitCore;

		private function loaderInfo_completeHandler(event:flash.events.Event):void
		{
			Starling.multitouchEnabled = true;
			this._starling = new Starling(starling.display.Sprite, this.stage);
			this._starling.addEventListener(starling.events.Event.ROOT_CREATED, starling_rootCreatedHandler);
			this._starling.start();
		}

		private function starling_rootCreatedHandler(event:starling.events.Event):void
		{
			starlingRoot = starling.display.Sprite(this._starling.root);
			this._flexunit = new FlexUnitCore();
			this._flexunit.addListener(new TraceListener());
			this._flexunit.addListener(new CIListener());
			this._flexunit.addEventListener(FlexUnitCore.TESTS_COMPLETE, flexunit_testsCompleteHandler);
			this._flexunit.run(
			[
				//general component tests
				InvalidateTests,
				MinAndMaxDimensionsTests,
				ComponentLifecycleTests,
				
				//individual component tests
				BasicButtonTests,
				BasicButtonMeasurementTests,
				BasicButtonInternalStateTests,
				ButtonTests,
				ButtonInternalStateTests,
				ButtonFocusTests,
				ButtonMeasurementTests,
				ButtonGroupTests,
				ButtonGroupDataProviderEventsTests,
				CalloutTests,
				DateTimeSpinnerTests,
				DefaultListItemRendererInternalStateTests,
				DrawersTests,
				DrawersMeasurementTests,
				GroupedListTests,
				GroupedListDataProviderTests,
				GroupedListFactoryIDFunctionTests,
				GroupedListRendererAddRemoveTests,
				ImageLoaderTests,
				ImageLoaderInternalStateTests,
				LabelMeasurementTests,
				LayoutGroupTests,
				LayoutGroupInternalStateTests,
				ListTests,
				ListFactoryIDFunctionTests,
				ListRendererAddRemoveTests,
				PageIndicatorMeasurementTests,
				PickerListTests,
				ProgressBarTests,
				ProgressBarMeasurementTests,
				RadioTests,
				SimpleScrollBarHorizontalTests,
				ScreenNavigatorTests,
				ScrollBarHorizontalTests,
				ScrollContainerTests,
				ScrollerTests,
				SliderHorizontalTests,
				StackScreenNavigatorTests,
				TabBarTests,
				TabBarEmptyDataProviderTests,
				TextAreaTests,
				TextAreaInternalStateTests,
				TextInputTests,
				TextInputMeasurementTests,
				TextInputInternalStateTests,
				ToggleButtonTests,
				ToggleButtonFocusTests,
				ToggleGroupTests,
				ToggleSwitchTests,
				
				//layout tests
				FlowLayoutTests,
				LayoutGroupHorizontalLayoutTests,
				LayoutGroupVerticalLayoutTests,
				TiledRowsLayoutTests,
				TiledColumnsLayoutTests,
				VerticalLayoutTests,
				HorizontalSpinnerLayoutTests,
				VerticalSpinnerLayoutTests,

				//collections tests
				ListCollectionWithArrayTests,

				//focus tests
				FocusManagerEnabledTests,
				FocusManagerTests,
				PopUpManagerFocusManagerTests,
				TextInputFocusTests,
				TextAreaFocusTests,
				StageTextTextEditorFocusTests,
				TextFieldTextEditorFocusTests,
				BitmapFontTextEditorFocusTests,
				TextBlockTextEditorFocusTests,
				
				//misc
				PopUpManagerTests,
				TextureCacheTests,
				TapToTriggerTests,
				TapToSelectTests,
				LongPressTests,
				KeyToSelectTests,
				KeyToTriggerTests,
				TokenListTests,
				ImageSkinTests,
				DropDownPopUpContentManagerTests,
				BottomDrawerPopUpContentManagerTests,
				VerticalCenteredPopUpContentManagerTests,
				CalloutPopUpContentManagerTests,
			]);
		}

		private function flexunit_testsCompleteHandler(event:flash.events.Event):void
		{
			System.exit(0);
		}

	}
}