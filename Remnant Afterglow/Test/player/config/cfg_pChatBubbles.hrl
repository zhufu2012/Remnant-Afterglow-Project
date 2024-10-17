-ifndef(cfg_pChatBubbles_hrl).
-define(cfg_pChatBubbles_hrl, true).

-record(pChatBubblesCfg, {
	%% 聊天气泡ID
	iD,
	%% 所属职业
	%% 0所有性别
	%% 1男
	%% 2女
	%% 3人妖
	%% 填了职业ID的是默认聊天气泡，不会显示在列表里，不用
	character,
	%% 聊天气泡名字
	name,
	%% 动图聊天气泡的帧数
	%% 填0表示是静态聊天气泡
	%% 非0表示是动图聊天气泡，这里则是帧数
	gif,
	%% 聊天气泡
	%% 聊天气泡icon
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
	attribute,
	%% 组ID
	%% 对应PChatStar_1_聊天升星
	pChatBubblesID
}).

-endif.
