-ifndef(cfg_activityWeeklyCard_hrl).
-define(cfg_activityWeeklyCard_hrl, true).

-record(activityWeeklyCardCfg, {
	iD,
	%% 激活周卡类型 
	%% 1、钻石激活
	%% 2、直购激活
	type,
	%% 周卡激活所需绿钻数量（不包含钻石）
	%% 绿钻货币ID：11
	%% 钻石货币ID：0.
	conditions,
	%% 直购激活，填写直购商品ID
	directPurchase,
	%% 作者:
	%% 奖励物品
	%% {第几天，职业，类型，ID，数量，品质，星级，是否绑定，是否显示转圈特效是否装备}
	%% 第几天：第1天…第7天
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 是否显示转圈特效：1.显示  0.不显示
	reward
}).

-endif.
