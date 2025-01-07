-ifndef(cfg_emoji_hrl).
-define(cfg_emoji_hrl, true).

-record(emojiCfg, {
	%% 表情ID
	iD,
	%% 激活类型
	%% 1=等级激活
	%% 2=道具激活
	%% 备注：2类型只是用于道具显示和反查（调用获取途径等）具体道具激活是在道具表里配置
	active,
	name,
	%% 表情名称
	namestring,
	%% 表情特效
	effect,
	%% 特效持续时间(毫秒）这个时间后停止特效
	effectTime,
	%% 表情CD时间（毫秒）
	cD
}).

-endif.
