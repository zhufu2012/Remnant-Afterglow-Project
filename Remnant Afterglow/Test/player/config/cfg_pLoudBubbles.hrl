-ifndef(cfg_pLoudBubbles_hrl).
-define(cfg_pLoudBubbles_hrl, true).

-record(pLoudBubblesCfg, {
	%% 喇叭气泡ID
	iD,
	%% 是否默认泡泡，不用
	character,
	%% 喇叭气泡名字
	name,
	%% 动图喇叭气泡的帧数
	%% 填0表示是静态喇叭气泡
	%% 非0表示是动图喇叭气泡，这里则是帧数
	gif,
	%% 喇叭气泡
	%% 喇叭气泡icon
	icon,
	%% 默认是否开启
	%% 1，开启
	%% 0，不开启(如果激活了，就自动开启)
	open,
	%% 激活道具
	%% (道具ID，数量)
	%% 填“0”表示创建角色的时候默认激活的
	itemId,
	%% 基础属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
