-ifndef(cfg_dragonIllustrationsNew_hrl).
-define(cfg_dragonIllustrationsNew_hrl, true).

-record(dragonIllustrationsNewCfg, {
	%% 图鉴ID
	iD,
	%% 关联任务章节，正式章节+1填写
	task,
	%% 图鉴立绘
	painting,
	%% 激活目标
	%% 类型|ID
	%% 1.神像
	%% 2.宠物
	%% 3.翅膀
	%% 4.坐骑
	%% 5.守护
	%% 6.圣物
	%% 7.神像武器
	%% 8.精灵龙
	%% 9.神像秘典
	%% 101.升级神像
	%% 102.升级宠物
	%% 103.升级翅膀
	%% 104.升级坐骑
	%% 105.升级守护
	%% 106.升级圣物
	%% 107.升级神像武器
	%% 108.升级精灵龙
	%% 109.升级神像秘典
	target,
	%% 是否关联快捷任务
	%% 0不关联
	%% 1关联
	quick,
	%% 任务获取进度
	%% (道具序号,起始任务编号,结束任务编号)
	%% 道具序号：Target为神像时，如为（DragonBaseNew表Activation字段）神器激活神像，则道具序号分别对应六个神器（按照DragonBaseNew表Consume序）
	%% taget为其他时,仅一个道具序号
	%% 起始任务编号,结束任务编号：标识任务进度，百分比显示
	protection
}).

-endif.
