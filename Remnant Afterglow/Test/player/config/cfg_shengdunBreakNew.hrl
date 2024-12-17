-ifndef(cfg_shengdunBreakNew_hrl).
-define(cfg_shengdunBreakNew_hrl, true).

-record(shengdunBreakNewCfg, {
	%% 突破ID
	iD,
	%% 突破后圣盾等级上限
	maxLv,
	%% 客户端索引最大突破等级
	maxBL,
	%% 需要材料
	%% （道具ID，数量）
	needItem,
	%% 附加属性
	%% 这里的值是累计值
	attribute,
	%% 评价值
	%% 累计值
	rank
}).

-endif.
