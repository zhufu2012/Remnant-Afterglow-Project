-ifndef(cfg_rebirthSuppress_hrl).
-define(cfg_rebirthSuppress_hrl, true).

-record(rebirthSuppressCfg, {
	%% 转生等级
	iD,
	%% （服务器人数，压制万分比）
	%% 服务器人数往下取
	serverSuppress,
	%% 服务器压制总上限
	serverSuppressLimit,
	%% BOSS每日被压制万分比
	%% （5点结算）
	everydaySuppress,
	%% （个人压制万分比，个人压制次数，次数间隔压制CD[秒]）
	%% 多次次数才有间隔CD
	playerSuppress,
	%% （求助压制万分比，个人求助压制次数）
	%% *注意：这个求助并不是协助，不能够完成任何协助次数相关的达成！
	helpSuppress,
	%% 个人压制总上限（万分比）
	playerSuppressLimit,
	%% 求助压制获得奖励
	%% （类型，ID，数量）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	helpSuppressGift
}).

-endif.
