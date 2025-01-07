-ifndef(cfg_zhiGouVipExp_hrl).
-define(cfg_zhiGouVipExp_hrl, true).

-record(zhiGouVipExpCfg, {
	iD,
	%% （货币类型，货币数量）
	%% 货币类型：
	%% 1.人民币
	%% 2.美元
	%% 3.港币
	%% 4.新台币
	%% 5.韩元
	%% …
	%% （有需要再增加枚举）
	%% 货币数量：这里乘以100配置
	%% 例如(1,2800)|(2,499)表示：28人民币和4.99美元的直购项目
	type,
	%% 1、花费左边对应金额进行直购时，获得的VIP经验点
	%% 2、直购时，充值钻石额度进度，额度=值*10（实际不会发放这里的钻石）
	vipExp
}).

-endif.
