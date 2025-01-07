-ifndef(cfg_promotionTypeP_hrl).
-define(cfg_promotionTypeP_hrl, true).

-record(promotionTypePCfg, {
	%% ID
	iD,
	%% 基础消耗：
	%% （消耗组,类型,参数1,参数2）
	%% 消耗组：
	%% 同组消耗需同时满足；多组消耗只需满足其中一组即可
	%% 最多两个消耗（程序处理）
	%% 类型：
	%% 1为消耗道具；参数1：消耗道具ID；
	%% 参数2：消耗道具数量
	%% 2为消耗货币；参数1：消耗货币ID；
	%% 参数2：消耗货币数量
	consume,
	%% 消耗增幅
	%% 第1次增幅|第2次增幅2|第3次增幅|…|第10次增幅.（万分比）
	%% 实际消耗数=基础消耗数*消耗增幅/10000.（向上取整）
	%% 基础消耗数：Consume字段的“参数2”.
	change,
	%% 重置
	%% （类型，参数1，参数2，重置上限）
	%% 类型1：道具，参数1=道具ID，参数2=数量；
	%% 类型2：货币，参数1=货币ID，参数2=数量；
	%% 类型3：充值，参数1=0，参数2=非绑数量.
	%% 充值为：本活动期间每充值多少，可以获得1点重置次数.（3,0,1000)每充值1000非绑获得1点重置次数.
	%% 重置上限：活动时间内可重置的最大次数.
	reset,
	%% 大奖权重
	%% （次数，次数，权值）|（次数，次数，权值）|（次数，次数，权值）
	%% (1,3,1000)|(3,7,2000)|(5,10,3000)
	%% 第一个大奖在第1次至第3次中以每次10%的概率随出，如果前两次都没出，则第3次直接必出。
	%% 第二个大奖在第3次至第7次中以每次20%的概率随出，如果前3-6次都没出，则第7次直接必出。如果第一个大奖占用了第二个大奖应该出的次数，则第二个大奖排除该次数.
	%% 第三个大奖在第5次至第10次中以每次30%的概率随出，如果前5-9次都没出，则第10次直接必出。如果第一个或第二个大奖占用了第三个大奖应该出的次数，则第三个大奖排除该次数.
	%% 字段长度即7牌的数量
	%% 活动中修改次数时，不要缩小范围上限
	specWeight,
	%% 大奖
	%% 装备
	%% （编号，职业，装备ID，装备品质，装备星级，是否绑定，数量)
	%% 编号：第几个7对应的奖励
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 是否绑定：0为非绑 1为绑定
	specAwardEquip,
	%% 大奖
	%% 道具/货币
	%% (编号，职业,类型，物品ID，是否绑定，数量)
	%% 编号：第几个7对应的奖励
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 掉落是否绑定：0为非绑 1为绑定，货币和积分不使用此参数
	specAwardItem,
	%% 普通物品权重
	%% （物品编号,权值）
	%% 字段长度即普通物品牌的数量
	weight,
	%% 普通奖励
	%% 装备
	%% （普通编号，职业，装备ID，装备品质，装备星级，是否绑定，数量)
	%% 普通编号：物品编号
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 是否绑定：0为非绑 1为绑定
	awardEquip,
	%% 普通奖励
	%% 道具/货币
	%% (普通编号，职业,类型，物品ID，是否绑定，数量)
	%% 普通编号：物品编号
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 掉落是否绑定：0为非绑 1为绑定，货币和积分不使用此参数
	awardItem,
	%% 中奖公告
	%% （普通编号，是否显示中奖公告）
	%% 0表示不显示公告，1表示显示公告
	notice
}).

-endif.