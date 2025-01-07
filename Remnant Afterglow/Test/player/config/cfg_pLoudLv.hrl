-ifndef(cfg_pLoudLv_hrl).
-define(cfg_pLoudLv_hrl, true).

-record(pLoudLvCfg, {
	%% 相册等级
	iD,
	%% 升级经验(头像经验道具提供的经验升级)
	%% 填“0”表示已升至最大级
	star,
	%% 所有头像属性增加万分比
	%% 描述 所有头像属性 
	attrIncrease,
	%% 属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
