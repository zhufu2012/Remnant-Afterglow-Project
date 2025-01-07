-ifndef(cfg_shengdunSkillLvNew_hrl).
-define(cfg_shengdunSkillLvNew_hrl, true).

-record(shengdunSkillLvNewCfg, {
	%% 技能序号
	iD,
	%% 技能等级
	level,
	%% 索引
	index,
	%% 最大等级
	levelMax,
	%% 是否默认显示
	%% 默认读取0等级数值即可
	open,
	%% 升级消耗道具
	%% (物品id,数量)
	%% 0升1，读取0配置
	needItem,
	%% 圣盾技能
	%% （技能类型，id，学习位）
	%% 技能类型：1为技能(skillbase),
	%% 2为修正(skillcorr)
	%% 学习位：0不可直接获得，圣盾位124-135，D3新增技能位821-850
	%% 125为圣盾永久Buff技能
	%% 注：skill与Buffcorr同时有时优先显示buffCorr
	skill,
	%% buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 修正ID为ID[BuffCorr]
	%% 注：skill与Buffcorr同时有时优先显示buffCorr
	buffCorr,
	%% 圣盾评分，为累计值
	rank
}).

-endif.
