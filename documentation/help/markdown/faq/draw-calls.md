---
title: Why do Feathers component require so many draw calls? Aren't those bad?  
author: Josh Tynjala

---
# Why do Feathers components require so many draw calls? Aren't those bad?

Displaying a text renderer often results in a new draw call. Contrary to popular belief, many draw calls aren't necessarily bad. It's good to reduce them when you can, but they aren't going to bring your apps to screeching halts. Sometimes, more draw calls are actually better for performance. There are cases where CPU usage from ActionScript will be high enough to negatively affect frame rates. We can improve frame rates by putting a larger burden on the GPU in order to reduce the CPU usage. Feathers does this, and its level of performance in many cases wouldn't be possible without those extra draw calls.

From a technical standpoint, the Feathers `List` component performs well because classes like `Scale9Image` and `BitmapFontTextRenderer` use their own internal QuadBatch. A `QuadBatch` on the display list always requires an extra draw call. However, the `QuadBatch` is able to cache certain calculations that would otherwise need to be re-calculated every single frame for all of the separate Images that would be required without a `QuadBatch`. Using a `QuadBatch`, the CPU usage can be reduced, and the frame rate increases as a result.

Vector-based text capabilities provided by `flash.text.TextField`, Flash Text Engine (FTE), or Text Layout Framework (TLF) can only be moved to the GPU by rendering the text in software, drawing to `BitmapData` and uploading the pixels to a texture. Each one of these text objects that you want to display in Starling requires a separate texture. Each new texture will trigger a state change that requires another draw call. When using vector-based fonts, this is a limitation that has no good solution. You can switch to bitmap fonts, but that's not always possible. For instance, to display many of the world's languages, you simply cannot use bitmap fonts because there will be too many different individual characters to fit into texture memory.

------------------------------------------------------------------------

This is a detailed response to a [Frequently Asked Question](../faq.html) about [Feathers](../index.html).


