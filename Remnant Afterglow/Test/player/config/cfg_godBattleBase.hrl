-ifndef(cfg_godBattleBase_hrl).
-define(cfg_godBattleBase_hrl, true).

-record(godBattleBaseCfg, {
	%% 地图ID
	iD,
	%% 开始挑战的波数差值
	%% 相对于历史最高胜利波数
	%% 比如历史最高19波，则从（19-3）=16波开始挑战
	beginDiff,
	%% 积分系数
	%% 积分计算公式=玩家当前战力/积分系数*镜像属性比例/100
	%% 计算结果四舍五入
	%% 玩家当前战力：战场外的角色总战力，不记战斗加成
	%% 镜像属性比例：当前战胜的最大波数的值+(当前波数的值-当前战胜的最大波数的值）*（1-当前镜像剩余生命百分比）
	%% 波数取值：【GodBattleFight_1_神力战场内】ImageAttrScale
	integralRatio,
	%% 奖励序号
	%% （玩家等级，序号）
	%% 用于战场奖励【GodBattle_1_神力战场】结算
	%% 取“小于等于”当前等级的最大值
	awardOrder,
	%% 镜像死亡刷新倒计时/秒
	%% 第1次刷新倒计时在地图表
	countTime
}).

-endif.
