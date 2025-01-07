-ifndef(cfg_vipCondition_hrl).
-define(cfg_vipCondition_hrl, true).

-record(vipConditionCfg, {
	%% VIP等级
	%% 影响判断：限时特惠/直购悬赏/直购周卡/自选直购
	iD,
	%% 前1日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	%% 例如：第1日配置是(500,3000)(1000.2000)
	%% 对应VIP降低值1
	%% 即是玩家前1日，充值额度低于500绿钻(含)，得到降低VIP值1=300、如果501-100(含)之间，得到VIP值1=2000，如果充值大于100就VIP值1=0
	%% 中间省略
	%% 第10日配置是(10000,3000)(15000,2000)
	%% 对应VIP降低值30
	%% 即是玩家前10日，累计充值额度低于1000绿钻(含)，得到降低VIP值30=300、如果10001-15000(含)之间，得到VIP值30=2000，如果充值大于15000就VP值30=0
	vipRule1,
	%% 前2日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule2,
	%% 前3日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule3,
	%% 前4日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule4,
	%% 前5日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule5,
	%% 前6日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule6,
	%% 前7日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule7,
	%% 前8日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule8,
	%% 前9日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule9,
	%% 前10日充值和降档
	%% （低于XXX绿钻，降低VIP值），降低VIP值数为万分比
	vipRule10
}).

-endif.