-ifndef(cfg_expeditionMonsAward_hrl).
-define(cfg_expeditionMonsAward_hrl, true).

-record(expeditionMonsAwardCfg, {
	%% 怪物ID
	monster,
	%% 地图ID
	map,
	%% 对怪物的伤害排名
	%% 取小于等于玩家排名的最大配置值
	order,
	%% 索引
	index,
	%% 功勋值奖励
	%% 防守奖励配置在全局表
	rankMertial,
	%% BOSS真实掉落
	%% （职业，掉落ID，掉落是否绑定,掉落数量，掉落概率）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 掉落ID：读取[DropItem]的ID
	%% 掉落是否绑定：0为非绑 1为绑定
	%% 掉落数量为掉落包的个数，开启时每个包独立开启
	%% 掉落概率值为万分比，上限为10000，下限为0
	%% 掉落出的物品数量不堆叠，按配置的数量发到拍卖商店
	drop
}).

-endif.
