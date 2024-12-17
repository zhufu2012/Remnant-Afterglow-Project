-ifndef(cfg_petLevel_hrl).
-define(cfg_petLevel_hrl, true).

-record(petLevelCfg, {
	%% 等级
	iD,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID,属性值}
	%% OB+4不用该字段：魔宠升级不再直接增加属性,而是通过等级和资质计算出等级属性；
	%% 属性类型与“洗髓”资质类型对应
	%% 每个等级的属性值：ROUND(资质*对应资质转换系数/10000,0.1）
	%% 资质转换系数为全局配置：MCZZTransCoef
	attrAdd
}).

-endif.
