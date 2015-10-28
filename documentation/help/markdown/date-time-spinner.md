---
title: How to use the Feathers DateTimeSpinner component  
author: Josh Tynjala

---
# How to use the Feathers `DateTimeSpinner` component

The [`DateTimeSpinner`](../api-reference/feathers/controls/DateTimeSpinner.html) component allows the selection of a date, a time, or both a date and a time using a set of [`SpinnerList`](spinner-list.html) components.

<aside class="warn">This document is still being written. If you have any questions, please visit the [Feathers forum](http://forum.starling-framework.org/forum/feathers).</aside>

## The Basics

First, let's create a `DateTimeSpinner` control, set up its editing mode and its range of values, and add it to the display list.

``` code
var spinner:DateTimeSpinner = new DateTimeSpinner();
spinner.editingMode = DateTimeSpinner.EDITING_MODE_DATE;
spinner.minimum = new Date(1970, 0, 1);
spinner.maximum = new Date(2050, 11, 31);
spinner.value = new Date(2015, 10, 31);
this.addChild( spinner );
```

The [`value`](../api-reference/feathers/controls/DateTimeSpinner.html#value) property indicates the currently selected date and time, while the [`minimum`](../api-reference/feathers/controls/DateTimeSpinner.html#minimum) and [`maximum`](../api-reference/feathers/controls/DateTimeSpinner.html#maximum) properties establish a range of possible values. You may omit the `minimum` and `maximum` properties, and reasonable defaults will be chosen automatically.

The [`editingMode`](../api-reference/feathers/controls/DateTimeSpinner.html#editingMode) property determines how the date and time are displayed.

* [`DateTimeSpinner.EDITING_MODE_DATE`](../api-reference/feathers/controls/DateTimeSpinner.html#EDITING_MODE_DATE) displays only the date, without the time. The month and day are displayed in order based on the current locale.
* [`DateTimeSpinner.EDITING_MODE_TIME`](../api-reference/feathers/controls/DateTimeSpinner.html#EDITING_MODE_TIME) displays only the time, without the date. The time is displayed in either 12-hour or 24-hour format based on the current locale.
* [`DateTimeSpinner.EDITING_MODE_DATE_AND_TIME`](../api-reference/feathers/controls/DateTimeSpinner.html#EDITING_MODE_DATE_AND_TIME) displays both the date and the time. As with the previous mode, the current locale determines formatting.

## Related Links

-   [`feathers.controls.DateTimeSpinner` API Documentation](../api-reference/feathers/controls/DateTimeSpinner.html)