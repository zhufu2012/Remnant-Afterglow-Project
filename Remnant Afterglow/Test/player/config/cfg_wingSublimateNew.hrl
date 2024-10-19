-ifndef(cfg_wingSublimateNew_hrl).
-define(cfg_wingSublimateNew_hrl, true).

-record(wingSublimateNewCfg, {
	%% 等级
	iD,
	%% 升级所需道具ID
	needItem,
	%% 所需翅膀觉醒等级
	needAwaken,
	%% 所需翅膀等级
	needLevel,
	%% 炼魂最大等级
	maxLv,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd,
	%% 额外奖励属性
	%% {属性ID，属性值}
	attrAdd2,
	%% 前端预览额外属性，每级属性非替换关系，为累加
	showAtt,
	%% 强化及突破提升万分比
	wingUpBreak,
	%% 前端预览额外属性，每级强化提升万分比非替换关系，为累加
	showAttNew
}).

-endif.
