-ifndef(cfg_godTowerSkill_hrl).
-define(cfg_godTowerSkill_hrl, true).

-record(godTowerSkillCfg, {
	%% 库ID
	iD,
	%% 品质
	%% 1、白色
	%% 2、绿色
	%% 3、蓝色
	%% 4、紫色
	%% 5、橙色
	quarlity,
	%% 龙神ID
	%% 玩家需要持有这个龙神才能生效
	%% 需要提示玩家
	dragonID,
	%% 祝福强化（类型，ID）
	%% 类型=1，ID=技能ID
	%% 类型=2，ID=BUFF
	%% 祝福强化是可以重复叠加的
	blessAdd
}).

-endif.
