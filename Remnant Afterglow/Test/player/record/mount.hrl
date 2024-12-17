%%%-------------------------------------------------------------------
%%% @author zhufu
%%% @copyright (C) 2023, DoubleGame
%%% @doc
%%% 坐骑头文件
%%% @end
%%% Created : 10. 4月 2023 21:18
%%%-------------------------------------------------------------------
-author("zhufu").

-ifndef(mount_hrl).
-define(mount_hrl, true).

-record(mount, {
	mount_id = 0,           %% 道具配置表ID
	%% 基础属性
	level = 1,                  %% 等级
	exp = 0,                  %% 等级
	star = 0,                    %% 星数
	break_lv = 0,                    %% 突破
	awaken_lv = 0,                %% 觉醒等级
	sublimate_lv = 0,                %% 炼魂
	is_rein = 0,              %% 是否转生 0否 1是
	ele_awaken = 0,              %% 元素觉醒
	expire_time = 0                %%过期时间 0 为永久  大于0限时，  限时过期是当前时间大于该过期时间
}).

-record(shouling, {
	lv = 1,                %%  等级
	exp = 0,            %%  经验
	break_lv = 0,        %% 突破等级
	skill_p = [],        %%  装配的技能 来自cfg_mountAwakenNew.skill [{Pos, MountId, 0}]
	skill_t_mask = 0,    %%  触发技能格子开启信息
	skill_t = [],        %%  打造的技能 来自cfg_mountStarNew.skill [{Pos, MountID, Index, IsLock}] 由MountID和Index决定技能
	eqs = [],            %%  穿戴的装备[{{套序号,位置},Uid,等级,突破等级}]   [{{1,1},3661149420122016897,40,2}] 有装备时为装备的Uid，无装备时为0
	unlock_suit_pos = [],%%  解锁的坐骑装备格[{套序号,位置}]  有要求且已解锁的
	pill1 = 0,
	pill2 = 0,
	pill3 = 0,
	award_list = []
}).

-define(Lock_UnLock, 0). %% 锁定状态 未锁定
-define(Lock_Locking, 1). %% 锁定状态 锁定中

-endif. %% -ifndef
