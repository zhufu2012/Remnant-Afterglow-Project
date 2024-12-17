-ifndef(cfg_aIPlayerBase_hrl).
-define(cfg_aIPlayerBase_hrl, true).

-record(aIPlayerBaseCfg, {
	%% AI
	%% ID
	iD,
	%% 名称
	name,
	%% 公会ID
	%% 是否是统一帮会
	guildID,
	%% 公会名称
	guildName,
	%% 展示装备
	show_Equip,
	%% 展示翅膀
	show_Wing,
	%% 职业
	prof,
	%% 技能
	skill,
	%% 初始属性
	attrBase,
	%% AI配置ID
	aI
}).

-endif.
