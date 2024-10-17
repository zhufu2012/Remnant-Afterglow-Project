-ifndef(cfg_dragonCombo_hrl).
-define(cfg_dragonCombo_hrl, true).

-record(dragonComboCfg, {
	%% 组号（装备备注填写用：1-4代表职业+（00-10）转职+1（A类）/2（B类）[这里职业做了区分主要是因为不同职业的A/B类套装的技能不同]
	%% （饰品备注填写用：1-4代表职业+（00-10）转职）
	group,
	%% 套装装备件数填多少就是几件套
	suit,
	%% 索引
	index,
	%% 是否需要有对应的祝福武器才可以激活
	%% 0.否
	%% 1.是
	limit,
	%% 属性(属性id，数值)
	%% 当Type=1或2时：·Attribute/Skill/BuffCorr三个字段同时生效，同时显示
	%% ·技能当做属性来显示，玩家看着是一条属性，实际上是通过技能实现的.
	%% 当Type=3时，只有Attribute生效，并且显示。
	%% *程序做累加
	attribute,
	%% 配饰修正
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill,
	%% buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 修正ID为ID[BuffCorr]
	buffCorr
}).

-endif.
