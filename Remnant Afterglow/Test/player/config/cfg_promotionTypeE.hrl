-ifndef(cfg_promotionTypeE_hrl).
-define(cfg_promotionTypeE_hrl, true).

-record(promotionTypeECfg, {
	iD,
	%% 作者:
	%% 1.充值类型
	%% RankPara,参数1代表充值元宝
	%% 2.消耗类型
	%% RankPara,参数1代表消耗元宝
	type,
	%% 作者:
	%% {奖励序号,排名上限,排名下限,参数1}
	rankPara,
	%% 作者:
	%% {奖励序号,奖励类型,参数1,参数2}
	%% 奖励类型：
	%% 1为奖励道具；参数1：道具ID，
	%% 参数2：道具数量
	%% 2为奖励货币；参数1：货币ID，
	%% 参数2：货币数量
	rankAward,
	%% 作者:
	%% 排名多少以内不显示具体的上榜值（即0位全部显示），填-1为全部不显示
	rankValueView
}).

-endif.
