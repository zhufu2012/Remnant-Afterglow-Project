-ifndef(cfg_fashionShow3_hrl).
-define(cfg_fashionShow3_hrl, true).

-record(fashionShow3Cfg, {
	%% 衣橱等级
	iD,
	%% 升级经验
	%% 填“0”表示已升至最大级
	star,
	%% 所有时装属性增加万分比，加成的属性为：Attribute[FashionShow2_1_时装激活升星]
	%% 描述：时装属性加成
	%% 配置的为累计值
	attrIncrease,
	%% 属性
	%% (附加属性ID，附加值)
	%% 配置的为累计值
	attribute
}).

-endif.
