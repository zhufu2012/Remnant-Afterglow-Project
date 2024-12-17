-ifndef(cfg_changeRole_hrl).
-define(cfg_changeRole_hrl, true).

-record(changeRoleCfg, {
	%% 职业ID
	%% 1004=战士
	%% 1005=法师
	%% 1006=弓手
	iD,
	%% 转职等级
	lv,
	%% 双索引
	index,
	%% 转职后称号
	name,
	%% 预览等级
	%% 在当前转职等级上，角色达到预览等级，即开放下级转职的预览入口
	viewLv,
	%% 预览人物所穿戴的装备阶数
	%% 通过阶读取装备套装表的部件模型
	%% 10转展示圣装，配置圣装id
	model,
	%% 接取转职任务ID
	%% 当玩家接取了该任务时显示“转职”按钮
	precondition,
	%% 转职完成条件：任务ID
	%% 注：按配置顺序从左至右依次往下完成
	conditions,
	%% 完成转职任务ID
	%% 转职任务最后一环
	finishingTask,
	%% 转职成功后，解锁的功能(类型，参数)
	%% 类型
	%% 1.开启翅膀幻形；参数=翅膀ID
	%% 2.开启新功能；参数=功能ID(功能开启表)
	%% 3.可穿戴装备；参数=装备阶数
	openFunction,
	%% 转职成功后一次性属性提升
	%% (属性ID，属性值)
	attrAdd,
	%% 转职技能
	%% 技能或修正
	%% (技能类型1,ID1,学习位1)|(技能类型2,ID2,学习位2)
	%% 技能类型：1为技能(skillBase);2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得,92-94职业技能 8为光环技能,107为职业被动技能
	skill,
	%% 广告语
	%% 转职广告语，读取text。没有填0
	advertisement,
	%% 称号奖励
	%% (奖励序号,称号表ID,道具表ID，权值)
	titleReward
}).

-endif.
