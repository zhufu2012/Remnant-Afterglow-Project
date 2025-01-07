%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%               地图进程调用
%%% @end
%%% Created : 26. 七月 2018 16:36
%%%-------------------------------------------------------------------
-module(buff_map).
-author("cbfan").

-include("buff.hrl").
-include("record.hrl").
-include("globalDict.hrl").
-include("netmsgRecords.hrl").
-include("gameMap.hrl").
-include("logger.hrl").
-include("playerDefine.hrl").
-include("globalDict.hrl").
-include("skill.hrl").
-include("id_generator.hrl").
-include("cfg_buffCorr.hrl").
-include("db_table.hrl").
-include("cfg_mapsetting.hrl").
-include("attribute.hrl").
-include("cfg_buff.hrl").
-include("cfg_buffBase.hrl").
-include("skill_new.hrl").
-include("cfg_damLevel.hrl").

%% API
-export([
	get_buff_prop/2, get_buff_prop/3, get_buff_prop2/3, get_buff/2, add_buffer/4, add_buffer/6,
	add_buffer2/4, add_buffer2/6, add_buffer3/6, remove_buff/2, remove_buff/3,
	is_buff_exist/2, is_buff_exist/3, do_add_old_buff_data/3, on_obj_exit_map/2, on_obj_exit_map/3, on_erase_buff/2,
	on_map_init/0, add_buff_data/4, on_tick/4, map_send_buff_list/2, event_del_buff/3, remove_sb_buff_by_type/5,
	remove_sb_buff_by_type/6, send_role_buff/2]).
-export([get_skill_consume_buff_layer/3, on_tick_1s/1, create_role_copy_buff/2]).
-export([gm_add_buff/3, gm_remove_buff/2, on_send_buff_when_reconnect/1, gm_add_buff2/3]).
-export([on_damage_shield/3, check_effect_damage2attr/3]).
-export([unDoBuff_Charm/2, on_damage_shield_times/3]).    %% 该接口被buff_map模块调用，虽然实际流程应该是没有走的，导出来是为了解决编译警告
-export([save_buff_2_db_local/3, on_battle_status_change/2]).
-export([sd_change_buff_enable/3, on_add_buff_broadcast/3, handle_hurt/6,
	multiplicative_buff_layer_by_type/7, handle_damage_hit_effect/5, is_buff_type_exist/4, get_hlsilence_param/2, erase_hp_recover_param/2]).
-export([handle/1]).

-define(BuffTriggerAttack, 1).
-define(BuffTriggerBeAttacked, 101).
-define(BuffTriggerMove, 201).

handle({do_buff_activate_effect, TargetID, TargetRoleId, Buff, Param}) ->
	do_buff_activate_effect(TargetID, TargetRoleId, Buff, Param);
handle(Msg) ->
	?LOG_ERROR("unhandle msg ~p", [Msg]).

on_map_init() -> put(?ObjectBuffTable, []).

%% 加buff  死亡状态加不上 伤害类型BUFF友方加不上
add_buffer(CasterID, ObjectID, BuffDataID, SkillID) ->
	CasterRoleId = map_role:get_leader_id(CasterID),
	RoleIdList = map_role:get_role_id_list(ObjectID),
	lists:foreach(
		fun(RoleId) ->
			add_buffer(CasterID, CasterRoleId, ObjectID, RoleId, BuffDataID, SkillID)
		end, RoleIdList).
add_buffer(CasterID, CasterRoleId, ObjectID, RoleId, BuffDataID, SkillID) ->
	BuffCfg = cfg_buffBase:getRow(BuffDataID),
	case BuffCfg =/= {} andalso check_can_add_buff(BuffCfg, ObjectID) andalso charDefine:canAddbuff(ObjectID, RoleId) andalso can_add_buff_relation(BuffCfg, CasterID, CasterRoleId, ObjectID, RoleId) of
		?FALSE -> ?InvalidBuffCfg;
		?TRUE ->
			do_add_buffer(ObjectID, RoleId, BuffCfg, CasterID, CasterRoleId, SkillID)
	end.
%% 不判断死亡状态 不判断友方
add_buffer2(CasterID, ObjectID, BuffDataID, SkillID) ->
	CasterRoleId = map_role:get_leader_id(CasterID),
	RoleIdList = map_role:get_role_id_list(ObjectID),
	lists:foreach(
		fun(RoleId) ->
			add_buffer2(CasterID, CasterRoleId, ObjectID, RoleId, BuffDataID, SkillID)
		end, RoleIdList).
add_buffer2(CasterID, CasterRoleId, ObjectID, RoleId, BuffDataID, SkillID) ->
	BuffCfg = cfg_buffBase:getRow(BuffDataID),
	case BuffCfg =/= {} andalso check_can_add_buff(BuffCfg, ObjectID) of
		?FALSE ->
			?InvalidBuffCfg;
		?TRUE ->
			do_add_buffer(ObjectID, RoleId, BuffCfg, CasterID, CasterRoleId, SkillID)
	end.
%% 基于add_buffer2/4，将内部消息的发送改为基于地图，以便兼容联服的情况
add_buffer3(CasterID, CasterRoleId, ObjectID, RoleId, BuffDataID, SkillID) ->
	BuffCfg = cfg_buffBase:getRow(BuffDataID),
	case BuffCfg =/= {} andalso check_can_add_buff(BuffCfg, ObjectID) of
		?FALSE ->
			?InvalidBuffCfg;
		?TRUE ->
			do_add_buffer(ObjectID, RoleId, BuffCfg, CasterID, CasterRoleId, SkillID)
	end.

%% 地图心跳
on_tick(_MapAI, _MapDataID, Milliseconds, IntervalMS) -> on_tick_1(Milliseconds, IntervalMS).
on_tick_1s(TimesTamp) -> on_tick_2(TimesTamp).

%% 离开地图
on_obj_exit_map(ObjID, IsOffline) ->
	RoleIdList = map_role:get_role_id_list(ObjID) ++ map_pet:get_pet_obj_id_list(ObjID),
	lists:foreach(
		fun(RoleId) ->
			obj_exit_map_1(ObjID, RoleId, IsOffline)
		end, RoleIdList).
on_obj_exit_map(ObjID, IsOffline, MapAI) ->
	NeedSave = not lists:member(MapAI, ?ExpeditionMapAIList),
	RoleIdList = map_role:get_role_id_list(ObjID) ++ map_pet:get_pet_obj_id_list(ObjID),
	lists:foreach(
		fun(RoleId) ->
			%% 删除地图进程BUFF，返回BUFF
			event_del_buff(ObjID, RoleId, ?TranMap_Del_Buff),
			case get_buff(ObjID, RoleId) of
				{} -> ok;
				BuffData when NeedSave ->
					save_buff_2_db(BuffData, robot_player:is_robot(ObjID) orelse id_generator:id_type(ObjID), ObjID, IsOffline);
				_ -> ok
			end
		end, RoleIdList).
on_battle_status_change(ObjID, BattleStatus) ->
	RoleIdList = map_role:get_role_id_list(ObjID) ++ map_pet:get_pet_obj_id_list(ObjID),
	case BattleStatus of
		0 -> [buff_map:event_del_buff(ObjID, RoleId, ?Out_Del_Buff) || RoleId <- RoleIdList];
		1 -> [buff_map:event_del_buff(ObjID, RoleId, ?In_Del_BUff) || RoleId <- RoleIdList]
	end.

force_save_buff(ObjectId, RoleId) ->
	case get_buff(ObjectId, RoleId) of
		{} -> ok;
		ObjectBuff ->
			SaveBuffData = common:listsFiterMap(fun(Buff) ->
				BuffCfg = cfg_buffBase:getRow(Buff#buff_obj.buff_data_id),
				case BuffCfg#buffBaseCfg.deleteType band ?TranMap_Del_Buff > 0 of
					?TRUE -> ok;
					?FALSE -> Buff
				end
												end, ObjectBuff#objectBuff.dataList),
			save_buff_2_db(ObjectBuff#objectBuff{dataList = SaveBuffData}, robot_player:is_robot(ObjectId) orelse id_generator:id_type(ObjectId), ObjectId, ?FALSE)
	end.

on_erase_buff(ObjID, RoleId) ->
%% 删除地图进程BUFF，返回BUFF
	mapdb:deleteObjectTransFormInfo(ObjID, RoleId),
	case get_buff(ObjID, RoleId) of
		{} -> ok;
		_ ->
			BuffIdList = get(?ObjectBuffTable),
			erase({?ObjectBuffData, ObjID, RoleId}),
			erase_disable_list(ObjID),
			put(?ObjectBuffTable, lists:delete({ObjID, RoleId}, BuffIdList))
	end,
	erase_buff_damage_list(ObjID, RoleId),
	erase_buff_count_effect(ObjID, RoleId),
	erase_effect_damage2attr(ObjID, RoleId),
	erase_suck_attr(ObjID, RoleId),
	erase_hlsilence_param(ObjID, RoleId),
	erase_hp_recover_param(ObjID, RoleId),
	erase_buff_immune(ObjID, RoleId),
	ok.

map_send_buff_list([], _ObjectList) ->
	ok;
map_send_buff_list(_IdList, []) ->
	ok;
map_send_buff_list(IdList, ObjectList) ->
	NObjectList = lists:foldl(
		fun(ObjectID, List) ->
			RoleIdList = map_role:get_enable_role_id_list(ObjectID),
			[{ObjectID, RoleId} || RoleId <- RoleIdList] ++ List
		end, [], ObjectList),
	F = fun({ObjectID, RoleId}, Ret) ->
		case get_buff(ObjectID, RoleId) of
			{} -> Ret;
			ObjectBuff ->
				Fun = fun(X) ->
					#pk_ObjectBuff{
						id = X#buff_obj.buff_uid,
						caster_id = X#buff_obj.caster_id,
						caster_role_id = X#buff_obj.caster_role_id,
						buff_data_id = X#buff_obj.buff_data_id,
						allValidTime = X#buff_obj.valid_time,
						remainTriggerCount = X#buff_obj.remain_trigger_count,
						layoutNum = X#buff_obj.layout_num,
						is_pause = X#buff_obj.is_pause
					}
					  end,
				Buffs = [Fun(Item) || Item <- ObjectBuff#objectBuff.dataList],
				case Buffs of
					[] -> Ret;
					_ -> [#pk_ObjectBuffInfo{objectId = ObjectID, role_id = RoleId, buffs = Buffs} | Ret]
				end
		end
		end,
	BuffList = lists:foldl(F, [], NObjectList),
	case BuffList of
		[] -> ok;
		_ ->
			MapAi = map:getMapAI(),
			Msg = #pk_GS2U_BuffList{buffList = BuffList},
			NewIdList = [Id || Id <- IdList, mapView:filter_msg(MapAi, Id, Msg)],
			mapView:send_to_player_list(NewIdList, Msg)
	end.

%% 返回对象ObjectID身上是否有BuffDataID的BUFF
%% 不关心CasterID
is_buff_exist(ObjectID, BuffDataID) ->
	RoleIdList = map_role:get_role_id_list(ObjectID),
	lists:any(
		fun(RoleId) ->
			is_buff_exist(ObjectID, RoleId, BuffDataID)
		end, RoleIdList).
is_buff_exist(ObjectID, RoleId, BuffDataID) ->
	case get_buff(ObjectID, RoleId) of
		#objectBuff{dataList = DataList} ->
			lists:any(fun(#buff_obj{id_tuple = {_, BID}}) -> BuffDataID =:= BID end, DataList);
		_ -> ?FALSE
	end.
is_buff_type_exist(ObjectID, RoleId, Pos, Type) ->
	case get_buff(ObjectID, RoleId) of
		#objectBuff{dataList = DataList} ->
			lists:any(fun(#buff_obj{buff_data_id = BuffDataID}) ->
				case cfg_buffBase:getRow(BuffDataID) of
					#buffBaseCfg{buffType = BuffType} ->
						element(Pos, BuffType) =:= Type;
					_ -> ?FALSE
				end
					  end, DataList);
		_ -> ?FALSE
	end.

event_del_buff(ObjectId, RoleId, EventType) ->
	case get_buff(ObjectId, RoleId) of
		{} -> ok;
		ObjectBuff ->
			lists:foreach(fun(Buff) ->
				BuffCfg = cfg_buffBase:getRow(Buff#buff_obj.buff_data_id),

				case BuffCfg#buffBaseCfg.deleteType band EventType > 0 of
					?TRUE ->
						remove_buff(ObjectId, RoleId, Buff#buff_obj.id_tuple);
					?FALSE -> ok
				end,
				case EventType =:= ?Dead_Del_Buff of
					?TRUE ->
						case lists:keyfind(11, 1, Buff#buff_obj.activateEffect) of
							?FALSE -> ok;
							{_, P2, P3, P4, P5} ->
								[do_buff_activate_effect(ObjectId, RoleId, Buff, {P3, P4, P5}) || P2 >= 10000 orelse map_rand:rand() =< P2]
						end;
					?FALSE ->
						ok
				end
						  end, ObjectBuff#objectBuff.dataList)
	end.

%%
do_add_old_buff_data(ObjectID, RoleId, BuffDataList) ->
	F = fun(TBuffData) ->
		BuffData = TBuffData#buff_obj{buff_uid = mapdb:getObjectAutoBuffIndex()},
		case get_buff(ObjectID, RoleId) of
			{} ->
				put_buff(#objectBuff{id = ObjectID, role_id = RoleId, dataList = [BuffData]});
			ObjectBuff ->
				NDataList = lists:keydelete(BuffData#buff_obj.id_tuple, #buff_obj.id_tuple, ObjectBuff#objectBuff.dataList),
				put_buff(ObjectBuff#objectBuff{dataList = [BuffData | NDataList]})
		end,
		on_add_buff_broadcast(ObjectID, RoleId, BuffData)
		end,
	lists:foreach(F, BuffDataList).


%% 获取对象BUFF影响的属性 返回 [{Index, AddValue, MultiValue}]
get_buff_prop(ObjectID, RoleId) ->
	ObjectBuff = get_buff(ObjectID, RoleId),
	case ObjectBuff of
		{} -> [];
		_ ->
			SuckAttrList = calc_total_suck_attr(ObjectID, RoleId),
			F = fun
					(#buff_obj{is_enable = ?FALSE}, FixList) -> FixList;
					(BuffData, FixList) ->
						BuffCfg = cfg_buffBase:getRow(BuffData#buff_obj.buff_data_id),
						case BuffData#buff_obj.buff_effect of
							{Tp, _, _} when Tp =:= 0 orelse Tp =:= 3 orelse Tp =:= 6 orelse Tp =:= 7 -> %% 护盾类型buff属性生效
								case BuffData#buff_obj.attr_para of
									[] -> FixList;
									AttrList ->
										AdditionValue = get_buff_addition_value(ObjectID, RoleId, BuffData, BuffCfg),
										F = fun({_, I, A, M}, Ret) ->
											merge_prop({I, A * BuffData#buff_obj.layout_num + AdditionValue, M * BuffData#buff_obj.layout_num}, Ret)
											end,
										lists:foldl(F, FixList, AttrList)
								end;
							_ -> FixList
						end
				end,
			lists:foldl(F, SuckAttrList, ObjectBuff#objectBuff.dataList)
	end.

get_buff_addition_value(ObjectID, RoleId, BuffData, #buffBaseCfg{otherEffect = OtherEffect}) ->
	P1 = attribute_map:get_attribute(ObjectID, RoleId),
	case OtherEffect of
		{0, 0, 0, 0} -> 0;
		{Param1, Param2, Param3, Param4} ->
			%% 附加修正值
			AdditionFix = Param3 / 10000,
			BaseProp_P1 = attribute_map:get_base_attribute(ObjectID, RoleId),
			Value = case Param1 of
						%% 参数1=101时,附加效果值=附加修正值
						101 -> AdditionFix;
						%% 参数1=102时,附加效果值=【P1.基础属性(参数2对应属性)*附加修正值/10^4】
						102 -> ?MAP(BaseProp_P1, Param2) * AdditionFix;
						%% 参数1=103时,附加效果值=【P1.最终属性(参数2对应属性)*附加修正值/10^4】
						103 -> ?MAP(P1, Param2) * AdditionFix;
						%% 参数1=104时,附加效果值=【生命(参数2对应生命类型)*附加修正值/10^4】
						104 ->
							get_buff_addition_value_1({P1, BaseProp_P1}, Param2, AdditionFix, BuffData#buff_obj.param, Param4);
						_ -> 0
					end,
			Value;
		_ ->
			0
	end.
get_buff_addition_value_1({P1, BaseProp_P1}, Value, FixValue, BuffParam, Param4) ->
	case Value of
		%% 1.P1.基础最大生命
		1 -> ?MAP(BaseProp_P1, ?P_ShengMing) * FixValue;
		%% 3.P1.最大生命
		3 ->
			ObjectId1 = ?MAP(P1, ?P_ObjectID),
			case id_generator:id_type(ObjectId1) =:= ?ID_TYPE_Monster of
				?FALSE -> ?MAP(P1, ?P_ShengMing) * FixValue;
				?TRUE ->
					MonsterLv = mapdb:getMonsterProperty(ObjectId1, #mapMonster.level),
					CfgKey = common:getValueByInterval1(MonsterLv, cfg_damLevel:getKeyList(), 1),
					LvFixValue = element(#damLevelCfg.damLevel1 + Param4 - 1, cfg_damLevel:getRow(CfgKey)),
					?MAP(P1, ?P_ShengMing) * FixValue * LvFixValue / 10000
			end;
		%% 5.P1.当前生命
		5 ->
			ObjectId1 = ?MAP(P1, ?P_ObjectID),
			RoleId1 = ?MAP(P1, ?P_RoleId),
			mapdb:getObjectHp(ObjectId1, RoleId1) * FixValue;
		%% 7.P1.当前损生命
		7 ->
			ObjectId1 = ?MAP(P1, ?P_ObjectID),
			RoleId1 = ?MAP(P1, ?P_RoleId),
			n(?MAP(P1, ?P_ShengMing) - mapdb:getObjectHp(ObjectId1, RoleId1)) * FixValue;
		10 -> %% 10.(当前buff创造时记录生命值-当前buff触发时生命值）/自身最大生命值(buff后)*10000
			ObjectId1 = ?MAP(P1, ?P_ObjectID),
			RoleId1 = ?MAP(P1, ?P_RoleId),
			n(BuffParam - mapdb:getObjectHp(ObjectId1, RoleId1)) / mapdb:getObjectHpMax(ObjectId1, RoleId1) * 10000 * FixValue;
		11 -> %% 11.主人已损失生命值生命值影响宠物属性仅宠物用（转化为本buff的attrpara）参数2为转换比例（万分比）
			ObjectId1 = ?MAP(P1, ?P_ObjectID),
			RoleId1 = map_role:get_leader_id(ObjectId1),
			(10000 - mapdb:getObjectHpRate(ObjectId1, RoleId1) * 10000) * FixValue
	end.

n(V) when V < 0 -> 0;
n(V) -> V.

%% 获取对象BUFF影响的属性 返回 [{Index, AddValue, MultiValue}] Type 1-扫荡使用属性  2-挂机使用属性
get_buff_prop(ObjectID, RoleId, Type) ->
	ObjectBuff = get_buff(ObjectID, RoleId),
	case ObjectBuff of
		{} -> [];
		_ ->
			F = fun(BuffData, FixList) ->
				#buffBaseCfg{econoBuff = {_, Sweep, Hang, _}} = cfg_buffBase:getRow(BuffData#buff_obj.buff_data_id),
				{BuffType, _, _} = BuffData#buff_obj.buff_effect,
				IsCalc = case Type of
							 1 -> Sweep =:= 1;
							 2 -> Hang =:= 1
						 end,
				case IsCalc andalso BuffType =:= 0 of
					?TRUE ->
						case BuffData#buff_obj.attr_para of
							[] -> FixList;
							AttrList ->
								F = fun({_, I, A, M}, Ret) ->
									merge_prop({I, A * BuffData#buff_obj.layout_num, M * BuffData#buff_obj.layout_num}, Ret)
									end,
								lists:foldl(F, FixList, AttrList)
						end;
					_ -> FixList
				end
				end,
			lists:foldl(F, [], ObjectBuff#objectBuff.dataList)
	end.

%% 获取对象某个buff影响的属性
get_buff_prop2(ObjectID, RoleId, BuffDataID) ->
	case get_buff(ObjectID, RoleId) of
		#objectBuff{dataList = BuffList} ->
			case lists:keyfind(BuffDataID, #buff_obj.buff_data_id, BuffList) of
				#buff_obj{attr_para = AttrList, layout_num = N} ->
					[{I, A * N, M * N} || {_, I, A, M} <- AttrList];
				_ -> []
			end;
		_ -> []
	end.

%% 特殊处理 挂机buff特殊处理
add_buff_data(ObjectID, RoleId, BuffID, ValidTime) ->
	BuffCfg = cfg_buffBase:getRow(BuffID),
	{_LastTime, _, InitLayout, _} = BuffCfg#buffBaseCfg.timePara,

	Milliseconds = time:time_ms(),
	#buffBaseCfg{triggerPeriod = {T, T1, T2}} = BuffCfg,
	TriggerInfo = case T of
					  0 -> {};
					  ?BuffTriggerAttack ->
						  {T, T1, T2, 0};
					  ?BuffTriggerBeAttacked ->
						  {T, T1, T2, 0};
					  ?BuffTriggerMove ->
						  {T, T1, T2, 0, mapdb:getObjectPos(ObjectID)}
				  end,

	BuffData = #buff_obj{
		id_tuple = {ObjectID, BuffCfg#buffBaseCfg.iD},
		buff_uid = mapdb:getObjectAutoBuffIndex(),
		buff_data_id = BuffID,
		skill_id = 0,%%产生该BUFF的技能ID
		caster_id = ObjectID,
		caster_role_id = RoleId,
%%		is_enable = ?TRUE,
		is_enable = is_enable(ObjectID, BuffCfg),
		start_time = Milliseconds,   %%
		valid_time = ValidTime * 1000,   %% 单位ms
		last_dot_effect_time = Milliseconds,
		last_dot_effect_time_1 = Milliseconds,
		last_dot_effect_time_6 = Milliseconds,
		trigger_info = TriggerInfo,
		layout_num = InitLayout,
		shield = 0,            %%吸收伤害盾
		attr_para = BuffCfg#buffBaseCfg.attrPara,
		attr_para_base = BuffCfg#buffBaseCfg.attrPara,
		time_para = BuffCfg#buffBaseCfg.timePara
	},
	case get_buff(ObjectID, RoleId) of
		{} ->
			put_buff(#objectBuff{id = ObjectID, role_id = RoleId, dataList = [BuffData]});
		ObjectBuff ->
			NDataList = lists:keydelete(BuffData#buff_obj.id_tuple, #buff_obj.id_tuple, ObjectBuff#objectBuff.dataList),
			put_buff(ObjectBuff#objectBuff{dataList = [BuffData | NDataList]})
	end,
	on_add_buff_broadcast(ObjectID, RoleId, BuffData),
	do_buff_effect(ObjectID, RoleId, BuffData),
	ok.

gm_add_buff(FromPlayerID, ToPlayerName, BuffDataID) ->
	ToPlayerID = case is_integer(ToPlayerName) of
					 ?TRUE -> ToPlayerName;
					 _ ->
						 MapPlayerList = mapdb:getMapPlayerList(),
						 ToPlayerIDList = [MapPlayer#mapPlayer.id || MapPlayer <- MapPlayerList, MapPlayer#mapPlayer.name == ToPlayerName],
						 case ToPlayerIDList of
							 [] ->
								 FromPlayerID;%%没有找到目标，给自己上BUFF
							 [FirstPlayerID | _] ->
								 FirstPlayerID
						 end
				 end,
	ErrorCode = add_buffer2(FromPlayerID, ToPlayerID, BuffDataID, 0),
	?LOG_NOTICE("gmAddBuff ErrorCode  = ~p", [ErrorCode]).
gm_add_buff2(FromPlayerID, ToPlayerName, BuffDataID) ->
	ToPlayerID = case is_integer(ToPlayerName) of
					 ?TRUE -> ToPlayerName;
					 _ ->
						 MapPlayerList = mapdb:getMapPlayerList(),
						 ToPlayerIDList = [MapPlayer#mapPlayer.id || MapPlayer <- MapPlayerList, MapPlayer#mapPlayer.name == ToPlayerName],
						 case ToPlayerIDList of
							 [] ->
								 FromPlayerID;%%没有找到目标，给自己上BUFF
							 [FirstPlayerID | _] ->
								 FirstPlayerID
						 end
				 end,
	ErrorCode = add_buffer(FromPlayerID, ToPlayerID, BuffDataID, 0),
	?LOG_NOTICE("gmAddBuff ErrorCode  = ~p", [ErrorCode]).
gm_remove_buff(ObjectID, BuffDataID) ->
	remove_buff(ObjectID, BuffDataID).


%% 断线重连推送buff
on_send_buff_when_reconnect(PlayerID) ->
	RoleIdList = map_role:get_enable_role_id_list(?ID_TYPE_Player, PlayerID),
	MsgList = lists:foldl(
		fun(RoleId, List) ->
			case get_buff(PlayerID, RoleId) of
				{} -> List;
				ObjectBuff ->
					[#pk_GS2U_AddBuff{
						id = BuffObj#buff_obj.buff_uid,
						actor_id = PlayerID,
						actor_role_id = RoleId,
						caster_id = BuffObj#buff_obj.caster_id,
						caster_role_id = BuffObj#buff_obj.caster_role_id,
						buff_data_id = BuffObj#buff_obj.buff_data_id,
						allValidTime = BuffObj#buff_obj.valid_time,
						remainTriggerCount = BuffObj#buff_obj.remain_trigger_count,
						layoutNum = BuffObj#buff_obj.layout_num,
						is_pause = BuffObj#buff_obj.is_pause
					}
						|| BuffObj <- ObjectBuff#objectBuff.dataList] ++ List
			end
		end, [], RoleIdList),
	map:send_client(PlayerID, MsgList).

send_role_buff(PlayerID, RoleId) ->
	case get_buff(PlayerID, RoleId) of
		{} -> ok;
		ObjectBuff ->
			MsgList = [#pk_GS2U_AddBuff{
				id = BuffObj#buff_obj.buff_uid,
				actor_id = PlayerID,
				actor_role_id = RoleId,
				caster_id = BuffObj#buff_obj.caster_id,
				caster_role_id = BuffObj#buff_obj.caster_role_id,
				buff_data_id = BuffObj#buff_obj.buff_data_id,
				allValidTime = BuffObj#buff_obj.valid_time,
				remainTriggerCount = BuffObj#buff_obj.remain_trigger_count,
				layoutNum = BuffObj#buff_obj.layout_num,
				is_pause = BuffObj#buff_obj.is_pause
			}
				|| BuffObj <- ObjectBuff#objectBuff.dataList],
			map:send_client(PlayerID, MsgList)
	end.

%% 移除buff
remove_buff(ObjectID, BuffDataIDOrBuffIDTuple) ->
	RoleIdList = map_role:get_role_id_list(ObjectID),
	lists:foreach(
		fun(RoleId) ->
			remove_buff(ObjectID, RoleId, BuffDataIDOrBuffIDTuple)
		end, RoleIdList).
%%
remove_buff(ObjectID, RoleId, BuffDataID) ->
	remove_buff(ObjectID, RoleId, BuffDataID, ?FALSE).
remove_buff(ObjectID, RoleId, BuffDataID, IsTimeout) when is_integer(BuffDataID) ->
	try
		ObjectBuffRecord = get_buff(ObjectID, RoleId),
		case ObjectBuffRecord of
			{} -> throw(ok);
			_ ->
				Fun = fun(ObjectBuffData) ->
					{_, TBuffDataID} = IDTuple = ObjectBuffData#buff_obj.id_tuple,
					case TBuffDataID of
						BuffDataID ->
							remove_buff(ObjectID, RoleId, IDTuple, IsTimeout);
						_ -> ok
					end
					  end,
				lists:foreach(Fun, ObjectBuffRecord#objectBuff.dataList)
		end
	catch
		ErrorCode -> ErrorCode
	end;
remove_buff(ObjectID, RoleId, {_, _} = BuffIDTuple, IsTimeout) ->
	ObjectBuffRecord = get_buff(ObjectID, RoleId),
	case ObjectBuffRecord of
		{} -> ok;
		_ ->
			case lists:keytake(BuffIDTuple, #buff_obj.id_tuple, ObjectBuffRecord#objectBuff.dataList) of
				?FALSE -> ok;
				{value, RemoveBuff, NewBuffList} ->
					BuffCfg = cfg_buffBase:getRow(RemoveBuff#buff_obj.buff_data_id),
					{CasterID, BuffDataID} = BuffIDTuple,
					%%先保存
					put_buff(ObjectBuffRecord#objectBuff{dataList = NewBuffList}),
					%% 检查取消暂停
					check_unpause(BuffCfg, ObjectID, RoleId, NewBuffList),
					%%再使buff效果失效
					un_do_buff_effect(ObjectID, RoleId, RemoveBuff, BuffCfg, IsTimeout),
					%%广播
					Msg = #pk_GS2U_DelBuff{
						id = RemoveBuff#buff_obj.buff_uid,
						actor_id = ObjectID,
						actor_role_id = RoleId,
						caster_id = CasterID,
						buff_data_id = BuffDataID},
					mapView:broadcastByView_client(Msg, ObjectID, 0),
					RemoveBuff#buff_obj.shield =/= 0 andalso clean_object_shield(ObjectID, RoleId),
					{EffectType, _EffectParam, _} = BuffCfg#buffBaseCfg.effectType,
					if
						EffectType =:= ?BuffEffectType_TransForm ->
							skill_map:send_skill_fix(ObjectID, RoleId);
						true -> ok
					end,
					%% 同步经验BUFF
					case BuffCfg#buffBaseCfg.econoBuff of
						{1, _, _, _} ->
							check_send_hang_buff(ObjectID, RoleId);
						_ -> skip
					end,
					%% 事件响应，移除buff
					on_remove_buff(ObjectID, RoleId, RemoveBuff)
			end
	end;
remove_buff(_, _, _, _) -> ok.

check_unpause(_, _ObjectID, _RoleId, []) -> ok;
check_unpause(#buffBaseCfg{replace = 2, groupID = DelGroupID, level = DelLv}, ObjectID, RoleId, BuffList) when DelGroupID > 0 ->
	SortList = lists:keysort(1, [{-Cfg#buffBaseCfg.level, BuffObj} || BuffObj <- BuffList, (Cfg = cfg_buffBase:getRow(BuffObj#buff_obj.buff_data_id)) =/= {}
		andalso Cfg#buffBaseCfg.groupID =:= DelGroupID]),
	case lists:any(fun({Level, _}) -> Level =< -DelLv end, SortList) of
		?TRUE -> skip; %% 有同级的还在生效
		?FALSE when SortList =/= [] ->%% 按等级生效下一个
			{_, ActiveData} = hd(SortList),
			NewActiveData = ActiveData#buff_obj{is_pause = 0, is_enable = ?TRUE},
			update_buff_data(ObjectID, RoleId, NewActiveData),
			on_update_buff_broadcast(ObjectID, RoleId, NewActiveData);
		_ -> skip
	end;
check_unpause(_, _, _, _) -> ok.
%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 根据优先级删除buff
remove_buff_by_priority(ObjectId, RoleId, BuffList) ->
	SortFun =
		fun(A, B) ->
			#buffBaseCfg{priority = PA, level = LA} = cfg_buffBase:getRow(A#buff_obj.buff_data_id),
			#buffBaseCfg{priority = PB, level = LB} = cfg_buffBase:getRow(B#buff_obj.buff_data_id),
			case PA < PB of
				?TRUE -> ?TRUE;
				?FALSE ->
					case PA =:= PB of
						?TRUE -> LA < LB;
						?FALSE -> ?FALSE
					end
			end
		end,
	case lists:sort(SortFun, BuffList) of
		[H | _] ->
			remove_buff(ObjectId, RoleId, H#buff_obj.id_tuple);  %% TODO
		_ -> ok
	end.

%% 事件响应，移除buff
on_remove_buff(ObjectID, RoleId, BuffObj) ->
	#buffBaseCfg{triggerPara = {_, _, IsOverTrigger}} = BuffCfg = cfg_buffBase:getRow(BuffObj#buff_obj.buff_data_id),
	case IsOverTrigger =:= 1 of
		?TRUE -> do_buff_effect(ObjectID, RoleId, BuffObj);
		_ -> skip
	end,
	DamageList = buff_liquidation(ObjectID, RoleId, BuffObj),
	do_damage_result(DamageList, {ObjectID, RoleId, BuffObj, 1}, 0),
	[do_buff_activate_effect(ObjectID, RoleId, BuffObj, {P3, P4, P5}) || {2, P2, P3, P4, P5} <- BuffObj#buff_obj.activateEffect, P2 >= 10000 orelse map_rand:rand() =< P2],
	[do_buff_activate_count_effect(ObjectID, RoleId, {BuffCfg, BuffObj}, {P3, P4, P5}, lose) || {12, _P2, P3, P4, P5} <- BuffObj#buff_obj.activateEffect],
	skill_map:remove_map_skill(ObjectID, RoleId, BuffObj#buff_obj.temp_skill_list), %% 移除临时触发技
	ok.

on_remove_buff_layout(ObjectID, RoleId, BuffObj, Layout) ->
	#buffBaseCfg{triggerPara = {_, _, IsOverTrigger}} = cfg_buffBase:getRow(BuffObj#buff_obj.buff_data_id),
	case IsOverTrigger =:= 1 of
		?TRUE -> do_buff_effect(ObjectID, RoleId, BuffObj#buff_obj{layout_num = Layout});
		_ -> skip
	end.

%% BUFF清算
buff_liquidation(_ObjectID, _RoleId, #buff_obj{injury_liquidation = {0, _, _, _, _}}) -> [];
buff_liquidation(ObjectID, RoleId, #buff_obj{caster_id = CasterID, caster_role_id = CasterRoleID,
	injury_liquidation = {1, P1, P2, P3, _}, layout_num = LayerNum}) -> %% 按buff层数结算
	MapAttrP1 = attribute_map:get_attribute(CasterID, CasterRoleID),
	MapAttrP2 = attribute_map:get_attribute(ObjectID, RoleId),
	TargetP = case P1 of
				  1 -> MapAttrP1;
				  2 -> MapAttrP2
			  end,
	%% 基础结算伤害 =（buff层数*对应属性值*万分比）*（(P1.攻击伤害加成<GongJiShangHaiJiaCheng>-
	%% P2.攻击伤害减免<GongJiShangHaiJianMian>)/10000+伤害修正）
	BaseDamage = LayerNum * ?MAP(TargetP, P2) * P3 / 10000 * (n(?MAP(MapAttrP1, ?P_GongJiShangHaiJiaCheng) -
		?MAP(MapAttrP2, ?P_GongJiShangHaiJianMian)) / 10000 + attribute_map:get_damage_fix(MapAttrP1, MapAttrP2)),
	Value = attribute_map:get_final_damage(MapAttrP1, MapAttrP2, BaseDamage),
	{ShieldList, NewValue} = skill_new:damage_shield(CasterID, CasterRoleID, ObjectID, RoleId, Value),
	[skill_new:make_damage_info(ObjectID, RoleId, 0, 0, ?HitType_Hit, NewValue)] ++ ShieldList;
buff_liquidation(ObjectID, RoleId, #buff_obj{caster_id = CasterID, caster_role_id = CasterRoleID,
	injury_liquidation = {2, P1, _, _, _}, id_tuple = Key}) -> %% 按目标受到的累计伤害结算
	SumDamage = take_buff_damage(ObjectID, RoleId, Key),
	%% 基础结算伤害=（P2累计伤害*万分比）
	BaseDamage = trunc(SumDamage * P1 / 10000),
	{ShieldList, NewValue} = skill_new:damage_shield(CasterID, CasterRoleID, ObjectID, RoleId, BaseDamage),
	[skill_new:make_damage_info(ObjectID, RoleId, 0, 0, ?HitType_Hit, NewValue)] ++ ShieldList;
buff_liquidation(ObjectID, RoleId, #buff_obj{caster_id = CasterID, caster_role_id = CasterRoleID,
	injury_liquidation = {3, P1, _, _, SumDamage}}) -> %% 按目标受到的团队累计伤害结算
	%% 基础结算伤害=（P2累计伤害*万分比）
	BaseDamage = trunc(SumDamage * P1 / 10000),
	{ShieldList, NewValue} = skill_new:damage_shield(CasterID, CasterRoleID, ObjectID, RoleId, BaseDamage),
	[skill_new:make_damage_info(ObjectID, RoleId, 0, 0, ?HitType_Hit, NewValue)] ++ ShieldList.

%% 执行buff昏迷效果
do_buff_stun(ObjectID, RoleId) ->
	mapActorStateFlag:addStateFlag(ObjectID, RoleId, ?State_Flag_Disable_Hold).
%% 执行buff定身效果
do_buff_fasten(ObjectID, RoleId) ->
	mapActorStateFlag:addStateFlag(ObjectID, RoleId, ?State_Flag_Disable_Move).

%% 执行buff无敌效果
do_buff_immortal(ObjectID, RoleId, _ObjectBuff) ->
	mapActorStateFlag:addStateFlag(ObjectID, RoleId, ?State_Flag_God).

%% 执行buff沉默效果
do_buff_silence(ObjectID, RoleId, BuffCfg) ->
	{_, SkillType, _} = BuffCfg#buffBaseCfg.effectType,
	skill_map:silence(ObjectID, RoleId, SkillType).
%% 执行buff恐惧
do_buff_fear(ObjectID, RoleId, ObjectBuff) ->
	mapActorStateFlag:addStateFlag(ObjectID, RoleId, ?State_Flag_Fear),
	monster:onFearBegin(ObjectID, ObjectBuff#buff_obj.caster_id, ObjectBuff#buff_obj.caster_role_id).
%%  冰冻眩晕
do_buff_frozen(ObjectID, RoleId) ->
	mapActorStateFlag:addStateFlag(ObjectID, RoleId, ?State_Flag_FrozenHold).
%% 锁血
do_buff_lock_hp(ObjectID, RoleId, BuffCfg) ->
	{_, Percent, _} = BuffCfg#buffBaseCfg.effectType,
	skill_map:set_lock_hp(ObjectID, RoleId, Percent).
%% 限制伤害
do_buff_damage_limit(ObjectID, RoleId, BuffCfg) ->
	{_, Percent, _} = BuffCfg#buffBaseCfg.effectType,
	skill_map:set_damage_limit(ObjectID, RoleId, Percent).
%% 吸血万分比
do_buff_suck_blood(ObjectID, RoleId, BuffCfg, ObjectBuff) ->
	{_, Percent, LimitW} = BuffCfg#buffBaseCfg.effectType,
	LimitMax = trunc(mapdb:getObjectHpMax(ObjectID, RoleId) / 10000 * LimitW),
	skill_map:add_suck_blood_percent(ObjectID, RoleId, ObjectBuff#buff_obj.id_tuple, Percent, LimitMax).
%% 护盾增益/减益万分比
do_buff_shield_percent(ObjectID, RoleId, BuffCfg) ->
	{_, Percent, _} = BuffCfg#buffBaseCfg.effectType,
%%	?DDEBUG([ObjectID, RoleId, BuffCfg#buffBaseCfg.iD]),
	skill_map:set_shield_percent(ObjectID, RoleId, Percent).

%% 执行删除昏迷效果
unDoBuff_Stun(ObjectID, RoleId, _ObjectBuff) ->
	mapActorStateFlag:removeStateFlag(ObjectID, RoleId, ?State_Flag_Disable_Hold).
%% 执行删除定身效果
unDoBuff_Fasten(ObjectID, RoleId, _ObjectBuff) ->
	mapActorStateFlag:removeStateFlag(ObjectID, RoleId, ?State_Flag_Disable_Move).
%% 执行删除定身效果
undo_buff_science(ObjectID, RoleId, BuffCfg) ->
	{_, SkillType, _} = BuffCfg#buffBaseCfg.effectType,
	skill_map:undo_silence(ObjectID, RoleId, SkillType).
%% 执行删除无敌效果
unDoBuff_Immortal(ObjectID, RoleId, _ObjectBuff) ->
	mapActorStateFlag:removeStateFlag(ObjectID, RoleId, ?State_Flag_God).
%% 执行删除恐惧效果
unDoBuff_Fear(ObjectID, RoleId, _ObjectBuff) ->
	mapActorStateFlag:removeStateFlag(ObjectID, RoleId, ?State_Flag_Fear),
	monster:onFearEnd(ObjectID).
%% 执行删除魅惑状态
unDoBuff_Charm(ObjectID, RoleId) ->
	mapActorStateFlag:removeStateFlag(ObjectID, RoleId, ?State_Flag_Charm).
%% 执行删除FrozenHold状态
unDoBuff_FrozenHold(ObjectID, RoleId) ->
	mapActorStateFlag:removeStateFlag(ObjectID, RoleId, ?State_Flag_FrozenHold).
unDoBuff_TransForm(ObjectID, RoleId, BuffCfg) ->
	{_, TransformId, _} = BuffCfg#buffBaseCfg.effectType,
	transform:transform_back(ObjectID, RoleId, TransformId).
%% 取消锁血
undo_buff_lock_hp(ObjectID, RoleId) ->
	skill_map:erase_lock_hp(ObjectID, RoleId).
%% 取消限制伤害
undo_buff_damage_limit(ObjectID, RoleId) ->
	skill_map:erase_damage_limit(ObjectID, RoleId).

%% ActivateEffect 字段
do_buff_dot1(Record, TriggerInterval, PlayerID, RoleId, Milliseconds, Param, IsLimitTime, _BuffCfg) ->
	TimeLost = Milliseconds - Record#buff_obj.last_dot_effect_time_1,
	case TimeLost > TriggerInterval of
		?TRUE ->%%单次dot时间有效
			RemainTime = on_time_update_buff(PlayerID, RoleId, Record, TimeLost, TriggerInterval, {1, Param}),
			case RemainTime > 0 orelse IsLimitTime of
				?TRUE ->%%还剩余时间
					update_buff_with(PlayerID, RoleId, Record#buff_obj.id_tuple, fun(R) ->
						R#buff_obj{last_dot_effect_time_1 = Milliseconds, valid_time = RemainTime} end);
				?FALSE ->%%存活时间已完
					remove_buff(PlayerID, RoleId, Record#buff_obj.id_tuple, ?TRUE)
			end;
		?FALSE -> ok
	end.

%% ActivateEffect 字段
do_buff_dot6(Record, TriggerInterval, PlayerID, RoleId, Milliseconds, Param, IsLimitTime, BuffCfg) ->
	TimeLost = Milliseconds - Record#buff_obj.last_dot_effect_time_6,
	IsEffect = map_armor:check_armor_effect(PlayerID, BuffCfg#buffBaseCfg.activateEffect, 6),
	case TimeLost > TriggerInterval andalso IsEffect of
		?TRUE ->%%单次dot时间有效
			RemainTime = on_time_update_buff(PlayerID, RoleId, Record, TimeLost, TriggerInterval, {1, Param}),
			case RemainTime > 0 orelse IsLimitTime of
				?TRUE ->%%还剩余时间
					update_buff_with(PlayerID, RoleId, Record#buff_obj.id_tuple, fun(R) ->
						R#buff_obj{last_dot_effect_time_6 = Milliseconds, valid_time = RemainTime} end);
				?FALSE ->%%存活时间已完
					remove_buff(PlayerID, RoleId, Record#buff_obj.id_tuple, ?TRUE)
			end;
		?FALSE -> ok
	end.

do_buff_time_flow(_BuffCfg, Record, PlayerID, RoleId, TimeDt) ->
	{LastTime, _, _, _} = Record#buff_obj.time_para,
	case LastTime > 0 of
		?TRUE ->%%有时效的buff
			RemainTime = erlang:trunc(Record#buff_obj.valid_time - TimeDt),
			case RemainTime =< LastTime * 0.02 of %% 误差容错
				?TRUE ->%%时间到
					remove_buff(PlayerID, RoleId, Record#buff_obj.id_tuple, ?TRUE);
				?FALSE ->
					Record2 = Record#buff_obj{valid_time = RemainTime},
					update_buff_data(PlayerID, RoleId, Record2)
			end;
		?FALSE -> ok
	end.

get_buff(ObjectId, RoleId) -> case get({?ObjectBuffData, ObjectId, RoleId}) of ?UNDEFINED -> {}; Buff -> Buff end.

put_buff(Buff) ->
	put({?ObjectBuffData, Buff#objectBuff.id, Buff#objectBuff.role_id}, Buff),
	BuffIdList = get(?ObjectBuffTable),
	%% 存放身上有buff 的对象
	case lists:member({Buff#objectBuff.id, Buff#objectBuff.role_id}, BuffIdList) of
		?TRUE -> ok;
		?FALSE -> put(?ObjectBuffTable, [{Buff#objectBuff.id, Buff#objectBuff.role_id} | BuffIdList])
	end.

on_tick_1(Milliseconds, IntervalMS) ->
	BuffObjectIDList = get(?ObjectBuffTable),
	InternalTuple = internal_round(IntervalMS),
	UpdateBuffFunc = fun({ObjectID, RoleId}) ->
		case get_buff(ObjectID, RoleId) of
			{} -> ok;
			ObjectBuff ->
				on_buff_update(ObjectBuff#objectBuff.dataList, ObjectBuff#objectBuff.id, ObjectBuff#objectBuff.role_id, Milliseconds, InternalTuple)
		end
					 end,
	lists:foreach(UpdateBuffFunc, BuffObjectIDList).

internal_round(IntervalMS) ->
	case get({?MODULE, ?FUNCTION_NAME}) of
		{T1} ->
			put({?MODULE, ?FUNCTION_NAME}, {}),
			{IntervalMS, T1 + IntervalMS};
		_ ->
			put({?MODULE, ?FUNCTION_NAME}, {IntervalMS}),
			{IntervalMS, 0}
	end.

on_tick_2(TimesTamp) ->
	BuffObjectIDList = get(?ObjectBuffTable),
	MapIsWheel = map:getMapIsWheel(),
	UpdateBuffFunc = fun({ObjectID, RoleId}, Acc) ->
		ObjectBuff = get_buff(ObjectID, RoleId),
		Func = fun(#buff_obj{buff_data_id = BuffDataID} = R) ->
			#buffBaseCfg{effectType = EffectType, econoBuff = {Type, _, _, _}} = cfg_buffBase:getRow(BuffDataID),
			R1 = case MapIsWheel andalso Type =:= 0 of
					 ?TRUE ->
						 case {id_generator:id_type(ObjectID) =:= ?ID_TYPE_Player, map_role:get_role(ObjectID, RoleId)} of
							 {?TRUE, #mapRole{enable = 1}} -> R#buff_obj{is_enable = ?TRUE};
							 {?TRUE, _} -> R#buff_obj{is_enable = ?FALSE};
							 _ -> R
						 end;
					 _ -> R
				 end,
			case EffectType of
				{18, Param, _} ->
					IsAttackState = mapdb:is_attack_state(ObjectID, TimesTamp),
					IsEnable = common:getTernaryValue(Param =:= 0, not IsAttackState, IsAttackState),
					R1#buff_obj{is_enable = IsEnable};
				_ -> R1
			end
			   end,
		NewDataList = lists:map(Func, ObjectBuff#objectBuff.dataList),
		NewObjectBuff = ObjectBuff#objectBuff{dataList = NewDataList},
		put_buff(NewObjectBuff),
		?IF(NewDataList =:= [], Acc, [{ObjectID, RoleId} | Acc])
					 end,
	NewBuffTable = lists:foldl(UpdateBuffFunc, [], BuffObjectIDList),
	length(NewBuffTable) =/= length(BuffObjectIDList) andalso put(?ObjectBuffTable, NewBuffTable),
	ok.

%% 过滤不能加的buff
check_can_add_buff(#buffBaseCfg{buffEffect = {EffectType, _, _}}, ObjectId) when EffectType =:= 1 orelse EffectType =:= 8 ->
	map:is_out_safe_area(ObjectId, 0);
check_can_add_buff(#buffBaseCfg{buffType = {_, _, 39}}, ObjectId) ->
	case id_generator:id_type(ObjectId) of
		?ID_TYPE_Monster ->
			P = attribute_map:get_attribute(ObjectId, ObjectId),
			ObjectType = ?MAP(P, ?P_ObjectType),
			ObjectType =/= ?ObjectType_MonsterBoss;
		_ -> ?TRUE
	end;
%%check_can_add_buff(#buffBaseCfg{buffType = {GeneralType, _, _}}, _ObjectId) when GeneralType =:= 2 orelse GeneralType =:= 4 ->
%%	case map:getMapAI() of
%%		_ ->
%%			?TRUE
%%	end;
check_can_add_buff(#buffBaseCfg{objectType = _ObjTypeList}, _ObjectId) -> ?TRUE.
%%	ObjectType = id_generator:id_type(ObjectId),
%%	not lists:member(ObjectType, ObjTypeList).

%% 伤害类型BUFF不能加给友方 详细标识 62特殊伤害buff（能对友方加）
can_add_buff_relation(#buffBaseCfg{buffEffect = {T, _, _}, buffType = {_, _, T3}}, CasterID, CasterRoleId, ObjectID, RoleId) when (T =:= 1 orelse T =:= 8) andalso T3 =/= 62 ->
	charDefine:getRelation_Enemy(CasterID, CasterRoleId, ObjectID, RoleId);
can_add_buff_relation(_, _, _, _, _) -> ?TRUE.

do_add_buffer(ObjectID, RoleId, BuffCfg, CasterID, CasterRoleId, SkillID) ->
	try
		AddBuffCfg = do_buff_fix(CasterID, CasterRoleId, BuffCfg),
		%% 是否存在免疫类型
		case is_exists_immune(ObjectID, RoleId, AddBuffCfg) of ?TRUE -> throw(?Immune); _ -> ok end,
		{ErrorCode, DoBuffEffect, NewBuffData} = do_add_buff_final(ObjectID, RoleId, AddBuffCfg, {CasterID, CasterRoleId, ObjectID, RoleId, SkillID, time:time_ms()}),
%%		?LOG_ERROR("add buff ret :~p", [{ErrorCode, DoBuffEffect, AddBuffCfg#buffBaseCfg.iD, NewBuffData}]),

		%% 挂机特殊处理
		case (ErrorCode =:= ?Addbuff orelse ErrorCode =:= ?UpdateBuff) andalso AddBuffCfg#buffBaseCfg.econoBuff of
			{1, _, _, _} ->
				check_send_hang_buff(ObjectID, RoleId),
				%% 经济BUFF强制保存一下
				force_save_buff(ObjectID, RoleId);
			_ -> skip
		end,
		case ErrorCode of
			?Addbuff -> on_add_buff_broadcast(ObjectID, RoleId, NewBuffData);
			?UpdateBuff -> on_update_buff_broadcast(ObjectID, RoleId, NewBuffData);
			_ -> throw(ErrorCode)
		end,
		%% DoBuffEffect buff层数改变的时候 此参数ture
		case DoBuffEffect of
			?TRUE -> check_buff_layout_activate(ObjectID, RoleId, NewBuffData);
			_ -> throw(ok)
		end,
		%% Buff效果
		do_buff_effect_type(ObjectID, RoleId, AddBuffCfg, NewBuffData),
		%% 检查创建触发效果
		case AddBuffCfg#buffBaseCfg.triggerPara of
			{_, 1, _} -> do_buff_effect(ObjectID, RoleId, NewBuffData);
			_ -> skip
		end,
		[do_buff_activate_effect(ObjectID, RoleId, NewBuffData, {P3, P4, P5}) || {1, P2, P3, P4, P5} <- AddBuffCfg#buffBaseCfg.activateEffect, P2 >= 10000 orelse map_rand:rand() =< P2],
		[do_buff_activate_count_effect(ObjectID, RoleId, {BuffCfg, NewBuffData}, {P3, P4, P5}, get) || {12, _P2, P3, P4, P5} <- AddBuffCfg#buffBaseCfg.activateEffect],
		ErrorCode
	catch
		TErrorCode ->
			TErrorCode
	end.

do_buff_activate_count_effect(ObjectID, RoleId, {BuffCfg, BuffObj}, {AimType, 2, BuffID}, get) ->
	try
		#buff_obj{caster_id = CasterID, caster_role_id = CasterRoleID} = BuffObj,
		AimList = get_aim_list_by_type(AimType, ObjectID, RoleId, CasterID, CasterRoleID, BuffObj, BuffCfg),
		lists:foreach(fun({AimId, AimRoleId}) ->
			List = get_buff_count_effect(AimId, AimRoleId),
			case lists:keyfind(BuffID, 1, List) of
				?FALSE ->
					put_buff_count_effect(AimId, AimRoleId, [{BuffID, 1} | List]),
					add_buffer2(AimId, AimRoleId, AimId, AimRoleId, BuffID, 0);
				{_, N} ->
					put_buff_count_effect(AimId, AimRoleId, lists:keystore(BuffID, 1, List, {BuffID, N + 1}))
			end
					  end, AimList)
	catch
		ok -> ok
	end;
do_buff_activate_count_effect(ObjectID, RoleId, {BuffCfg, BuffObj}, {AimType, 2, BuffID}, lose) ->
	try
		#buff_obj{caster_id = CasterID, caster_role_id = CasterRoleID} = BuffObj,
		AimList = get_aim_list_by_type(AimType, ObjectID, RoleId, CasterID, CasterRoleID, BuffObj, BuffCfg),
		lists:foreach(fun({AimId, AimRoleId}) ->
			List = get_buff_count_effect(AimId, AimRoleId),
			case lists:keyfind(BuffID, 1, List) of
				?FALSE -> ok;
				{_, N} when N > 1 ->
					put_buff_count_effect(AimId, AimRoleId, lists:keystore(BuffID, 1, List, {BuffID, N - 1}));
				{_, _} ->
					put_buff_count_effect(AimId, AimRoleId, lists:keydelete(BuffID, 1, List)),
					remove_buff(AimId, AimRoleId, BuffID)
			end
					  end, AimList)
	catch
		ok -> ok
	end;
do_buff_activate_count_effect(_ObjectID, _RoleId, _, _, _) -> ok.

get_buff_count_effect(ObjectID, RoleId) ->
	case get({?MODULE, buff_count_effect, ObjectID, RoleId}) of
		?UNDEFINED -> [];
		List -> List
	end.
put_buff_count_effect(ObjectID, RoleId, List) ->
	put({?MODULE, buff_count_effect, ObjectID, RoleId}, List).
erase_buff_count_effect(ObjectID, RoleId) ->
	erase({?MODULE, buff_count_effect, ObjectID, RoleId}).

obj_exit_map_1(ObjID, RoleId, IsOffline) ->
	%% 删除地图进程BUFF，返回BUFF
	event_del_buff(ObjID, RoleId, ?TranMap_Del_Buff),
	case get_buff(ObjID, RoleId) of
		{} -> ok;
		BuffData ->
			save_buff_2_db(BuffData, robot_player:is_robot(ObjID) orelse id_generator:id_type(ObjID), ObjID, IsOffline)
	end.

%%save_buff_2_db(BuffData, ?ID_TYPE_Player, PlayerID, IsOffLine) -> skip;
save_buff_2_db(BuffData, ?ID_TYPE_Player, PlayerID, IsOffLine) ->
%%	db_table:insert(db_buff, #db_buff{
%%		buff_list = gamedbProc:term_to_dbstring(BuffData#objectBuff.dataList),
%%		player_id = PlayerID
%%	}),
%%	[m_send:send_msg_2_player_proc(PlayerID, {buff_flush}) || not IsOffLine],
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{serverID = ServerId} ->
			cluster:cast_process(group, ServerId, mainPID, {server_buff_flash, PlayerID, BuffData, IsOffLine});
		_ -> skip
	end,
	ok;
save_buff_2_db(_, _, _, _) -> ok.

save_buff_2_db_local(PlayerID, BuffData, IsOffLine) ->
	table_player:insert(db_buff, BuffData),
	[m_send:send_msg_2_player_proc(PlayerID, {buff_flush}) || not IsOffLine],
	#objectBuff{id = ID, role_id = RoleID, dataList = DataList} = BuffData,
	table_log:insert_row(log_buff_save, [ID, RoleID, gamedbProc:term_to_dbstring([{P1, P2, P3} || #buff_obj{buff_data_id = P1, start_time = P2, valid_time = P3} <- DataList]), time:time()]).

%% 移动触发的buff 处理
check_buff_move_trigger(ObjId, RoleId, #buff_obj{trigger_info = {?BuffTriggerMove, D, Interval, NextTriggerTime, Pos}, is_enable = ?TRUE} = BuffObj, NowTime) when NowTime > NextTriggerTime ->
	NowPos = mapdb:getObjectPos(ObjId),
	Times = trunc(mapView:getDistance(NowPos, Pos) / D),
	case Times > 0 of
		?TRUE ->
			Times1 = case Interval =:= 0 of
						 ?TRUE -> Times;
						 _ -> 1
					 end,
			[do_buff_trigger_2(ObjId, RoleId, BuffObj) || _T <- lists:seq(1, Times1)],
			BuffObj#buff_obj{
				trigger_info = {?BuffTriggerMove, D, Interval, NowTime + Interval, NowPos}
			};
		_ -> BuffObj
	end;
check_buff_move_trigger(ObjId, _RoleId, #buff_obj{trigger_info = {?BuffTriggerMove, D, Interval, NextTriggerTime, _Pos}, is_enable = ?TRUE} = BuffObj, NowTime) when NowTime < NextTriggerTime ->
	NowPos = mapdb:getObjectPos(ObjId),
	BuffObj#buff_obj{
		trigger_info = {?BuffTriggerMove, D, Interval, NextTriggerTime, NowPos}
	};
check_buff_move_trigger(_ObjId, _RoleId, BuffObj, _NowTime) ->
	BuffObj.

do_buff_trigger_2(ObjId, RoleId, BuffObj) ->
	do_buff_effect(ObjId, RoleId, BuffObj),
	[do_buff_activate_effect(ObjId, RoleId, BuffObj, {P3, P4, P5}) || {3, _, P3, P4, P5} <- BuffObj#buff_obj.activateEffect].


%% 获取视野内的对象列表
get_buff_view_list(CasterID, BuffCfg) ->
	Pos = mapdb:getObjectPos(CasterID),
	{MinDistance, MaxDistance} = BuffCfg#buffBaseCfg.rangeAura,
	case MaxDistance =:= 0 of
		?TRUE ->
			[{ObjectId, RoleId} || {ObjectId, RoleId} <- mapdb:get_object_role_id_list(), mapdb:getObjectHp(ObjectId, RoleId) > 0];
		_ ->
			Fun = fun(#objectPos{id = ObjectID, type = Type, is_viewer = IsViewer} = ObjectPos, List) ->
				case ObjectID =/= CasterID andalso not IsViewer andalso mapView:isDistanceLessThan(Pos, ObjectPos, MaxDistance)
					andalso mapView:isDistanceGreaterThan(Pos, ObjectPos, MinDistance) of
					?TRUE ->
						RoleIdList = map_role:get_enable_role_id_list(Type, ObjectID),
						[{ObjectID, RoleId} || RoleId <- RoleIdList, mapdb:isObjectDead(ObjectID, RoleId) =:= ?FALSE] ++ List;
					?FALSE ->
						List
				end
				  end,
			lists:foldl(Fun, [], mapdb:getObjectPosList())
	end.


%% activateEffect
do_buff_activate_effect(ObjectID, RoleId, BuffObj, {AimType, TriggerType, Param}) ->
	try
		case BuffObj#buff_obj.is_enable of
			?TRUE -> ok;
			_ -> throw(ok)
		end,
		BuffCfg = cfg_buffBase:getRow(BuffObj#buff_obj.buff_data_id),
		#buff_obj{id_tuple = IdTuple, caster_id = CasterId, caster_role_id = CasterRoleId, buff_data_id = BuffDataId} = BuffObj,
		case mapdb:getObjectPos(CasterId) of
			#objectPos{} -> skip;
			_ -> throw(ok)
		end,
		AimList = get_aim_list_by_type(AimType, ObjectID, RoleId, CasterId, CasterRoleId, BuffObj, BuffCfg),
%%		?LOG_ERROR("buff activate :~p", [{ObjectID, {TriggerType, Param, AimType}, AimList}]),
		case TriggerType of
			1 ->
				case dungeon_mount:get_take_buff_id(CasterId) of
					BuffDataId ->
						[SkillItem] = skill_lib:make_map_skill_list([{Param, 1, [], 0}]),
						skill_map:set_object_skill_item(ObjectID, RoleId, SkillItem),
						add_temp_skill(ObjectID, RoleId, IdTuple, [Param]);
					_ -> skip
				end,
				skill_new:server_use_skill(CasterId, CasterRoleId, Param, 0, 0, AimList, 2),
				ok;
			2 ->
				[buff_map:add_buffer(CasterId, CasterRoleId, AimId, AimRoleId, Param, 0) || {AimId, AimRoleId} <- AimList];
			3 ->
				TempSkillList = skill_player:skill_fix_combo_skill([{Param, 1, [], 0}]),
				skill_map:add_map_skill(ObjectID, RoleId, TempSkillList),
				add_temp_skill(ObjectID, RoleId, IdTuple, [element(1, TempSkill) || TempSkill <- TempSkillList]);
			_ -> skip
		end
	catch
		ok -> ok
	end.

add_temp_skill(ObjectID, RoleId, IdTuple, SkillIDList) ->
	case get_buff(ObjectID, RoleId) of
		{} -> ok;
		ObjectBuffRecord ->
			case lists:keyfind(IdTuple, #buff_obj.id_tuple, ObjectBuffRecord#objectBuff.dataList) of
				?FALSE -> skip;
				#buff_obj{temp_skill_list = OldTempSkillList} = BuffObj ->
					NewList = lists:keyreplace(IdTuple, #buff_obj.id_tuple, ObjectBuffRecord#objectBuff.dataList, BuffObj#buff_obj{temp_skill_list = SkillIDList ++ OldTempSkillList}),
					put_buff(ObjectBuffRecord#objectBuff{dataList = NewList})
			end
	end.

get_aim_list_by_type(AimType, ObjectID, RoleId, CasterId, CasterRoleId, BuffObj, BuffCfg) ->
	CasterType = id_generator:id_type(CasterId),
	AimList2 = case AimType of
				   0 -> [{ObjectID, RoleId}];
				   3 -> [{CasterId, CasterRoleId}];
				   4 ->
					   case CasterType of
						   ?ID_TYPE_Player ->
							   [{CasterId, map_role:get_leader_id(CasterId)}];
						   ?ID_TYPE_Monster when BuffObj#buff_obj.attach_owner_id > 0 ->
							   [{BuffObj#buff_obj.attach_owner_id, map_role:get_leader_id(BuffObj#buff_obj.attach_owner_id)}];
						   _ -> throw(ok)
					   end;
				   5 -> case map_pet:get_pet_obj_list(CasterId) of
							[] -> [];
							PetInfoList ->
								case lists:keyfind(CasterRoleId, #map_pet.object_id, PetInfoList) of
									#map_pet{been_link_uid = BeenLinkUid} when BeenLinkUid > 0 ->
										[{CasterId, BeenLinkUid}];
									_ -> []
								end
						end;
				   _ ->
					   ViewList = get_buff_view_list(BuffObj#buff_obj.caster_id, BuffCfg),
					   AimList1 = charDefine:select_skill_object_list(CasterType, CasterId, CasterRoleId, ViewList, BuffCfg#buffBaseCfg.targetAura),
					   case AimType of
						   1 -> lists:delete({ObjectID, RoleId}, AimList1);
						   2 -> AimList1
					   end
			   end,
	AimList3 = lists:usort(AimList2),
	[{TargetID, TargetRoleId} || {TargetID, TargetRoleId} <- AimList3,
		skill_new:can_use_skill_buff_2_target(CasterType, CasterId, CasterRoleId, TargetID, TargetRoleId)].

merge_prop({I, A, M}, List) ->
	case lists:keyfind(I, 1, List) of
		{I, Add, Multi} -> lists:keystore(I, 1, List, {I, Add + A, Multi + M});
		_ -> [{I, A, M} | List]
	end.


%% 追赶流失的时间（若流失的时间超过了2次BUFF脉冲的间隔，则执行多次）
%% return BUFF剩余时间
on_time_update_buff(ObjectID, RoleId, BuffData, TimeLost, TriggerInterval, T) ->
	TimeDist = TimeLost - TriggerInterval,
	case TimeDist > 0 of
		?TRUE ->
			case T of
				0 -> do_buff_effect(ObjectID, RoleId, BuffData);
				{1, Param} -> do_buff_activate_effect(ObjectID, RoleId, BuffData, Param) %% TODO
			end,
			RemainTime = BuffData#buff_obj.valid_time - TriggerInterval,
			NewObjectBuffData = setelement(#buff_obj.valid_time, BuffData, RemainTime),
			case (TimeDist >= TriggerInterval) andalso (RemainTime > 0) of
				?TRUE ->
					on_time_update_buff(ObjectID, RoleId, NewObjectBuffData, TimeDist, TriggerInterval, T);
				?FALSE -> NewObjectBuffData#buff_obj.valid_time
			end;
		?FALSE -> BuffData#buff_obj.valid_time
	end.

%% triggerPara 字段
do_buff_dot(Record, TriggerInterval, PlayerID, RoleId, Milliseconds, IsLimitTime, _BuffCfg) ->
	TimeLost = Milliseconds - Record#buff_obj.last_dot_effect_time,
	case TimeLost > TriggerInterval of
		?TRUE ->%%单次dot时间有效
			RemainTime = on_time_update_buff(PlayerID, RoleId, Record, TimeLost, TriggerInterval, 0),
			case RemainTime > 0 orelse IsLimitTime of
				?TRUE ->%%还剩余时间
					update_buff_with(PlayerID, RoleId, Record#buff_obj.id_tuple, fun(R) ->
						R#buff_obj{last_dot_effect_time = Milliseconds, valid_time = RemainTime} end);
				?FALSE ->%%存活时间已完
					remove_buff(PlayerID, RoleId, Record#buff_obj.id_tuple, ?TRUE)
			end;
		?FALSE -> ok
	end.

on_buff_update([], _PlayerID, _RoleId, _Milliseconds, _InternalTuple) -> ok;
on_buff_update([#buff_obj{is_pause = 1} | T], PlayerID, RoleId, Milliseconds, InternalTuple) ->
	on_buff_update(T, PlayerID, RoleId, Milliseconds, InternalTuple);
on_buff_update([#buff_obj{tick_way = 2} | T], PlayerID, RoleId, Milliseconds, InternalTuple) -> %% no map_tick_internal
	on_buff_update(T, PlayerID, RoleId, Milliseconds, InternalTuple);
on_buff_update([#buff_obj{tick_way = 0} = BuffObj | T], PlayerID, RoleId, Milliseconds, {TimeDt, _} = InternalTuple) when TimeDt > 0 -> %% 1 * map_tick_internal
	on_buff_update_1(BuffObj, PlayerID, RoleId, Milliseconds, TimeDt),
	on_buff_update(T, PlayerID, RoleId, Milliseconds, InternalTuple);
on_buff_update([#buff_obj{tick_way = 1} = BuffObj | T], PlayerID, RoleId, Milliseconds, {_, TimeDt} = InternalTuple) when TimeDt > 0 -> %% 2 * map_tick_internal
	on_buff_update_1(BuffObj, PlayerID, RoleId, Milliseconds, TimeDt),
	on_buff_update(T, PlayerID, RoleId, Milliseconds, InternalTuple);
on_buff_update([_ | T], PlayerID, RoleId, Milliseconds, InternalTuple) ->
	on_buff_update(T, PlayerID, RoleId, Milliseconds, InternalTuple).

on_buff_update_1(OldRecord, PlayerID, RoleId, Milliseconds, TimeDt) ->
	case get_buff(PlayerID, RoleId) of
		{} -> skip;
		#objectBuff{} = NewObjectBuff ->
			case lists:keyfind(OldRecord#buff_obj.id_tuple, #buff_obj.id_tuple, NewObjectBuff#objectBuff.dataList) of
				?FALSE -> ok;%% 可能已经被前面的BUFF更新时删除了
				Record ->
					BuffCfg = cfg_buffBase:getRow(Record#buff_obj.buff_data_id),
					{TriggerInterval, _, _} = BuffCfg#buffBaseCfg.triggerPara,
					IsActivate0 = Record#buff_obj.is_activate0,
					IsActivate6 = Record#buff_obj.is_activate6,

%%					BuffObj = check_buff_move_trigger(PlayerID, RoleId, Record, Milliseconds), %% 无用先屏蔽
					BuffObj = Record,
					case TriggerInterval > 0 orelse IsActivate0 orelse IsActivate6 of
						?TRUE -> %% dot效果buff  两边的效果独立存在
							IsLimitTime = case BuffObj#buff_obj.time_para of
											  {0, _, _, _} -> ?TRUE;
											  _ -> ?FALSE
										  end,
							case TriggerInterval > 0 of
								?TRUE ->
									do_buff_dot(BuffObj, TriggerInterval, PlayerID, RoleId, Milliseconds, IsLimitTime, BuffCfg);
								_ -> ok
							end,
							case IsActivate0 of
								?TRUE ->
									[do_buff_dot1(BuffObj, AInterval, PlayerID, RoleId, Milliseconds, {P3, P4, P5}, IsLimitTime, BuffCfg)
										|| {0, AInterval, P3, P4, P5} <- Record#buff_obj.activateEffect];
								_ -> ok
							end,
							case IsActivate6 of
								?TRUE ->
									[do_buff_dot6(BuffObj, AInterval, PlayerID, RoleId, Milliseconds, {P3, P4, P5}, IsLimitTime, BuffCfg)
										|| {6, AInterval, P3, P4, P5} <- Record#buff_obj.activateEffect];
								_ -> ok
							end,
							ok;
						?FALSE ->
							do_buff_time_flow(BuffCfg, BuffObj, PlayerID, RoleId, TimeDt)
					end
			end
	end.


%% 执行buff的 EffectType  获得的时候直接生效
do_buff_effect_type(ObjectID, RoleId, BuffCfg, ObjectBuff) when ObjectBuff#buff_obj.is_enable ->
	do_buff_attach(ObjectID, RoleId, BuffCfg, ObjectBuff),
	{EffectType, EffectParam, EffectParam2} = BuffCfg#buffBaseCfg.effectType,
	case EffectType of
		?BuffEffectType_Stun -> %%眩晕
			do_buff_stun(ObjectID, RoleId);
		?BuffEffectType_Fasten ->%%定身
			do_buff_fasten(ObjectID, RoleId);
		?BuffEffectType_Silence ->%%沉默
			do_buff_silence(ObjectID, RoleId, BuffCfg);
		?BuffEffectType_Immortal ->%%无敌
			do_buff_immortal(ObjectID, RoleId, ObjectBuff);
		?BuffEffectType_TransForm ->
			transform:transform(ObjectID, RoleId, EffectParam, BuffCfg#buffBaseCfg.iD, ObjectBuff);
		?BuffEffectType_RemoveSubClass ->  %% 是某类Buff失效
			buff_disable(ObjectID, RoleId, EffectParam);
		?BuffEffectType_Fear ->%% 恐惧
			do_buff_fear(ObjectID, RoleId, ObjectBuff);
		?Buff_Effect_Type_FrozenHold ->
			do_buff_frozen(ObjectID, RoleId);
		?Buff_Effect_Type_Lock_Hp ->
			do_buff_lock_hp(ObjectID, RoleId, BuffCfg);
		?Buff_Effect_Type_Damage_Limit ->
			do_buff_damage_limit(ObjectID, RoleId, BuffCfg);
		?Buff_Effect_Type_BuffImmune ->
			do_buff_immune(ObjectID, RoleId, {EffectParam, EffectParam2});
		?Buff_Effect_Type_Suck_Blood ->
			do_buff_suck_blood(ObjectID, RoleId, BuffCfg, ObjectBuff);
		?Buff_Effect_Type_Shield_Percent ->
			do_buff_shield_percent(ObjectID, RoleId, BuffCfg);
		?Buff_Effect_Type_22 ->
			case ObjectBuff#buff_obj.layout_num =:= EffectParam of
				?TRUE ->
					skill_map:reset_player_skill_cd([{ObjectBuff#buff_obj.caster_id, ObjectBuff#buff_obj.caster_role_id}], 113);
				?FALSE -> ok
			end;
		?Buff_Effect_Type_Damage2Attr ->
			do_buff_effect_damage2attr(ObjectID, RoleId);
		?Buff_Effect_Type_SuckAttr ->
			do_buff_effect_suck_attr(ObjectID, RoleId, BuffCfg, ObjectBuff, 1);
		?Buff_Effect_Type_PetSuckAttr ->
			do_buff_effect_suck_attr(ObjectID, RoleId, BuffCfg, ObjectBuff, 2);
		?Buff_Effect_Type_HpRecover ->
			do_buff_effect_hp_recover(ObjectID, RoleId);
		_ -> ok%%执行后面的伤害
	end;
do_buff_effect_type(_ObjectID, _RoleId, _BuffCfg, _ObjectBuff) ->
	ok.

do_buff_attach(_ObjectID, _RoleId, #buffBaseCfg{buffMonster = {_, 0}}, _ObjectBuff) -> ok;
do_buff_attach(ObjectID, RoleId, #buffBaseCfg{buffMonster = BuffMonster}, ObjectBuff) ->
	monsterAttach:add_monster(ObjectID, RoleId, ObjectBuff#buff_obj.buff_data_id, ObjectBuff#buff_obj.caster_id, ObjectBuff#buff_obj.caster_role_id, BuffMonster).

%%执行buff伤害
do_buff_damage(ObjectID, RoleId, ObjectBuff, SkillEffect) ->
	SrcObjectID = ObjectBuff#buff_obj.caster_id,
	SrcRoleId = ObjectBuff#buff_obj.caster_role_id,
	case attribute_map:buff_effect(SrcObjectID, SrcRoleId, ObjectID, RoleId, ObjectBuff, SkillEffect) of
		List when is_list(List) ->
			HurtValue = do_damage_result(List, {ObjectID, RoleId, ObjectBuff, SkillEffect}, 0),
			case ObjectBuff#buff_obj.injury_liquidation of
				{2, _, _, _, _} ->
					add_buff_damage(ObjectID, RoleId, ObjectBuff#buff_obj.id_tuple, HurtValue);
				_ -> ok
			end;
		ok -> skip
	end.

do_damage_result([], _Param, HurtSum) -> HurtSum;
do_damage_result([#pk_Object_Damage{value = 0} | T], Param, HurtSum) -> do_damage_result(T, Param, HurtSum);
do_damage_result([#pk_Object_Damage{value = V, type = Type} = Damage | T], {ObjectID, RoleId, ObjectBuff, SkillEffect} = Param, HurtSum) ->
	SrcObjectID = ObjectBuff#buff_obj.caster_id,
	SrcRoleId = ObjectBuff#buff_obj.caster_role_id,
	Msg = #pk_GS2U_BuffResult{objectID = ObjectID, role_id = RoleId, buffID = ObjectBuff#buff_obj.buff_data_id, srcObjectID = SrcObjectID, srcRoleId = SrcRoleId,
		damage = Damage#pk_Object_Damage{value = skill_new:hurt_value_4_sync(V)}},
	mapView:broadcastByView_client(Msg, ObjectID, 0),
	%% 护盾圣盾抵消的伤害不进入计算
	HurtType = Type band 16#FF,
	IsShieldHurt = HurtType =:= ?HitType_Holy_Shield_Imbibe orelse HurtType =:= ?HitType_Holy_Shield_Resist orelse HurtType =:= ?HitType_Shield_Resist,
	NewHurtSum = case IsShieldHurt of
					 ?TRUE -> HurtSum;
					 _ ->
						 case id_generator:id_type(RoleId) =:= ?ID_TYPE_MY_PET orelse mapdb:isObjectDead(ObjectID, RoleId) of
							 ?TRUE -> HurtSum; %% 英雄或玩家已死亡不执行后续
							 ?FALSE ->
								 case SkillEffect of
									 1 ->     %% 伤害
										 map:changeObjectHpFromSkill(SrcObjectID, SrcRoleId, ObjectID, RoleId, -V, ?TRUE, HurtType =:= ?HitType_HpPercent),
										 ObjectType = id_generator:id_type(ObjectID),
										 SrcObjectType = id_generator:id_type(SrcObjectID),
										 map:doDamage(ObjectType, ObjectID, RoleId, SrcObjectType, SrcObjectID, SrcRoleId, ObjectBuff#buff_obj.skill_id, V);
									 2 ->    %% 治疗
										 map:changeObjectHpFromSkill(SrcObjectID, SrcRoleId, ObjectID, RoleId, -V, ?FALSE, HurtType =:= ?HitType_HpPercent)
								 end,
								 case mapdb:isObjectDead(ObjectID, RoleId) of
									 ?TRUE ->
										 MsgDead = #pk_GS2U_Dead{deadActorCode = ObjectID, deadRoleID = RoleId, killerCode = SrcObjectID,
											 killerRoleID = SrcRoleId, killerName = mapdb:getObjectName(SrcObjectID),
											 skillID = ObjectBuff#buff_obj.skill_id, recover = mapdb:getObjectRecover(ObjectID)},
										 map:doDead(ObjectID, RoleId, SrcObjectID, SrcRoleId, ObjectBuff#buff_obj.skill_id, MsgDead);
									 _ -> skip
								 end
						 end,
						 common:getTernaryValue(V > 0, HurtSum + V, HurtSum)
				 end,
	do_damage_result(T, Param, NewHurtSum).

%% buffEffect 字段生效处理  主要是修改属性 伤害  治疗
do_buff_effect(ObjectID, RoleId, ObjectBuff) when ObjectBuff#buff_obj.is_enable =:= ?TRUE ->
	BuffCfg = cfg_buffBase:getRow(ObjectBuff#buff_obj.buff_data_id),
	case mapdb:isObjectDead(ObjectID, RoleId) of
		?TRUE -> skip;
		_ ->
			%%根据buff类型，生效  暴击-1000（吸收 1000）
			ObjectBuffFix = do_buff_effect_fix(ObjectID, ObjectBuff),
			case ObjectBuffFix =/= ObjectBuff of
				?TRUE ->
					update_buff_data(ObjectID, RoleId, ObjectBuffFix);
				_ ->
					skip
			end,
			{HurtType, Param2, Param3} = ObjectBuff#buff_obj.buff_effect,
			case HurtType of
				0 ->  %% 提供玩家属性  attrPara 字段
					attribute_map:on_prop_change(ObjectID, RoleId);
				1 ->  %% 伤害
					do_buff_damage(ObjectID, RoleId, ObjectBuffFix, 1);
				2 ->  %% 治疗
					do_buff_damage(ObjectID, RoleId, ObjectBuffFix, 2);
				3 ->  %% 护盾 加属性
					attribute_map:on_prop_change(ObjectID, RoleId);
				4 ->  %% 恢复怒气
					map:updateObjectRage(ObjectID, RoleId, Param3);
				5 ->  %% 恢复圣盾 恢复圣盾值=【最大圣盾值】*buffEffect参数2[BuffBase]/10^4+buffEffect参数3[BuffBase]
					FinalValue = map_shield:get_obj_sd_max(ObjectID, RoleId) * Param2 / 10000 + Param3,
					map_shield:change_player_sd(ObjectID, RoleId, trunc(FinalValue));
				6 ->  %% 宠物护盾
					attribute_map:on_prop_change(ObjectID, RoleId);
				7 -> %% 宠物治疗
					attribute_map:on_prop_change(ObjectID, RoleId),
					do_buff_damage(ObjectID, RoleId, ObjectBuffFix, 2);
				8 ->  %% 宠物伤害
					do_buff_damage(ObjectID, RoleId, ObjectBuffFix, 1);
				_ ->
					skip
			end
	end;
do_buff_effect(_ObjectID, _RoleId, _ObjectBuff) ->
	ok.

%% 触发buff 前对buff effect进行修正
do_buff_effect_fix(ObjectId, ObjectBuff) ->
	BuffCfg = cfg_buffBase:getRow(ObjectBuff#buff_obj.buff_data_id),
	do_buff_effect_fix_1(ObjectId, ObjectBuff, BuffCfg, BuffCfg#buffBaseCfg.paraCorr).

do_buff_effect_fix_1(_, ObjectBuff, _BuffCfg, []) -> ObjectBuff;
do_buff_effect_fix_1(ObjectId, ObjectBuff, BuffCfg, [{1, P1, P2, P3, F1, F2, F3} | T]) ->
	Target = get_round_target_num(ObjectId, {P1, P2, P3}),
	NewObjectBuff = do_buff_effect_fix_2(ObjectBuff, BuffCfg, {F1, F2, F3}, Target),
	do_buff_effect_fix_1(ObjectId, NewObjectBuff, BuffCfg, T);
do_buff_effect_fix_1(ObjectId, ObjectBuff, BuffCfg, [{2, P1, P2, P3, F1, F2, F3} | T]) ->
	TimeDiff = (map:milliseconds() - ObjectBuff#buff_obj.start_time),
	Rate = min(?IF(TimeDiff - P1 > 0, 1 + (TimeDiff - P1) div P2, 0), P3),
	NewObjectBuff = case Rate > 0 of
						?TRUE ->
							do_buff_effect_fix_2(ObjectBuff, BuffCfg, {F1, F2, F3}, Rate);
						?FALSE -> ObjectBuff
					end,
	do_buff_effect_fix_1(ObjectId, NewObjectBuff, BuffCfg, T);
do_buff_effect_fix_1(ObjectId, ObjectBuff, BuffCfg, [_ | T]) ->
	do_buff_effect_fix_1(ObjectId, ObjectBuff, BuffCfg, T).

do_buff_effect_fix_2(ObjectBuff = #buff_obj{attr_para_base = AttrList, attr_para = AttrList}, _, _, 0) -> ObjectBuff;
do_buff_effect_fix_2(ObjectBuff, #buffBaseCfg{buffEffect = {Param1, Param2, Param3}}, {1, T1, T2}, Rate) ->
	ObjectBuff#buff_obj{buff_effect = {Param1, Param2 + T1 * Rate, Param3 + T2 * Rate}};
do_buff_effect_fix_2(ObjectBuff = #buff_obj{attr_para_base = AttrList}, _BuffCfg, {2, FixValue, 0}, Target) ->
	NewAttrList = [{P1, P2, P3 + FixValue * Target, P4} || {P1, P2, P3, P4} <- AttrList],
	ObjectBuff#buff_obj{attr_para = NewAttrList};
do_buff_effect_fix_2(ObjectBuff = #buff_obj{attr_para_base = AttrList}, _BuffCfg, {2, FixValue, FixIndex}, Target) ->
	case length(AttrList) >= FixIndex of
		?TRUE ->
			{P1, P2, P3, P4} = lists:nth(FixIndex, AttrList),
			NewAttrList = common:set_list_index(FixIndex, AttrList, {P1, P2, P3 + FixValue * Target, P4}),
			ObjectBuff#buff_obj{attr_para = NewAttrList};
		_ ->
			?LOG_ERROR("err buff paracorr :~p", [ObjectBuff#buff_obj.buff_data_id]),
			ObjectBuff
	end;
do_buff_effect_fix_2(ObjectBuff = #buff_obj{attr_para_base = AttrList}, _BuffCfg, {3, FixValue, 0}, Target) ->
	NewAttrList = [{P1, P2, P3, P4 + FixValue * Target} || {P1, P2, P3, P4} <- AttrList],
	ObjectBuff#buff_obj{attr_para = NewAttrList};
do_buff_effect_fix_2(ObjectBuff = #buff_obj{attr_para_base = AttrList}, _BuffCfg, {3, FixValue, FixIndex}, Target) ->
	case length(AttrList) >= FixIndex of
		?TRUE ->
			{P1, P2, P3, P4} = lists:nth(FixIndex, AttrList),
			NewAttrList = common:set_list_index(FixIndex, AttrList, {P1, P2, P3, P4 + FixValue * Target}),
			ObjectBuff#buff_obj{attr_para = NewAttrList};
		_ ->
			?LOG_ERROR("err buff paracorr :~p", [ObjectBuff#buff_obj.buff_data_id]),
			ObjectBuff
	end;
do_buff_effect_fix_2(ObjectBuff, Param, _BuffCfg, _Target) ->
	?LOG_ERROR("invalid buff paracorr :~p", [{ObjectBuff#buff_obj.buff_data_id, Param}]),
	ObjectBuff.

%% 获取周围敌人的目标
get_round_target_num(ObjectId, {EnemyType, Distance, MaxTarget}) ->
	Pos = mapdb:getObjectPos(ObjectId),
	Fun = fun
			  (_, Num) when Num >= MaxTarget -> MaxTarget;
			  (#objectPos{id = TargetId}, Num) when TargetId =:= ObjectId -> Num;
			  (#objectPos{id = TargetId, is_viewer = IsViewer} = ObjectPos, Num) ->
				  case TargetId =/= ObjectId andalso not IsViewer andalso mapdb:isObjectDead(TargetId) =:= ?FALSE andalso mapView:isDistanceLessThan(Pos, ObjectPos, Distance) of
					  ?TRUE ->
						  Bool2 = case EnemyType of
									  1 -> ?TRUE;
									  2 -> id_generator:id_type(TargetId) =:= ?ID_TYPE_Monster;
									  3 -> id_generator:id_type(TargetId) =:= ?ID_TYPE_Player;
									  4 -> id_generator:id_type(TargetId) =:= ?ID_TYPE_Monster;
									  _ -> ?FALSE
								  end,
						  Bool3 = case EnemyType of
									  4 -> charDefine:getRelation_Friend(ObjectId, ObjectId, TargetId, TargetId);
									  _ -> charDefine:getRelation_Enemy(ObjectId, ObjectId, TargetId, TargetId)
								  end,
						  common:getTernaryValue(Bool2 andalso Bool3, Num + 1, Num);
					  _ ->
						  Num
				  end
		  end,
	Target = lists:foldl(Fun, 0, mapdb:getObjectPosList()),
	Target.

on_add_buff_broadcast(ObjectID, RoleId, ObjectBuffData) ->
	case map_role:is_role_enable(ObjectID, RoleId) of
		?TRUE ->
			Msg = #pk_GS2U_AddBuff{
				id = ObjectBuffData#buff_obj.buff_uid,
				actor_id = ObjectID,
				actor_role_id = RoleId,
				caster_id = ObjectBuffData#buff_obj.caster_id,
				caster_role_id = ObjectBuffData#buff_obj.caster_role_id,
				buff_data_id = ObjectBuffData#buff_obj.buff_data_id,
				allValidTime = ObjectBuffData#buff_obj.valid_time,
				remainTriggerCount = ObjectBuffData#buff_obj.remain_trigger_count,
				layoutNum = ObjectBuffData#buff_obj.layout_num,
				is_pause = ObjectBuffData#buff_obj.is_pause
			},
			mapView:broadcastByView_client(Msg, ObjectID, 0);
		?FALSE -> ok
	end.
on_update_buff_broadcast(ObjectID, RoleId, ObjectBuffData) ->
	case map_role:is_role_enable(ObjectID, RoleId) of
		?TRUE ->
			Msg = #pk_GS2U_UpdateBuff{
				id = ObjectBuffData#buff_obj.buff_uid,
				actor_id = ObjectID,
				actor_role_id = RoleId,
				caster_id = ObjectBuffData#buff_obj.caster_id,
				caster_role_id = ObjectBuffData#buff_obj.caster_role_id,
				buff_data_id = ObjectBuffData#buff_obj.buff_data_id,
				allValidTime = ObjectBuffData#buff_obj.valid_time,
				remainTriggerCount = ObjectBuffData#buff_obj.remain_trigger_count,
				layoutNum = ObjectBuffData#buff_obj.layout_num,
				is_pause = ObjectBuffData#buff_obj.is_pause
			},
			mapView:broadcastByView_client(Msg, ObjectID, 0);
		?FALSE -> ok
	end.


%%buff效果失效 TODO 在移除状态的时候判断身上是否存在同类型的buff
un_do_buff_effect(ObjectID, RoleId, ObjectBuff, BuffCfg, IsTimeout) ->
	un_do_buff_attach(ObjectID, ObjectBuff, BuffCfg),
	%%根据buff类型，失效
	case ObjectBuff#buff_obj.buff_effect of
		{Tp, _, _} when Tp =:= 0 orelse Tp =:= 3 ->
			attribute_map:on_prop_change(ObjectID, RoleId);
		_ -> skip
	end,
	case BuffCfg#buffBaseCfg.buffType of
		{_, _, 54} ->
			attribute_map:erase_ex_ShangHaiJiaChen(ObjectID, RoleId);
		_ -> skip
	end,
	{EffectType, EffectParam, EffectParam2} = BuffCfg#buffBaseCfg.effectType,
	case EffectType of
		?BuffEffectType_Stun ->%%眩晕
			unDoBuff_Stun(ObjectID, RoleId, ObjectBuff);
		?BuffEffectType_Fasten ->%%定身
			unDoBuff_Fasten(ObjectID, RoleId, ObjectBuff);
		?BuffEffectType_Silence ->%%定身
			undo_buff_science(ObjectID, RoleId, BuffCfg);
		?BuffEffectType_TransForm ->
			unDoBuff_TransForm(ObjectID, RoleId, BuffCfg);
		?BuffEffectType_Fear ->%%恐惧
			unDoBuff_Fear(ObjectID, RoleId, ObjectBuff);
		?BuffEffectType_RemoveSubClass ->  %% 是某类Buff失效
			buff_enable(ObjectID, RoleId, EffectParam);
		?BuffEffectType_Immortal ->%%无敌
			unDoBuff_Immortal(ObjectID, RoleId, ObjectBuff);
		?Buff_Effect_Type_FrozenHold ->
			unDoBuff_FrozenHold(ObjectID, RoleId);
		?Buff_Effect_Type_Lock_Hp ->
			undo_buff_lock_hp(ObjectID, RoleId);
		?Buff_Effect_Type_Damage_Limit ->
			undo_buff_damage_limit(ObjectID, RoleId);
		?Buff_Effect_Type_BuffImmune ->
			undo_buff_immune(ObjectID, RoleId, {EffectParam, EffectParam2});
		?Buff_Effect_Type_Suck_Blood ->
			skill_map:remove_suck_blood_percent(ObjectID, RoleId, ObjectBuff#buff_obj.id_tuple);
		?Buff_Effect_Type_Shield_Percent ->
			skill_map:erase_shield_percent(ObjectID, RoleId);
		?Buff_Effect_Type_Damage2Attr ->
			undo_buff_effect_damage2attr(ObjectID, RoleId, BuffCfg);
		?Buff_Effect_Type_SuckAttr ->
			undo_buff_effect_suck_attr(ObjectID, RoleId, ObjectBuff, 1);
		?Buff_Effect_Type_HLSilence ->
			undo_buff_effect_hlsilence(ObjectID, RoleId, BuffCfg);
		?Buff_Effect_Type_PetSuckAttr ->
			undo_buff_effect_suck_attr(ObjectID, RoleId, ObjectBuff, 2);
		?Buff_Effect_Type_HpRecover ->
			IsTimeout andalso undo_buff_effect_hp_recover(ObjectID, RoleId, BuffCfg, ObjectBuff);
		_ -> ok
	end.

un_do_buff_attach(_ObjectID, _ObjectBuff, #buffBaseCfg{buffMonster = {_, 0}}) -> ok;
un_do_buff_attach(ObjectID, ObjectBuff, _BuffCfg) ->
	monsterAttach:remove_monster(ObjectID, ObjectBuff#buff_obj.buff_data_id).

%% 对象身的免疫BUFF中是否有 免疫生效中Type
is_exists_immune(ObjectID, RoleId, #buffBaseCfg{buffType = {_, _, P3}}) ->
	case buff_immune(ObjectID, RoleId) of
		#{P3 := W} ->
			W >= 10000 orelse rand:uniform(10000) < W;
		_ -> ?FALSE
	end.

buff_time_fix(#buffBaseCfg{timePara = {_, MaxValidTime, _, _}}, Time) ->
	min(MaxValidTime, Time).

%% MakeNewBuffDataParam = {CasterID, CasterRoleId, ObjectID, RoleId, SkillID, Milliseconds}
make_new_buff_data(BuffCfg, MakeNewBuffDataParam) ->
	{CasterID, CasterRoleId, ObjectID, RoleId, SkillID, Milliseconds} = MakeNewBuffDataParam,
	{LastTime, _MaxValidTime, InitLayout, _} = BuffCfg#buffBaseCfg.timePara,
	ValidTime = buff_time_fix(BuffCfg, get_buff_last_time(CasterID, CasterRoleId, ObjectID, RoleId, BuffCfg)),
	case ValidTime =:= 0 andalso LastTime =/= 0 of
		?TRUE -> throw({?NoValidTime, ?FALSE, {}});
		_ -> skip
	end,

	#buffBaseCfg{triggerPeriod = {T, T1, T2}} = BuffCfg,
	TriggerInfo = case T of
					  0 -> {};
					  ?BuffTriggerAttack -> {T, T1, T2, 0};
					  ?BuffTriggerBeAttacked -> {T, T1, T2, 0};
					  ?BuffTriggerMove -> {T, T1, T2, 0, mapdb:getObjectPos(ObjectID)}
				  end,

	Shield = buff_shield(BuffCfg, CasterID, CasterRoleId, ObjectID, RoleId),
	send_object_shield(ObjectID, RoleId, Shield),
	ShieldTimes = buff_shield_times(BuffCfg),
	AttachOwnerId = case id_generator:id_type(CasterID) =:= ?ID_TYPE_Monster andalso mapdb:getMonster(CasterID) of
						#mapMonster{attach_owner_id = AttachOid} when AttachOid > 0 -> AttachOid;
						_ -> 0
					end,
	#buff_obj{
		id_tuple = {CasterID, BuffCfg#buffBaseCfg.iD},
		buff_uid = mapdb:getObjectAutoBuffIndex(),
		buff_data_id = BuffCfg#buffBaseCfg.iD,
		skill_id = SkillID,%%产生该BUFF的技能ID
		caster_id = CasterID,
		caster_role_id = CasterRoleId,
%%		is_enable = ?TRUE,
		is_enable = is_enable(ObjectID, BuffCfg) andalso map_shield:check_buff_enable(ObjectID, RoleId, BuffCfg#buffBaseCfg.iD),
		start_time = Milliseconds,   %%
		valid_time = ValidTime,   %% 单位ms
		remain_trigger_count = BuffCfg#buffBaseCfg.allLastCount,
		last_dot_effect_time = Milliseconds,
		last_dot_effect_time_1 = Milliseconds,
		last_dot_effect_time_6 = Milliseconds,
		trigger_info = TriggerInfo,
		layout_num = InitLayout,
		attr_para = BuffCfg#buffBaseCfg.attrPara,
		attr_para_base = BuffCfg#buffBaseCfg.attrPara,
		time_para = BuffCfg#buffBaseCfg.timePara,
		shield = Shield,
		activateEffect = BuffCfg#buffBaseCfg.activateEffect,
		injury_liquidation = erlang:append_element(BuffCfg#buffBaseCfg.buffSettle, 0),
		attach_owner_id = AttachOwnerId,
		shield_times = ShieldTimes,
		is_activate0 = lists:keymember(0, 1, BuffCfg#buffBaseCfg.activateEffect),
		is_activate6 = lists:keymember(6, 1, BuffCfg#buffBaseCfg.activateEffect),
		tick_way = select_tick_model(BuffCfg#buffBaseCfg.triggerPara, BuffCfg#buffBaseCfg.activateEffect, BuffCfg#buffBaseCfg.timePara),
		param = get_buff_param(ObjectID, RoleId, BuffCfg),
		buff_effect = BuffCfg#buffBaseCfg.buffEffect
	}.

select_tick_model({Internal1, _, _}, ActivateEffect, {LastTime, _, _, _}) ->
	Internal2 = case lists:keyfind(0, 1, ActivateEffect) of
					{_, T1, _, _, _} -> T1;
					?FALSE -> 0
				end,
	Internal3 = case lists:keyfind(6, 1, ActivateEffect) of
					{_, T2, _, _, _} -> T2;
					?FALSE -> 0
				end,
	TimeList = [Internal1, Internal2, Internal3, LastTime],
	MinInternal = case [T || T <- TimeList, T > 0] of
					  [] -> 0;
					  L -> lists:min(L)
				  end,
	TickInternal = mapSup:tick_internal(map:getMapAI()),
	if
		MinInternal =:= 0 -> 2;
		MinInternal > TickInternal -> 1;
		?TRUE -> 0
	end.

get_buff_param(ObjectID, RoleId, #buffBaseCfg{otherEffect = {104, 10, _, _}}) ->
	mapdb:getObjectHp(ObjectID, RoleId);
get_buff_param(_, _, _) -> 0.

send_object_shield(ObjectId, RoleId, Shield) when Shield > 0 ->
	Msg = #pk_GS2U_object_shield{object_id = RoleId, value = Shield},
	mapView:broadcastByView_client(Msg, ObjectId, 0);
send_object_shield(_ObjectId, _RoleId, _Shield) -> skip.

clean_object_shield(ObjectId, RoleId) ->
	Msg = #pk_GS2U_object_shield{object_id = RoleId, value = 0},
	mapView:broadcastByView_client(Msg, ObjectId, 0).


%% buff护盾值：
%% 当BuffEffect参数1[BuffBase]=3时，护盾值=P1.攻击*buffEffect参数2[BuffBase]/10000+buffEffect参数3[BuffBase]+附加护盾值
%% 附加护盾值=Min(附加效果值,附加限制值)
buff_shield(#buffBaseCfg{buffEffect = {3, Param2, Param3}, otherEffect = OtherEffect, othEffLimit = OthEffLimit}, CasterId, CasterRoleId, ObjectId, RoleId) ->
	P1 = attribute_map:get_attribute(CasterId, CasterRoleId),
	P2 = attribute_map:get_attribute(ObjectId, RoleId),
	Value = ?MAP(P1, ?P_GongJi) * Param2 / 10000 + Param3,
	Addition = attribute_map:get_skill_addition_damage(P1, P2, {OtherEffect, OthEffLimit}),
	ShieldPercent = skill_map:get_shield_percent(ObjectId, RoleId),
	max(0, trunc((Value + Addition) * (10000 + ShieldPercent) / 10000));
buff_shield(#buffBaseCfg{buffEffect = {6, Param2, Param3}}, CasterId, CasterRoleId, ObjectId, RoleId) ->
	P1 = attribute_map:get_attribute(CasterId, CasterRoleId),
	P2 = attribute_map:get_attribute(ObjectId, RoleId),
	Value = ?MAP(P2, ?P_ShengMing) * Param2 / 10000 + ?MAP(P1, ?P_ShengMing) * Param3 / 10000,
	ShieldPercent = skill_map:get_shield_percent(ObjectId, RoleId),
	max(0, trunc(Value * (10000 + ShieldPercent) / 10000));
buff_shield(_, _, _, _, _) -> 0.

buff_shield_times(#buffBaseCfg{effectType = {?Buff_Effect_Type_Shield_Times, N, _}}) -> N;
buff_shield_times(_) -> 0.

%% Buff创建时长=【TimePara参数1*(10^4+Buff强化-Buff抵抗)/10^4】
get_buff_last_time(ObjectId1, RoleId1, ObjectId2, RoleId2, BuffCfg) ->
	#buffBaseCfg{buffType = BuffType, timePara = TimePara} = BuffCfg,
	P1 = attribute_map:get_attribute(ObjectId1, RoleId1),
	P2 = attribute_map:get_attribute(ObjectId2, RoleId2),
	{Intensify1, Resist1} = case element(2, BuffType) of
								1 -> {?MAP(P1, ?P_RuanKongQH), ?MAP(P2, ?P_RuanKongDK)};
								2 -> {?MAP(P1, ?P_YingKongQH), ?MAP(P2, ?P_YingKongDK)};
								3 -> {?MAP(P1, ?P_JianSuQH), ?MAP(P2, ?P_JianSuDK)};
								4 -> {?MAP(P1, ?P_DingShengQH), ?MAP(P2, ?P_DingShengDK)};
								9 -> {?MAP(P1, ?P_RuanKongQH), ?MAP(P2, ?P_RuanKongDK)};
								10 -> {?MAP(P1, ?P_YingKongQH), ?MAP(P2, ?P_YingKongDK)};
								_ -> {0, 0}
							end,
	{Intensify2, Resist2} = case element(1, BuffType) of
								3 -> {?MAP(P1, ?P_ZengYiZengQiang), ?MAP(P2, ?P_ZengYiDiKang)};
								4 -> {?MAP(P1, ?P_JianYiZengQiang), ?MAP(P2, ?P_JianYiDiKang)};
								_ -> {0, 0}
							end,
	Value = element(1, TimePara) * (10000 + Intensify1 + Intensify2 - Resist1 - Resist2) / 10000,
	max(trunc(Value), 0).


%% 更新物件BUFF列表里面的BuffData
update_buff_data(ObjectID, RoleId, BuffData) ->
	case get_buff(ObjectID, RoleId) of
		{} -> ok;
		ObjectBuffRecord ->
			NewList = lists:keyreplace(BuffData#buff_obj.id_tuple, #buff_obj.id_tuple, ObjectBuffRecord#objectBuff.dataList, BuffData),
			put_buff(ObjectBuffRecord#objectBuff{dataList = NewList})
	end.
update_buff_with(ObjectID, RoleId, IDTuple, Fun) ->
	case get_buff(ObjectID, RoleId) of
		{} -> ok;
		ObjectBuffRecord ->
			case lists:keytake(IDTuple, #buff_obj.id_tuple, ObjectBuffRecord#objectBuff.dataList) of
				?FALSE -> ok;
				{_, BuffData, Left} ->
					NewList = [Fun(BuffData) | Left],
					put_buff(ObjectBuffRecord#objectBuff{dataList = NewList})
			end
	end.

%% 更新BUFF，增加层数，重置时间
%% return {DoBuffEffect, NewBuffData}
buff_overlay(BuffData, ObjectID, RoleId, Milliseconds, AllValidTime, BuffCfg, AddBuffCfg) ->
	{LastTime, MaxTime1, _InitLayout, _MaxLayout} = BuffCfg#buffBaseCfg.timePara,
	{_LastTime, MaxTime2, InitLayout, MaxLayout} = AddBuffCfg#buffBaseCfg.timePara,
	{NewLayout, DoBuffEffect} = case BuffData#buff_obj.layout_num < MaxLayout of
									?TRUE -> {min(BuffData#buff_obj.layout_num + InitLayout, MaxLayout), ?TRUE};
									_ -> {MaxLayout, ?FALSE}
								end,
	MaxTime = ?IF(BuffCfg#buffBaseCfg.iD =:= AddBuffCfg#buffBaseCfg.iD, MaxTime2, MaxTime1),
	ValidTime = min(AllValidTime, MaxTime),
	case ValidTime =:= 0 andalso LastTime =/= 0 of
		?TRUE -> throw({?NoValidTime, ?FALSE, {}});
		_ -> skip
	end,
	Shield = max(buff_shield(AddBuffCfg, BuffData#buff_obj.caster_id, BuffData#buff_obj.caster_role_id, ObjectID, RoleId), BuffData#buff_obj.shield),
	ShieldTimes = max(buff_shield_times(AddBuffCfg), BuffData#buff_obj.shield_times),
	NewBuffData = BuffData#buff_obj{
		layout_num = NewLayout,
		start_time = Milliseconds,
		valid_time = ValidTime,
		shield = Shield,
		shield_times = ShieldTimes
	},
	{DoBuffEffect, NewBuffData}.

%% MakeNewBuffDataParam = {CasterID, CasterRoleId, ObjectID, RoleId, SkillID, Milliseconds}
do_add_buff_final(ObjectID, RoleId, AddBuffCfg, MakeNewBuffDataParam) ->
	try
		case get_buff(ObjectID, RoleId) of
			{} ->
				BuffData = make_new_buff_data(AddBuffCfg, MakeNewBuffDataParam),
				put_buff(#objectBuff{id = ObjectID, role_id = RoleId, dataList = [BuffData]}),
				{?Addbuff, ?TRUE, BuffData};
			ObjectBuff when AddBuffCfg#buffBaseCfg.replace =:= 2 ->
				{ErrorCode, DoBuffEffect, NewBuffData} = do_add_buffer_pause(ObjectBuff, ObjectBuff#objectBuff.dataList, AddBuffCfg, MakeNewBuffDataParam, ?FALSE),
				{ErrorCode, DoBuffEffect, NewBuffData};
			ObjectBuff ->
				{ErrorCode, DoBuffEffect, NewBuffData} = do_add_buffer_2(ObjectBuff, ObjectBuff#objectBuff.dataList, AddBuffCfg, MakeNewBuffDataParam),
				{ErrorCode, DoBuffEffect, NewBuffData}
		end
	catch
		{P1, P2, P3} -> {P1, P2, P3}
	end.

do_add_buffer_pause(ObjectBuff, [], AddBuffCfg, MakeNewBuffDataParam, IsHigher) ->
	%% 比较空了都没返回，说明要添加
	BuffData = make_new_buff_data(AddBuffCfg, MakeNewBuffDataParam),
	NewBuffData = ?IF(IsHigher, BuffData#buff_obj{is_pause = 1, is_enable = ?FALSE}, BuffData),
	NewObjectBuff = get_buff(ObjectBuff#objectBuff.id, ObjectBuff#objectBuff.role_id),
	put_buff(NewObjectBuff#objectBuff{dataList = [NewBuffData | NewObjectBuff#objectBuff.dataList]}),
	{?Addbuff, ?TRUE, NewBuffData};
do_add_buffer_pause(ObjectBuff, [BuffData | T], AddBuffCfg, MakeNewBuffDataParam, IsHigher) ->
	BuffCfg = cfg_buffBase:getRow(BuffData#buff_obj.buff_data_id),
	case BuffCfg#buffBaseCfg.iD =:= AddBuffCfg#buffBaseCfg.iD orelse (BuffCfg#buffBaseCfg.groupID =/= 0 andalso BuffCfg#buffBaseCfg.groupID =:= AddBuffCfg#buffBaseCfg.groupID) of
		?TRUE ->
			{CasterID, _CasterRoleId, ObjectID, RoleId, _SkillID, Milliseconds} = MakeNewBuffDataParam,
			case {BuffData#buff_obj.caster_id == CasterID, BuffCfg#buffBaseCfg.iD =:= AddBuffCfg#buffBaseCfg.iD} of
				{?TRUE, ?TRUE} -> %% 相同释放者,相同BUFF -> 叠加时间，直接返回
					ValidTime = buff_time_fix(BuffCfg, get_buff_last_time(BuffData#buff_obj.caster_id, BuffData#buff_obj.caster_role_id, ObjectID, RoleId, AddBuffCfg)),
					Time = ?IF(BuffCfg#buffBaseCfg.buffRemain =:= 1, BuffData#buff_obj.valid_time, ValidTime + BuffData#buff_obj.valid_time),
					{TDoBuffEffect, TNewBuffData} = buff_overlay(BuffData, ObjectID, RoleId, Milliseconds, Time, BuffCfg, AddBuffCfg),
					update_buff_data(ObjectID, RoleId, TNewBuffData),
					{?UpdateBuff, TDoBuffEffect, TNewBuffData};
				{?TRUE, ?FALSE} -> %% 相同释放者，不同BUFF
					case BuffCfg#buffBaseCfg.level =:= AddBuffCfg#buffBaseCfg.level of
						?TRUE -> %% 等级相同，继续往后比较
							do_add_buffer_pause(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam, IsHigher);
						?FALSE ->
							case BuffCfg#buffBaseCfg.level < AddBuffCfg#buffBaseCfg.level of
								?TRUE -> %% 新的等级更高，老的则需暂停，继续往后比较
									NewOldBuffData = BuffData#buff_obj{is_pause = 1, is_enable = ?FALSE},
									%% 更新、广播老的
									update_buff_data(ObjectID, RoleId, NewOldBuffData),
									on_update_buff_broadcast(ObjectID, RoleId, NewOldBuffData),
									do_add_buffer_pause(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam, IsHigher);
								?FALSE -> %% 旧的等级更高，新的则暂停，继续往后比较
									do_add_buffer_pause(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam, ?TRUE)
							end
					end;
				{?FALSE, _} -> %% 不同释放者
					case AddBuffCfg#buffBaseCfg.diffCasterKeep of
						?NoKeep_Diffrent_Caster_Buff -> %% 不共存，按等级替换
							case BuffCfg#buffBaseCfg.level =< AddBuffCfg#buffBaseCfg.level of
								?TRUE -> %% 新的等级更高，老的删除，继续往后比较
									remove_buff(ObjectID, RoleId, BuffData#buff_obj.id_tuple),
									do_add_buffer_pause(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam, IsHigher);
								?FALSE -> %% 旧的等级更高，直接返回无效
									{?BuffAlreadyExist, ?FALSE, BuffData}
							end;
						?Keep_Diffrent_Caster_Buff -> %% 共存， 检查暂停低等级BUFF，继续往后检查
							case BuffCfg#buffBaseCfg.level < AddBuffCfg#buffBaseCfg.level of
								?TRUE -> %% 新的等级更高，老的则需暂停，继续往后比较
									NewOldBuffData = BuffData#buff_obj{is_pause = 1, is_enable = ?FALSE},
									%% 更新、广播老的
									update_buff_data(ObjectID, RoleId, NewOldBuffData),
									on_update_buff_broadcast(ObjectID, RoleId, NewOldBuffData),
									do_add_buffer_pause(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam, IsHigher);
								?FALSE -> %% 旧的等级更高，新的则暂停，继续往后比较
									do_add_buffer_pause(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam, ?TRUE)
							end
					end
			end;
		_ ->
			do_add_buffer_pause(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam, IsHigher)
	end.

%% 遍历身上的buff 1.  判断是否为同组Buff 2. 施法者判断  3. buff等级判断  小的直接失败
%% MakeNewBuffDataParam = {CasterID, CasterRoleId, ObjectID, RoleId, SkillID, Milliseconds}
do_add_buffer_2(ObjectBuff, [], AddBuffCfg, MakeNewBuffDataParam) ->
	BuffData = make_new_buff_data(AddBuffCfg, MakeNewBuffDataParam),
	BuffNum = cfg_globalSetup:buffNum1() + cfg_globalSetup:buffNum2(),

	case length(ObjectBuff#objectBuff.dataList) >= BuffNum of
		?TRUE ->
			remove_buff_by_priority(ObjectBuff#objectBuff.id, ObjectBuff#objectBuff.role_id, ObjectBuff#objectBuff.dataList);
		?FALSE ->
			ok
	end,
	NewObjectBuff = get_buff(ObjectBuff#objectBuff.id, ObjectBuff#objectBuff.role_id),
	put_buff(NewObjectBuff#objectBuff{dataList = [BuffData | NewObjectBuff#objectBuff.dataList]}),
	{?Addbuff, ?TRUE, BuffData};
do_add_buffer_2(ObjectBuff, [BuffData | T], AddBuffCfg, MakeNewBuffDataParam) ->
	BuffCfg = cfg_buffBase:getRow(BuffData#buff_obj.buff_data_id),
	case BuffCfg#buffBaseCfg.iD =:= AddBuffCfg#buffBaseCfg.iD orelse (BuffCfg#buffBaseCfg.groupID =/= 0 andalso BuffCfg#buffBaseCfg.groupID =:= AddBuffCfg#buffBaseCfg.groupID) of
		?TRUE ->
			{CasterID, _CasterRoleId, _ObjectID, _RoleId, _SkillID, _Milliseconds} = MakeNewBuffDataParam,
			case BuffData#buff_obj.caster_id == CasterID of
				?TRUE ->
					update_buff_rule(ObjectBuff, BuffData, AddBuffCfg, MakeNewBuffDataParam);
				?FALSE ->
					case AddBuffCfg#buffBaseCfg.diffCasterKeep of
						?NoKeep_Diffrent_Caster_Buff ->
							update_buff_rule(ObjectBuff, BuffData, AddBuffCfg, MakeNewBuffDataParam);
						?Keep_Diffrent_Caster_Buff ->
							do_add_buffer_2(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam)
					end
			end;
		_ ->
			do_add_buffer_2(ObjectBuff, T, AddBuffCfg, MakeNewBuffDataParam)
	end.

%% MakeNewBuffDataParam = {CasterID, CasterRoleId, ObjectID, RoleId, SkillID, Milliseconds}
update_buff_rule(ObjectBuff, BuffData, AddBuffCfg, MakeNewBuffDataParam) ->
	BuffCfg = cfg_buffBase:getRow(BuffData#buff_obj.buff_data_id),
	ObjectID = ObjectBuff#objectBuff.id,
	RoleId = ObjectBuff#objectBuff.role_id,
	{_CasterID, _CasterRoleId, _ObjectID, _RoleId, _SkillID, Milliseconds} = MakeNewBuffDataParam,
	case BuffCfg#buffBaseCfg.level > AddBuffCfg#buffBaseCfg.level of
		?TRUE ->
			%% 已存的buff比新来的等级高，直接跳出，新增无效
			{?BuffAlreadyExist, ?FALSE, BuffData};
		?FALSE ->
			case (AddBuffCfg#buffBaseCfg.replace =/= 1 orelse BuffCfg#buffBaseCfg.iD =:= AddBuffCfg#buffBaseCfg.iD) andalso BuffCfg#buffBaseCfg.level == AddBuffCfg#buffBaseCfg.level of
				?TRUE -> %% 等级相等情况下 判断强制替换
					ValidTime = buff_time_fix(BuffCfg, get_buff_last_time(BuffData#buff_obj.caster_id, BuffData#buff_obj.caster_role_id, ObjectID, RoleId, AddBuffCfg)),
					Time = ?IF(BuffCfg#buffBaseCfg.buffRemain =:= 1, BuffData#buff_obj.valid_time, ValidTime + BuffData#buff_obj.valid_time),
					{TDoBuffEffect, TNewBuffData} = buff_overlay(BuffData, ObjectID, RoleId, Milliseconds, Time, BuffCfg, AddBuffCfg),
					update_buff_data(ObjectID, RoleId, TNewBuffData),
					{?UpdateBuff, TDoBuffEffect, TNewBuffData};
				?FALSE ->
					%% 更新，先删除老的，然后添加新的
					remove_buff(ObjectID, RoleId, BuffData#buff_obj.id_tuple),
					TNewBuffData = make_new_buff_data(AddBuffCfg, MakeNewBuffDataParam),
					NewBuff = get_buff(ObjectID, RoleId),
					put_buff(ObjectBuff#objectBuff{dataList = [TNewBuffData | NewBuff#objectBuff.dataList]}),
					{?Addbuff, ?TRUE, TNewBuffData}
			end
	end.


%% 技能特殊效果特殊处理
remove_sb_buff_by_type(ObjId, RoleId, Type, T1, T2) ->
	remove_sb_buff_by_type(ObjId, RoleId, Type, T1, T2, ?TRUE).
remove_sb_buff_by_type(ObjId, RoleId, Type, T1, T2, ForceDel) ->
	case get_buff(ObjId, RoleId) of
		#objectBuff{dataList = BuffList} ->
			F = fun(#buff_obj{buff_data_id = BuffId}) ->
				#buffBaseCfg{buffType = BuffType} = cfg_buffBase:getRow(BuffId),
				Type =< tuple_size(BuffType) andalso element(Type, BuffType) =:= T1
				end,
			L = lists:filter(F, BuffList),
			case T2 =:= 0 of
				?TRUE ->
					[remove_buff(ObjId, RoleId, IdTuple) || #buff_obj{id_tuple = IdTuple} <- L];
				_ ->
					remove_sb_buff_by_type_1(ObjId, RoleId, L, T2, ForceDel)
			end;
		_ -> skip
	end.

%% 技能特殊效果-使目标buff 层数翻N倍
multiplicative_buff_layer_by_type(P1ObjId, _P1RoleId, P2ObjId, P2RoleId, Type, T1, T2) ->
	case get_buff(P2ObjId, P2RoleId) of
		#objectBuff{dataList = BuffList} = ObjectBuffRecord ->
			F = fun(#buff_obj{buff_data_id = BuffId, caster_id = CasterID, time_para = {_, MaxValidTime, _, MaxLayer}} = BuffObj, {Flag, Change, Ret}) ->
				#buffBaseCfg{buffType = BuffType} = cfg_buffBase:getRow(BuffId),
				case Type =< tuple_size(BuffType) andalso element(Type, BuffType) =:= T1 andalso CasterID =:= P1ObjId of
					?FALSE -> {Flag, Change, Ret};
					?TRUE ->
						NewBuffObj = BuffObj#buff_obj{layout_num = min(BuffObj#buff_obj.layout_num * T2, MaxLayer), valid_time = MaxValidTime},
						{?TRUE, [NewBuffObj | Change], lists:keystore(NewBuffObj#buff_obj.id_tuple, #buff_obj.id_tuple, Ret, NewBuffObj)}
				end
				end,
			case lists:foldl(F, {?FALSE, [], BuffList}, BuffList) of
				{?FALSE, _, _} -> ok;
				{?TRUE, ChangeBuffList, NewBuffList} ->
					put_buff(ObjectBuffRecord#objectBuff{dataList = NewBuffList}),
					[begin
						 check_buff_layout_activate(P2ObjId, P2RoleId, BuffObj),
						 on_update_buff_broadcast(P2ObjId, P2RoleId, BuffObj)
					 end || BuffObj <- ChangeBuffList]
			end;
		_ -> skip
	end.

%% 一层一层的删除buff
remove_sb_buff_by_type_1(ObjectID, RoleId, [#buff_obj{id_tuple = BuffIDTuple} | T], LayoutNum, ForceDel) when LayoutNum > 0 ->
	ObjectBuffRecord = get_buff(ObjectID, RoleId),
	case ObjectBuffRecord of
		{} -> ok;
		_ ->
			case lists:keytake(BuffIDTuple, #buff_obj.id_tuple, ObjectBuffRecord#objectBuff.dataList) of
				?FALSE -> ok;
				{value, RemoveBuff, NewBuffList} ->
					case RemoveBuff#buff_obj.layout_num > LayoutNum of
						?TRUE ->
							NewBuffObj = RemoveBuff#buff_obj{layout_num = RemoveBuff#buff_obj.layout_num - LayoutNum},
							put_buff(ObjectBuffRecord#objectBuff{dataList = [NewBuffObj | NewBuffList]}),
							on_remove_buff_layout(ObjectID, RoleId, NewBuffObj, LayoutNum),
							check_buff_layout_activate(ObjectID, RoleId, NewBuffObj),
							on_update_buff_broadcast(ObjectID, RoleId, NewBuffObj);
						_ when ForceDel ->
							BuffCfg = cfg_buffBase:getRow(RemoveBuff#buff_obj.buff_data_id),
							{CasterID, BuffDataID} = BuffIDTuple,
							%%先保存
							put_buff(ObjectBuffRecord#objectBuff{dataList = NewBuffList}),
							%%再使buff效果失效
							un_do_buff_effect(ObjectID, RoleId, RemoveBuff, BuffCfg, ?FALSE),
							%%广播
							Msg = #pk_GS2U_DelBuff{
								id = RemoveBuff#buff_obj.buff_uid,
								actor_id = ObjectID,
								actor_role_id = RoleId,
								caster_id = CasterID,
								buff_data_id = BuffDataID},
							mapView:broadcastByView_client(Msg, ObjectID, 0),
							RemoveBuff#buff_obj.shield =/= 0 andalso clean_object_shield(ObjectID, RoleId),
							{EffectType, _EffectParam, _} = BuffCfg#buffBaseCfg.effectType,
							if
								EffectType =:= ?BuffEffectType_TransForm ->
									skill_map:send_skill_fix(ObjectID, RoleId);
								true -> ok
							end,
							%% 事件响应，移除buff
							on_remove_buff(ObjectID, RoleId, RemoveBuff),
							remove_sb_buff_by_type_1(ObjectID, RoleId, T, LayoutNum - RemoveBuff#buff_obj.layout_num, ForceDel);
						_ ->
							remove_sb_buff_by_type_1(ObjectID, RoleId, T, LayoutNum - RemoveBuff#buff_obj.layout_num, ForceDel)
					end
			end
	end;
remove_sb_buff_by_type_1(_, _, _, _, _) -> skip.


%% 使用某类Buff失效
buff_disable(ObjId, RoleId, BuffType) ->
	add_disable_list(ObjId, BuffType),
	case get_buff(ObjId, RoleId) of
		#objectBuff{dataList = BuffList} -> buff_disable_1(BuffList, ObjId, RoleId, BuffType);
		_ -> skip
	end.
buff_disable_1([], _ObjId, _RoleId, _Type) -> skip;
buff_disable_1([#buff_obj{buff_data_id = BuffCfgId, is_enable = ?TRUE} = BuffObj | T], ObjId, RoleId, Type) ->
	case cfg_buffBase:getRow(BuffCfgId) of
		#buffBaseCfg{buffType = {_, Type, _}} = BuffCfg ->
			NewBuffObj = BuffObj#buff_obj{is_enable = ?FALSE},
			update_buff_data(ObjId, RoleId, NewBuffObj),
			un_do_buff_effect(ObjId, RoleId, NewBuffObj, BuffCfg, ?FALSE);
		_ -> skip
	end,
	buff_disable_1(T, ObjId, RoleId, Type);
buff_disable_1([#buff_obj{is_enable = ?FALSE} | T], ObjId, RoleId, Type) ->
	buff_disable_1(T, ObjId, RoleId, Type).

%% buff_disable失效
buff_enable(ObjId, RoleId, BuffType) ->
	dec_disable_list(ObjId, BuffType),
	case get_buff(ObjId, RoleId) of
		#objectBuff{dataList = BuffList} -> buff_enable_1(BuffList, ObjId, RoleId, BuffType);
		_ -> skip
	end.

buff_enable_1([], _ObjId, _RoleId, _Type) -> skip;
buff_enable_1([#buff_obj{buff_data_id = BuffCfgId, is_enable = ?FALSE} = BuffObj | T], ObjId, RoleId, Type) ->
	case cfg_buffBase:getRow(BuffCfgId) of
		#buffBaseCfg{buffType = {_, Type, _}} = BuffCfg ->
			NewBuffObj = BuffObj#buff_obj{is_enable = ?TRUE},
			do_buff_effect_type(ObjId, RoleId, BuffCfg, NewBuffObj),
			update_buff_data(ObjId, RoleId, NewBuffObj),
			do_buff_effect(ObjId, RoleId, NewBuffObj);
		_ -> skip
	end,
	buff_enable_1(T, ObjId, RoleId, Type);
buff_enable_1([#buff_obj{is_enable = ?TRUE} | T], ObjId, RoleId, Type) ->
	buff_enable_1(T, ObjId, RoleId, Type).


get_disable_list(ObjId) ->
	case get({'map_disable_list', ObjId}) of
		?UNDEFINED -> [];
		L -> L
	end.
set_disable_list(ObjId, List) -> put({'map_disable_list', ObjId}, List).
erase_disable_list(ObjId) -> erase({'map_disable_list', ObjId}).

add_disable_list(ObjId, Type) ->
	DisableList = get_disable_list(ObjId),
	case lists:keyfind(Type, 1, DisableList) of
		{_, Count} -> set_disable_list(ObjId, lists:keystore(Type, 1, DisableList, {Type, Count + 1}));
		_ -> set_disable_list(ObjId, [{Type, 1} | DisableList])
	end.
dec_disable_list(ObjId, Type) ->
	DisableList = get_disable_list(ObjId),
	case lists:keyfind(Type, 1, DisableList) of
		{_, Count} when Count > 1 -> set_disable_list(ObjId, lists:keystore(Type, 1, DisableList, {Type, Count - 1}));
		_ -> set_disable_list(ObjId, lists:keydelete(Type, 1, DisableList))
	end.

is_enable(ObjId, #buffBaseCfg{buffType = {_, T, _}}) ->
	case lists:keyfind(T, 1, get_disable_list(ObjId)) of
		{_, Count} when Count > 0 -> ?FALSE;
		_ -> ?TRUE
	end.


%% Buff修正  TODO  在创建的时候直接使用配置表的结构进行修正 创建完成后写入到Buff的结构体中
do_buff_fix(ObjId, RoleID, BuffCfg) ->
	case id_generator:id_type(ObjId) of
		?ID_TYPE_Player ->
			case mapdb:getMapPlayer(ObjId) of
				#mapPlayer{} = MapPlayer ->
					FixRoleID = ?IF(id_generator:id_type(RoleID) =:= ?ID_TYPE_MY_PET, map_role:get_leader_id(MapPlayer), RoleID),
					case map_role:get_role(MapPlayer, FixRoleID) of
						#mapRole{buff_fixes = BuffFixList} when BuffFixList =/= [] ->
							do_buff_fix_1(BuffCfg, BuffFixList);
						_ ->
							BuffCfg
					end;
				_ -> BuffCfg
			end;
		?ID_TYPE_Monster ->
			case mapdb:getMonster(ObjId) of
				#mapMonster{attach_owner_id = AttachOwnerID} when AttachOwnerID > 0 ->
					case map_role:get_role(AttachOwnerID, map_role:get_leader_id(AttachOwnerID)) of
						#mapRole{buff_fixes = BuffFixList} when BuffFixList =/= [] ->
							do_buff_fix_1(BuffCfg, BuffFixList);
						_ ->
							BuffCfg
					end;
				_ -> BuffCfg
			end;
		_ -> BuffCfg
	end.
do_buff_fix_1(BuffCfg, BuffFixList) ->
	FixList = [FixId || {_, _, FixId} = Fix <- BuffFixList, is_fix(BuffCfg, Fix), cfg_buffCorr:getRow(FixId) /= {}],
	case FixList of
		[] -> BuffCfg;
		_ ->
			{F1, F2, F3, F4} = filter_fix(FixList),
			BuffCfg_1 = buff_fix_1(BuffCfg, F1),
			BuffCfg_2 = buff_fix_2(BuffCfg_1, F2),
			BuffCfg_3 = buff_fix_4(BuffCfg_2, F4),
			BuffCfg_4 = buff_fix_3(BuffCfg_3, F3),
			BuffCfg_4
	end.

is_fix(#buffBaseCfg{buffType = {_, _, BuffType}}, {1, BuffType, _}) -> ?TRUE;
is_fix(#buffBaseCfg{iD = BuffId}, {2, BuffId, _}) -> ?TRUE;
is_fix(#buffBaseCfg{buffType = {_, Type, _}}, {3, Type, _}) -> ?TRUE;
is_fix(_, _) -> ?FALSE.


%% 修正方式 0为空;1为替换;2为添加;3为改_加;4为改_乘
filter_fix(FixList) ->
	F = fun(FixId, {R1, R2, R3, R4}) ->
		#buffCorrCfg{corrWay = CorrType, priority = Priority} = cfg_buffCorr:getRow(FixId),
		N = {Priority, FixId},
		case CorrType of
			1 -> {[N | R1], R2, R3, R4};
			2 -> {R1, [N | R2], R3, R4};
			3 -> {R1, R2, [N | R3], R4};
			4 -> {R1, R2, R3, [N | R4]};
			_ -> ?LOG_ERROR("Err Fix Type :~p", [FixId]), {R1, R2, R3, R4}
		end
		end,
	{L1, L2, L3, L4} = lists:foldl(F, {[], [], [], []}, FixList),
	F1 = case L1 of
			 [] -> {};
			 _ -> lists:last(lists:keysort(1, L1))
		 end,
	F2 = lists:reverse(lists:keysort(1, L2)),
	F3 = lists:reverse(lists:keysort(1, L3)),
	F4 = lists:reverse(lists:keysort(1, L4)),
	{F1, F2, F3, F4}.

%% 替换
buff_fix_1(BuffCfg, {}) -> BuffCfg;
buff_fix_1(BuffCfg, {_, FixId}) ->
	#buffCorrCfg{attrPara = AttrPara, timePara = TimePara, activateEffect = ActivateEffect} = cfg_buffCorr:getRow(FixId),
	BuffCfg#buffBaseCfg{
		attrPara = common:getTernaryValue(AttrPara =:= [], BuffCfg#buffBaseCfg.attrPara, AttrPara),
		timePara = common:getTernaryValue(TimePara =:= {0, 0, 0, 0}, BuffCfg#buffBaseCfg.timePara, TimePara),
		activateEffect = common:getTernaryValue(ActivateEffect =:= [], BuffCfg#buffBaseCfg.activateEffect, ActivateEffect)
	}.

%% 增加
buff_fix_2(BuffCfg, []) -> BuffCfg;
buff_fix_2(BuffCfg, [{_, FixId} | T]) ->
	#buffCorrCfg{attrPara = AttrPara, activateEffect = ActivateEffect} = cfg_buffCorr:getRow(FixId),
	New = BuffCfg#buffBaseCfg{
		attrPara = BuffCfg#buffBaseCfg.attrPara ++ AttrPara,
		activateEffect = BuffCfg#buffBaseCfg.activateEffect ++ ActivateEffect
	},
	buff_fix_2(New, T).

%% 修改1 直接加
buff_fix_3(BuffCfg, []) -> BuffCfg;
buff_fix_3(BuffCfg, FixList) ->
	FixInfo = merge_fix_list(FixList, []),
	buff_fix_3_or_4(BuffCfg, FixInfo, fun f3/2).

buff_fix_4(SkillInfo, []) -> SkillInfo;
buff_fix_4(SkillInfo, FixList) ->
	FixInfo = merge_fix_list(FixList, []),
	buff_fix_3_or_4(SkillInfo, FixInfo, fun f4/2).

f3(A, B) -> A + B.
f4(A, B) -> trunc(A * (10000 + B) / 10000).

merge_fix_list([], Ret) -> Ret;
merge_fix_list([{_, FixId} | T], Ret) ->
	{RetAttrPara, RetTimePara, RetActivateEffect, RetBuffEffect} = case Ret of
																	   [] -> {[], {0, 0, 0, 0}, [], {0, 0, 0}};
																	   _ -> Ret
																   end,
	#buffCorrCfg{attrPara = AttrPara, timePara = TimePara, activateEffect = ActivateEffect, buffEffect = BuffEffect} = cfg_buffCorr:getRow(FixId),
	NewAttrPara = RetAttrPara ++ AttrPara,

	{T1, T2, T3, T4} = TimePara,
	{OldT1, OldT2, OldT3, OldT4} = RetTimePara,
	NewTimePara = {OldT1 + T1, OldT2 + T2, OldT3 + T3, OldT4 + T4},
	NewActivateEffect = RetActivateEffect ++ ActivateEffect,
	{OldB1, OldB2, OldB3} = RetBuffEffect,
	{B1, B2, B3} = BuffEffect,
	NewBuffEffect = {OldB1 + B1, OldB2 + B2, OldB3 + B3},

	NewRet = {NewAttrPara, NewTimePara, NewActivateEffect, NewBuffEffect},
	merge_fix_list(T, NewRet).

buff_fix_3_or_4(BuffCfg, FixInfo, Func) ->
	{AttrPara, TimePara, ActivateEffect, BuffEffect} = FixInfo,
	#buffBaseCfg{attrPara = OldAttrPara, timePara = OldTimePara, activateEffect = OldActivateEffect, buffEffect = OldBuffEffect} = BuffCfg,
	AttrParaFun = fun({Index, _, Add, Multi}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
				Ret;
			_ ->
				{P1, P2, P3, P4} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {P1, P2, Func(P3, Add), Func(P4, Multi)})
		end end,
	NewAttrPara = lists:foldl(AttrParaFun, OldAttrPara, AttrPara),

	ActivateEffectFun = fun({Index, Param, _, _, _}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
				Ret;
			_ ->
				{P1, P2, P3, P4, P5} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {P1, Func(P2, Param), P3, P4, P5})
		end end,
	NewActivateEffect = lists:foldl(ActivateEffectFun, OldActivateEffect, ActivateEffect),

	{T1, T2, T3, T4} = TimePara,
	{OldT1, OldT2, OldT3, OldT4} = OldTimePara,
	NewTimePara = {Func(OldT1, T1), Func(OldT2, T2), Func(OldT3, T3), Func(OldT4, T4)},
	{_, B1, B2} = BuffEffect,
	{BuffEfType, BUffEfP1, BUffEfP2} = OldBuffEffect,
	NewBuffEffect = {BuffEfType, Func(BUffEfP1, B1), Func(BUffEfP2, B2)},
	BuffCfg#buffBaseCfg{attrPara = NewAttrPara, timePara = NewTimePara, activateEffect = NewActivateEffect, buffEffect = NewBuffEffect}.


%% buff扣除护盾
%% 1.护盾值优先于生命值抵消伤害，但不等同于生命。
%% 2.Buff护盾值由buff获得,当buff消失对应护盾值消失，或护盾值为空对应buff也消失
%% 3.护盾类型buff，AttrPara[BuffBase]字段拥有加属性的功能
%% 4.护盾值只能在Buff创建时生成
%% 5.获得同组或同ID护盾buff,新护盾值=max(当前buff剩余的护盾值，新buff护盾值)
%% 6.优先级高的护盾优先扣除，同优先级先扣除先获得的
on_damage_shield(_ObjId, _RoleId, DecValue) when DecValue =< 0 -> DecValue;
on_damage_shield(ObjId, RoleId, DecValue) ->
	case get_buff(ObjId, RoleId) of
		#objectBuff{dataList = BuffList} ->
			NewValue = on_damage_shield_1(ObjId, RoleId, DecValue, BuffList),
			NewValue;
		_ -> DecValue
	end.

on_damage_shield_1(ObjId, RoleId, Damage, BuffList) ->
	F = fun(#buff_obj{buff_data_id = BuffCfgId, is_enable = IsEnable, buff_effect = {Tp, _, _}} = BuffObj) ->
		#buffBaseCfg{priority = Priority} = cfg_buffBase:getRow(BuffCfgId),
		case lists:member(Tp, [3, 5, 6]) andalso IsEnable of
			?TRUE -> {?TRUE, {Priority, BuffObj}};
			_ -> ?FALSE
		end
		end,
	BuffList1 = lists:filtermap(F, BuffList),
	BuffList2 = lists:reverse(lists:keysort(1, BuffList1)),
	NewDamage = damage_shield(ObjId, RoleId, BuffList2, Damage),
	NewDamage.

damage_shield(_, _, _, Damage) when Damage =< 0 -> 0;
damage_shield(_, _, [], Damage) -> Damage;
damage_shield(ObjId, RoleId, [{_, #buff_obj{shield = Shield} = BuffObj} | T], Damage) ->
	LeftShield = Shield - Damage,
	case LeftShield > 0 of
		?TRUE -> update_buff_data(ObjId, RoleId, BuffObj#buff_obj{shield = LeftShield});
		_ -> remove_buff(ObjId, RoleId, BuffObj#buff_obj.id_tuple)
	end,
	send_object_shield(ObjId, RoleId, max(0, LeftShield)),
	damage_shield(ObjId, RoleId, T, Damage - Shield).

on_damage_shield_times(_ObjId, _RoleId, DecValue) when DecValue =< 0 -> DecValue;
on_damage_shield_times(ObjId, RoleId, DecValue) ->
	case get_buff(ObjId, RoleId) of
		#objectBuff{dataList = BuffList} ->
			NewValue = on_damage_shield_times_1(ObjId, RoleId, DecValue, BuffList),
			NewValue;
		_ -> DecValue
	end.

on_damage_shield_times_1(ObjId, RoleId, Damage, BuffList) ->
	F = fun(#buff_obj{buff_data_id = BuffCfgId, is_enable = IsEnable, buff_effect = {Tp, _, _}} = BuffObj) ->
		#buffBaseCfg{priority = Priority} = cfg_buffBase:getRow(BuffCfgId),
		case lists:member(Tp, [3, 5, 6]) andalso IsEnable of
			?TRUE -> {?TRUE, {Priority, BuffObj}};
			_ -> ?FALSE
		end
		end,
	BuffList1 = lists:filtermap(F, BuffList),
	BuffList2 = lists:reverse(lists:keysort(1, BuffList1)),
	NewDamage = damage_shield_times(ObjId, RoleId, BuffList2, Damage),
	NewDamage.

damage_shield_times(_, _, _, Damage) when Damage =< 0 -> 0;
damage_shield_times(_, _, [], Damage) -> Damage;
damage_shield_times(ObjId, RoleId, [{_, #buff_obj{shield_times = ShieldTimes} = BuffObj} | T], _Damage) when ShieldTimes > 0 ->
	LeftShieldTimes = ShieldTimes - 1,
	case LeftShieldTimes > 0 of
		?TRUE -> update_buff_data(ObjId, RoleId, BuffObj#buff_obj{shield_times = LeftShieldTimes});
		_ -> remove_buff(ObjId, RoleId, BuffObj#buff_obj.id_tuple)
	end,
	damage_shield_times(ObjId, RoleId, T, 0);
damage_shield_times(ObjId, RoleId, [_ | T], Damage) ->
	damage_shield_times(ObjId, RoleId, T, Damage).

%% Buff层数改变触发效果
%% Buff达到层数触发:ActivateEffect[BuffBase]参数1=4时，参数2=层数；
%% Buff低于层数触发:ActivateEffect[BuffBase]参数1=5时，参数2=层数；
check_buff_layout_activate(ObjId, RoleId, BuffObj) ->
	[do_buff_activate_effect(ObjId, RoleId, BuffObj, {P3, P4, P5}) || {4, Num, P3, P4, P5} <- BuffObj#buff_obj.activateEffect, BuffObj#buff_obj.layout_num =:= Num],
	[do_buff_activate_effect(ObjId, RoleId, BuffObj, {P3, P4, P5}) || {5, Num, P3, P4, P5} <- BuffObj#buff_obj.activateEffect, BuffObj#buff_obj.layout_num < Num].


%% 圣盾值是否存在以至于buff是否生效
sd_change_buff_enable(PlayerId, RoleId, IsExist) ->
	case buff_map:get_buff(PlayerId, RoleId) of
		#objectBuff{dataList = BuffList} ->
			PropChange = change_buff_enable_1(PlayerId, RoleId, BuffList, IsExist, ?FALSE),
			[attribute_map:on_prop_change(PlayerId, RoleId) || PropChange];
		_ -> skip
	end.

change_buff_enable_1(_PlayerId, _RoleId, [], _IsExist, PropChange) -> PropChange;
change_buff_enable_1(PlayerId, RoleId, [#buff_obj{buff_data_id = BuffId, is_enable = IsEnable} = BuffObj | T], IsExist, PropChange) ->
	case cfg_buffBase:getRow(BuffId) of
		#buffBaseCfg{effectType = {9, S, _}} ->
			IsNeedEnable = common:getTernaryValue(S > 0, IsExist, not IsExist),
			[update_buff_data(PlayerId, RoleId, BuffObj#buff_obj{is_enable = IsNeedEnable}) || IsNeedEnable =/= IsEnable],
			change_buff_enable_1(PlayerId, RoleId, T, IsExist, PropChange orelse IsNeedEnable =/= IsEnable);
		_ ->
			change_buff_enable_1(PlayerId, RoleId, T, IsExist, PropChange)
	end.

do_buff_trigger(AttackerID, AttackerRoleId, TargetID, TargetRoleId, RealAttackerID, Damage) ->
	NowTime = map:milliseconds(),
	case get_buff(AttackerID, AttackerRoleId) of
		#objectBuff{dataList = BuffList1} = ObjBuff1 ->
			F1 = fun(BuffObj, Ret) ->
				NewBuffObj1 = do_buff_trigger_1(AttackerID, AttackerID, ?BuffTriggerAttack, BuffObj, NowTime),
				[NewBuffObj1 | Ret] end,
			NewBuffList = lists:foldl(F1, [], BuffList1),
			put_buff(ObjBuff1#objectBuff{dataList = NewBuffList});
		_ -> skip
	end,
	case get_buff(TargetID, TargetRoleId) of
		#objectBuff{dataList = BuffList2} = ObjBuff2 ->
			F2 = fun(BuffObj, Ret) ->
				NewBuffObj1 = do_buff_trigger_1(TargetID, TargetRoleId, ?BuffTriggerBeAttacked, BuffObj, NowTime),
				NewBuffObj2 = sum_buff_damage(RealAttackerID, NewBuffObj1, Damage),
				[NewBuffObj2 | Ret] end,
			NewBuffList2 = lists:foldl(F2, [], BuffList2),
			put_buff(ObjBuff2#objectBuff{dataList = NewBuffList2});
		_ -> skip
	end,
	ok.

do_buff_trigger_1(ObjId, RoleId, T, #buff_obj{trigger_info = {T, Rand, Interval, NextTriggerTime}} = BuffObj, NowTime) when NowTime > NextTriggerTime ->
	case rand:uniform(10000) < Rand of
		?TRUE ->
			do_buff_trigger_2(ObjId, RoleId, BuffObj),
			BuffObj#buff_obj{
				trigger_info = {T, Rand, Interval, NowTime + Interval}
			};
		_ -> BuffObj
	end;
do_buff_trigger_1(_, _, _, BuffObj, _NowTime) ->
	BuffObj.

sum_buff_damage(AttackerID, #buff_obj{caster_id = AttackerID, injury_liquidation = {3, P1, P2, P3, OldDamage}} = BuffObj, Damage) ->
	BuffObj#buff_obj{injury_liquidation = {3, P1, P2, P3, OldDamage + Damage}};
sum_buff_damage(_, BuffObj, _Damage) -> BuffObj.

handle_hurt(AttackerID, AttackerRoleId, TargetID, TargetRoleId, RealAttackerID, Damage) ->
	do_buff_trigger(AttackerID, AttackerRoleId, TargetID, TargetRoleId, RealAttackerID, Damage).

get_skill_consume_buff_layer(ObjId, RoleId, SkillInfo) ->
	%% {Type,BuffType,ForceDel}
	Type2BuffType = [{7, 1, ?FALSE}, {8, 2, ?FALSE}, {9, 3, ?FALSE}, {10, 1, ?TRUE}, {11, 2, ?TRUE}, {12, 3, ?TRUE}],
	List = lists:foldl(fun({_, Type, T1, T2}, Ret) ->
		case lists:keyfind(Type, 1, Type2BuffType) of
			?FALSE -> Ret;
			{_, Tp, ForceDel} ->
				[{Tp, T1, T2, ForceDel} | Ret]
		end
					   end, [], SkillInfo#skill_map_info.spec_effect),

	case get_buff(ObjId, RoleId) of
		#objectBuff{dataList = BuffList} ->
			lists:foldl(fun({Type, T1, T2, ForceDel}, Acc) ->
				F = fun(#buff_obj{buff_data_id = BuffId}) ->
					#buffBaseCfg{buffType = BuffType} = cfg_buffBase:getRow(BuffId),
					Type =< tuple_size(BuffType) andalso element(Type, BuffType) =:= T1
					end,
				L = lists:filter(F, BuffList),
				TotalLayer = lists:sum([N || #buff_obj{layout_num = N} <- L]),
				N = case T2 =:= 0 of
						?TRUE -> TotalLayer;
						_ ->
							case TotalLayer >= T2 of
								?TRUE -> T2;
								_ when ForceDel ->
									TotalLayer;
								_ -> 0
							end
					end,
				Acc + N
						end, 0, List);
		_ -> 0
	end.

create_role_copy_buff(PlayerID, CreateRoleID) ->
	case map_role:get_first_role(PlayerID) of
		#mapRole{role_id = RoleID} ->
			BuffData1 = get_buff(PlayerID, RoleID),
			BuffData2 = get_buff(PlayerID, CreateRoleID),
			case BuffData1 =/= {} of
				?TRUE ->
					%% 给新建角色同步下经济buff
					AddBuffDataList = lists:foldl(fun(#buff_obj{buff_data_id = BuffID} = BuffObj, Ret) ->
						case BuffData2 =:= {} orelse lists:keyfind(BuffID, #buff_obj.buff_data_id, BuffData2#objectBuff.dataList) =:= ?FALSE of
							?TRUE -> case cfg_buffBase:getRow(BuffID) of
										 #buffBaseCfg{econoBuff = {1, _, _, _}} ->
											 [BuffObj | Ret];
										 _ -> Ret
									 end;
							_ -> Ret
						end
												  end, [], BuffData1#objectBuff.dataList),
					buff_map:do_add_old_buff_data(PlayerID, CreateRoleID, AddBuffDataList),
					AddBuffDataList =/= [] andalso attribute_map:on_prop_change(PlayerID, CreateRoleID);
				?FALSE -> ok
			end;
		_ -> ok
	end.

add_buff_damage(ObjectID, RoleId, Key, Value) ->
	List = get_buff_damage_list(ObjectID, RoleId),
	NewList = case lists:keyfind(Key, 1, List) of
				  ?FALSE -> [{Key, Value} | List];
				  {_, OldValue} -> lists:keystore(Key, 1, List, {Key, OldValue + Value})
			  end,
	set_buff_damage_list(ObjectID, RoleId, NewList).

take_buff_damage(ObjectID, RoleId, Key) ->
	List = get_buff_damage_list(ObjectID, RoleId),
	case lists:keytake(Key, 1, List) of
		?FALSE -> 0;
		{_, {_, V}, Left} ->
			set_buff_damage_list(ObjectID, RoleId, Left),
			V
	end.
get_buff_damage_list(ObjectID, RoleId) ->
	case get({?MODULE, buff_damage_list, ObjectID, RoleId}) of
		?UNDEFINED -> [];
		L -> L
	end.
set_buff_damage_list(ObjectID, RoleId, List) ->
	put({?MODULE, buff_damage_list, ObjectID, RoleId}, List).
erase_buff_damage_list(ObjectID, RoleId) ->
	erase({?MODULE, buff_damage_list, ObjectID, RoleId}).

handle_damage_hit_effect(AttackerID, AttackerRoleId, TargetID, TargetRoleId, Type) ->
	%% 此处不直接执行do_buff_activate_effect，而是通过消息执行，目的是让攻击流程有序化，避免穿插触发效果而引起异常
	case Type band 2#1111 of
		?HitType_CriticalHit -> %% 暴击
			check_do_buff_activate_effect(TargetID, TargetRoleId, 13);
		?HitType_Miss ->
			check_do_buff_activate_effect(TargetID, TargetRoleId, 14);
		_ -> ok
	end,
	case (Type bsr 6) band 2#11 of
		0 -> %% 攻击
			check_do_buff_activate_effect(AttackerID, AttackerRoleId, 8),
			check_do_buff_activate_effect(TargetID, TargetRoleId, 9);
		_ -> skip
	end.

check_do_buff_activate_effect(ObjectID, RoleId, Type) ->
	case get_buff(ObjectID, RoleId) of
		{} -> ok;
		ObjectBuff ->
			lists:foreach(fun(Buff) ->
				case lists:keyfind(Type, 1, Buff#buff_obj.activateEffect) of
					?FALSE -> ok;
					{_, P2, P3, P4, P5} ->
						[self() ! ?ModHandleMsg(?MODULE, {do_buff_activate_effect, ObjectID, RoleId, Buff, {P3, P4, P5}}) || P2 >= 10000 orelse map_rand:rand() =< P2]
				end
						  end, ObjectBuff#objectBuff.dataList)
	end.

check_send_hang_buff(ObjectID, RoleId) ->
	case id_generator:id_type(ObjectID) =:= ?ID_TYPE_Player andalso get_buff(ObjectID, RoleId) of
		#objectBuff{dataList = DataList} ->
			SendList = lists:foldl(fun(#buff_obj{buff_data_id = BuffDataID, valid_time = ValidTime, is_pause = IsPause}, Ret) ->
				case cfg_buffBase:getRow(BuffDataID) of
					#buffBaseCfg{econoBuff = {1, _, 1, _}} when IsPause =:= 0 ->
						[{BuffDataID, ValidTime} | Ret];
					_ -> Ret
				end
								   end, [], DataList),
			map:sendMsgToPlayerProcess(ObjectID, {hang_buff_refresh, SendList});
		_ ->
			skip
	end.

do_buff_effect_damage2attr(ObjectID, RoleId) ->
	set_effect_damage2attr(ObjectID, RoleId, 0).

undo_buff_effect_damage2attr(ObjectID, RoleId, BuffCfg) ->
	case get({?MODULE, effect_damage2attr, ObjectID, RoleId}) of
		?UNDEFINED -> skip;
		V ->
			{_, BuffDataID, W} = BuffCfg#buffBaseCfg.effectType,
			HpMax = mapdb:getObjectHpMax(ObjectID, RoleId),
			AddV = trunc(V / HpMax * W),
			#buffBaseCfg{attrPara = AttrPara} = BuffCfg = cfg_buffBase:getRow(BuffDataID),
			NewBuffCfg = BuffCfg#buffBaseCfg{attrPara = [{P1, P2, AddV, P3} || {P1, P2, _, P3} <- AttrPara]},
			do_add_buffer(ObjectID, RoleId, NewBuffCfg, ObjectID, RoleId, 0)
	end,
	erase_effect_damage2attr(ObjectID, RoleId).

check_effect_damage2attr(ObjectID, RoleId, V) ->
	case get({?MODULE, effect_damage2attr, ObjectID, RoleId}) of
		?UNDEFINED -> skip;
		OldV -> set_effect_damage2attr(ObjectID, RoleId, OldV + V)
	end.

set_effect_damage2attr(ObjectID, RoleId, V) ->
	put({?MODULE, effect_damage2attr, ObjectID, RoleId}, V).

erase_effect_damage2attr(ObjectID, RoleId) ->
	erase({?MODULE, effect_damage2attr, ObjectID, RoleId}).

do_buff_effect_suck_attr(ObjectID, RoleId, BuffCfg, #buff_obj{buff_uid = BuffUid, caster_id = CasterID, caster_role_id = CasterRoleID, attr_para = AttrPara, layout_num = Layout}, TargetType) ->
	{EffType, Param1, Param2} = BuffCfg#buffBaseCfg.effectType,
	BaseP = attribute_map:get_base_attribute(ObjectID, RoleId),
	NewAttr = attribute_map:prop_merge([{I, trunc(A * Layout * Param2 / 10000), trunc(M * Layout * Param2 / 10000)} || {_, I, A, M} <- AttrPara, I =:= Param1], BaseP),
	Func = fun({_, I, _, _}, Ret) ->
		OldV = maps:get(I, BaseP, 0),
		NewV = maps:get(I, NewAttr, 0),
		case OldV > NewV of
			?TRUE -> [{I, OldV - NewV, 0} | Ret];
			?FALSE -> Ret
		end
		   end,
	case lists:foldl(Func, [], AttrPara) of
		[] -> skip;
		AddList ->
			case mapdb:getObjectPos(CasterID) of
				{} -> skip;
				_ ->
					TargetRoleID = case TargetType of
									   1 -> CasterRoleID;
									   2 -> map_role:get_leader_id(CasterID)
								   end,
					add_suck_attr(CasterID, TargetRoleID, BuffUid, EffType, AddList),
					attribute_map:on_prop_change(CasterID, TargetRoleID)
			end
	end.

undo_buff_effect_suck_attr(_ObjectID, _RoleId, #buff_obj{buff_uid = BuffUid, caster_id = CasterID, caster_role_id = CasterRoleID}, TargetType) ->
	TargetRoleID = case TargetType of
					   1 -> CasterRoleID;
					   2 -> map_role:get_leader_id(CasterID)
				   end,
	OldList = get_suck_attr_list(CasterID, TargetRoleID),
	case lists:keymember(BuffUid, 1, OldList) of
		?TRUE ->
			NewList = lists:keydelete(BuffUid, 1, OldList),
			put({?MODULE, suck_attr_list, CasterID, TargetRoleID}, NewList),
			attribute_map:on_prop_change(CasterID, TargetRoleID);
		?FALSE -> skip
	end.

get_suck_attr_list(ObjectID, RoleId) ->
	case get({?MODULE, suck_attr_list, ObjectID, RoleId}) of
		?UNDEFINED -> [];
		L -> L
	end.

add_suck_attr(ObjectID, RoleId, BuffUid, EffType, AttrList) ->
	OldList = get_suck_attr_list(ObjectID, RoleId),
	NewList = lists:keystore(BuffUid, 1, OldList, {BuffUid, EffType, AttrList}),
	put({?MODULE, suck_attr_list, ObjectID, RoleId}, NewList).

calc_total_suck_attr(ObjectID, RoleId) ->
	SuckAttrList = get_suck_attr_list(ObjectID, RoleId),
	Attr1 = case SuckAttrList =/= [] andalso is_buff_type_exist(ObjectID, RoleId, 3, 55) of
				?TRUE -> calc_total_suck_attr_1(SuckAttrList, ?Buff_Effect_Type_SuckAttr);
				?FALSE -> []
			end,
	Attr2 = case SuckAttrList =/= [] andalso is_buff_type_exist(ObjectID, RoleId, 3, 56) of
				?TRUE -> calc_total_suck_attr_1(SuckAttrList, ?Buff_Effect_Type_PetSuckAttr);
				?FALSE -> []
			end,
	lists:foldl(fun merge_prop/2, Attr1, Attr2).

calc_total_suck_attr_1(SuckAttrList, TargetEffType) ->
	F1 = fun merge_prop/2,
	F2 = fun
			 ({_, EffType, AttrList}, List) when EffType =:= TargetEffType -> lists:foldl(F1, List, AttrList);
			 (_, List) -> List
		 end,
	lists:foldl(F2, [], SuckAttrList).

erase_suck_attr(ObjectID, RoleId) ->
	erase({?MODULE, suck_attr_list, ObjectID, RoleId}).


set_hlsilence_param(ObjectID, RoleId, Param) ->
	put({?MODULE, hlsilence_param, ObjectID, RoleId}, Param).

get_hlsilence_param(ObjectID, RoleId) ->
	case get({?MODULE, hlsilence_param, ObjectID, RoleId}) of
		?UNDEFINED -> {0, 10000};
		V -> V
	end.

erase_hlsilence_param(ObjectID, RoleId) ->
	erase({?MODULE, hlsilence_param, ObjectID, RoleId}).


undo_buff_effect_hlsilence(ObjectID, RoleId, #buffBaseCfg{effectType = {_, Ms, W}}) ->
	set_hlsilence_param(ObjectID, RoleId, {map:milliseconds() + Ms, W}).

do_buff_effect_hp_recover(ObjectID, RoleId) ->
	Hp = mapdb:getObjectHp(ObjectID, RoleId),
	hp_recover_param(ObjectID, RoleId, Hp).
undo_buff_effect_hp_recover(ObjectID, RoleId, #buffBaseCfg{effectType = {_, Per, MaxHpPer}}, ObjectBuff) ->
	OldHp = hp_recover_param(ObjectID, RoleId),
	erase_hp_recover_param(ObjectID, RoleId),
	Hp = mapdb:getObjectHp(ObjectID, RoleId),
	case Hp > 1 andalso OldHp > Hp of
		?TRUE ->
			RecoverHp = max(trunc((OldHp - Hp) * Per / 10000), 1),
			MaxRecoverHp = trunc(mapdb:getObjectHpMax(ObjectID, RoleId) * MaxHpPer / 10000),
			FinalRecoverHp = min(RecoverHp, MaxRecoverHp),
			DamageList = [skill_new:make_damage_info(ObjectID, ObjectID, 1, 0, 1, -FinalRecoverHp)],
			do_damage_result(DamageList, {ObjectID, RoleId, ObjectBuff, 2}, 0);
		?FALSE ->
			ok
	end.

hp_recover_param(ObjectID, RoleId, Hp) ->
	put({?MODULE, hp_recover_param, ObjectID, RoleId}, Hp).

hp_recover_param(ObjectID, RoleId) ->
	case get({?MODULE, hp_recover_param, ObjectID, RoleId}) of
		?UNDEFINED -> 0;
		V -> V
	end.
erase_hp_recover_param(ObjectID, RoleId) ->
	erase({?MODULE, hp_recover_param, ObjectID, RoleId}).

buff_immune(ObjectID, RoleID, M) ->
	?P_DIC_PUT({ObjectID, RoleID}, M).
buff_immune(ObjectID, RoleID) ->
	?P_DIC_GET({ObjectID, RoleID}, maps:new()).
erase_buff_immune(ObjectID, RoleID) ->
	?P_DIC_ERASE(buff_immune, {ObjectID, RoleID}).
do_buff_immune(ObjectID, RoleID, {Type, W}) ->
	M = buff_immune(ObjectID, RoleID),
	NM = M#{Type => maps:get(Type, M, 0) + W},
	buff_immune(ObjectID, RoleID, NM).
undo_buff_immune(ObjectID, RoleID, {Type, W}) ->
	M = buff_immune(ObjectID, RoleID),
	NM = case M of
			 #{Type := OldW} when OldW =< W -> maps:remove(Type, M);
			 #{Type := OldW} -> M#{Type => OldW - W};
			 _ -> M
		 end,
	buff_immune(ObjectID, RoleID, NM).
