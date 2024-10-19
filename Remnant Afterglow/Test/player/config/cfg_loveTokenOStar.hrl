-ifndef(cfg_loveTokenOStar_hrl).
-define(cfg_loveTokenOStar_hrl, true).

-record(loveTokenOStarCfg, {
	%% 作者:
	%% 信物ID
	%% 每条独立判断
	iD,
	%% 作者:
	%% 编号
	order,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 最大编号
	orderLimit,
	%% 作者:
	%% 激活条件
	%% {条件类型,参数1}
	%% 1.仙侣共同信物星级
	%% 参数1：信物星级
	%% 2.自身信物星级
	%% 参数1：信物星级
	condition,
	%% 额外属性
	%% （属性ID，属性值）
	attrBase
}).

-endif.
