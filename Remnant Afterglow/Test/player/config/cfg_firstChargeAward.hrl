-ifndef(cfg_firstChargeAward_hrl).
-define(cfg_firstChargeAward_hrl, true).

-record(firstChargeAwardCfg, {
	%% 首充奖励编号
	%% 界面展示文字规则：字头&编号&位置序号
	iD,
	%% 服务器组
	%% 含义修改为：
	%% 1、0.99直购版本的首充
	%% 2、累充版本的首充
	serverGroup,
	%% 索引
	index,
	%% 首充奖励
	%% （职业，掉落ID，掉落是否绑定,掉落数量，掉落概率）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 掉落ID：读取[DropItem]的ID
	%% 掉落是否绑定：0为非绑 1为绑定
	%% 掉落数量为掉落包的个数，开启时每个包独立开启
	%% 掉落概率值为万分比，上限为10000，下限为0
	award
}).

-endif.
