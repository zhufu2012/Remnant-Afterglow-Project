-ifndef(cfg_constellationStoneSkill_hrl).
-define(cfg_constellationStoneSkill_hrl, true).

-record(constellationStoneSkillCfg, {
	%% 星座ID
	iD,
	%% 技能等级
	level,
	%% 索引
	index,
	%% 星座技能
	%% （技能类型，技能id）
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 默认激活条件：星石位镶满
	skillId,
	%% 技能升至下一级的消耗
	%% （道具id，数量）
	%% 填0表示已到最大等级
	consume,
	%% 技能重置消耗
	%% （货币枚举，数量）
	%% 技能重置默认1级
	%% 填0表示不能重置
	resetCost,
	%% 技能重置返还
	%% （道具id，数量）
	resetGain
}).

-endif.
