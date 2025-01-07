-ifndef(cfg_surrLevel_hrl).
-define(cfg_surrLevel_hrl, true).

-record(surrLevelCfg, {
	%% 作者:
	%% 臣服等级
	iD,
	%% 作者:
	%% 最大臣服等级
	maxLevel,
	%% 作者:
	%% 升级所需经验
	exp,
	%% 作者:
	%% 描述
	desc,
	%% 作者:
	%% 团队属性（AttributeTeam）ID
	attrTeam
}).

-endif.
