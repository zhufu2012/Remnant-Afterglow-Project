-ifndef(cfg_rewardOpenSpecial_hrl).
-define(cfg_rewardOpenSpecial_hrl, true).

-record(rewardOpenSpecialCfg, {
	%% 奖励序号
	%% RewardOpenRank表RewardCondBase字段
	giftID,
	%% 活动ID，对应ReawardOpenRank表ID字段
	active,
	%% 战盟职位：
	%% 1.盟主
	%% 2.执法者
	%% 3.普通成员(包括副盟主+精英+成员)
	%% 4.普照奖，所有战盟成员获得奖励，仅普照奖配置
	position,
	%% 索引
	index,
	%% 奖励道具/货币
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardItem,
	%% 奖励装备
	%% （职业，装备ID，装备品质，装备星级，是否绑定）
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	awardEquip,
	%% 界面上显示道具icon的物品ID
	itemShow
}).

-endif.