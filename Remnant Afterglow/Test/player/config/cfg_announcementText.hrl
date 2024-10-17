-ifndef(cfg_announcementText_hrl).
-define(cfg_announcementText_hrl, true).

-record(announcementTextCfg, {
	%% 单选或多选，但一定要选
	%% 格式：0|1|2|3
	%%   
	%% 1:世界系统频道 
	%% 2:走马灯频道
	%% 3:玩法频道
	%% 4.掉落频道
	%% 5.公会频道
	%% 6.区域频道
	%% 7.系统频道
	%% 8.普通婚礼频道
	%% 9.本地玩家信息频道
	%% 10.组队频道掉落
	channel
}).

-endif.
