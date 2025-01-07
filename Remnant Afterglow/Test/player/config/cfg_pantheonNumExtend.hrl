-ifndef(cfg_pantheonNumExtend_hrl).
-define(cfg_pantheonNumExtend_hrl, true).

-record(pantheonNumExtendCfg, {
	%% 助战位置顺序
	iD,
	%% 最大助战位置数量
	maxNum,
	%% 可开启条件
	%% （分组，类型，参数1，参数2）
	%% 分组：ID相同的组的条件必须同时满足
	%% 类型：1.VIP，参数1=VIP等级，参数2=0.
	%% 类型：2.消耗道具，参数1=道具ID，参数2=道具数量。
	%% 填0表示默认开启
	%% D3修改：这里是针对每一个单角色的
	%% OB+4修改：没三角色了
	condition
}).

-endif.
