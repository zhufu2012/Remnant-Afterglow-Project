-ifndef(cfg_dshipProperty_hrl).
-define(cfg_dshipProperty_hrl, true).

-record(dshipPropertyCfg, {
	%% 随机事件类型
	%% 1为掠夺事件
	%% 2为保护事件
	%% 3为夺回事件
	iD,
	%% （初始概率，叠加概率），万分比
	%% 每次事件有初始概率，判断触发失败则下次判断概率为（初始概率+叠加概率），触发成功则重置为初始概率
	mode
}).

-endif.
