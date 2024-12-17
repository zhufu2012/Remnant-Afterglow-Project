-ifndef(cfg_petMakeEquip_hrl).
-define(cfg_petMakeEquip_hrl, true).

-record(petMakeEquipCfg, {
	%% 英雄星数
	iD,
	%% （库ID，万分比概率）
	probabilityAdd
}).

-endif.
