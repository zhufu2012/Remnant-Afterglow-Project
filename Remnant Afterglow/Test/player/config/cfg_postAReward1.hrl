-ifndef(cfg_postAReward1_hrl).
-define(cfg_postAReward1_hrl, true).

-record(postAReward1Cfg, {
	iD,
	%% 参与活动门票消耗
	%% (类型，ID，数量)
	%% 类型1：道具.
	%% 类型2：货币，ID=货币ID，数量=货币数量；
	%% 类型3：累充，ID=货币ID，数量=货币数量；
	%% 购买期间累充多少，也可激活门票
	cost,
	%% 参与活动门票消耗
	%% 直购商品ID
	%% Cost和DirectPurchase二选一配置
	directPurchase,
	%% 活动开始后，多少时间内可以购买门票(单位时间：秒）
	%% 例如：86400表示活动开始后一天之内可以购买
	timeBuy,
	%% 条件达成ID
	%% 填【PostAReward2_1_活动悬赏达成】表格中具体的ID
	getId,
	%% 计数类型
	%% 1为活动开启后就开始计数
	%% 2为角色购买门票后开始计数
	%% 0为不需要计数）
	count,
	%% 门票名称
	nameText,
	%% 门票名称
	nameText_EN,
	%% 印尼
	nameText_IN,
	%% 泰语
	nameText_TH,
	%% RU
	nameText_RU,
	%% FR
	nameText_FR,
	%% GE
	nameText_GE,
	%% TR
	nameText_TR,
	%% SP
	nameText_SP,
	%% PT
	nameText_PT,
	%% KR
	nameText_KR,
	%% TW
	nameText_TW,
	%% JP
	nameText_JP,
	%% 购买超时多少小时并且玩家没有购买隐藏已超时该分页
	overTime
}).

-endif.
