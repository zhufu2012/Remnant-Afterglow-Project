-ifndef(cfg_hallowsBaseNew_hrl).
-define(cfg_hallowsBaseNew_hrl, true).

-record(hallowsBaseNewCfg, {
	%% 圣物ID
	iD,
	%% 是否生效
	open,
	%% 名字
	name,
	%% 圣物类型1火2水3雷4土
	element,
	%% 初始星数(升星表中寻找激活材料)
	starIniti,
	%% 稀有度
	%% 0为A
	%% 1为S
	%% 2为SS
	rareType,
	%% 基础属性
	%% {属性ID，属性值}
	attrBase,
	%% 不用了
	%% 附带圣灵技
	%% {技能ID，解锁需要圣物等级}
	passiveSkill,
	%% 排序ID
	orderId,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 激活消耗道具
	%% (消耗道具，消耗数量)
	consume
}).

-endif.
