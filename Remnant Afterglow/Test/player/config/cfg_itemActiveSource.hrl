-ifndef(cfg_itemActiveSource_hrl).
-define(cfg_itemActiveSource_hrl, true).

-record(itemActiveSourceCfg, {
	%% 活动类型：
	%% 1达成类活动（PromotionReachBase_1_达成条件活动）
	%% 2公会骑士团
	%% 3问卷调查
	%% 4荣耀献礼
	%% 5限时特惠
	%% 6无尽宝藏
	%% 7觉醒狂欢
	%% 8BOSS首杀
	%% 9、ActiveRoulette1_1_普通转盘
	%% 10、ActiveRoulette2_1_排行榜转盘
	%% 11、ActiveRoulette3_1_聚宝盆转盘
	%% 12、ActiveRoulette4_1_迷宫
	%% 13、ActiveRoulette5_1_矩阵寻宝
	%% 14、捐献活动
	%% 15、寒风森林
	%% 16、天神秘宝
	%% 17、直购活动1（DirectPurchaseSummary1_1_直购1）
	%% 18、直购活动2（DirectPurchaseSegmented1_1_直购2）
	%% 19、任意充（ArbitraryCharge1_1_任意充）
	%% 20、龙神殿((DragonTempleBase_1_龙神殿)
	%% 21、盛典(GrandCeremonyBase_1_盛典)
	%% 22、荣耀龙徽
	%% 23、道具兑换活动（ItemExchangeBase_1_道具兑换基础）
	iD,
	%% 道具ID
	%% 可从这类型的活动中获得的道具
	item
}).

-endif.
