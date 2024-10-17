-ifndef(cfg_dropPackage_hrl).
-define(cfg_dropPackage_hrl, true).

-record(dropPackage, {
	id,
	maxWeight,
	itemList
}).
-record(dropPackageItem, {
			iD,
		itemID,
		weight,
		min,
		max,
		index

 }).
-endif.