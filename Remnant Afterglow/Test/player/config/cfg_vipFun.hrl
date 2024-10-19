-ifndef(cfg_vipFun_hrl).
-define(cfg_vipFun_hrl, true).

-record(vipFunCfg, {
	%% 作者:
	%% VIP功能编号
	%% (固定ID)定死的ID用连续1-1000
	%% （动态ID）灵活ID用1000以上
	iD,
	%% 作者:
	%% 说明
	%% 需要在VIP特权文字说明的用绿色，不需要说明的用黄色，没有作用的用灰色，不清楚作用的用蓝色
	name,
	%% 临时VIP是否拥有此权限？
	%% 1=有
	%% 0=无
	tempVIP,
	%% 订阅特权
	%% 一种特殊的VIP等级特权
	%% 使用效果是：和VIP等级特权相叠加
	subscribePrivilege,
	%% 作者:
	%% -1代表功能未开启
	vIP0,
	vIP1,
	vIP2,
	vIP3,
	vIP4,
	vIP5,
	vIP6,
	vIP7,
	vIP8,
	vIP9,
	vIP10,
	vIP11,
	vIP12,
	vIP13,
	vIP14,
	vIP15,
	vIP16,
	vIP17,
	vIP18,
	vIP19,
	vIP20
}).

-endif.
