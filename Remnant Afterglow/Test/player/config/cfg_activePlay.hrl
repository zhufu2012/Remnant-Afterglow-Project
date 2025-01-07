-ifndef(cfg_activePlay_hrl).
-define(cfg_activePlay_hrl, true).

-record(activePlayCfg, {
	%% 活动玩法ID
	%% 用于玩法活动基础ActivePlayBase
	iD,
	%% 关卡数
	stage,
	%% 索引
	index,
	%% 地图id
	%% 地图、怪物及相关功能走通用配置
	mapId,
	%% 传送消耗
	%% (消耗类型,类型id,数量)
	%% 类型类型1：道具，填写道具id、数量
	%% 消耗类型2：货币，填写货币枚举、数量
	transCost,
	%% 普通复活返回的关卡数
	%% 包括自然时间复活、立即复活（复活方式1、3）；而（非绑）原地复活则不掉关卡数（复活方式2）
	comReliveToStage,
	%% 特权vip等级
	%% 填写vip等级，
	%% vip等级达到条件时，点击功能按钮可传送到对应npc位置
	vipLevle,
	%% 时间经验奖励
	%% (奖励间隔，经验系数)
	%% 每隔一段时间自动获得经验=角色等级标准经验*该系数/100
	%% 间隔时间：秒
	%% 计算结果取整
	timeExp,
	%% 是否分线
	%% 0：不分线
	%% 1：分线
	isBra
}).

-endif.
