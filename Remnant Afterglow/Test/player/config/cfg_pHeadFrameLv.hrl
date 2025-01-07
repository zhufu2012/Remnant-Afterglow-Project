-ifndef(cfg_pHeadFrameLv_hrl).
-define(cfg_pHeadFrameLv_hrl, true).

-record(pHeadFrameLvCfg, {
	%% 头像框等级
	iD,
	%% 升级经验(头像框经验道具提供的经验升级)
	%% 填“0”表示已升至最大级
	star,
	%% 所有头像框属性增加万分比
	%% 描述 所有头像框属性
	attrIncrease,
	%% 属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
