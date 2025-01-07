-ifndef(cfg_robotShow_hrl).
-define(cfg_robotShow_hrl, true).

-record(robotShowCfg, {
	%% 世界等级段
	%% 向下取，例：1级向下取的最大等级为0级
	wLevel,
	%% 序号
	%% 每个世界等级段对应的所有外显顺序编号，从1开始连续编号
	order,
	%% 索引
	%% 机器按当前所属世界段和随机到的序号获取属性
	index,
	%% 最大序号
	%% 对应世界等级段的最大序号，程序用来选择具体的序号
	maxOrder,
	%% 职业
	%% 1004：战士
	%% 1005：法师
	%% 1006：弓手
	profession,
	%% 技能
	%% (技能id,槽位)
	%% 注：不要用位移技能（涉及前后端表现）
	skill,
	%% 武器id及强化段数
	weap,
	%% 护手id及强化段数
	hand,
	%% 胸甲id及强化段数
	bard,
	%% 头盔id及强化段数
	helmet,
	%% 副手id及强化段数
	shoulder,
	%% 护肩id及强化段数
	boot,
	%% 裤子id及强化段数
	trousers,
	%% 龙神id
	dragon,
	%% 坐骑id
	mount,
	%% 宠物id及星数
	pet,
	%% 翅膀id
	wing,
	%% 圣物id（多个）
	hallows,
	%% 守护id
	guard,
	%% 称号id
	title,
	%% 头衔等级
	titlePromotionLv
}).

-endif.
