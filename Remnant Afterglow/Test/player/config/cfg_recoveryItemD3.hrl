-ifndef(cfg_recoveryItemD3_hrl).
-define(cfg_recoveryItemD3_hrl, true).

-record(recoveryItemD3Cfg, {
	%% 资源找回ID
	recoveryID,
	%% 等级
	%% 找回ID=17时，这里代表的是地图ID
	level,
	%% 索引 
	index,
	%% （类型，道具ID，数量）
	%% 1道具
	%% 2货币
	item,
	%% （参数1，参数2，参数3，参数4）经验
	%% 填“0”表示：没有经验
	%%  参数1=1时，固定经验，获得经验=参数4，参数2，参数3为0
	%%  参数1=2时，动态经验{
	%% 参数2=1，玩家等级对应获得参数4*经验标准值：配置在ExpDistribution表中StandardEXP字段中，参数3=0
	%% 参数2=2时，玩家等级对应获得参数4*竞技场挑战胜利经验值：配置在ExpDistribution表中Arena字段中，参数3=0
	%% 参数2=3时，参数3=MonsterExp表中列数，玩家等级对应获得参数4*怪物经验值：配置在MonsterExp表对应参数3的字段}
	exp
}).

-endif.
