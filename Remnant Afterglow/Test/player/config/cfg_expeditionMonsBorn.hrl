-ifndef(cfg_expeditionMonsBorn_hrl).
-define(cfg_expeditionMonsBorn_hrl, true).

-record(expeditionMonsBornCfg, {
	%% 阵营
	%% 1红色阵营
	%% 2蓝色阵营
	%% 3绿色阵营
	camp,
	%% 活动编号
	%% 对应周历表的活动序号
	order,
	%% 索引
	index,
	%% 巨魔出现的城池
	%% 配置城池ID【ExpeditionCity_1_城池】
	%% 1阶段
	cityID1,
	%% 巨魔出现的城池
	%% 配置城池ID【ExpeditionCity_1_城池】
	%% 2阶段
	cityID2,
	%% 巨魔出现的城池
	%% 配置城池ID【ExpeditionCity_1_城池】
	%% 3阶段
	cityID3,
	%% 巨魔出现的城池
	%% 配置城池ID【ExpeditionCity_1_城池】
	%% 4阶段
	cityID4,
	%% 巨魔出现的城池
	%% 配置城池ID【ExpeditionCity_1_城池】
	%% 前面4个字段做好后删除
	cityID
}).

-endif.
