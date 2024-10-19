-ifndef(cfg_cardSuitUR_hrl).
-define(cfg_cardSuitUR_hrl, true).

-record(cardSuitURCfg, {
	%% 套装分类
	%% 1、攻击类（1武器、14副手）
	%% 2、防御类（3为护手，5衣服，6头盔，7肩甲，9裤子）
	%% 3、饰品类（2为项链、4为戒指、10护符）
	iD,
	%% 套装件数
	num,
	%% 套装等级
	lv,
	index,
	%% 套装最大等级
	lvMax,
	%% 套装激活条件,卡片等级
	condition,
	%% 激活套装获得的技能：
	%% (技能类型,技能ID,学习位,技能等级)
	%% 技能类型：
	%% 1为技能(skillBase)；2为技能修正(SkillCorr)
	skill
}).

-endif.
