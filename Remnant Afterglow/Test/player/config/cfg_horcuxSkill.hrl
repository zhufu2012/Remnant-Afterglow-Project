-ifndef(cfg_horcuxSkill_hrl).
-define(cfg_horcuxSkill_hrl, true).

-record(horcuxSkillCfg, {
	%% 被动技能ID
	iD,
	%% 被动技能属性
	%% {属性ID，属性值}
	attribute
}).

-endif.
