---
title: Feathers coding conventions for contributors  
author: Josh Tynjala

---
# Feathers coding conventions for contributors

This is the code formatting style used within the [Feathers](index.html) library. When contributing code to Feathers, you are required to use this style. [Pull Requests](https://help.github.com/articles/using-pull-requests) to the [Feathers project on Github](https://github.com/joshtynjala/feathers) that are formatted with a different style will be rejected. The author respects that you may have your own personal style, and the author would attempt to follow your style if he were to contribute to your open source project. Save him some time so that he doesn't need to manually reformat your contributed code.

If you are not contributing code to Feathers, then please feel no obligation to follow this style guide when working with the library. This guide is aimed at developers who wish to contribute bug fixes and enhancements to Feathers.

The terms "public" and "private" are used below in a general sense. When the specific `public` or `private` namespace is referenced, it will be clearly styled. When not marked as a namespace, public refers to any API that is meant to be exposed to someone using a particular class. It may include things like `public` members and `protected` members that are meant to be accessed in subclasses. Similarly, private refers to APIs that are meant to be used only internally. Private APIs may be part of the `protected` namespace, but using these APIs in subclasses is an at-your-own-risk convenience only.

## Whitespace

-   Use tabs to indent lines of code. Do not use spaces for indentation.

-   Place one space before and after operators like +, -, \*, /, ?, :, \<, \>, ==, etc.

-   Place no spaces between if/for/while/etc. and the opening parenthesis.

-   One empty line should appear between functions.

-   All blocks should be indented by one tab more than their parent block.

## Line Length

-   Try to keep lines shorter than 80 characters. If a statement is longer than 80 characters, try to break it before 80, and continue on the next line with one indent more than the first line.

-   Particularly messy `if` statements should be organized with extra parentheses and new lines to make them as readable as possible. It may be better to break up parts into separate variables.

## Braces

-   All opening braces `{` should be placed on a new line. Braces should not appear at the end of the line.

-   All if/for/while and other constructs must always use braces, even if the language considers them optional for content that is only one line.

## Naming

-   Names should be descriptive and clear. Extreme brevity is not a goal.

-   When an API is similar to one in Apache Flex or in Adobe's ActionScript 3.0 components for Flash Professional, the same name or a similar one is recommended for use in Feathers.

-   Names should not be abbreviated, in most cases. Commonly recognized acronyms are generally acceptable. Acronyms should have every letter capitalized.

-   Classes should use `CamelCaseNames`, and they must start with a capital letter.

-   Variable and functions should use `camelCaseNames`, and they must start with a lower-case letter.

-   However, private member variables or variables associated with a getter or setter should start with an underscore `_` followed by a lower-case letter.

## Access Levels

-   In general, properties and methods should be `public` or `protected`. Use of `private` is discouraged because it limits developers trying to extend components.

-   Custom namespaces are strongly discouraged.

## Class Organization

In general, classes should be organized in the following manner:

1.  `static` Variables

2.  `static` Functions

3.  Constructor

4.  Member Variables and Properties

5.  `public` Member Functions

6.  `protected` Member Functions

7.  `private` Member Functions

### Additional Notes on Class Organization

-   Public getters and setters should appear immediately after the private variable that they expose.

-   In general, within a function category (such as `public` or `protected`), overridden functions should appear first, followed by new functions, followed by event listeners. If there's a mix of event listeners and signal listeners, signal listeners should appear before event listeners.

-   Static functions should follow the same access level ordering as member functions.

## The this keyword

The `this` keyword should be used to reference member variables and functions. The author is particularly serious about this one, in case you didn't notice when you looked at the Feathers source code.

## Documentation

-   Use [asdoc comments](http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bb7b-7fed.html) for all public APIs.

-   Mark private APIs `@private` so that they are hidden from the generated HTML. If needed, they may still contain a description, but it will only be seen when reading the source code.

-   Use `<code></code>` tags when referring to specific classes, variables, properties, and functions in your descriptions.

-   Consider adding a `@see` tag when you refer to other public APIs or classes.

-   When referring to a measurement of some sort, such as dimensions or time, *always* include the unit, such as pixels or seconds.


