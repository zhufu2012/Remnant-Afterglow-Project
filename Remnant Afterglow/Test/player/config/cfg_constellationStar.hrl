-ifndef(cfg_constellationStar_hrl).
-define(cfg_constellationStar_hrl, true).

-record(constellationStarCfg, {
	%% 星座id
	iD,
	%% 星数
	star,
	%% 索引
	index,
	%% 最大星数
	starMax,
	%% 下一级需要碎片,数量
	%% 不累加
	needItem,
	%% 星座属性提升万分比
	%% 提升“升星和装备本身”的基础属性：四维基础、元素攻防、命中闪避值、暴击韧性值
	starAttrIncrease,
	%% 守护属性提升万分比
	%% 提升守护的“激活、升级突破、升星、觉醒精炼、炼魂”的基础属性：四维基础、元素攻防、命中闪避值、暴击韧性值
	guardAttrIncrease,
	%% 星级奖励属性
	%% (属性ID，属性值)
	attrAdd,
	%% 解锁守护孔位
	unlockGuardPosit,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 边境远征-星座星级奖励属性
	%% (属性ID，属性值)
	%% 边境远征玩法中，星座升星基础属性需统一
	expeditionAttrAdd
}).

-endif.
