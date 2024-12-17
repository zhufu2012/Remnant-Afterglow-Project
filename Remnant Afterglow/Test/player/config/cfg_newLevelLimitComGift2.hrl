-ifndef(cfg_newLevelLimitComGift2_hrl).
-define(cfg_newLevelLimitComGift2_hrl, true).

-record(newLevelLimitComGift2Cfg, {
	%% ID
	iD,
	%% 奖励序号
	giftOrder,
	%% 索引
	index,
	%% 达成条件：封印等级
	conditions,
	%% 奖励物品
	%% (职业，类型，ID，数量，品质，星级，是否绑定)
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 注：显示的前后顺序，按照配置的顺序
	awardItem
}).

-endif.
