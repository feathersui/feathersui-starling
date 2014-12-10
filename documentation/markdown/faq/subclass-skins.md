# FAQ: Why don't I see skins when I subclass a Feathers component?

Subclasses shouldn't necessarily have the same skins as their superclass. For instance, DefaultListItemRenderer and Check both extend Button, but they don't look very much like buttons. If you want a subclass to have the same skins as its superclass, you should [extend the theme](../extending-themes.html) and tell it to use the same initializer function for the subclass that is defined for the superclass.

------------------------------------------------------------------------

This is a detailed response to a [Frequently Asked Question](../faq.html) about [Feathers](../start.html).


