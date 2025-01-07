%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2020 20:17
%%%-------------------------------------------------------------------
-author("suw").

-define(Bonfire_Close_Stage, 0).    %% 功能未开放
-define(Bonfire_Idle_Stage, 1).     %% 空闲阶段
-define(Bonfire_Drink_Stage, 2).    %% 喝酒阶段
-define(Bonfire_Exp_Stage, 3).      %% 经验阶段
-define(Bonfire_Boss_Stage, 4).     %% Boss阶段

%% 活动数据
-record(bonfire_data, {
	stage = 0,          %% 当前阶段
	open_time = 0,      %% 开启时间
	boss_time = 0,      %% Boss时间
	close_time = 0      %% 关闭时间
}).

-define(ETS_BonfireBoss, 'ets_bonfire_boss').
-record(bonfire_boss, {
	guild_id = 0,
	player_drink_info = [], %% #bonfire_player_drink
	guild_player_rank_list = [],
	guild_ratio = 0,   %% 战盟加成
	guild_t2 = 0,   %% 战盟非绑请客总次数
	treat_point = 0,   %% 请客积分
	guild_materials = 0    %% 获得的战盟建材
}).

-define(ETS_BonfireClusterTop, 'ets_bonfire_cluster_top').
-record(bonfire_cluster_top, {
	guild_id = 0,
	server_id = 0,
	guild_name = "",
	chairman_name = "",
	total_damage = 0
}).

-record(bonfire_player_drink, {
	player_id = 0,
	personal_ratio = 0,  %% 个人加成
	exp = 0,
	coin = 0,
	t1 = 0,
	t2 = 0,
	award_mask = 0,
	retrieve_param = {0, 0},
	in_map = false
}).

-record(playerDamageInfo, {player_id, player_name, player_sex, career, server_name, server_id, damage, battle_value}).