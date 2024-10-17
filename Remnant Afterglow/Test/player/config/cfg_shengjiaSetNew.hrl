-ifndef(cfg_shengjiaSetNew_hrl).
-define(cfg_shengjiaSetNew_hrl, true).

-record(shengjiaSetNewCfg, {
	%% 圣甲阶数
	iD,
	%% 可镶嵌宝石类型
	%% （孔位,宝石类型）
	%% 同道具详细类型,在宝石大类型（22）下新增元素宝石
	%% 3-生命，4-火，5-水，6-风，7-土
	%% 宝石属性配置在宝石基础表“GemBase_1_宝石属性”
	setType,
	%% 可镶嵌宝石等级上限
	stoneLvLimit
}).

-endif.
