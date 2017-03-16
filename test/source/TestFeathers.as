package
{
	import feathers.tests.AddOnFunctionStyleProviderTests;
	import feathers.tests.AlertMeasurementTests;
	import feathers.tests.AnchorLayoutTests;
	import feathers.tests.ArrayCollectionTests;
	import feathers.tests.BasicButtonInternalStateTests;
	import feathers.tests.BasicButtonMeasurementTests;
	import feathers.tests.BasicButtonTests;
	import feathers.tests.BitmapFontTextEditorFocusTests;
	import feathers.tests.BitmapFontTextRendererTests;
	import feathers.tests.BottomDrawerPopUpContentManagerTests;
	import feathers.tests.ButtonFocusTests;
	import feathers.tests.ButtonGroupDataProviderEventsTests;
	import feathers.tests.ButtonGroupMeasurementTests;
	import feathers.tests.ButtonGroupTests;
	import feathers.tests.ButtonInternalStateTests;
	import feathers.tests.ButtonMeasurementTests;
	import feathers.tests.ButtonTests;
	import feathers.tests.CalloutMeasurementTests;
	import feathers.tests.CalloutPopUpContentManagerTests;
	import feathers.tests.CalloutTests;
	import feathers.tests.ComponentLifecycleTests;
	import feathers.tests.ConditionalStyleProviderTests;
	import feathers.tests.DateTimeSpinnerTests;
	import feathers.tests.DefaultGroupedListHeaderOrFooterRendererMeasurementTests;
	import feathers.tests.DefaultListItemRendererInternalStateTests;
	import feathers.tests.DefaultListItemRendererMeasurementTests;
	import feathers.tests.DrawersMeasurementTests;
	import feathers.tests.DrawersTests;
	import feathers.tests.DropDownPopUpContentManagerTests;
	import feathers.tests.FlowLayoutTests;
	import feathers.tests.FocusManagerEnabledTests;
	import feathers.tests.FocusManagerTests;
	import feathers.tests.FunctionStyleProviderTests;
	import feathers.tests.GroupedListDataProviderTests;
	import feathers.tests.GroupedListFactoryIDFunctionTests;
	import feathers.tests.GroupedListRendererAddRemoveTests;
	import feathers.tests.GroupedListTests;
	import feathers.tests.HeaderInternalStateTests;
	import feathers.tests.HeaderMeasurementTests;
	import feathers.tests.HeaderTests;
	import feathers.tests.HorizontalLayoutTests;
	import feathers.tests.HorizontalSpinnerLayoutTests;
	import feathers.tests.ImageLoaderInternalStateTests;
	import feathers.tests.ImageLoaderTests;
	import feathers.tests.ImageSkinTests;
	import feathers.tests.InvalidateTests;
	import feathers.tests.KeyToSelectTests;
	import feathers.tests.KeyToTriggerTests;
	import feathers.tests.LabelMeasurementTests;
	import feathers.tests.LabelTests;
	import feathers.tests.LayoutGroupHorizontalLayoutTests;
	import feathers.tests.LayoutGroupInternalStateTests;
	import feathers.tests.LayoutGroupMeasurementTests;
	import feathers.tests.LayoutGroupTests;
	import feathers.tests.LayoutGroupVerticalLayoutTests;
	import feathers.tests.ListCollectionFilterTests;
	import feathers.tests.ListCollectionWithArrayTests;
	import feathers.tests.ListFactoryIDFunctionTests;
	import feathers.tests.ListRendererAddRemoveTests;
	import feathers.tests.ListTests;
	import feathers.tests.LongPressTests;
	import feathers.tests.MinAndMaxDimensionsTests;
	import feathers.tests.NumericStepperMeasurementTests;
	import feathers.tests.PageIndicatorMeasurementTests;
	import feathers.tests.PanelMeasurementTests;
	import feathers.tests.PickerListMeasurementTests;
	import feathers.tests.PickerListTests;
	import feathers.tests.PopUpManagerFocusManagerTests;
	import feathers.tests.PopUpManagerTests;
	import feathers.tests.ProgressBarMeasurementTests;
	import feathers.tests.ProgressBarTests;
	import feathers.tests.RadioTests;
	import feathers.tests.RestrictedStyleTests;
	import feathers.tests.ScaleTests;
	import feathers.tests.ScreenNavigatorMeasurementTests;
	import feathers.tests.ScreenNavigatorTests;
	import feathers.tests.ScrollBarHorizontalMeasurementTests;
	import feathers.tests.ScrollBarHorizontalTests;
	import feathers.tests.ScrollBarVerticalMeasurementTests;
	import feathers.tests.ScrollContainerMeasurementTests;
	import feathers.tests.ScrollContainerTests;
	import feathers.tests.ScrollerMeasurementTests;
	import feathers.tests.ScrollerTests;
	import feathers.tests.SimpleScrollBarHorizontalTests;
	import feathers.tests.SimpleScrollBarMeasurementTests;
	import feathers.tests.SliderHorizontalMeasurementTests;
	import feathers.tests.SliderHorizontalTests;
	import feathers.tests.SliderVerticalMeasurementTests;
	import feathers.tests.SpinnerListTests;
	import feathers.tests.StackScreenNavigatorMeasurementTests;
	import feathers.tests.StackScreenNavigatorTests;
	import feathers.tests.StageTextTextEditorFocusTests;
	import feathers.tests.StyleNameFunctionStyleProviderTests;
	import feathers.tests.StyleProviderRegistryTests;
	import feathers.tests.TabBarEmptyDataProviderTests;
	import feathers.tests.TabBarMeasurementTests;
	import feathers.tests.TabBarTests;
	import feathers.tests.TabNavigatorTests;
	import feathers.tests.TapToSelectTests;
	import feathers.tests.TapToTriggerTests;
	import feathers.tests.TextAreaFocusTests;
	import feathers.tests.TextAreaInternalStateTests;
	import feathers.tests.TextAreaTests;
	import feathers.tests.TextBlockTextEditorFocusTests;
	import feathers.tests.TextBlockTextRendererTests;
	import feathers.tests.TextFieldTextEditorFocusTests;
	import feathers.tests.TextFieldTextEditorTests;
	import feathers.tests.TextFieldTextRendererTests;
	import feathers.tests.TextInputFocusTests;
	import feathers.tests.TextInputInternalStateTests;
	import feathers.tests.TextInputMeasurementTests;
	import feathers.tests.TextInputTests;
	import feathers.tests.TextureCacheTests;
	import feathers.tests.TiledColumnsLayoutTests;
	import feathers.tests.TiledRowsLayoutTests;
	import feathers.tests.TimeLabelTests;
	import feathers.tests.ToggleButtonFocusTests;
	import feathers.tests.ToggleButtonInternalStateTests;
	import feathers.tests.ToggleButtonTests;
	import feathers.tests.ToggleGroupTests;
	import feathers.tests.ToggleSwitchMeasurementTests;
	import feathers.tests.ToggleSwitchTests;
	import feathers.tests.TokenListTests;
	import feathers.tests.TouchToStateTests;
	import feathers.tests.VectorCollectionTests;
	import feathers.tests.VerticalCenteredPopUpContentManagerTests;
	import feathers.tests.VerticalLayoutTests;
	import feathers.tests.VerticalSpinnerLayoutTests;
	import feathers.tests.XMLListCollectionTests;

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
				ScaleTests,
				RestrictedStyleTests,

				//individual component tests
				AlertMeasurementTests,
				BasicButtonTests,
				BasicButtonMeasurementTests,
				BasicButtonInternalStateTests,
				ButtonTests,
				ButtonInternalStateTests,
				ButtonFocusTests,
				ButtonMeasurementTests,
				ButtonGroupTests,
				ButtonGroupMeasurementTests,
				ButtonGroupDataProviderEventsTests,
				CalloutTests,
				CalloutMeasurementTests,
				DateTimeSpinnerTests,
				DefaultGroupedListHeaderOrFooterRendererMeasurementTests,
				DefaultListItemRendererMeasurementTests,
				DefaultListItemRendererInternalStateTests,
				DrawersTests,
				DrawersMeasurementTests,
				GroupedListTests,
				GroupedListDataProviderTests,
				GroupedListFactoryIDFunctionTests,
				GroupedListRendererAddRemoveTests,
				HeaderTests,
				HeaderMeasurementTests,
				HeaderInternalStateTests,
				ImageLoaderTests,
				ImageLoaderInternalStateTests,
				LabelTests,
				LabelMeasurementTests,
				LayoutGroupTests,
				LayoutGroupInternalStateTests,
				LayoutGroupMeasurementTests,
				ListTests,
				ListFactoryIDFunctionTests,
				ListRendererAddRemoveTests,
				NumericStepperMeasurementTests,
				PageIndicatorMeasurementTests,
				PanelMeasurementTests,
				PickerListTests,
				PickerListMeasurementTests,
				ProgressBarTests,
				ProgressBarMeasurementTests,
				RadioTests,
				SimpleScrollBarHorizontalTests,
				SimpleScrollBarMeasurementTests,
				ScreenNavigatorTests,
				ScreenNavigatorMeasurementTests,
				ScrollBarHorizontalTests,
				ScrollBarHorizontalMeasurementTests,
				ScrollBarVerticalMeasurementTests,
				ScrollContainerTests,
				ScrollContainerMeasurementTests,
				ScrollerTests,
				ScrollerMeasurementTests,
				SliderHorizontalTests,
				SliderHorizontalMeasurementTests,
				SliderVerticalMeasurementTests,
				SpinnerListTests,
				StackScreenNavigatorTests,
				StackScreenNavigatorMeasurementTests,
				TabBarTests,
				TabBarMeasurementTests,
				TabBarEmptyDataProviderTests,
				TabNavigatorTests,
				TextAreaTests,
				TextAreaInternalStateTests,
				TextInputTests,
				TextInputMeasurementTests,
				TextInputInternalStateTests,
				ToggleButtonTests,
				ToggleButtonInternalStateTests,
				ToggleButtonFocusTests,
				ToggleGroupTests,
				ToggleSwitchTests,
				ToggleSwitchMeasurementTests,

				//media tests
				TimeLabelTests,

				//layout tests
				AnchorLayoutTests,
				FlowLayoutTests,
				LayoutGroupHorizontalLayoutTests,
				LayoutGroupVerticalLayoutTests,
				TiledRowsLayoutTests,
				TiledColumnsLayoutTests,
				HorizontalLayoutTests,
				VerticalLayoutTests,
				HorizontalSpinnerLayoutTests,
				VerticalSpinnerLayoutTests,

				//collections tests
				ListCollectionWithArrayTests,
				ListCollectionFilterTests,
				ArrayCollectionTests,
				VectorCollectionTests,
				XMLListCollectionTests,

				//text renderers
				BitmapFontTextRendererTests,
				TextBlockTextRendererTests,
				TextFieldTextRendererTests,

				//text editors
				TextFieldTextEditorTests,

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

				//style providers and themes
				ConditionalStyleProviderTests,
				FunctionStyleProviderTests,
				StyleNameFunctionStyleProviderTests,
				AddOnFunctionStyleProviderTests,
				StyleProviderRegistryTests,

				//misc
				PopUpManagerTests,
				TextureCacheTests,
				TapToTriggerTests,
				TapToSelectTests,
				LongPressTests,
				TouchToStateTests,
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