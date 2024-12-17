-ifndef(cfg_constellationBase_hrl).
-define(cfg_constellationBase_hrl, true).

-record(constellationBaseCfg, {
	%% 星座ID
	iD,
	%% 是否生效
	open,
	%% 名字
	name,
	%% 激活消耗道具
	%% （道具id，数量） 
	consume,
	%% 激活星座后再使用激活卡，对应分解成的道具和数量
	%% （道具id，数量）
	recount,
	%% 星座激活时的初始星级
	initStar,
	%% 星座激活时的星魂孔初始可装备阶数
	%% （星魂装备的部件枚举，最低阶数，最高阶数）|……
	%% 部件枚举：1战剑2战戒3战镯4战坠5战链6战盔7战甲8战腕9战腿10战靴
	equipLevel,
	%% 赛季可穿戴的最高星魂装备阶数
	%% （赛季，最高阶数）|……
	%% 取小于等于当前赛季的最大配置
	%% 若赛季最大装备阶数大于孔位可装备最大阶数，则仍以星座可装备阶数为准
	%% 最大阶数不能小于最小阶数
	seasonEquipLevel,
	%% 激活前星座的特效路径
	activationEffectLow,
	%% 激活后星座的特效路径
	activationEffect,
	%% 获取是否走马灯公告
	%% 0为不开放
	%% 1为开放
	notice,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 强化方案
	strengthPlan
}).

-endif.
