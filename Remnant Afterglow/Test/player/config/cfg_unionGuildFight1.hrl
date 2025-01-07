-ifndef(cfg_unionGuildFight1_hrl).
-define(cfg_unionGuildFight1_hrl, true).

-record(unionGuildFight1Cfg, {
	iD,
	%% 开启时间
	%% 小组积分赛开启时间
	%% （每月第几周，星级几）
	%% (1,2)|(3,2)：每月第1周星期二，和每月第3周的星期二
	%% 小组赛开启后，本周后内的活动时间见周历表配置
	rule1,
	%% 抽签资格：
	%% 5盟主、
	%% 4执法者（太上长老）
	%% 3副盟主
	%% 2长老
	%% 1精英
	%% 0其他成员
	rule2,
	%% 抽签时间段:
	%% （周二的几点开始，周二的几点截止）
	%% ·配置：秒，换算成具体时间点.
	%% 到了截止时间后，未抽取，则自动分组
	rule3,
	%% 个人等级分段
	%% (等级,等级序号）
	%% 等级段：向前取等
	%% (0,1）|(501,2):
	%% 0≤等级≤500,为序号1
	%% 等级≥501,为序号2.
	rule5,
	%% 个人积分排名段
	%% (排名区间1,排名区间2，排名序号）
	%% (1,1,1)|(2,2,2)|(3,6,3)|(4,999,4):
	%% 第1名,为序号1
	%% 第2名,为序号2.
	%% 第3-6名，为序号3.
	%% 第4-999名，为序号4.
	rule6,
	%% 世界等级分段
	%% (世界等级,世界等级序号）
	%% 等级段：向前取等
	%% (0,1）|(501,2):
	%% 0≤世界等级≤500,为序号1
	%% 世界等级≥501,为序号2.
	rule7,
	%% 小组积分赛，单次胜负小组积分
	%% （胜利积分，失败积分）
	rule8,
	%% 拍卖持续时间
	%% 配置：秒
	%% 拍卖开始时间为：公会本场活动结算时.
	%% ·额外备注：如果贵重物品，那么贵重物品流拍时间GuildTrade_StreamBeatTime3【globalSetup_10_战盟和好友】
	rule9,
	%% 流拍到世界拍卖
	%% （世界拍卖开始时间，世界拍卖结束时间）
	%% 配置：秒，换算成时间点.
	%% '(79800,81600)，表示：世界拍卖时间为：22:10-22:40
	rule10,
	%% ·公会联赛-巅峰赛结束时，根据公会排名额外给冠亚季军公会会长称号奖励
	%% 配置：称号道具ID|称号道具ID|称号道具ID
	%% 依次为：
	%% 1、冠军公会的会长的
	%% 2、亚军公会的会长的
	%% 3、季军公会的会长的
	rule11
}).

-endif.