-ifndef(cfg_huangjinmijingBP3_hrl).
-define(cfg_huangjinmijingBP3_hrl, true).

-record(huangjinmijingBP3Cfg, {
	%% 类型ID：
	%% 类型
	%% 1、击杀黄金秘境BOSS，拿到奖励算击杀
	%% 2、采集成功大宝箱
	%% 3、采集成功小宝箱
	%% 4、每获得xx日常活跃度
	%% 5、每日登录次数
	iD,
	%% 积分参数
	%% （参数1，参数2）
	%% 类型ID=1、击杀黄金秘境BOSS，拿到奖励算击杀，参数1=击杀数，参数2=积分；
	%% 类型ID=2、采集成功大宝箱，参数1=采集数，参数2=积分
	%% 类型ID=3、采集成功小宝箱，参数1=采集数，参数2=积分
	%% 类型ID=4、每获得xx日常活跃度，参数1=活跃度，参数2=积分
	%% 类型ID=5、每日登录次数，参数1=登录次数，参数2=积分
	parameter
}).

-endif.
