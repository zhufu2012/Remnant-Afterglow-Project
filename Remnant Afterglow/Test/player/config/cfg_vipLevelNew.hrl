-ifndef(cfg_vipLevelNew_hrl).
-define(cfg_vipLevelNew_hrl, true).

-record(vipLevelNewCfg, {
	%% 作者:
	%% 对于VIP等级
	iD,
	%% 作者:
	%% VIP等级累计所需经验
	%% 消耗非绑钻石累计*0.1
	%% （排出途径见策划案）
	needExp,
	%% 最大等级VIP等级
	maxVIP,
	%% 快捷购买时的物品ID
	conqShopID,
	%% VIP经验卡每日获取经验上限
	%% 0表示无上限
	dailyExp,
	%% VIP直购ID
	%% 调用：ID【vipDirectpurchase_VIP直购】
	%% ·填0表示，没有直购，注意没有直购显示情况
	%% ·可以多填，按照填写的顺序默认显示
	vipDirectpurchase,
	%% VIP达成额外奖励，达到对应VIP等级时通过邮件发放
	%% （职业，类型，ID，数量，品质，星级，是否绑定）
	%% 职业:0=所有职业，1004=战士，1005=法师，1006=弓手，1007=圣职
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	additionalRewards,
	%% VIP每日领取，免费奖励.
	%% （职业，类型，ID，数量，品质，星级，是否绑定）
	%% 职业:0=所有职业，1004=战士，1005=法师，1006=弓手，1007=圣职
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	freeRewards
}).

-endif.
