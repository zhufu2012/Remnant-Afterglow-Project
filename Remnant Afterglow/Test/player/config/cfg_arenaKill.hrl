-ifndef(cfg_arenaKill_hrl).
-define(cfg_arenaKill_hrl, true).

-record(arenaKillCfg, {
	%% 角色等级
	iD,
	%% 正常奖励（经验）
	%% （参数1，参数2，参数3）副本经验
	%% 填“0”表示：该副本没有副本通关经验
	%%  参数1=1时，固定经验，胜利获得经验=参数2，失败获得经验=参数3
	%%  参数1=2时，动态经验，成功获得经验=参数2*玩家等级对应获得经验标准值，失败获得经验=参数3*玩家等级对应获得经验标准值
	%% 玩家等级对应获得经验标准值：配置在ExpDistribution表中StandardEXP字段中
	arena,
	%% 正常奖励（金币）
	%% （参数1，参数2，参数3）副本金币
	%% 填“0”表示：该副本没有副本通关奖励金币
	%%  参数1=1时，固定金币，胜利获得金币=参数2，失败获得金币=参数3
	%%  参数1=2时，动态金币，胜利获得金币=参数2*玩家等级对应获得金币标准值，失败获得金币=参数3*玩家等级对应获得金币标准值 
	%% 玩家等级对应获得金币标准值：配置在ExpDistribution表中StandardMoney字段中
	arenaCoin,
	%% 道具奖励
	%% （类型，ID，绑定，胜利获得数量，失败获得数量）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定
	%% 2023.3.3修改后仅用做前端展示
	getReward,
	%% 实际奖励
	%% （胜负标识，职业，掉落ID，绑定，掉落数量，掉落概率）
	%% 1.胜利
	%% 0.失败
	realityReward
}).

-endif.