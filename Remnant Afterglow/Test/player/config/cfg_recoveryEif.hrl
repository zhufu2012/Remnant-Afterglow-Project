-ifndef(cfg_recoveryEif_hrl).
-define(cfg_recoveryEif_hrl, true).

-record(recoveryEifCfg, {
	%% 资源找回ID
	recoveryID,
	%% 关卡ID
	difficulty,
	%% 索引
	index,
	%% 金币找回获得资源
	%% (职业,类型，道具ID,是否绑定，数量)
	%% 类型：
	%% 1为道具
	%% 2为货币
	coinFindItem,
	%% 金币找回
	%% （参数1，参数2，参数3，参数4）经验
	%% 填“0”表示：该没有经验
	%%  参数1=1时，固定经验，获得经验=参数4，参数2，参数3为0
	%%  参数1=2时，动态经验{
	%% 参数2=1，玩家等级对应获得参数4*经验标准值：配置在ExpDistribution表中StandardEXP字段中，参数3=0
	%% 参数2=2时，玩家等级对应获得参数4*竞技场挑战胜利经验值：配置在ExpDistribution表中Arena字段中，参数3=0
	%% 参数2=3时，参数3=MonsterExp表中列数，玩家等级对应获得参数4*怪物经验值：配置在MonsterExp表对应参数3的字段}
	coinFindExp,
	%% 金币找回
	%% （参数1，参数2）任务金币
	%% 填“0”表示：该任务没有任务奖励金币
	%%  参数1=1时，固定金币，获得金币=参数2
	%%  参数1=2时，动态金币，获得金币=参数2*玩家等级对应获得金币标准值。
	%% 玩家等级对应获得金币标准值：配置在ExpDistribution表中StandardMoney字段中
	coinFindGold,
	%% 钻石找回获得资源
	%% (职业,类型，道具ID,是否绑定，数量)
	%% 类型：
	%% 1为道具
	%% 2为货币
	diamondFindItem,
	%% 钻石找回
	%% （参数1，参数2，参数3，参数4）经验
	%% 填“0”表示：该没有经验
	%%  参数1=1时，固定经验，获得经验=参数4，参数2，参数3为0
	%%  参数1=2时，动态经验{
	%% 参数2=1，玩家等级对应获得参数4*经验标准值：配置在ExpDistribution表中StandardEXP字段中，参数3=0
	%% 参数2=2时，玩家等级对应获得参数4*竞技场挑战胜利经验值：配置在ExpDistribution表中Arena字段中，参数3=0
	%% 参数2=3时，参数3=MonsterExp表中列数，玩家等级对应获得参数4*怪物经验值：配置在MonsterExp表对应参数3的字段}
	diamondFindExp,
	%% 钻石找回
	%% （参数1，参数2）任务金币
	%% 填“0”表示：该任务没有任务奖励金币
	%%  参数1=1时，固定金币，获得金币=参数2
	%%  参数1=2时，动态金币，获得金币=参数2*玩家等级对应获得金币标准值。
	%% 玩家等级对应获得金币标准值：配置在ExpDistribution表中StandardMoney字段中
	diamondFindGold
}).

-endif.
