-ifndef(cfg_loginWindowsReward_hrl).
-define(cfg_loginWindowsReward_hrl, true).

-record(loginWindowsRewardCfg, {
	iD,
	%% 天数
	day,
	index,
	%% 弹出的奖励窗口上方的文字描述
	text,
	%% 英语
	text_EN,
	%% 印尼
	text_IN,
	%% 泰语
	text_TH,
	%% 奖励装备
	%% （职业，装备ID，装备品质，装备星级，是否绑定，数量)
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 是否绑定：0为非绑 1为绑定
	%% AwardEquip1与AwardItem1为一组
	%% 填0表示该等级无奖励
	%% 精英版一个等级最多配置1种奖励
	%% 展示排序：用于大奖界面的进阶奖励展示排序，值大的在前
	awardEquip,
	%% 奖励道具/货币
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 是否绑定：0为非绑 1为绑定
	%% AwardEquip1与AwardItem1为一组
	%% 填0表示该等级无奖励
	%% 精英版一个等级最多配置1种奖励
	%% 展示排序：用于大奖界面的进阶奖励展示排序，值大的在前
	awardItem
}).

-endif.