-ifndef(cfg_guildHelpBase_hrl).
-define(cfg_guildHelpBase_hrl, true).

-record(guildHelpBaseCfg, {
	%% 可协助系统ID
	%% 填写【Openaction_1_功能开放条件】的ID
	%% 地图内，用地图表字段【Mapsetting】MapOpenaction关联
	iD,
	%% 协助类型：1.打宝类玩法；2.商船协助夺回 3.组队副本玩法
	type,
	%% 协助声望
	%% 协助成功获得的基础声望，受战盟等级加成，
	%% 配置在“战盟大厅”的等级加成中
	helpPres,
	%% 求助者得到协助者成功帮助后，求助者获得的奖励（类型，道具ID，数量）
	%% 类型：1.道具 2.货币 3.装备
	%% 发到背包里
	guildHelpToMe
}).

-endif.
