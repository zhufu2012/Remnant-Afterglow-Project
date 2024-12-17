-ifndef(cfg_expeditionBaseAtrr_hrl).
-define(cfg_expeditionBaseAtrr_hrl, true).

-record(expeditionBaseAtrrCfg, {
	%% 赛季
	iD,
	%% 边境远征-人物基础属性
	%% 远征玩法中（城战、猎魔），玩家只计部分系统的属性：
	%% 远征基础属性、远征爵位属性&buff、远征指挥官属性、玩家当前赛季星座&星魂属性
	%% 爵位buff、指挥官buff仅在远征玩法中生效
	%% 远征玩法中，当前赛季星座技能解锁即生效（不用装配、不计其他星座）
	%% 远征玩法中，玩家技能只带入基础技能（1+4），没有其他技能和buff（例如：天赋效果、骑宠翼属性技&触发技能、魔戒效果……），不能变龙神
	baseAtrr
}).

-endif.
