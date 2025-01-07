-ifndef(cfg_weaponStar_hrl).
-define(cfg_weaponStar_hrl, true).

-record(weaponStarCfg, {
	%% 主手1
	%% 副手2
	iD,
	%% 部位
	%% 1、主体
	%% 2：剑柄/弓臂/杖体
	%% 3：剑格/弓耳/杖头
	%% 4、剑脊/弓玄/杖尾
	%% 5、剑刃/箭台/魔石
	part,
	%% 星级
	star,
	%% 客户端索引
	index,
	%% 最大星级
	starMax,
	%% 所需主部位星级
	needStar,
	%% 升级所需
	%% (道具ID，数量)
	%% 读下当前级，0升1，读0
	%% 一种材料，多种材料需优化
	needItem,
	%% 属性加值
	%% (属性id,属性值)
	attrAdd
}).

-endif.
