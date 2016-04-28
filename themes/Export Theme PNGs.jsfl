var folder = fl.browseForFolderURL("Select a folder to export theme assets");

var libraryItems = fl.getDocumentDOM().library.items;
var libraryItemsCount = libraryItems.length;

var otherDocument = fl.createDocument("timeline");

for(var i = 0; i < libraryItemsCount; i++)
{
	var item = libraryItems[i];
	if(item.itemType !== "movie clip")
	{
		continue;
	}
	if(item.name.indexOf("Export/") !== 0)
	{
		continue;
	}
	fl.copyLibraryItem(document.pathURI, item.name);
	otherDocument.clipPaste(true);
	var selectedItem = otherDocument.selection[0];
	var itemName = item.name.substr("Export/".length);
	var exportPath = folder + "/" + itemName + "0000.png";
	otherDocument.exportInstanceToPNGSequence(exportPath);
	otherDocument.deleteSelection();
}
otherDocument.close(false);