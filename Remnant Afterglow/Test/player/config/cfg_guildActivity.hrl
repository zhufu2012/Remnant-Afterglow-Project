-ifndef(cfg_guildActivity_hrl).
-define(cfg_guildActivity_hrl, true).

-record(guildActivityCfg, {
	iD,
	%% 连续多少天个人公活跃度低于多少时，将被踢出公会
	%% (天，个人公会活跃度值）
	activity_personal,
	%% 连续多少天公活跃度低于多少时，公会将被解散
	%% (天，公会活跃度值）
	%% 公会活跃度值=公会内所有成员获得的值之和
	activity_Guild,
	%% 公会活跃获取途径：
	%% （类型，单次获得活跃值，每日次数上限）
	%% 类型：日常表ID
	%% 59、﻿﻿公会捐献（普通+高级）
	%% 45、公会篝火
	%% 27、公会boss
	%% 49、公会商船
	%% 66、公会协助
	%% 显示顺序根据配置的顺序从左至右显示，奖励预览读取对应日常那里的奖励预览.
	access
}).

-endif.
