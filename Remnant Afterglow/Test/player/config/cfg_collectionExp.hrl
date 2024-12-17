-ifndef(cfg_collectionExp_hrl).
-define(cfg_collectionExp_hrl, true).

-record(collectionExpCfg, {
	%% 道具ID
	%% 当英雄幻化激活后，精炼等级满级后，相同的多余英雄幻化激活道具和升星道具，可分解成收藏室升级的经验
	iD,
	%% 提供的经验
	itemExp
}).

-endif.
