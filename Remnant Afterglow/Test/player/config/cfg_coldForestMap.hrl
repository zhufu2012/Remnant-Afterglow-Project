-ifndef(cfg_coldForestMap_hrl).
-define(cfg_coldForestMap_hrl, true).

-record(coldForestMapCfg, {
	%% 关卡数
	iD,
	%% 地图id
	%% 地图、怪物及相关功能走通用配置
	mapId,
	%% 到下一层消耗
	%% (消耗类型,类型id,数量)
	%% 类型类型1：道具，填写道具id、数量
	%% 消耗类型2：货币，填写货币枚举、数量
	transCost,
	%% 普通复活返回的关卡数
	%% 包括自然时间复活、立即复活（复活方式1、3）；而（非绑）原地复活则不掉关卡数（复活方式2）
	comReliveToStage,
	%% 直接传送到NPC位置的消耗
	%% (消耗类型,类型id,数量)
	%% 类型类型1：道具，填写道具id、数量
	%% 消耗类型2：货币，填写货币枚举、数量
	flyCost,
	%% 时间经验奖励
	%% (奖励间隔，经验系数)
	%% 每隔一段时间自动获得经验=角色等级标准经验*该系数/100
	%% 间隔时间：秒
	%% 计算结果取整
	timeExp,
	%% 本层总疲劳值
	tiredNum,
	%% NPC传送
	%% （NPCID,传送x坐标、传送z坐标）
	nPCTransport
}).

-endif.
