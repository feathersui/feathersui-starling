---
title: Adding tool-tips to Feathers components  
author: Josh Tynjala

---
# Adding tool-tips to Feathers components

In desktop apps, users expect to be able to hover their mouse over a UI control to see a tool tip with extra information about the control. Feathers provides optional tool-tip support with the [`ToolTipManager`](../api-reference/feathers/core/ToolTipManager.html) class, if your app needs these capabilities.

<aside class="info">In general, you should only enable tool-tip management in desktop apps. Mobile apps don't support mouse hover, so tool-tips will never be shown.</aside>

## Enabling the Tool-Tip Manager

To enable tool tips, only one line is required when your app first starts up:

``` code
ToolTipManager.setEnabledForStage( this.stage, true );
```

That's it! You will be able to set the [`toolTip`](../api-reference/feathers/core/FeathersControl.html#toolTip) property of any component, and the tool-tip will appear when the user hovers their mouse over the component.

If you are building an AIR desktop app with multiple Starling instances in multiple windows, you will need to enable tool-tips management for each stage with separate calls to [`setEnabledForStage()`](../api-reference/feathers/core/ToolTipManager.html#setEnabledForStage()).

## Setting a component's tool-tip

In the following example, a [`Button`](button.html) is given a tool-tip:

``` code
var button:Button = new Button();
button.label = "Click Me";
button.toolTip = "Some useful information";
```

All Feathers components have a [`toolTip`](../api-reference/feathers/core/FeathersControl.html#toolTip) property.

## Related Links

-   [`feathers.core.ToolTipManager` API Documentation](../api-reference/feathers/core/ToolTipManager.html)