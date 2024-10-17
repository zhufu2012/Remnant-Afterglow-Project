-ifndef(cfg_heroStarConversion_hrl).
-define(cfg_heroStarConversion_hrl, true).

-record(heroStarConversionCfg, {
	%% 英雄品质
	rare,
	%% 英雄星级
	star,
	%% 英雄品质-英雄星级-星位
	index,
	%% 基础星级使用
	%% 英雄高星转换时，作为本体材料放入，可增加本体和材料5星的数量
	%% （增加本体5星数，增加材料5星数）
	baseNum,
	%% 基础星级使用
	%% 英雄高星转换时，作为通用材料放入，可增加材料5星的数量
	materialNum,
	%% 基础星级使用
	%% 英雄高星置换，特殊材料返还
	%% 道具类型，道具ID，道具数量
	%% 道具类型：1为道具，2为货币
	materialSpecial,
	%% 基础星级使用
	%% 英雄高星转换时，作为本体材料放入，可增加本体和材料5星的数量
	%% （增加本体5星数，增加材料5星数）
	baseNum1,
	%% 基础星级使用
	%% 英雄高星转换时，作为通用材料放入，可增加材料5星的数量
	materialNum1,
	%% 基础星级使用
	%% 英雄高星置换，特殊材料返还
	%% 道具类型，道具ID，道具数量
	%% 道具类型：1为道具，2为货币
	materialSpecial1,
	%% 基础星级使用
	%% 英雄高星转换时，作为本体材料放入，可增加本体和材料5星的数量
	%% （增加本体5星数，增加材料5星数）
	baseNum2,
	%% 基础星级使用
	%% 英雄高星转换时，作为通用材料放入，可增加材料5星的数量
	materialNum2,
	%% 基础星级使用
	%% 英雄高星置换，特殊材料返还
	%% 道具类型，道具ID，道具数量
	%% 道具类型：1为道具，2为货币
	materialSpecial2,
	%% 基础星级使用
	%% 英雄高星转换时，作为本体材料放入，可增加本体和材料5星的数量
	%% （增加本体5星数，增加材料5星数）
	baseNum3,
	%% 基础星级使用
	%% 英雄高星转换时，作为通用材料放入，可增加材料5星的数量
	materialNum3,
	%% 基础星级使用
	%% 英雄高星置换，特殊材料返还
	%% 道具类型，道具ID，道具数量
	%% 道具类型：1为道具，2为货币
	materialSpecial3,
	%% 基础星级使用
	%% 英雄高星转换时，作为本体材料放入，可增加本体和材料5星的数量
	%% （增加本体5星数，增加材料5星数）
	baseNum4,
	%% 基础星级使用
	%% 英雄高星转换时，作为通用材料放入，可增加材料5星的数量
	materialNum4,
	%% 基础星级使用
	%% 英雄高星置换，特殊材料返还
	%% 道具类型，道具ID，道具数量
	%% 道具类型：1为道具，2为货币
	materialSpecial4
}).

-endif.