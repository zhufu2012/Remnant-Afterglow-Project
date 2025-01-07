-ifndef(cfg_noRepeat_hrl).
-define(cfg_noRepeat_hrl, true).

-record(noRepeatCfg, {
	%% 作者:
	%% 选择礼包道具组
	%% UseType=85
	iD,
	%% （奖励序号，权值）
	dropPro,
	%% 掉落物品
	%% （序号，职业，道具类型，ID，是否绑定，数量，品质，星数）
	%% 道具类型：1道具，ID=道具ID
	%% 道具类型：2货币，ID=货币ID
	%% 道具类型：3装备，ID=装备ID，只有装备才配品质和星数，其他为0
	%% 是否绑定：0不绑定，1绑定
	noRepeatItem
}).

-endif.
