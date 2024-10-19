-ifndef(cfg_skillCorr_hrl).
-define(cfg_skillCorr_hrl, true).

-record(skillCorrCfg, {
	%% 技能修正ID
	iD,
	%% 技能名称
	%% 文字表ID
	%% SkillFixInfo[Texts]
	name,
	%% 技能描述
	%% 文字表ID
	%% SkillFixInfo[Texts]
	desc,
	%% 修正描述参数
	desc_Para,
	%% 技能品质
	%% 0为普通白
	%% 1为优秀蓝
	%% 2为史诗紫
	%% 3为传说橙
	%% 4为神话红
	%% 5为粉色
	%% 6为幻彩色
	skillCharacter,
	%% 修正ICON
	icon,
	%% 评分参数：
	%% (修正系数评分,修正基础评分,修正固定评分)
	point,
	%% 修正优先级
	priority,
	%% 修改方式：
	%% 0为空 1为替换 2为添加 3为改1 4为改2
	%% 替换时,优先级高的生效,同优先级后者生效
	%% 添加需再替换之后,且优先级高的先添加,同优先级前者先添加,及添加的数组内容是有顺序的(数组序号)
	%% 修改需再替换和添加之后,同类修改可叠加：
	%% 数组序号：0代表该字段所有数组都修正；大于0为对应数组修正
	%% 改1：实际参数=原有参数+修正参数
	%% 改2：实际参数=原有参数*(10^4+修正参数)/10^4
	corrWay,
	%% 被动技能触发参数修改
	%% 当CorrWay=1和2时,配置方式与TrigPara[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式:(数组序号,修正参数)
	trigPara,
	%% 连招技能
	%% (连招下个ID,有效触发时间(毫秒))
	%% 当CorrWay=1,配置方式与CombPara[SkillBase]相同
	%% 当CorrWay=3和4时,
	%% (无效,有效毫秒)
	combPara,
	%% 不同状态修正效果：
	%% 当CorrWay=1和2时,配置方式与ParaCorr[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% (数组序号,修正参数,修正参数,修正参数,无效,修正参数,修正参数)
	paraCorr,
	%% 技能目标相关参数：
	%% 当CorrWay=1和2时,配置方式与Target[SkillBase]相同;
	%% 当CorrWay=3时,
	%% 格式:(数组序号,无效,无效,修正参数)
	target,
	%% 冷却时间相关参数修改：
	%% 当CorrWay=1时,配置方式与CDPara[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式:(无效,冷却修正参数,无效,技能存储修正参数,无效)
	cDPara,
	%% 消耗配置;
	%% 格式：
	%% 当CorrWay=1时,配置方式与Cost[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式:(数组序号,修正参数)
	cost,
	%% 技能效果：
	%% 当CorrWay=1时,配置方式与SkillEffect[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式：(无效,修正参数,修正参数)
	skillEffect,
	%% 属性调整;
	%% 当CorrWay=1和2时,配置方式与AttrPara[SkillBase]相同;
	%% 当CorrWay=3和4时
	%% 格式:(数组序号,无效,修正参数,修正参数)
	attrPara,
	%% 附加效果：
	%% 当CorrWay=1,配置方式与OtherEffect[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式：(无效,无效,修正参数)
	otherEffect,
	%% 附加限制：
	%% 当CorrWay=1时,配置方式与OthEffLimit[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式：(无效,无效,修正参数)
	othEffLimit,
	%% 特殊效果
	%% 当CorrWay=1,2时,配置方式与SpeEffect[SkillBase]相同;
	%% 当CorrWay=3时,
	%% 格式：(无效,数组序号,参数1,参数2)
	speEffect,
	%% 特殊效果附加限制：
	%% 当CorrWay=1时,配置方式与SpeEffLimit[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式：(无效,修正参数1,修正参数2)
	speEffLimit,
	%% 触发效果修改：
	%% 当CorrWay=1和2时,配置方式与ActivateSkill[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式：(数组序号,修正参数,无效,无效,无效)
	activateEffect,
	%% 位移配置;
	%% 当CorrWay=1时,配置方式与Displacement[SkillBase]相同;
	%% 当CorrWay=3和4时,
	%% 格式：(无效,修正参数)
	displacement
}).

-endif.
