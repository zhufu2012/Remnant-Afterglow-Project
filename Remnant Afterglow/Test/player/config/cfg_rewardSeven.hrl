-ifndef(cfg_rewardSeven_hrl).
-define(cfg_rewardSeven_hrl, true).

-record(rewardSevenCfg, {
	%% 作者:
	%% 天数
	iD,
	%% 作者:
	%% 分页
	paging,
	%% 多组七天奖组号
	%% 每一组七天奖最小ID及开服时间，为开启时间
	%% 每一组最大ID为该活动的关闭时间
	team,
	%% Sky123.Org:
	%% 客户端索引
	index,
	%% 作者:
	%% 分页名称
	pagName,
	%% 作者:
	%% {任务编号，功能编号，参数1，参数2，参数3}
	%% 任务编号不可以重复
	%% 功能编号
	%% 1：购买道具或货币；参数1：消耗元宝数量；参数2：折扣力度（万分比，向上取整）；参数3：全服可购买人数（0为不限购）
	%% 注：所购买道具或货币（可多配置）,所需消耗配置货币类型，数量与折扣获得对应物品；
	%% 2：开服天数；参数1：第几天；
	%% 注：达到开服对应天数即可领取对应奖励
	%% 3：累计充值；参数1：累计充值RMB
	%% 注：累计充值对应RMB即可领取奖励
	%% 4：剧情副本；参数1：所需星数；
	%% 注：剧情副本总星数达到配置星数即可领取对应奖励
	%% 5：装备强化；参数1：件数；参数2；资质（显示转化为阶级）；参数3；强化等级
	%% 注：穿戴指定件数以上，阶级以上，等级以上即可领取对应奖励
	%% 6：英雄等级；参数1：数量；参数2：稀有度；参数3：等级；
	%% 注：拥有指定数量以上，稀有度以上，等级以上即可领取对应奖励
	%% 7：竞技场；参数1：竞技场类型（默认为1）,竞技场历史最大排名 参数2：目标排名以上
	%% 注：历史达到指定竞技场排名以上，即可领取对应奖励
	%% 8.装备精炼；参数1：件数；参数2；资质（显示转化为阶级）；参数3：精炼等级
	%% 注：穿戴指定件数以上，阶级以上，精炼等级以上即可领取对应奖励
	%% 9.闯天关；参数1：星数；
	%% 注：历史达到指定闯天关最大星数以上即可领取奖励
	%% 10.英雄星级；参数1：数量；参数2：稀有度；参数3：星级
	%% 注：拥有指定数量以上，稀有度以上，星级以上即可获得奖励
	%% 11.夺宝；参数1：类型（0为总次数，1为抢人）；参数2：次数；
	%% 注：达到指定抢夺次数或指定抢人次数即可领取奖励
	%% 12.三界；参数1：类型（0为死亡，1为击杀，2为个人开启宝箱，3为公会击杀BOSS）
	%% 参数2：数量；
	%% 注：达到对应条件即可获得奖励，类型2（个人开启宝箱，必须自己开启宝箱才算）
	%% 类型3（公会成员击杀及算完成，必须击杀时本人在公会，次数绑定个人）
	%% 13.星图；参数1：宝石数；参数2：宝石等级；
	%% 镶嵌指定颗数以上，宝石等级以上即可领取奖励；
	%% 14.诛仙；参数1：类型（0为参与BOSS击杀，1为参与公会BOSS击杀）
	%% 参数2：指定诛仙ID（0为任意），参数3为次数
	%% 注：达到指定条件BOSS击杀数量即可获得奖励；参与任意击杀，指定击杀：诛仙BOSS死亡时，有资格领取红包奖励的算一次；
	%% 参与公会指定BOSS击杀，公会成员中某一位击杀指定BOSS算一次（击杀时，当前参与该公会成员算一次，
	%% 及有资格领取指定诛仙BOSS公会击杀红包的）
	%% 15.披风；参数1：件数；参数2：等级
	%% 注：达到指定数量披风以上，等级以上（显示为几阶几星）即可完成
	%% 16.通天塔：参数1：关卡ID；
	%% 注：通关指定关卡即可领取奖励
	%% 17.英雄升品；参数1：数量；参数2：品级；
	%% 注：拥有指定英雄数量以上，品级以上的（显示为绿+1类型）即可领取奖励
	%% 18.公会副本；参数1：公会副本ID(此项为0时，代表任意公会副本)；参数2：次数；
	%% 注：通关指定公会副本或总体公会副本次数以上即可获得奖励（击杀时，本帮会成员算一次）
	%% 19.战斗力；参数1：战斗力
	%% 注：达到指定战斗力以上即可完成
	%% 20.玩家等级；参数1：玩家等级
	%% 注：达到指定等级以上即可完成
	%% 21.野图；参数1：类型（0为多倍挂机时间（分）,1为参与击杀BOSS，2为开启宝箱数）；参数2：分或次数
	%% 注：多倍挂机时间为每日赠送的部分；BOSS被玩家击杀，有伤害记录的及算
	%% 22.连续充值；参数1：所需天数；参数2：所需金额
	%% 注：连续充值当前版本只有1种类型，达到当日配置的所需金额就算1天
	%% 23.抽卡；参数1：抽卡ID；参数2：次数
	%% 注：与Roulette，ID对应
	%% 24.商店消耗；参数1：商店ID；参数2：货币类型；参数3：数量
	%% 注：与ShopCreate，ID对应
	%% 25.剧情次数；参数1：次数
	%% 注：剧情副本通关次数，扫荡也算
	%% 26.组队次数；参数1：类型（0为收益，1为协助）；参数2：次数
	%% 注：达到指定类型次数即可领取奖励
	%% 27.通天塔次数；参数1：次数
	%% 注：通天塔通关次数，扫荡也算
	%% 28.闯天关重置次数；参数1：次数
	%% 注：重置一次算一次
	%% 29.公会副本次数；参数1：次数
	%% 注：消耗公会副本次数就算1次
	%% 30.坐骑等级；参数1：坐骑数；参数2：坐骑稀有度；参数3：坐骑等级
	%% 注：拥有指定数量以上，稀有度以上，坐骑等级以上即可领取奖励
	%% 31.坐骑星级；参数1：坐骑数；参数2：坐骑稀有度；参数3：坐骑星级
	%% 注：拥有指定数量以上，稀有度以上，坐骑星级以上即可领取奖励
	%% 32.领地战；参数1：类型（0为击杀，1为攻城伤害，2为积分）；参数2：数量
	%% 注：达到指定类型的条件以上即可领取奖励
	%% 33.时装精炼；参数1：数量；参数2：精炼等级
	%% 注：达到指定数量以上，精炼等级以上即可获得奖励
	%% 34.驻地；参数1：类型（0为打坐时间，1为请客次数）；参数2：分钟或数量
	%% 注：每请1次客都算一次（扣元宝成功）
	%% 35.副将位；参数1：数量；参数2：等级
	%% 注：达到指定数量以上，等级以上即可获得奖励
	%% 36.新购买道具或货币；参数1：货币类型；参数2：数量；参数3：折扣力度（万分比，向上取整）
	%% 大注：
	%% 所有标示“以上”的都含当前值
	%% 所有任务都可以提前完成，第一天把第七天的任务完成，第七天即可马上领取奖励
	%% 货币类型：
	%% 0，元宝
	%% 1，铜币
	%% 2，魂玉
	%% 3，声望
	%% 4，荣誉
	%% 5，战魂
	%% 6，铸魂
	%% 7，帮会贡献
	%% 8，器魂
	%% 9，爱心值
	%% 104，为装备强化石
	taskList,
	%% 作者:
	%% {任务编号，物品ID，数量}
	rewardList,
	%% 作者:
	%% {任务编号，类型，数量}
	%% 类型：
	%% 0，元宝
	%% 1，铜币
	%% 2，魂玉
	%% 3，声望
	%% 4，荣誉
	%% 5，战魂
	%% 6，铸魂
	%% 7，帮会贡献
	%% 8，器魂
	%% 9，爱心值
	%% 104，为装备强化石
	rewardMoney,
	%% 奖励道具
	%% （任务编号，职业，道具ID，掉落是否绑定，掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	rewardItem,
	%% 奖励货币
	%% （任务编号，货币ID，数量）
	rewardCoin
}).

-endif.