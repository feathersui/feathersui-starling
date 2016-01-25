---
title: Why do Feathers component require so many draw calls? Aren't those bad?  
author: Josh Tynjala

---
# Why do Feathers components require so many draw calls? Aren't those bad?

Displaying a text renderer often results in a new draw call. Contrary to popular belief, many draw calls aren't necessarily bad. It's good to reduce them when you can, but they aren't going to bring your apps to screeching halts. Sometimes, more draw calls are actually better for performance. There are cases where CPU usage from ActionScript will be high enough to negatively affect frame rates. We can improve frame rates by putting a larger burden on the GPU in order to reduce the CPU usage. Feathers does this, and its level of performance in many cases wouldn't be possible without those extra draw calls.

Vector-based text capabilities provided by [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html), Flash Text Engine (FTE), or Text Layout Framework (TLF) can only be moved to the GPU by rendering the text in software, drawing to [`flash.display.BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploading the pixels to a texture. Each one of these text objects that you want to display in Starling requires a separate texture. Each new texture will trigger a state change that requires another draw call. When using vector-based fonts, this is a limitation that has no good solution. You can switch to bitmap fonts, but that's not always possible. For instance, to display many of the world's languages, you simply cannot use bitmap fonts because there will be too many different individual characters to fit into texture memory.