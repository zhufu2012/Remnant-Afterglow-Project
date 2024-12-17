-ifndef(cfg_divinityOutfit_hrl).
-define(cfg_divinityOutfit_hrl, true).

-record(divinityOutfitCfg, {
	%% 装备类型
	%% 1上古装-红
	%% 2远古装-龙
	%% 3太古装-龙
	%% 4神灵装-神
	%% 5神祗装-神
	%% 6神王装-龙神
	quality,
	%% 数量
	number,
	%% 索引
	index,
	%% 属性（属性ID，属性值）
	attribute,
	%% 技能
	skill
}).

-endif.
