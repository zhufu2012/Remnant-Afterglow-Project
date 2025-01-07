-ifndef(cfg_mountEquipUnlock_hrl).
-define(cfg_mountEquipUnlock_hrl, true).

-record(mountEquipUnlockCfg, {
	%% 第几套
	num,
	%% 部位序号
	%% 部位序号为0表示的是套装按钮的条件
	part,
	%% 索引
	index,
	%% 对应的解锁需求评分
	%% （类型，参数）
	%% 类型1：人物等级
	%% 类型2：解锁需求评分
	%% 0为默认开启
	%% 多个为且的条件
	needPoint,
	%% 获取途径ID
	needID,
	%% 解锁消耗
	%% (类型，ID，数量）
	%% 类型1、道具
	%% 类型2、货币
	itemConsume
}).

-endif.
