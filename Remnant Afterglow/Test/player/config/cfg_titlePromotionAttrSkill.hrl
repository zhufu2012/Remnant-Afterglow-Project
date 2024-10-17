-ifndef(cfg_titlePromotionAttrSkill_hrl).
-define(cfg_titlePromotionAttrSkill_hrl, true).

-record(titlePromotionAttrSkillCfg, {
	%% 属性技能ID
	iD,
	%% 属性
	attribute,
	%% 属性技能ICON
	attrSkillIcon,
	%% 属性技能名称
	attrSkillName,
	%% 属性技能描述
	attrSkillDes
}).

-endif.
