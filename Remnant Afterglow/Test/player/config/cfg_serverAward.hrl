-ifndef(cfg_serverAward_hrl).
-define(cfg_serverAward_hrl, true).

-record(serverAwardCfg, {
	%% 距离章节数：
	%% 玩家距离封印章节的距离
	iD,
	%% BUFF：
	%% 根据玩家距离封印章节的距离获得不同加成的BUFF
	%% 读取BuffBase表ID
	buffID
}).

-endif.
