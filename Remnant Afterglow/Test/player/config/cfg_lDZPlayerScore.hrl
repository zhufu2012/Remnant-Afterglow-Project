-ifndef(cfg_lDZPlayerScore_hrl).
-define(cfg_lDZPlayerScore_hrl, true).

-record(lDZPlayerScoreCfg, {
	%% 个人等级，向前取
	level,
	%% 排名区间1
	ranking1,
	%% 排名区间2
	ranking2,
	%% 序号
	index,
	%% S战区奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardS,
	%% A战区奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 2为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardA,
	%% B战区奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 3为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardB,
	%% C战区奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 4为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardC,
	%% D战区奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 5为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardD,
	%% 龙神塔通关层数分段奖励（限制AwardBoxNewTwo字段）
	%% （通关层数，层级奖励序号）
	%% (0,1)|(1,2)|(10,3)表示：
	%% 通关0层，给层级奖励序号为1的奖励；
	%% 通关第1-9层，给层级奖励序号为2的奖励；
	%% 通关第10层及以后，给层级奖励序号为3的奖励
	%% （0,1)表示：通关0层（即1层都没通关），仍然给层级奖励序号为1的奖励
	%% （1,1）表示：只有通关了1层及以上，给层级奖励序号为1的奖励
	hierarchy,
	%% S级战区奖励(指定道具）
	%% （层级奖励序号，类型，ID，掉落是否绑定,掉落数量）
	%% 层级奖励序号：对应Hierarchy字段的层级奖励序号
	%% 类型1，ID指：道具ID；
	%% 类型2，ID指：货币ID。
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxNewS,
	%% A级战区奖励(指定道具）
	%% （层级奖励序号，类型，ID，掉落是否绑定,掉落数量）
	%% 层级奖励序号：对应Hierarchy字段的层级奖励序号
	%% 类型1，ID指：道具ID；
	%% 类型2，ID指：货币ID。
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxNewA,
	%% B级战区奖励(指定道具）
	%% （层级奖励序号，类型，ID，掉落是否绑定,掉落数量）
	%% 层级奖励序号：对应Hierarchy字段的层级奖励序号
	%% 类型1，ID指：道具ID；
	%% 类型2，ID指：货币ID。
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxNewB,
	%% C级战区奖励(指定道具）
	%% （层级奖励序号，类型，ID，掉落是否绑定,掉落数量）
	%% 层级奖励序号：对应Hierarchy字段的层级奖励序号
	%% 类型1，ID指：道具ID；
	%% 类型2，ID指：货币ID。
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxNewC,
	%% D级战区奖励(指定道具）
	%% （层级奖励序号，类型，ID，掉落是否绑定,掉落数量）
	%% 层级奖励序号：对应Hierarchy字段的层级奖励序号
	%% 类型1，ID指：道具ID；
	%% 类型2，ID指：货币ID。
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	awardBoxNewD
}).

-endif.