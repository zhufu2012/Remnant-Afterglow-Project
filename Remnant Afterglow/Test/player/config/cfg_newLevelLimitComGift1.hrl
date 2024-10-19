-ifndef(cfg_newLevelLimitComGift1_hrl).
-define(cfg_newLevelLimitComGift1_hrl, true).

-record(newLevelLimitComGift1Cfg, {
	%% ID
	iD,
	%% 分页序号
	oder,
	%% 奖励序号
	%% 对应[NewLevelLimitCom_1_封印比拼]表RewardCond字段的序号
	giftOrder,
	%% 索引
	index,
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
