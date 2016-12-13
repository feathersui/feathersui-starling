/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.display
{
	import starling.core.Starling;
	import starling.display.Stage;

	/**
	 * Finds the Starling instance that controls a particular
	 * <code>starling.display.Stage</code>.
	 *
	 * @productversion Feathers 2.2.0
	 */
	public function stageToStarling(stage:Stage):Starling
	{
		for each(var starling:Starling in Starling.all)
		{
			if(starling.stage === stage)
			{
				return starling;
			}
		}
		return null;
	}
}
