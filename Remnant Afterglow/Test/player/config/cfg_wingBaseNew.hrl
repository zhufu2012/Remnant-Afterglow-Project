-ifndef(cfg_wingBaseNew_hrl).
-define(cfg_wingBaseNew_hrl, true).

-record(wingBaseNewCfg, {
	%% 翅膀ID
	iD,
	%% 名字
	name,
	%% 新增
	%% 对应品质
	%% 0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	rareType,
	%% 是否生效
	open,
	%% 翅膀飞行冲刺技能修正技能ID
	rollSkillFix,
	%% 初始星数
	starIniti,
	%% 基础属性
	%% {属性ID，属性值}
	attrBase,
	%% 排序ID
	orderId,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 激活消耗道具
	%% (消耗道具，消耗数量)
	consume,
	%% 翅膀飞翼激活道具
	%% {类型，道具，数量}
	%% 类型1道具
	%% 2货币
	flyNeedItem,
	%% 飞翼激活后，除了让翅膀能飞，还会附带些属性
	%% {属性ID，值}
	flyAttrBase,
	%% 翅膀升星消耗ID
	consumeStar
}).

-endif.
