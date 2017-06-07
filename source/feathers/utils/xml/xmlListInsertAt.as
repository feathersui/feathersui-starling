/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.xml
{
	/**
	 * Adds an XML value to an XMLList at a specific index.
	 *
	 * @productversion Feathers 3.3.0
	 */
	public function xmlListInsertAt(xmlList:XMLList, index:int, xmlToInsert:XML):XMLList
	{
		var listLength:int = xmlList.length();
		//we can't use insertChildAfter() or insertChildAfter() directly on
		//the XMLList, so we add it to an XML and insert there instead
		var wrapper:XML = <wrapper/>;
		wrapper.appendChild(xmlList);
		if(index === listLength)
		{
			var lastItem:XML = xmlList[index - 1];
			wrapper.insertChildAfter(lastItem, xmlToInsert);
		}
		else
		{
			var currentItem:XML = xmlList[index];
			wrapper.insertChildBefore(currentItem, xmlToInsert);
		}
		return wrapper.elements();
	}
}