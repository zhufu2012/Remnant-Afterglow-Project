-ifndef(cfg_d2XDragonIllustrations_hrl).
-define(cfg_d2XDragonIllustrations_hrl, true).

-record(d2XDragonIllustrationsCfg, {
	%% 龙神图鉴ID
	%% ，ID只增不减
	iD,
	%% 大奖对应DragonIllustrationsGift表中奖励组ID
	specialAwardDungeon,
	%% （激活目标，职业，参数1，参数2）
	%% 激活目标：
	%% 1、技能，参数1=技能激活道具ID，参数2=技能位
	%% 2、龙晶，参数1=龙晶ID，参数2=龙晶顺序
	%% 3、坐骑，参数1=坐骑ID，参数2=0
	%% 4、守护，参数1=守护ID，参数2=0
	%% 5、饰品魔戒，参数1=饰品ID，参数2=商店id
	%% 6、魔宠，参数1=魔宠ID，参数2=0
	%% 2020.11.18新增
	%% 7、翅膀，参数1=翅膀ID，参数2=0.
	%% 8、圣物幻化，参数1=圣物幻化物品ID，参数2=0
	%% 9、其他道具，参数1=物品ID，参数2=0
	target,
	%% 奖励组ID
	giftID
}).

-endif.
