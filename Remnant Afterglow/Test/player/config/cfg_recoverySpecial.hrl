-ifndef(cfg_recoverySpecial_hrl).
-define(cfg_recoverySpecial_hrl, true).

-record(recoverySpecialCfg, {
	%% 资源找回ID
	iD,
	%% 奖励序号
	%% （服务器类型，世界等级，奖励序号）
	%% 服务器类型：0不论单服和联服，1单服，2联服
	%% 世界等级：为世界等级段，如以下举例
	%% 奖励序号：序号不能重复
	%% （1,1,1)|(1,100,2)|(2,1,3)|(2,150,4)表示：
	%% 单服，世界等级1-99时，读取奖励序号为1的奖励；
	%% 单服，世界等级100级及以上时，读取奖励序号为2的奖励；
	%% 联服，世界等级1-99时，读取奖励序号为3的奖励；
	%% 单服，世界等级100级及以上时，读取奖励序号为4的奖励
	%% （0,1,1)表示：不论单服和联服，世界等级>=1时，都读取序号为1的奖励.
	orderReward,
	%% 金币找回获得资源
	%% (奖励序号，职业,类型，道具ID,是否绑定，数量)
	%% 类型
	%% 1：物品
	%% 2：货币
	coinFindItem,
	%% 金币找回
	%% （奖励序号，参数1，参数2，参数3，参数4）经验
	%% 填“0”表示：该没有经验
	%%  参数1=1时，固定经验，获得经验=参数4，参数2，参数3为0
	%%  参数1=2时，动态经验{
	%% 参数2=1，玩家等级对应获得参数4*经验标准值：配置在ExpDistribution表中StandardEXP字段中，参数3=0
	%% 参数2=2时，玩家等级对应获得参数4*竞技场挑战胜利经验值：配置在ExpDistribution表中Arena字段中，参数3=0
	%% 参数2=3时，参数3=MonsterExp表中列数，玩家等级对应获得参数4*怪物经验值：配置在MonsterExp表对应参数3的字段}
	coinFindExp,
	%% 金币找回
	%% （奖励序号，参数1，参数2）任务金币
	%% 填“0”表示：该任务没有任务奖励金币
	%%  参数1=1时，固定金币，获得金币=参数2
	%%  参数1=2时，动态金币，获得金币=参数2*玩家等级对应获得金币标准值。
	%% 玩家等级对应获得金币标准值：配置在ExpDistribution表中StandardMoney字段中
	coinFindGold,
	%% 钻石找回获得资源
	%% (奖励序号，职业,类型，道具ID,是否绑定，数量)
	%% 类型：
	%% 1：物品
	%% 2：货币
	diamondFindItem,
	%% 钻石找回
	%% （奖励序号，参数1，参数2，参数3，参数4）经验
	%% 填“0”表示：该没有经验
	%%  参数1=1时，固定经验，获得经验=参数4，参数2，参数3为0
	%%  参数1=2时，动态经验{
	%% 参数2=1，玩家等级对应获得参数4*经验标准值：配置在ExpDistribution表中StandardEXP字段中，参数3=0
	%% 参数2=2时，玩家等级对应获得参数4*竞技场挑战胜利经验值：配置在ExpDistribution表中Arena字段中，参数3=0
	%% 参数2=3时，参数3=MonsterExp表中列数，玩家等级对应获得参数4*怪物经验值：配置在MonsterExp表对应参数3的字段}
	diamondFindExp,
	%% 钻石找回
	%% （奖励序号，参数1，参数2）任务金币
	%% 填“0”表示：该任务没有任务奖励金币
	%%  参数1=1时，固定金币，获得金币=参数2
	%%  参数1=2时，动态金币，获得金币=参数2*玩家等级对应获得金币标准值。
	%% 玩家等级对应获得金币标准值：配置在ExpDistribution表中StandardMoney字段中
	diamondFindGold,
	%% 龙神塔通关层数分段奖励（限制AwardBoxNewTwo字段）
	%% （通关层数，层级奖励序号）
	%% (0,1)|(1,2)|(10,3)表示：
	%% 通关0层，给层级奖励序号为1的奖励；
	%% 通关第1-9层，给层级奖励序号为2的奖励；
	%% 通关第10层及以后，给层级奖励序号为3的奖励
	%% （0,1)表示：通关0层（即1层都没通关），仍然给层级奖励序号为1的奖励
	%% （1,1）表示：只有通关了1层及以上，给层级奖励序号为1的奖励
	%% 注：赛季服务器通过邮件发的奖励，最好不配这种，会使游戏变卡
	hierarchy,
	%% 金币找回
	%% 奖励(指定道具）
	%% （层级奖励序号，奖励序号，道具ID，掉落是否绑定,掉落数量）
	%% 层级奖励序号：对应Hierarchy字段的层级奖励序号
	%% 奖励序号：OrderReward字段的奖励序号
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 道具ID：指定道具ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	coinAwardBoxNewTwo,
	%% 钻石找回
	%% 奖励(指定道具）
	%% （层级奖励序号，奖励序号，道具ID，掉落是否绑定,掉落数量）
	%% 层级奖励序号：对应Hierarchy字段的层级奖励序号
	%% 奖励序号：OrderReward字段的奖励序号
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 道具ID：指定道具ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	diamondAwardBoxNewTwo
}).

-endif.