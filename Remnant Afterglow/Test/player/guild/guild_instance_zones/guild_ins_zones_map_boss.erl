%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%		公会副本-BOSS关
%%% @end
%%% Created : 10. 3月 2022 13:51
%%%-------------------------------------------------------------------
-module(guild_ins_zones_map_boss).
-author("suw").

%% API
-export([init_map/1, on_tick/1, on_player_enter/1, on_player_exit/1, get_is_damage_full/1, on_damage/3, on_boss_dead/1,
	do_settle/1, refresh_effect_buff/2, hit_boss_hp/2, fix_dec_hp/2]).

-include("global.hrl").
-include("guild_instance_zones.hrl").
-include("cfg_guildCopyNode.hrl").
-include("id_generator.hrl").
-include("record.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("netmsgRecords.hrl").
-include("cfg_guildCopyItem.hrl").

%%%===================================================================
%%% API
%%%===================================================================
init_map(_MapParams) ->
	try
		GuildID = mapSup:getMapOwnerID(),
		?CHECK_THROW(guild_pub:find_guild(GuildID) =/= {}, ?ErrorCode_Guild_NoGuild),
		MapDataID = mapSup:getMapDataID(),
		{ChapterID, NodeID} = Key = guild_ins_zones_logic:map_id_to_chapter_node(MapDataID),
		guild_ins_zones_map_common:set_node_key(Key),
		#guildCopyNodeCfg{bossBorn = {BossDataID, X, Z, R}, monsterAttr = Attr, deductLimit = DeductLimit, isRepeat = IsRepeat} = cfg_guildCopyNode:row(Key),
		case guild_ins_zones_logic:find_node(GuildID, NodeID) of
			{} ->
				MonsterID = monsterMgr:addMonster(Attr, [], 1, 1, 1, 0, BossDataID, X, Z, R, 0, 0, 0, 0),
				set_monster_id(MonsterID),
				MaxHp = mapdb:getObjectHpMax(MonsterID, MonsterID),
				set_monster_max_hp(MaxHp),
				Node = #guild_ins_zones_node{guild_id = GuildID, node_id = NodeID, param1 = 10000, max_hp = MaxHp, map_pid = self()},
				guild_instance_zones:send_2_me({insert_new_node, ChapterID, Node}),
				set_deduct_limit(ceil(MaxHp * DeductLimit / 10000));
			#guild_ins_zones_node{is_pass = 0, param1 = Param1, rank_list = RankList} ->
				MonsterID = monsterMgr:addMonster(Attr, [], 1, 1, 1, 0, BossDataID, X, Z, R, 0, 0, 0, 0),
				set_monster_id(MonsterID),
				MaxHp = mapdb:getObjectHpMax(MonsterID, MonsterID),
				set_monster_max_hp(MaxHp),
				NowHp = trunc(MaxHp * Param1 / 10000),
				mapdb:setObjectHp(MonsterID, MonsterID, NowHp),
				set_deduct_limit(ceil(MaxHp * DeductLimit / 10000)),
				load_damage_list(RankList),
				guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.max_hp, MaxHp}, {#guild_ins_zones_node.map_pid, self()}]);
			#guild_ins_zones_node{is_pass = 1} when IsRepeat =:= 1 ->
				MonsterID = monsterMgr:addMonster(Attr, [], 1, 1, 1, 0, BossDataID, X, Z, R, 0, 0, 0, 0),
				set_monster_id(MonsterID),
				MaxHp = mapdb:getObjectHpMax(MonsterID, MonsterID),
				set_monster_max_hp(MaxHp),
				guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.max_hp, MaxHp},
					{#guild_ins_zones_node.param1, 10000}, {#guild_ins_zones_node.rank_list, []}, {#guild_ins_zones_node.map_pid, self()}]),
				set_deduct_limit(ceil(MaxHp * DeductLimit / 10000));
			Other ->
				?LOG_ERROR("map init error ~p", [Other]),
				self() ! {quit}
		end
	catch
		_ -> self() ! {quit}
	end.

on_tick(TimesTamp) ->
	guild_ins_zones_map_common:check_time_out(TimesTamp),
	case guild_ins_zones_map_common:get_cond_change_flag() andalso TimesTamp rem 5 =:= 0 of
		?TRUE ->
			guild_ins_zones_map_common:set_cond_change_flag(?FALSE),
			case get_monster_id() of
				?UNDEFINED ->
					?LOG_ERROR("monster id is null");
				ID ->
					HpRate = trunc(mapdb:getObjectHpRate(ID, ID) * 10000),
					GuildID = mapSup:getMapOwnerID(),
					{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
					#guild_ins_zones_node{param1 = OldHpRate} = guild_ins_zones_logic:find_node(GuildID, NodeID),
					HpRate =/= OldHpRate andalso guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.param1, HpRate}])
			end;
		?FALSE -> ok
	end,
	case get_damage_change_flag() andalso TimesTamp rem 3 =:= 0 of
		?TRUE -> do_damage_rank();
		?FALSE -> ok
	end.

on_player_enter(PlayerID) ->
	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{stayTime = StayTime} = cfg_guildCopyNode:row(Key),
	guild_ins_zones_map_common:add_player_stay_time(PlayerID, StayTime),
	GuildID = mapSup:getMapOwnerID(),
	guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.player_num, length(mapdb:getMapPlayerIDList())}]),
	set_damage_change_flag(?TRUE),
	map:send_client(PlayerID, #pk_GS2U_guild_ins_zones_label_info{chapter_id = ChapterID, node_id = NodeID}),
	map:send_client(PlayerID, #pk_GS2U_CopyMapLeftTime{leftTime = StayTime}).

on_player_exit(PlayerID) ->
	guild_ins_zones_map_common:del_game_over_list(PlayerID),
	erase_player_damage_total(PlayerID),
	erase_is_damage_full(PlayerID),
	del_damage(PlayerID),
	GuildID = mapSup:getMapOwnerID(),
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.player_num, length(mapdb:getMapPlayerIDList()) - 1}]).

on_damage(AtkID, TargetID, Damage) ->
	case TargetID =:= get_monster_id() andalso id_generator:id_type(TargetID) =:= ?ID_TYPE_Monster andalso id_generator:id_type(AtkID) =:= ?ID_TYPE_Player of
		?TRUE ->
			case get_is_damage_full(AtkID) of
				?FALSE ->
					FixDamage = min(Damage, get_deduct_limit()),
					IsDamageLimit = add_player_damage_total(AtkID, FixDamage),
					IsDamageLimit andalso set_is_damage_full(AtkID, ?TRUE),
					add_damage(AtkID, FixDamage),
					guild_ins_zones_map_common:set_cond_change_flag(?TRUE);
				?TRUE ->
					ok
			end;
		?FALSE -> ok
	end.

on_boss_dead(MonsterID) ->
	case MonsterID =:= get_monster_id() of
		?TRUE ->
			GuildID = mapSup:getMapOwnerID(),
			{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.is_pass, 1}, {#guild_ins_zones_node.is_mark, 0},
				{#guild_ins_zones_node.param1, 0}]),
			guild_instance_zones:on_node_pass(GuildID, ChapterID, NodeID),
			guild_ins_zones_map_common:challenge_log(GuildID, 4, 0, ChapterID, NodeID, 0, 0, 0, 0, 0, 0),
			#guildCopyNodeCfg{reward2 = Reward2} = cfg_guildCopyNode:row(Key),
			CurrList = [{CfgId, Amount} || {_, 2, CfgId, Amount, _, _, _} <- Reward2],
			ItemList = [{CfgId, Amount, Bind} || {_, 1, CfgId, Amount, _, _, Bind} <- Reward2],
			lists:foreach(fun(PlayerID) ->
				case guild_ins_zones_map_common:is_not_game_over(PlayerID) of
					?TRUE ->
						EqList = eq:create_eq([{I, B, Q, S} || {_, 3, I, _, Q, S, B} <- Reward2]),
						TotalDamage = get_player_damage_total(PlayerID),
						Percent = case TotalDamage > get_deduct_limit() of
									  ?TRUE ->
										  #guildCopyNodeCfg{deductLimit = DeductLimit} = cfg_guildCopyNode:row(Key),
										  DeductLimit;
									  ?FALSE ->
										  trunc(TotalDamage / get_monster_max_hp() * 10000)
								  end,
						Msg = #pk_GS2U_guild_ins_zones_settle_boss{
							chapter_id = ChapterID,
							node_id = NodeID,
							total_damage = TotalDamage,
							percent = Percent,
							is_kill = 1,
							item_list = [#pk_Dialog_Item{item_id = CfgId, count = Amount, multiple = 1, bind = Bind} || {CfgId, Amount, Bind} <- ItemList],
							eq_list = [eq:make_eq_msg(Eq) || {_, Eq} <- EqList],
							coin_list = [#pk_Dialog_Coin{type = CfgId, amount = Amount, multiple = 1} || {CfgId, Amount} <- CurrList]
						},
						map:send(PlayerID, Msg),
						case ItemList =/= [] orelse CurrList =/= [] orelse EqList =/= [] of
							?TRUE ->
								map:send_mail(PlayerID, #mailInfo{
									player_id = PlayerID,
									title = "【没有文字ID】BOSS击杀奖励描述",
									describe = "【没有文字ID】BOSS击杀奖励描述",
									coinList = [#coinInfo{type = CoinType, num = CoinNum, reason = ?Reason_GuildInsZonesKillBoss} || {CoinType, CoinNum} <- CurrList],
									itemList = [#itemInfo{itemID = ItemID, num = Count, isBind = IsBind} || {ItemID, Count, IsBind} <- ItemList],
									itemInstance = EqList,
									attachmentReason = ?Reason_GuildInsZonesKillBoss
								});
							?FALSE -> ok
						end;
					?FALSE -> ok
				end
						  end, mapdb:getMapPlayerIDList()),
			erlang:send_after(120000, self(), {quit});
		?FALSE -> ok
	end.

get_is_damage_full(PlayerID) ->
	case get({?MODULE, is_damage_full, PlayerID}) of
		?UNDEFINED -> ?FALSE;
		F -> F
	end.

fix_dec_hp(_AttackerID, Damage) when Damage >= 0 -> Damage;
fix_dec_hp(AttackerID, Damage) ->
	case id_generator:id_type(AttackerID) =:= ?ID_TYPE_Player of
		?TRUE ->
			Total = get_player_damage_total(AttackerID),
			CanDec = max(get_deduct_limit() - Total, 0),
			max(-CanDec, Damage);
		?FALSE -> Damage
	end.

do_settle(PlayerID) ->
	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
	TotalDamage = get_player_damage_total(PlayerID),
	Percent = case TotalDamage > get_deduct_limit() of
				  ?TRUE ->
					  #guildCopyNodeCfg{deductLimit = DeductLimit} = cfg_guildCopyNode:row(Key),
					  DeductLimit;
				  ?FALSE ->
					  trunc(TotalDamage / get_monster_max_hp() * 10000)
			  end,
	Msg = #pk_GS2U_guild_ins_zones_settle_boss{
		chapter_id = ChapterID,
		node_id = NodeID,
		total_damage = TotalDamage,
		percent = Percent,
		is_kill = 0,
		item_list = [],
		eq_list = [],
		coin_list = []
	},
	map:send(PlayerID, Msg),
	GuildID = mapSup:getMapOwnerID(),
	MonsterID = get_monster_id(),
	LeftHpPer = trunc(mapdb:getObjectHpRate(MonsterID, MonsterID) * 10000),
	guild_ins_zones_map_common:challenge_log(GuildID, 1, PlayerID, ChapterID, NodeID, 0, 0, 0, TotalDamage, Percent, LeftHpPer).

refresh_effect_buff(1, BuffID) ->
	[buff_map:add_buffer2(PlayerID, PlayerID, BuffID, 0) || PlayerID <- mapdb:getMapPlayerIDList()];
refresh_effect_buff(2, BuffID) ->
	MonsterID = get_monster_id(),
	buff_map:add_buffer2(MonsterID, MonsterID, BuffID, 0).

hit_boss_hp(PlayerID, {ItemID, Num}) ->
	case guild_ins_zones_map_common:get_is_finish_flag() of
		?TRUE -> ok;
		?FALSE ->
			DecPerW = case cfg_guildCopyItem:getRow(ItemID) of
						  {} -> 0;
						  #guildCopyItemCfg{num = PerN, proportion = DecP} ->
							  Num div PerN * DecP
					  end,
			DecHp = trunc(get_monster_max_hp() * DecPerW / 10000),
			MonsterUid = get_monster_id(),
			map:changeObjectHp(MonsterUid, MonsterUid, -DecHp),
			guild_ins_zones_map_common:set_cond_change_flag(?TRUE),
			on_tick(15),
			GuildID = mapSup:getMapOwnerID(),
			{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
			#mapMonster{data_id = BossDataID, level = BossLv} = mapdb:getMonster(MonsterUid),
			guild_ins_zones_map_common:challenge_log(GuildID, 3, PlayerID, ChapterID, NodeID, BossDataID, BossLv, ItemID, DecHp, DecPerW, Num)
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================

set_deduct_limit(N) ->
	put({?MODULE, deduct_limit}, N).
get_deduct_limit() ->
	case get({?MODULE, deduct_limit}) of
		?UNDEFINED -> 10000;
		N -> N
	end.

get_monster_id() ->
	get({?MODULE, monster_id}).
set_monster_id(ID) ->
	put({?MODULE, monster_id}, ID).

get_monster_max_hp() ->
	get({?MODULE, monster_max_hp}).
set_monster_max_hp(MaxHp) ->
	put({?MODULE, monster_max_hp}, MaxHp).

add_player_damage_total(PlayerID, N) ->
	NewTotal = get_player_damage_total(PlayerID) + N,
	put({?MODULE, damage_total, PlayerID}, NewTotal),
	NewTotal >= get_deduct_limit().
get_player_damage_total(PlayerID) ->
	case get({?MODULE, damage_total, PlayerID}) of
		?UNDEFINED -> 0;
		N -> N
	end.
erase_player_damage_total(PlayerID) ->
	erase({?MODULE, damage_total, PlayerID}).

set_is_damage_full(PlayerID, Flag) ->
	put({?MODULE, is_damage_full, PlayerID}, Flag).
erase_is_damage_full(PlayerID) ->
	erase({?MODULE, is_damage_full, PlayerID}).

set_damage_list(List) ->
	put({?MODULE, set_damage_list}, List).

get_damage_list() ->
	case get({?MODULE, set_damage_list}) of
		?UNDEFINED -> [];
		L -> L
	end.

add_damage(PlayerID, Damage) ->
	List = get_damage_list(),
	NewList = case lists:keytake(PlayerID, 1, List) of
				  ?FALSE -> [{PlayerID, Damage} | List];
				  {_, {_, OldDamage}, Left} -> [{PlayerID, OldDamage + Damage} | Left]
			  end,
	set_damage_list(NewList),
	set_damage_change_flag(?TRUE).
del_damage(PlayerID) ->
	List = get_damage_list(),
	NewList = lists:keydelete(PlayerID, 1, List),
	set_damage_list(NewList),
	set_damage_change_flag(?TRUE).

set_damage_change_flag(Flag) ->
	put({?MODULE, damage_change_flag}, Flag).

get_damage_change_flag() ->
	case get({?MODULE, damage_change_flag}) of
		?UNDEFINED -> ?FALSE;
		F -> F
	end.

do_damage_rank() ->
	DamageList = get_damage_list(),
	MaxHp = get_monster_max_hp(),
	{RankList, _} = lists:mapfoldl(fun({PlayerID, Damage}, Num) ->
		{Name, Sex} = get_player_param(PlayerID),
		{{Num, PlayerID, Name, Sex, Damage, trunc(Damage / MaxHp * 100)}, Num + 1}
								   end, 1, lists:reverse(lists:keysort(2, DamageList))),
%%	GuildID = mapSup:getMapOwnerID(),
%%	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
%%	guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.rank_list, RankList}]),
	RankMsg = [#pk_guild_ins_zones_boss_rank{rank = Num, name = Name, sex = Sex, damage = Damage, percent = Per} ||
		{Num, _PlayerID, Name, Sex, Damage, Per} <- lists:sublist(RankList, 5)],
	lists:foreach(fun(PlayerID) ->
		{MyRank, MyDamage} = case lists:keyfind(PlayerID, 2, RankList) of
								 {Num, _, _, _, Damage, _} -> {Num, Damage};
								 _ -> {0, 0}
							 end,
		map:send_client(PlayerID, #pk_GS2U_guild_ins_zones_boss_rank{rank_list = RankMsg, my_rank = MyRank, my_damage = MyDamage})
				  end, mapdb:getMapPlayerIDList()).
load_damage_list(_RankList) ->
	ok.
%%	DamageList = [{PlayerID, Damage} || {_, PlayerID, _, _, Damage, _} <- RankList],
%%	set_damage_list(DamageList).

get_player_param(PlayerID) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{name = Name, sex = Sex} -> {Name, Sex};
		_ ->
			Name = mirror_player:get_player_name(PlayerID),
			Sex = mirror_player:get_player_sex(PlayerID),
			{Name, Sex}
	end.