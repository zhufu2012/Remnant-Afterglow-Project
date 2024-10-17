-ifndef(cfg_loveTokenOLv_hrl).
-define(cfg_loveTokenOLv_hrl, true).

-record(loveTokenOLvCfg, {
	%% 作者:
	%% 信物ID
	%% 每条独立判断
	iD,
	%% 作者:
	%% 编号
	numb,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 最大编号
	numbMax,
	%% 作者:
	%% 激活条件
	%% {条件类型,参数1}
	%% 1.仙侣共同信物等级
	%% 参数1：信物等级
	%% 2.自身信物等级
	%% 参数1：信物等级
	condition,
	%% 额外属性  
	%% （属性ID，属性值）
	attrBase
}).

-endif.
