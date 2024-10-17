-ifndef(cfg_functionMail_hrl).
-define(cfg_functionMail_hrl, true).

-record(functionMailCfg, {
	%% 功能ID
	iD,
	%% 功能名称
	name,
	%% 邮件标题
	title,
	%% 邮件内容
	desc,
	%% 奖励
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	%% 这里获得和掉落都用这字段
	%% AwardType=3极品掉落显示，YanMoAward只管显示不做产出
	%% 这里前端显示和掉落非装备类型的道具都用这字段
	yanMoKLAward,
	%% 是否可一键领取
	%% 0否
	%% 1是
	allIn
}).

-endif.
