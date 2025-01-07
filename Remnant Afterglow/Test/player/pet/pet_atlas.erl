%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%   英雄图鉴
%%% @end
%%% Created : 30. 6月 2022 15:20
%%%-------------------------------------------------------------------
-module(pet_atlas).
-author("admin").

-include("logger.hrl").
-include("global.hrl").
-include("error.hrl").
-include("record.hrl").
-include("cfg_petStar.hrl").
-include("cfg_petBase.hrl").
-include("player_task_define.hrl").
-include("variable.hrl").
-include("db_table.hrl").
-include("record.hrl").
-include("netmsgRecords.hrl").
-include("seven_gift_define.hrl").
-include("reason.hrl").

-define(DB_PET_ATLAS, db_pet_atlas).


%% API
-export([on_load/0, send_all_info/0, atlas_active/1, atlas_level_up/1, atlas_active_reward/1, get_all_atlas_prop/0, check_atlas_active/1]).
-export([get_atlas_list/0, get_active_atlas_list/0, get_active_atlas/1, get_atlas_count/0, update_atlas/1, check_get/2, get_atlas_max_star/1]).

%% 加载图鉴信息 并保存计算属性
on_load() -> ?metrics(begin
						  PlayerID = player:getPlayerID(),
						  AtlasList = table_player:lookup(?DB_PET_ATLAS, PlayerID),
						  set_atlas_list([db_atlas_to_record(Atlas) || Atlas <- AtlasList]),
						  calc_prop(?TRUE),
						  ok end).

%% 上线发送图鉴消息 ?CHECK_THROW
send_all_info() -> ?metrics(begin
								case get_atlas_list() of
									[] -> skip;
									AtlasList ->
										player:send(#pk_GS2U_AtlasUpdate{atlas_list = [make_atlas_msg(Atlas) || Atlas <- AtlasList]})
								end,
								ok end).

%% 图鉴激活，同步星数
atlas_active(AtlasID) -> ?metrics(begin
									  try
										  %%检测功能开启
										  ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
										  PetList = pet_new:get_pet_list(),
										  AtlasIDList = case AtlasID of
															0 ->%%一键激活 SR及以下品质图鉴
																lists:foldl(fun
																				(#atlas{atlas_id = Id, stars = 0}, Acc) ->
																					case cfg_petBase:getRow(Id) of
																						#petBaseCfg{rareType = RareType} when RareType =< 2 ->%%SR及以下品质图鉴
																							[Id | Acc];
																						_ -> Acc
																					end;
																				(#atlas{atlas_id = Id, stars = OldStar}, Acc) ->
																					case cfg_petBase:getRow(Id) of
																						#petBaseCfg{rareType = RareType} when RareType =< 2 ->%%SR及以下品质图鉴
																							NewStars = sync_stars(Id, OldStar, PetList),
																							case NewStars =:= OldStar of
																								?TRUE -> Acc;
																								_ -> [Id | Acc]
																							end;
																						_ -> Acc
																					end
																			end, [], get_atlas_list());
															_ ->%%激活单个图鉴
																%%检测该图鉴是否激活
																?CHECK_THROW(get_active_atlas(AtlasID) =:= {}, ?ErrorCode_GD_AlreadyActive),
																%%检测玩家是否曾经拥有对应宠物
																case lists:keymember(AtlasID, #pet_new.pet_cfg_id, pet_new:get_pet_list()) of
																	?TRUE -> skip;
																	?FALSE ->
																		case lists:keymember(AtlasID, #atlas.atlas_id, get_atlas_list()) of
																			?TRUE -> skip;
																			?FALSE -> throw(?ErrorCode_Pet_No)
																		end
																end,
																[AtlasID]
														end,
										  NewAtlasList = lists:foldl(fun(ID, Acc) ->
											  NewStars = sync_stars(ID, 0, PetList),
											  NewAtlas = #atlas{
												  atlas_id = ID,
												  stars = NewStars,
												  active_time = time:time(),
												  max_star = NewStars
											  }, [NewAtlas | Acc] end, [], AtlasIDList),
										  update_atlas(NewAtlasList),
										  calc_prop(?FALSE),
										  player_task:refresh_task(?Task_Goal_PetCount),
										  seven_gift:check_task(?Seven_Type_PetAtlas),
										  player:send(#pk_GS2U_AtlasActiveRet{atlas_id = AtlasID})
									  catch Err ->
										  player:send(#pk_GS2U_AtlasActiveRet{atlas_id = AtlasID, err_code = Err})
									  end
								  end).

%% 图鉴升级同步星数
atlas_level_up(AtlasID) -> ?metrics(begin
										try
											?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
											Atlas = get_active_atlas(AtlasID),
%%                                          检测图鉴是否激活
											?CHECK_THROW(Atlas =/= {}, ?ErrorCode_Card_No),
											PetBase = cfg_petBase:getRow(AtlasID),
											?CHECK_THROW(PetBase =/= {}, ?ERROR_Cfg),
											?CHECK_THROW(PetBase#petBaseCfg.elemType =/= 4, ?ERROR_Param),
											NewStar = sync_stars(AtlasID, Atlas#atlas.stars),
%%                                          判断升星条件是否满足
											?CHECK_THROW(NewStar > Atlas#atlas.stars, ?ErrorCode_Divine_Talent_Up_Star_Condition),
											NewAtlas = Atlas#atlas{stars = NewStar},
											update_atlas(NewAtlas),
											calc_prop(?FALSE),
											player:send(#pk_GS2U_AtlasLevelUpRet{atlas_id = AtlasID})
										catch Err ->
											player:send(#pk_GS2U_AtlasLevelUpRet{atlas_id = AtlasID, err_code = Err})
										end end).
%%领取图鉴激活奖励
atlas_active_reward(AtlasID) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 Atlas = get_active_atlas(AtlasID),%%   检测图鉴是否激活
					 ?CHECK_THROW(Atlas =/= {}, ?ErrorCode_Card_No),
					 PetBase = cfg_petBase:getRow(AtlasID),
					 ?CHECK_THROW(PetBase =/= {}, ?ERROR_Cfg),
					 ?CHECK_THROW(Atlas#atlas.is_reward =:= 0, ?Error_AtlasActiveRewardReceived),
					 F = fun({Type, Id, Value}, {ItemListRet, ConListRet}) ->
						 case Type of
							 1 -> {[{Id, Value} | ItemListRet], ConListRet};
							 2 -> {ItemListRet, [{Id, Value} | ConListRet]};
							 _ -> {ItemListRet, ConListRet}
						 end
						 end,
					 {ItemList, ConList} = lists:foldl(F, {[], []}, PetBase#petBaseCfg.illusgift),
					 player_item:reward(ItemList, [], ConList, ?REASON_Pet_AtlasActiveReward),
					 player_item:show_get_item_dialog(ItemList, ConList, [], 0),
					 update_atlas(Atlas#atlas{is_reward = 1}),
					 player:send(#pk_GS2U_AtlasActiveRewardRet{atlas_id = AtlasID})
				 catch
					 Err ->
						 player:send(#pk_GS2U_AtlasActiveRewardRet{atlas_id = AtlasID, err_code = Err})
				 end
			 end).


%% 图鉴进程字典 Atlas 图鉴id同宠物配置id
get_active_atlas(AtlasID) ->
	case lists:keyfind(AtlasID, #atlas.atlas_id, get_active_atlas_list()) of
		?FALSE -> {};
		Atlas -> Atlas
	end.

%% 已激活图鉴
get_active_atlas_list() ->
	case get(?MODULE) of
		?UNDEFINED -> [];
		AtlasList -> [Atlas || Atlas <- AtlasList, is_active(Atlas)]
	end.
%% 所有已获得宠物：已有数据，但星级为0，则为获得过该宠物
get_atlas_list() ->
	case get(?MODULE) of
		?UNDEFINED -> [];
		AtlasList -> AtlasList
	end.

%% 玩家进程获取最大星级
get_atlas_max_star(AtlasID) ->
	case lists:keyfind(AtlasID, #atlas.atlas_id, get_atlas_list()) of
		#atlas{max_star = MaxStar} -> MaxStar;
		_ -> 0
	end.

set_atlas_list(List) ->
	put(?MODULE, List).

is_active(Atlas) ->
	case Atlas of
		#atlas{stars = Star} when Star > 0 -> ?TRUE;
		_ -> ?FALSE
	end.

%% 总属性
put_all_atlas_prop(Prop) ->
	put(all_atlas_prop, Prop).
get_all_atlas_prop() ->
	case get(all_atlas_prop) of
		?UNDEFINED -> [];
		Attr -> Attr
	end.


%% 转换
db_atlas_to_record(Atlas) ->
	#atlas{
		atlas_id = Atlas#db_pet_atlas.atlas_id,
		stars = Atlas#db_pet_atlas.stars,
		active_time = Atlas#db_pet_atlas.active_time,
		max_star = Atlas#db_pet_atlas.max_star,
		is_reward = Atlas#db_pet_atlas.is_reward
	}.

record_atlas_to_db(Atlas) ->
	#db_pet_atlas{
		player_id = player:getPlayerID(),
		atlas_id = Atlas#atlas.atlas_id,
		stars = Atlas#atlas.stars,
		active_time = Atlas#atlas.active_time,
		max_star = Atlas#atlas.max_star,
		is_reward = Atlas#atlas.is_reward
	}.

make_atlas_msg(Atlas) ->
	#pk_AtlasInfo{
		atlas_id = Atlas#atlas.atlas_id,
		stars = Atlas#atlas.stars,
		max_star = Atlas#atlas.max_star,
		is_reward = Atlas#atlas.is_reward
	}.


%%计算属性总属性并保存
calc_prop(IsOnline) ->
	AtlasList = get_active_atlas_list(),
	F = fun(Atlas, Attr) ->
		AtlasID = Atlas#atlas.atlas_id,
		Stars = Atlas#atlas.stars,
		#petStarCfg{illusAttrAdd = StarAttr} = cfg_petStar:getRow(AtlasID, Stars),
		StarAttr ++ Attr end,
	AtlasAttr = lists:foldl(F, [], AtlasList),
	Prop = attribute:base_prop_from_list(common:listValueMerge(AtlasAttr)),
	put_all_atlas_prop(Prop),
	[attribute_player:on_prop_change() || not IsOnline].




is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetAtlas) =:= 1 andalso guide:is_open_action(?OpenAction_PetAtlas).

sync_stars(AtlasID, OldStars) ->
	PetList = pet_new:get_pet_list(),
	sync_stars(AtlasID, OldStars, PetList).
sync_stars(AtlasID, OldStars, PetList) ->
	MaxStar = get_atlas_max_star(AtlasID),
	F = fun(Pet, Stars) ->
		case Pet#pet_new.pet_cfg_id =:= AtlasID of
			?FALSE -> Stars;
			?TRUE ->
				case Pet#pet_new.star > Stars of
					?FALSE -> Stars;
					?TRUE -> Pet#pet_new.star
				end
		end end,
	lists:foldl(F, max(OldStars, MaxStar), PetList).

%% 更新数据
update_atlas([]) -> skip;
update_atlas(UpdateAtlasList) when is_list(UpdateAtlasList) ->
	table_player:insert(?DB_PET_ATLAS, [record_atlas_to_db(NewAtlas) || NewAtlas <- UpdateAtlasList]),
	AtlasList = get_atlas_list(),
	NewAtlasList =
		lists:foldl(fun(NewAtlas, Ret) ->
			lists:keystore(NewAtlas#atlas.atlas_id, #atlas.atlas_id, Ret, NewAtlas)
					end, AtlasList, UpdateAtlasList),
	set_atlas_list(NewAtlasList),
	player:send(#pk_GS2U_AtlasUpdate{atlas_list = [make_atlas_msg(NewAtlas) || NewAtlas <- NewAtlasList]});
update_atlas(NewAtlas) ->
	table_player:insert(?DB_PET_ATLAS, record_atlas_to_db(NewAtlas)),
	AtlasList = get_atlas_list(),
	NewAtlasList = lists:keystore(NewAtlas#atlas.atlas_id, #atlas.atlas_id, AtlasList, NewAtlas),
	set_atlas_list(NewAtlasList),
	player:send(#pk_GS2U_AtlasUpdate{atlas_list = [make_atlas_msg(NewAtlas)]}).

%% 获得大于等于指定品质图鉴的激活数量
check_atlas_active(Grade) ->
	List = get_active_atlas_list(),
	F = fun(Atlas) ->
		PetID = Atlas#atlas.atlas_id,
		PetBase = cfg_petBase:getRow(PetID),
		Grade =< PetBase#petBaseCfg.rareType
		end,
	AtlasList = lists:filter(F, List),
	length(AtlasList).

get_atlas_count() ->
	length(get_active_atlas_list()).

%% 检查已经获得宠物并更新，不给New标志
check_get(PetCfgID, Star) ->
	AtlasList = get_atlas_list(),
	case lists:keyfind(PetCfgID, #atlas.atlas_id, AtlasList) of
		#atlas{max_star = MaxStar} = A ->
			case Star > MaxStar of
				?TRUE -> update_atlas(A#atlas{max_star = Star});
				?FALSE -> skip
			end;
		_ -> update_atlas(#atlas{atlas_id = PetCfgID, max_star = Star})
	end.