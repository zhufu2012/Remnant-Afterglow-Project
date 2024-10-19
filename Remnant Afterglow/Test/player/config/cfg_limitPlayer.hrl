-ifndef(cfg_limitPlayer_hrl).
-define(cfg_limitPlayer_hrl, true).

-record(limitPlayerCfg, {
	%% 作者:
	%% 道具唯一ID
	%% ID段
	%% 100000000到199999999
	%% ID=1*10^8+ItemType*10^6+DetailedType*10^3+同类序列ID（0-999）
	%% 1000+为货币获取途径链接ID
	iD,
	%% 作者:
	%% 道具的昵称
	name,
	%% 邹明骏:
	%% 道具功能描述
	%% tpos使用
	sDesc
}).

-endif.
