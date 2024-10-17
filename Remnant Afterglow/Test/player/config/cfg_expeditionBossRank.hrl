-ifndef(cfg_expeditionBossRank_hrl).
-define(cfg_expeditionBossRank_hrl, true).

-record(expeditionBossRankCfg, {
	%% 赛季
	season,
	%% BOSS序号
	%% 每天随机1种boss，跨服统一
	%% 序号配置固定，与程序取值同步
	type,
	%% 索引
	index,
	%% 地图ID
	mapID,
	%% 解锁条件：当前猎魔等级
	needBossLV,
	%% 每日次数
	%% （免费次数，次数上限）
	levyLimit,
	%% 挑战消耗
	%% （次数，消耗类型，id，数量）
	%% 次数：配置已强征的次数，例：第1次强征消耗，读取0的配置
	%% 消耗类型1：道具，id为道具id
	%% 消耗类型2：货币，id为货币枚举
	levyConsume,
	%% 通关奖励
	%% （职业，奖励类型，类型id，是否绑定，数量）
	%% 奖励类型：1道具，id为道具id；2货币，id为货币枚举
	vicAward,
	%% 可排名的通关时间/秒
	%% 玩家通关时间小于等于配置值，才能参与排名
	rankTime,
	%% 排名数
	%% 跨服统一排名，只记前N名，时间超过排名内玩家即顶替重排
	rankNum,
	%% 排名奖励
	%% （排名，职业，奖励类型，类型id，是否绑定，数量）
	%% 奖励类型：1道具，id为道具id；2货币，id为货币枚举
	rankAward
}).

-endif.
