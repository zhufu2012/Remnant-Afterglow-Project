-ifndef(cfg_rebirth_hrl).
-define(cfg_rebirth_hrl, true).

-record(rebirthCfg, {
	%% 转生等级
	lv,
	%% 阶段
	stage,
	%% 双索引
	index,
	%% 最大阶段
	maxStage,
	%% 阶段是否跳过
	%% 0否
	%% 1是
	ifSkip,
	%% 转生任务阶段
	%% 1：对话任务
	%% 2：转生点收集任务
	%% 3：BOSS任务
	%% 4：星盘小游戏
	%% 5：恶魔封印展示阶段
	stageDiff,
	%% 转生开启等级
	startLv,
	%% 转生点目标
	%% 达成目标点后，并蛮族StartLv等级，开启下一个阶段
	%% 配0表示非转生点收集任务
	goalPoint,
	%% 转生任务
	%% （任务ID，转生点，是否智能排序）
	taskConditions,
	%% 转生点收集阶段性奖励
	%% （类型，道具id，是否绑定，数量）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	stageReward,
	%% 转生成功后一次性属性提升
	%% (属性ID，属性值)
	%% 配置不为0表示为该阶段转生的最后一个阶段，完成转生后获得属性
	attrAdd,
	%% 挑战BOSS文字
	bossExp,
	%% BOSS模型展示
	%% (模型ID,X偏移,Y偏移,Z偏移,X旋转,Y旋转,Z旋转,缩放值)
	bossModel,
	%% 恶魔封印ID
	levelSeal
}).

-endif.
