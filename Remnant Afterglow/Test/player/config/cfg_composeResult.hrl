-ifndef(cfg_composeResult_hrl).
-define(cfg_composeResult_hrl, true).

-record(composeResultCfg, {
	%% 品质
	iD,
	%% 序号
	stageNum,
	%% 攻击类，重铸合成出的结果库
	%% （序号，权重，ID）
	%% 攻击类：1为武器，14副手
	result,
	%% 防御类，重铸合成出的结果库
	%% （序号，权重，ID）
	%% 防御类：3为护手，5衣服，6头盔，7肩甲，9裤子
	result2,
	%% 饰品类，重铸合成出的结果库
	%% （序号，权重，ID）
	%% 饰品类：2为项链，4为戒指，10护符
	result3
}).

-endif.
