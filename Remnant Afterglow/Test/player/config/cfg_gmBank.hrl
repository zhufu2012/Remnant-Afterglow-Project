-ifndef(cfg_gmBank_hrl).
-define(cfg_gmBank_hrl, true).

-record(gmBankCfg, {
	%% 上架ID，唯一性
	%% GM后台上架默认货币类型：15三界币
	%% GM后台上架默认为：非绑道具.
	iD,
	%% 道具ID
	itemId,
	%% 名称
	name,
	%% 描述
	desc,
	%% 道具类型：1=神器，2=其他道具
	type,
	%% type=1时，参数1：神器创建 ArtifactCreate的ID
	%% type=2时，该字段没用，填“0” 
	param1,
	%% type=1时，参数2：神器阶.（注意神器品质，根据itemID和神器lv表对应，不能超过该神器的最大阶）
	%% type=2时，该字段没用，填“0” 
	param2,
	%% 单件价格最低价. PriceMin<= x <=PreiceMax
	%% 注：
	%% 1.该区间必须在item表的PriceType字段区间以内.
	%% 2.最低价的最小值为“大于或等于2”的值.
	priceMin,
	%% 单件价格最高价. PriceMin<= x <=PreiceMax
	%% 注：
	%% 1.该区间必须在item表的PriceType字段区间以内.
	%% 2.最低价的最小值为“大于或等于2”的值.
	priceMax,
	%% 单次出售数量上限：
	%% 和item表的Num字段，可寄售物品的最大数量保持一致
	numMax
}).

-endif.
