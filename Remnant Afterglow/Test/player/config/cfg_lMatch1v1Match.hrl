-ifndef(cfg_lMatch1v1Match_hrl).
-define(cfg_lMatch1v1Match_hrl, true).

-record(lMatch1v1MatchCfg, {
	%% 连败类型
	%% 关联【LMatch1v1MatchType_1_常规赛匹配方式】
	type,
	%% 排名范围1
	%% 1、联服开启1v1联赛功能时，将各服等级排行榜前50名中开启1v1联赛功能的玩家加入排行榜（时间顺序，确保后续排名不会变化）
	%% 2、玩家开启功能后，首次匹配设置默认排名为最后一位，若排名大于指定值【globalSetup_16_联服】LMatch1v1_PlayerLimit，则不让匹配
	%% 3、赛季重置时，剔除上个赛季参与次数【globalSetup_16_联服】LMatch1v1_RefMin过少的玩家
	%% 4、合服时，只处理有参与本赛季的玩家（混合排名）
	order1,
	%% 排名范围2
	order2,
	%% 索引
	index,
	%% 积分匹配范围上/下限
	%% 以玩家自身排名为中心，根据配置值计算当前时间段的匹配范围（不超出有效排名-实际排名）
	expansionScore,
	%% 战力匹配范围上/下限，对应前面时间
	%% （上限增值，下限增值）
	%% 以玩家自身排名为中心，根据配置值计算当前时间段的匹配范围（不超出有效排名-实际排名）
	%% 按配置顺序查找范围内是否有对手
	expansionFight,
	%% 匹配机器人
	%% 机器人战力匹配范围上/下限
	%% （上限增值，下限增值）
	%% 玩家自己加入机器人中比较战力排名，按配置顺序查找范围内是否有对手
	expansionFight2
}).

-endif.
