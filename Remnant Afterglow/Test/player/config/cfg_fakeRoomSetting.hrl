-ifndef(cfg_fakeRoomSetting_hrl).
-define(cfg_fakeRoomSetting_hrl, true).

-record(fakeRoomSettingCfg, {
	iD,
	%% 由2个字符串组成：
	%% 前面字符串：
	%% 1：世界房间
	%% 2：私人房间
	%% 3：仙盟房间
	%% 后面的字符串：
	%% 0、世界房间：
	%%     0：不要求战力
	%%     1：要求副本战力
	%%     2：要求双倍副本战力
	%%     其他：无用，默认不要求战力
	%% 1、私人房间：无用
	%% 2：仙盟房间：公会名字
	type,
	isFighting,
	%% 显示房间玩家数量
	%% 前面为当前人数，后面为人数上限
	playerNum,
	%% 房间持续时间，持续时间结束后被销毁；
	%% 单位：秒
	time
}).

-endif.
