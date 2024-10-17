-ifndef(cfg_activePlayBase_hrl).
-define(cfg_activePlayBase_hrl, true).

-record(activePlayBaseCfg, {
	iD,
	%% 每日免费活动次数
	%% 免费次数每天0点重置
	freeNum,
	%% 购买活动次数
	%% （方案,消耗类型,类型id，数量）
	%% 方案：按序号依次检测可用的方案
	%% 消耗类型：1道具，2货币
	%% 确定填写内容：一种道具、或一种货币、或一种道具+一种货币（转充值）
	%% 活动次数为0，且还有活动可参与时方可购买
	%% 购买的次数不会跨天清空（可以免费次数叠加），但活动结束时会统一清空
	buyNum,
	%% 活动奖励展示
	%% (职业，类型，ID，数量，品质，星级，是否绑定)
	%% 职业:D3默认填0.
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	activeAwardShow,
	%% 活动玩法
	%% （玩法id，默认关卡）
	%% 填写ActivePlay的ID（默认本配置表的ID）及初始进入的关卡数
	activePlay,
	%% 填写[ActionExchangeList_1_兑换列表]表的达成id
	activitys
}).

-endif.
