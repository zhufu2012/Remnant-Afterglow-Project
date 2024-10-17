-ifndef(cfg_guildHelpPres_hrl).
-define(cfg_guildHelpPres_hrl, true).

-record(guildHelpPresCfg, {
	%% 战盟职位
	%% 5盟主、
	%% 4执法者（太上长老）
	%% 3副盟主
	%% 2长老
	%% 1精英
	%% 0其他成员
	iD,
	%% 每日协助令牌上限
	presLimit
}).

-endif.
