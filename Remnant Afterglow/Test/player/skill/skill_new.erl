%%%-------------------------------------------------------------------
%%% @author xiehonggang
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 六月 2018 17:20
%%%-------------------------------------------------------------------
-module(skill_new).
-author("xiehonggang").
-include("global.hrl").
-include("gameMap.hrl").
-include("skill_new.hrl").
-include("logger.hrl").
-include("netmsgRecords.hrl").
-include("globalDict.hrl").
-include("cfg_skillBase.hrl").
-include("playerDefine.hrl").
-include("id_generator.hrl").
-include("attribute.hrl").
-include("error.hrl").
-include("objectEventDefine.hrl").
-include("cfg_mapsetting.hrl").
-include("monsterDefine.hrl").
-include("skill.hrl").
-include("cfg_buffBase.hrl").
-include("buff.hrl").

%% API
-export([object_use_skill/7, skill_attack_hit/6, object_use_passive_skill/7, server_use_skill/7, on_use_skill_buff/7]).
-export([object_use_skill/8, check_skill_damage_corr_effect/7, can_use_skill_buff_2_target/5]).  %% 复活戒指特殊处理
-export([make_damage_info/6, on_obj_dead/2, damage_shield/5, hurt_value_4_sync/1]).

%% 客户端请求使用技能
object_use_skill(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList) ->
	object_use_skill(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList, 1).
object_use_skill(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList, Type) ->
	on_skill_pre_event(AttackerID, SkillID),
	case skill_map:check_obj_use_skill(AttackerID, AttackerRoleId, SkillID) of
		{?ERROR_OK, SkillType} ->
			case SkillType of
				1 -> %%伤害技能,广播周围
					Msg = #pk_GS2U_UseSkill{
						type = Type,
						attackerid = AttackerID,
						attacker_role_id = AttackerRoleId,
						skillid = SkillID,
						pos_x = PosX,
						pos_y = PosY, %% TODO 同步技能位移 技能串号
						targetList = TargetList
					},
					mapView:broadcastByView_client(Msg, AttackerID, 0);
%%					map:send(PlayerID, Msg);
				0 ->
					%%技能特殊效果处理
					Msg = #pk_GS2U_UseSkill{
						type = Type,
						attackerid = AttackerID,
						attacker_role_id = AttackerRoleId,
						skillid = SkillID,
						pos_x = PosX,
						pos_y = PosY,
						targetList = []
					},
					mapView:broadcastByView_client(Msg, AttackerID, 0);
				EffectType when EffectType == 2 orelse EffectType == 3 orelse EffectType == 4 orelse EffectType == 5 -> %%2 恢复技能 3 宠物伤害技能 4为宠物的恢复技能
					Msg = #pk_GS2U_UseSkill{
						type = Type,
						attackerid = AttackerID,
						attacker_role_id = AttackerRoleId,
						skillid = SkillID,
						pos_x = PosX,
						pos_y = PosY,
						targetList = TargetList
					},
					mapView:broadcastByView_client(Msg, AttackerID, 0)
%%					map:send(PlayerID, Msg)
			end,
			skill_map:cache_skill_seg(AttackerID, AttackerRoleId, SkillID),
			on_skill_complete(AttackerID, AttackerRoleId, SkillID),
			skill_map:clear_skill_damage_param(AttackerID, AttackerRoleId, SkillID),
			ok;
		{ErrCode, _} -> %%技能无法释放处理
			Msg = #pk_GS2U_UseSkillFail{
				err_code = ErrCode,
				attackerid = AttackerID,
				attacker_role_id = AttackerRoleId,
				skillid = SkillID
			},
			map:send(PlayerID, Msg)
	end.


%% 命中
%% TargetList = [{ObjId, RoleId}]
skill_attack_hit(PlayerID, SkillID, Segment, AttackerID, AttackerRoleId, TargetList) ->
	AttackerType = id_generator:id_type(AttackerID),
	CheckHit = case AttackerType =:= ?ID_TYPE_Player andalso not robot_player:is_robot(AttackerID) of
				   ?TRUE -> skill_map:check_skill_hit(AttackerID, AttackerRoleId, SkillID);
				   _ -> ?TRUE
			   end,

	case CheckHit of
		?FALSE ->
			case cfg_skillBase:getRow(SkillID) of
				#skillBaseCfg{skillEffect = {0, _, _}} -> skip;
				_ ->
					map:sendMsgToPlayerProcess(PlayerID, {invalid_hit, 1, {SkillID, Segment, AttackerID}})
			end;
		_ -> skip
	end,
	case CheckHit andalso can_use_skill(AttackerID, AttackerRoleId, SkillID) of
		?TRUE ->
			do_use_skill(SkillID, Segment, AttackerType, AttackerID, AttackerRoleId, TargetList);
		_ ->
%%			?LOG_ERROR("cannot use skill :~p", [{PlayerID, AttackerID, SkillID, TargetList}]),
			skip
	end.

%% 技能过程中触发BUFF 客户端触发
%% TargetCodeList = [{TargetID, TargetRoleId}]
on_use_skill_buff(PlayerID, AttackerID, AttackerRoleId, SkillID, BuffID, _ForceFlag, TargetCodeList) ->
	try
		case mapdb:isObjectDead(AttackerID, AttackerRoleId) of
			?TRUE -> throw(?ErrorCode_Skill_ObjectDead);
			_ -> skip
		end,
		SkillBaseCfg = cfg_skillBase:row(SkillID),
		case SkillBaseCfg =:= {} of
			?TRUE -> throw(?ERROR_Cfg);
			?FALSE -> ok
		end,

		Skill = skill_map:get_object_skill(AttackerID, AttackerRoleId, SkillID),
		case Skill of
			{} -> throw(?ErrorCode_Skill_No);
			_ -> skip
		end,
%%		?LOG_ERROR("on_use_skill_buff :~p", [{BuffID, SkillID, Skill#skill_map_info.activate_effect, TargetCodeList}]),
		BuffIdList = [BuffId1 || {_P1, _P2, _P3, 2, BuffId1} <- Skill#skill_map_info.activate_effect],
		case lists:member(BuffID, BuffIdList) of
			?FALSE ->
				throw(?ErrorCode_Skill_No_This_Buff);
			_ -> skip
		end,
		AttackerType = id_generator:id_type(AttackerID),
		CheckHit = case AttackerType of
					   ?ID_TYPE_Player ->
						   skill_map:check_skill_buff(AttackerID, AttackerRoleId, SkillID);
					   _ -> ?TRUE
				   end,
		case CheckHit orelse map:getMapAI() =:= ?MapAI_ClientDungeons of
			?FALSE ->
				map:sendMsgToPlayerProcess(PlayerID, {invalid_hit, 2, {SkillID, BuffID, AttackerID}}),
				throw(666);
			_ -> skip
		end,

		[buff_map:add_buffer(AttackerID, AttackerRoleId, TargetID, TargetRoleId, BuffID, SkillID) ||
			{TargetID, TargetRoleId} <- select_buff_target(cfg_buffBase:getRow(BuffID), TargetCodeList),
			can_use_skill_buff_2_target(AttackerType, AttackerID, AttackerRoleId, TargetID, TargetRoleId)],
		case map:getMapAI() of
			?MapAI_YanMo -> ok;
			?MapAI_GuildCamp -> ok;
			_ -> map:send_client(PlayerID, #pk_GS2U_PlayerSkillBuffRet{err_code = ?ERROR_OK, buffId = BuffID})
		end
	catch
		Error ->
			map:send_client(PlayerID, #pk_GS2U_PlayerSkillBuffRet{err_code = Error, buffId = BuffID}),
			Error
	end.

select_buff_target(#buffBaseCfg{buffType = {_, _, 58}}, TargetCodeList) ->
	TimeMs = map:milliseconds(),
	lists:foldl(fun({TargetID, TargetRoleId}, Ret) ->
		case id_generator:id_type(TargetRoleId) of
			?ID_TYPE_Role ->
				PetObjIDList = map_pet:get_pet_obj_id_list(TargetID, ?TRUE),
				RoleIdList1 = [RoleId || RoleId <- [TargetRoleId | PetObjIDList], not buff_map:is_buff_type_exist(TargetID, RoleId, 3, 58)],
				RoleIdList2 = [RoleId || RoleId <- RoleIdList1, TimeMs >= element(1, buff_map:get_hlsilence_param(TargetID, RoleId))],
				case RoleIdList2 of
					[] when RoleIdList1 =/= [] ->
						FixTargetRoleId1 = common:list_rand(RoleIdList1),
						case element(2, buff_map:get_hlsilence_param(TargetID, FixTargetRoleId1)) >= map_rand:rand() of
							?TRUE -> [{TargetID, FixTargetRoleId1} | Ret];
							?FALSE -> Ret
						end;
					[] -> Ret;
					_ ->
						FixTargetRoleId2 = common:list_rand(RoleIdList2),
						[{TargetID, FixTargetRoleId2} | Ret]
				end;
			_ -> [{TargetID, TargetRoleId} | Ret]
		end
				end, [], TargetCodeList);
select_buff_target(_, TargetCodeList) -> TargetCodeList.

%% 触发被动技能，客户端请求，目前暂不需要额外验证，直接调用正常使用技能
object_use_passive_skill(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList) ->
	case map:getMapAI() of
		?MapAI_YanMo ->
			object_use_passive_skill2(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList);
		?MapAI_GuildCamp ->
			object_use_passive_skill2(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList);
		_ ->
			object_use_skill(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList)
	end.
object_use_passive_skill2(PlayerID, AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetList) ->
	Type = 1,
	on_skill_pre_event(AttackerID, SkillID),
	case skill_map:check_obj_use_skill(AttackerID, AttackerRoleId, SkillID) of
		{?ERROR_OK, SkillType} ->
			case SkillType of
				0 ->
					%%技能特殊效果处理
					Msg = #pk_GS2U_UseSkill{
						type = Type,
						attackerid = AttackerID,
						attacker_role_id = AttackerRoleId,
						skillid = SkillID,
						pos_x = PosX,
						pos_y = PosY,
						targetList = []
					},
					map:send_client(AttackerID, Msg);
				_ ->
					Msg = #pk_GS2U_UseSkill{
						type = Type,
						attackerid = AttackerID,
						attacker_role_id = AttackerRoleId,
						skillid = SkillID,
						pos_x = PosX,
						pos_y = PosY,
						targetList = TargetList
					},
					map:send_client(AttackerID, Msg)
			end,
			skill_map:cache_skill_seg(AttackerID, AttackerRoleId, SkillID),
			on_skill_complete(AttackerID, AttackerRoleId, SkillID),
			skill_map:clear_skill_damage_param(AttackerID, AttackerRoleId, SkillID),
			ok;
		{ErrCode, _} -> %%技能无法释放处理
			Msg = #pk_GS2U_UseSkillFail{
				err_code = ErrCode,
				attackerid = AttackerID,
				attacker_role_id = AttackerRoleId,
				skillid = SkillID
			},
			map:send(PlayerID, Msg)
	end.

%%新版本服务器技能释放(用于怪物之类的无客户端托管的目标)
server_use_skill(AttackerID, AttackerRoleId, SkillID, PosX, PosY, TargetRoleIdList, TriggerType) ->
	case skill_map:check_obj_use_skill(AttackerID, AttackerRoleId, SkillID) of
		{?ERROR_OK, _} ->
			Msg = #pk_GS2U_UseSkill{
				type = TriggerType,
				attackerid = AttackerID,
				attacker_role_id = AttackerRoleId,
				skillid = SkillID,
				pos_x = PosX,
				pos_y = PosY,
				targetList = [#pk_role_skill_hit{object_id = TargetId, role_id = RoleId} || {TargetId, RoleId} <- TargetRoleIdList]
			},
			case TriggerType of
				2 ->
					skill_map:cache_skill_seg(AttackerID, AttackerRoleId, SkillID),
					skill_map:clear_skill_damage_param(AttackerID, AttackerRoleId, SkillID);
				_ -> skip
			end,
			mapView:broadcastByView({withPlayerId, self(), AttackerID, Msg}, AttackerID, 0);
		{?ErrorCode_Skill_CD3, _} ->
%%			?LOG_WARNING("server_use_skill cannot use  skill :~p", [{R, SkillID}]);
			skip; %% 打印太多了，先屏蔽
		{?ErrorCode_Skill_NotExist, _} ->
%%			?LOG_WARNING("server_use_skill cannot use  skill :~p", [{R, SkillID}]);
			skip; %% 打印太多了，先屏蔽
		_R ->
			?LOG_INFO("server_use_skill cannot use  skill :~p", [{_R, SkillID}])
	end.

%% 受击或攻击者：死亡事件
on_obj_dead(TargetID, TargetRoleId) ->
	Msg = #pk_GS2U_Dead{deadActorCode = TargetID, deadRoleID = TargetRoleId, recover = mapdb:getObjectRecover(TargetID)},
	map:doDead(TargetID, TargetRoleId, 0, 0, 0, Msg),
	ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
change_object_hp(AttackerType, AttackerID, AttackerRoleId, DamageList, SkillID) ->
	F = fun(#pk_Object_Damage{objectId = DefenderID, role_id = DefenderRoleId, value = V, type = Type} = HurtMsg) ->
		case id_generator:id_type(DefenderRoleId) =:= ?ID_TYPE_MY_PET orelse mapdb:isObjectDead(DefenderID, DefenderRoleId) of
			?TRUE -> skip; %% 在DamageList可能有多条对同一对象的伤害，对象可能在之前的伤害中已经死亡了
			_ ->
				map:changeObjectHpFromSkill(AttackerID, AttackerRoleId, DefenderID, DefenderRoleId, -V, V > 0, Type band 16#FF =:= ?HitType_HpPercent),
				do_damage_event(AttackerType, AttackerID, AttackerRoleId, SkillID, HurtMsg),
				check_object_dead(AttackerID, AttackerRoleId, SkillID, DefenderID, DefenderRoleId)
		end
		end,
	lists:foreach(F, DamageList).


%% TODO 如果是命中的伤害为0  或者治疗为0  直接就不同步了
%% TargetList = [{ObjId, RoleId}]
do_use_skill(SkillID, Segment, AttackerType, AttackerID, AttackerRoleId, TargetList) ->
	NewObjects = [{DefId, DefRoleId} || {DefId, DefRoleId} <- TargetList,
		can_use_skill_2_target(AttackerType, AttackerID, AttackerRoleId, DefId, DefRoleId, SkillID)],
	%% 伤害
	do_use_skill_1(SkillID, Segment, AttackerType, AttackerID, AttackerRoleId, NewObjects).

%% TargetList = [{ObjId, RoleId}]
do_use_skill_1(_SkillID, _Segment, _AttackerType, _AttackerID, _AttackerRoleId, []) ->
	%%?LOG_ERROR("skill no target"),
	skip;
do_use_skill_1(SkillID, Segment, AttackerType, AttackerID, AttackerRoleId, TargetList) ->
	HitNum = length(TargetList),
	F = fun({DefenderID, DefenderRoleId}, {Ret, AccDamage}) ->
		%% A : 伤害基础类型 0-攻击、1-治疗
		{A, E} = attribute_map:skill_effect(AttackerID, AttackerRoleId, DefenderID, DefenderRoleId, SkillID, Segment, HitNum),
		case A =:= -1 of
			?TRUE -> {Ret, AccDamage};
			_ ->
				%% 护盾吸收伤害
				{make_damage_shield(AttackerID, AttackerRoleId, DefenderID, DefenderRoleId, A, E) ++ Ret, [{{DefenderID, DefenderRoleId}, get_damage(E)} | AccDamage]}
		end
		end,
	{DamageList1, DefDamageList} = lists:foldl(F, {[], []}, TargetList),
	SkillCfg = cfg_skillBase:row(SkillID),
	DamageList2 = case skill_spe_effect(AttackerID, AttackerRoleId, DamageList1, TargetList, SkillCfg, Segment) of
					  [#pk_Object_Damage{} | _] = E ->   %% 吸血的情况  目前没有二段伤害
						  E;
					  _ ->
						  []
				  end,
	DamageList3 = case lists:keymember(2, 3, SkillCfg#skillBaseCfg.damageCorrEffect) of
					  ?FALSE -> [];
					  ?TRUE ->
						  skill_damage_corr_cure(DamageList1, SkillCfg, AttackerID, AttackerRoleId, [])
				  end,
	DamageList4 = attribute_map:deal_with_suck_blood(AttackerID, AttackerRoleId, DamageList1),
	DamageList = DamageList4 ++ DamageList3 ++ DamageList2 ++ DamageList1,

%%	?LOG_ERROR("skill :~p", [{SkillID, DamageList}]),
	MsgDamageList = [Damage#pk_Object_Damage{value = hurt_value_4_sync(V)} || #pk_Object_Damage{value = V} = Damage <- DamageList],
	Msg = #pk_GS2U_SKillHitRet{
		skillid = SkillID,
		attackerid = AttackerID,
		attacker_role_id = AttackerRoleId,
		damageList = MsgDamageList
	},
%%	mapView:broadcastByView(Msg, AttackerID, 0),
	sync_hit_msg(AttackerType, AttackerID, Msg, MsgDamageList),
	StartHPDelay = DamageList =/= [] andalso (mapView:getBroadcastType() =:= ?BROADCAST_ALL),
	try
		StartHPDelay andalso mapView:start_hp_delay(),
		HurtList = [Element || #pk_Object_Damage{type = Tp} = Element <- DamageList, not (Tp =:= ?HitType_Holy_Shield_Imbibe orelse Tp =:= ?HitType_Holy_Shield_Resist orelse Tp =:= ?HitType_Shield_Resist)],
		%% 这里修bug调整了下触发顺序，do_damage_event,check_object_dead放到了change_object_hp里，保持观察有没有新问题
		change_object_hp(AttackerType, AttackerID, AttackerRoleId, HurtList, SkillID),
%%	do_damage_event(AttackerID, AttackerRoleId, SkillID, HurtList),
%%	[check_object_dead(AttackerID, AttackerRoleId, SkillID, ID, RoleId) || #pk_Object_Damage{objectId = ID, role_id = RoleId} <- HurtList],
		skill_hit_complete(AttackerID, AttackerRoleId, SkillID, Segment),
		%% 结算伤害
		check_skill_settle_hurt(AttackerType, AttackerID, AttackerRoleId, TargetList, SkillID),

		%% 保持最后
		check_hp_back(AttackerID, AttackerRoleId, DamageList, SkillID, DefDamageList)
	after
		StartHPDelay andalso mapView:finish_hp_delay()
	end.

check_skill_settle_hurt(AttackerType, AttackerID, AttackerRoleId, TargetList, SkillID) ->
	SkillKey = {AttackerID, AttackerRoleId, SkillID},
	F = fun({ObjectId, RoleId}, Acc) ->
		Hurt = attribute_map:get_skill_settle_hurt(ObjectId, RoleId, SkillKey),
		Hurt > 0 andalso attribute_map:reset_skill_settle_hurt(ObjectId, RoleId, SkillKey),
		case Hurt > 0 andalso not mapdb:isObjectDead(ObjectId, RoleId) of
			?TRUE ->
				[#pk_Object_Damage{objectId = ObjectId, role_id = RoleId, value = Hurt, type = 1} | Acc];
			_ -> Acc
		end
		end,
	DamageList = lists:foldl(F, [], TargetList),
	case DamageList of
		[] -> skip;
		_ ->
			MsgDamageList = [Damage#pk_Object_Damage{value = hurt_value_4_sync(V)} || #pk_Object_Damage{value = V} = Damage <- DamageList],
			Msg = #pk_GS2U_SKillHitRet{
				skillid = SkillID,
				attackerid = AttackerID,
				attacker_role_id = AttackerRoleId,
				damageList = MsgDamageList
			},
			sync_hit_msg(AttackerType, AttackerID, Msg, MsgDamageList),
			HurtList = [Element || #pk_Object_Damage{type = Tp} = Element <- DamageList, not (Tp =:= ?HitType_Holy_Shield_Imbibe orelse Tp =:= ?HitType_Holy_Shield_Resist orelse Tp =:= ?HitType_Shield_Resist)],
			change_object_hp(AttackerType, AttackerID, AttackerRoleId, HurtList, SkillID)
	end,
	ok.

make_damage_shield(P1, RoleId1, P2, RoleId2, A, {C, V}) ->
	make_damage_shield(P1, RoleId1, P2, RoleId2, A, [{C, V}]);
make_damage_shield(P1, RoleId1, P2, RoleId2, A, HurtList) ->
	F = fun({HurtType, Value}, Ret) ->
		case Value > 0 of
			?TRUE ->
				{L, NewValue} = damage_shield(P1, RoleId1, P2, RoleId2, Value),
				L ++ [make_damage_info(P2, RoleId2, A, 0, HurtType, NewValue) || NewValue =/= 0] ++ Ret;
			_ ->
				[make_damage_info(P2, RoleId2, A, 0, HurtType, Value)] ++ Ret
		end
		end,
	lists:foldl(F, [], HurtList).

sync_hit_msg(AttackerType, AttackerID, Msg, MsgDamageList) ->
	case AttackerType of
		?ID_TYPE_Player ->
			case map:getMapAI() of
				?MapAI_Couple ->
					mapView:broadcastByView_client(Msg, AttackerID, 0);
				?MapAI_Eq ->
					mapView:broadcastByView_client(Msg, AttackerID, 0);
				_ ->
					map:send_client(AttackerID, Msg),
					sync_hit_msg_0(MsgDamageList, Msg#pk_GS2U_SKillHitRet{damageList = []}, AttackerID)
			end;
		?ID_TYPE_Monster ->
			case monsterAttach:get_monster_attach_info(AttackerID) of
				{0, _, _, _} -> mapView:broadcastByView_client(Msg, AttackerID, 0);
				{OwnerId, _, _, _} ->
					map:send_client(OwnerId, Msg),
					sync_hit_msg_0(MsgDamageList, Msg#pk_GS2U_SKillHitRet{damageList = []}, OwnerId)
			end;
		_ -> mapView:broadcastByView_client(Msg, AttackerID, 0)
	end.

sync_hit_msg_0([], _, _) -> skip;
sync_hit_msg_0([#pk_Object_Damage{objectId = AttackerID} | T], Msg, AttackerID) ->
	sync_hit_msg_0(T, Msg, AttackerID);
sync_hit_msg_0([Damage = #pk_Object_Damage{objectId = ObjID} | T], Msg, AttackerID) ->
	map:send_client(ObjID, Msg#pk_GS2U_SKillHitRet{damageList = [Damage]}),
	sync_hit_msg_0(T, Msg, AttackerID).

%% A : 伤害基础类型4位：0-攻击、1-治疗
%% B : 伤害扩展类型4位：0-普通、1-重击、2-虚弱、3-重击+虚弱
%% C : 伤害真实类型8位：0-闪避、1-击中、2-致命、3-卓越、4-会心、5-暴击、6-格挡、7-免疫、8- 追击免疫 9-追命一击 10-绝对闪避 11-吸收(伤害盾吸收) 12-抵挡(圣盾吸收), 13 多倍一击
make_damage_info(DefenderID, DefenderRoleId, A, B, C, V) ->
	Type = (A bsl 12) bor (B bsl 8) bor C,
	#pk_Object_Damage{objectId = DefenderID, role_id = DefenderRoleId, objectHp = mapdb:getObjectHp(DefenderID, DefenderRoleId), type = Type, value = V}.

%% 伤害治疗 前端的显示不超过uint32
hurt_value_4_sync(Value) ->
	min(abs(Value), 4294967295).

damage_shield(_P1, _RoleId1, _P2, _RoleId2, Value) when Value =< 0 ->
	{[], Value};
damage_shield(P1, RoleId1, P2, RoleId2, Value) ->
	%% Value 5000  V1 3000  V2 1000
	V0 = buff_map:on_damage_shield_times(P2, RoleId2, Value),
	V1 = buff_map:on_damage_shield(P2, RoleId2, V0),
	V2 = map_shield:on_damage_shield(P1, RoleId1, P2, RoleId2, V1),

	M0 = [make_damage_info(P2, RoleId2, 0, 0, ?HitType_Shield_Resist, Value - V0) || V0 =/= Value],
	M1 = [make_damage_info(P2, RoleId2, 0, 0, ?HitType_Holy_Shield_Imbibe, V0 - V1) || V1 =/= V0],
	M2 = [make_damage_info(P2, RoleId2, 0, 0, ?HitType_Holy_Shield_Resist, V1 - V2) || V2 =/= V1],

	{M0 ++ M1 ++ M2, V2}.

%% 技能特殊效果
%% TargetList = [{ObjId, RoleId}]
skill_spe_effect(_P1, _RoleId1, [], [], _, _Segment) -> [];
skill_spe_effect(P1, RoleId1, DamageList, TargetList, #skillBaseCfg{iD = ID, damageArray = Array}, Segment) ->
	case skill_map:get_object_skill(P1, RoleId1, ID) of
		#skill_map_info{spec_effect = SpecEffectList, spec_eff_limit = SpecEffLimit} ->
			lists:foldl(fun({EffectDot, Type, T1, T2}, Ret) ->
				%% 生效点：0为所有击中,1为击中首段,2为击中末段
				IsDoEffect = case EffectDot of
								 0 -> ?TRUE;
								 1 -> Segment =:= 1;
								 2 -> Segment =:= length(Array);
								 _ -> ?FALSE
							 end,
				case IsDoEffect of
					?TRUE ->
						skill_spe_effect_1(P1, RoleId1, DamageList, TargetList, {Type, T1, T2}, SpecEffLimit) ++ Ret;
					_ -> Ret
				end
						end, [], SpecEffectList);
		_ -> []
	end.

%% 1为清除目标Buff(BuffType参数1)  参数1为对应编号, 参数2为清除数(为0时,无限个）
%% 2为清除目标Buff(BuffType参数2)
%% 3为清除目标Buff(BuffType参数3)
%% 4为吸血,参数1为转换万分比,参数2为0时所有伤害目标,大于0时伤害目标数
%% 5为目标直接死亡(状态类型,状态参数)1为目标当前生命比,参数为万分值
%% 6为指定学习位冷却时间修改,参数1为技能学习位,参数2为时间(可增可减,最多不超过本身最大冷却时间,最少不能低于0)
%% TargetList = [{ObjId, RoleId}]
skill_spe_effect_1(_P1, _RoleId1, _DamageList, TargetList, {1, T1, T2}, _SpecEffLimit) ->
	[buff_map:remove_sb_buff_by_type(P2, RoleId2, 1, T1, T2) || {P2, RoleId2} <- TargetList], [];
skill_spe_effect_1(_P1, _RoleId1, _DamageList, TargetList, {2, T1, T2}, _SpecEffLimit) ->
	[buff_map:remove_sb_buff_by_type(P2, RoleId2, 2, T1, T2) || {P2, RoleId2} <- TargetList], [];
skill_spe_effect_1(_P1, _RoleId1, _DamageList, TargetList, {3, T1, T2}, _SpecEffLimit) ->
	[buff_map:remove_sb_buff_by_type(P2, RoleId2, 3, T1, T2) || {P2, RoleId2} <- TargetList], [];
skill_spe_effect_1(P1, RoleId1, DamageList, _TargetList, {4, T1, T2}, SpecEffLimit) ->
	case DamageList =/= [] of
		?TRUE ->
			Damage = case T2 of
						 N when N > 0 ->
							 {L1, _} = lists:split(N, DamageList),
							 lists:sum([Value || #pk_Object_Damage{value = Value} <- L1, Value > 0]);
						 _ -> lists:sum([Value || #pk_Object_Damage{value = Value} <- DamageList, Value > 0])
					 end,
			V = trunc(Damage * T1 / 10000),
			FixV = case SpecEffLimit of
					   {1, W, _} ->
						   MaxV = trunc(mapdb:getObjectHpMax(P1, RoleId1) * W / 10000),
						   min(MaxV, V);
					   _ -> V
				   end,
			case id_generator:id_type(RoleId1) =/= ?ID_TYPE_MY_PET of
				?TRUE ->
					[make_damage_info(P1, RoleId1, 1, 0, 1, -FixV)];
				?FALSE ->
					[make_damage_info(P1, MyRoleID, 1, 0, 1, -FixV) || MyRoleID <- map_role:get_role_id_list(P1)]
			end;
		?FALSE -> []
	end;
skill_spe_effect_1(P1, _RoleId1, _, TargetList, {6, T1, T2}, _SpecEffLimit) ->
	case lists:member(T1, [13, 14, 15, 16]) of
		?FALSE ->
			skill_map:deal_player_skill_cd(TargetList, T1, T2), [];
		?TRUE -> %% 魔宠技能位，强制把对象修改为魔宠
			case mapdb:getMapPlayer(P1) of
				#mapPlayer{pet_infos = PetInfos} ->
					[skill_map:deal_player_skill_cd([{P1, PetObjID}], T1, T2) || #map_pet{object_id = PetObjID, is_fight = 1} <- PetInfos],
					[];
				_ -> []
			end
	end;
skill_spe_effect_1(P1, RoleId1, _DamageList, _TargetList, {7, T1, T2}, _SpecEffLimit) ->
	buff_map:remove_sb_buff_by_type(P1, RoleId1, 1, T1, T2, ?FALSE), [];
skill_spe_effect_1(P1, RoleId1, _DamageList, _TargetList, {8, T1, T2}, _SpecEffLimit) ->
	buff_map:remove_sb_buff_by_type(P1, RoleId1, 2, T1, T2, ?FALSE), [];
skill_spe_effect_1(P1, RoleId1, _DamageList, _TargetList, {9, T1, T2}, _SpecEffLimit) ->
	buff_map:remove_sb_buff_by_type(P1, RoleId1, 3, T1, T2, ?FALSE), [];
skill_spe_effect_1(P1, RoleId1, _DamageList, _TargetList, {10, T1, T2}, _SpecEffLimit) ->
	buff_map:remove_sb_buff_by_type(P1, RoleId1, 1, T1, T2, ?TRUE), [];
skill_spe_effect_1(P1, RoleId1, _DamageList, _TargetList, {11, T1, T2}, _SpecEffLimit) ->
	buff_map:remove_sb_buff_by_type(P1, RoleId1, 2, T1, T2, ?TRUE), [];
skill_spe_effect_1(P1, RoleId1, _DamageList, _TargetList, {12, T1, T2}, _SpecEffLimit) ->
	buff_map:remove_sb_buff_by_type(P1, RoleId1, 3, T1, T2, ?TRUE), [];
skill_spe_effect_1(P1, RoleId1, _DamageList, TargetList, {13, T1, T2}, _SpecEffLimit) ->
	[buff_map:multiplicative_buff_layer_by_type(P1, RoleId1, P2, RoleId2, 1, T1, T2) || {P2, RoleId2} <- TargetList],
	[];
skill_spe_effect_1(P1, RoleId1, _DamageList, TargetList, {14, T1, T2}, _SpecEffLimit) ->
	[buff_map:multiplicative_buff_layer_by_type(P1, RoleId1, P2, RoleId2, 2, T1, T2) || {P2, RoleId2} <- TargetList],
	[];
skill_spe_effect_1(P1, RoleId1, _DamageList, TargetList, {15, T1, T2}, _SpecEffLimit) ->
	[buff_map:multiplicative_buff_layer_by_type(P1, RoleId1, P2, RoleId2, 3, T1, T2) || {P2, RoleId2} <- TargetList],
	[];
skill_spe_effect_1(_, _, _, _, {0, _, _}, _) -> [];
skill_spe_effect_1(_, _, _, _, Info, _) ->
	?LOG_ERROR("unhandle skill special effect :~p", [Info]),
	[].

do_damage_event(AttackerType, AttackerID, AttackerRoleId, SkillID, #pk_Object_Damage{objectId = DefenderID, role_id = DefenderRoleId, value = Damage, type = Type}) ->
	%% 判断是伤害还是治疗
	case (Type bsr 12) band 2#11 =:= 1 of
		?TRUE -> map:doTreat(DefenderID, DefenderRoleId, AttackerID, AttackerRoleId, SkillID, 0 - Damage);
		_ ->
			damage_event(DefenderID, DefenderRoleId, AttackerType, AttackerID, AttackerRoleId, SkillID, Damage),
			buff_map:handle_damage_hit_effect(AttackerID, AttackerRoleId, DefenderID, DefenderRoleId, Type)
	end.

damage_event(TargetID, TargetRoleId, AttackerType, AttackerID, AttackerRoleId, SkillID, Damage) ->
	case mapActorStateFlag:isStateFlag(TargetID, TargetRoleId, ?State_Flag_God) of
		?TRUE -> skip;
		_ ->
			TargetType = id_generator:id_type(TargetID),
			map:doDamage(TargetType, TargetID, TargetRoleId, AttackerType, AttackerID, AttackerRoleId, SkillID, Damage),
			%% 怒气值处理
			%% 每累计受伤值达到生命上限的百分之一恢复一次怒气值，恢复值=P1.受伤比恢复怒气<SSNuQi>*(10^4+P1.受伤获得怒气加成<SSNuQiJiaC>)/10^4
			LastDamage = mapdb:get_obj_total_damage(TargetID, TargetRoleId),
			NewDamage = LastDamage + Damage,

			RageDmgAddNeed = cfg_globalSetup:rageDmgAddNeed(),
			MaxHp = mapdb:getObjectHpMax(TargetID, TargetRoleId),
			DamageNeed = max(1, trunc(MaxHp * RageDmgAddNeed / 100)),
			AddTimes = NewDamage div DamageNeed,
			case AddTimes > 0 of
				?TRUE ->
					%% 增加怒气值
					SSNuQi = attribute_map:get_object_property_value(TargetID, TargetRoleId, ?P_SSNuQi),
					SSNuQiJiaC = attribute_map:get_object_property_value(TargetID, TargetRoleId, ?P_SSNuQiJiaC),
					RageAdd = trunc(SSNuQi * (10000 + SSNuQiJiaC) / 10000 * AddTimes * get_map_rage_radio()),
					map:updateObjectRage(TargetID, TargetRoleId, RageAdd),
					%% 重算累计伤害值
					mapdb:updateObjectTotalDamge(TargetID, TargetRoleId, NewDamage rem DamageNeed);
				?FALSE -> mapdb:updateObjectTotalDamge(TargetID, TargetRoleId, NewDamage)
			end,
			case AttackerType =:= ?ID_TYPE_Player andalso TargetType =:= ?ID_TYPE_Monster of
				?TRUE ->
					case cfg_skillBase:getRow(SkillID) of
						#skillBaseCfg{cDPara = {999, _, _, _, _}} ->
							case mapdb:getMonster(TargetID) of
								#mapMonster{skill_use = SkillUseList} = MapMonster ->
									NewSkillUseList = lists:keystore(AttackerRoleId, 1, SkillUseList, {AttackerRoleId, SkillID}),
									mapdb:updateMonster(MapMonster#mapMonster{skill_use = NewSkillUseList});
								_ -> ok
							end;
						_ -> ok
					end;
				_ -> ok
			end
	end,
	ok.

get_map_rage_radio() ->
	case cfg_mapsetting:row(mapSup:getMapDataID()) of
		#mapsettingCfg{rageCor = Radio} -> Radio;
		_ -> 1
	end.

skill_hit_complete(AttackerID, AttackerRoleId, SkillID, _) ->
	%%	命中恢复怒气：伤害技能若命中目标则恢复怒气
	%%	技能恢复怒气=(释放恢复(RageRec[SkillBase]参数1)+命中恢复(RageRec[SkillBase]参数2))*(10^4+P1.技能获得怒气加成<JNNuQiJiaC>)/10^4
	#skillBaseCfg{rageRec = {_, HitRec}} = cfg_skillBase:getRow(SkillID),
	RageRec = HitRec * (10000 + attribute_map:get_object_property_value(AttackerID, AttackerRoleId, ?P_JNNuQiJiaC)) / 10000 * get_map_rage_radio(),
	map:updateObjectRage(AttackerID, AttackerRoleId, trunc(RageRec)).

can_use_skill(AttackID, AttackRoleId, SkillID) ->
	case mapdb:isObjectDead(AttackID, AttackRoleId) of
		?TRUE -> ?FALSE;
		_ ->
			case skill_map:get_object_skill(AttackID, AttackRoleId, SkillID) of
				{} ->
					?LOG_INFO("no skill in map when hit :~p", [{AttackID, SkillID}]),
					?FALSE;
				_ ->
					%% todo check skill enable
					IsAlive = ?TRUE,
					%%todo check skill cost
					IsAlive
			end

	end.

%%
check_object_dead(AttackerID, AttackerRoleId, SkillID, TargetID, TargetRoleId) ->
	case mapdb:isObjectDead(TargetID, TargetRoleId) of
		?TRUE ->
			onObjectDeadEvent(AttackerID, AttackerRoleId, TargetID, TargetRoleId, SkillID);
		_ ->
			ok
	end.

%%受击或攻击者：死亡事件
onObjectDeadEvent(AttackerID, AttackerRoleId, TargetID, TargetRoleId, SkillID) ->
	Msg = #pk_GS2U_Dead{deadActorCode = TargetID, deadRoleID = TargetRoleId, killerCode = AttackerID,
		killerRoleID = AttackerRoleId, killerName = mapdb:getObjectName(AttackerID),
		skillID = SkillID, recover = mapdb:getObjectRecover(TargetID)},
	map:doDead(TargetID, TargetRoleId, AttackerID, AttackerRoleId, SkillID, Msg).

on_skill_complete(AttackerID, AttackerRoleId, SkillID) ->
	%%	释放恢复怒气：伤害技能若命中目标则恢复怒气
	%%	技能恢复怒气=(释放恢复(RageRec[SkillBase]参数1)+命中恢复(RageRec[SkillBase]参数2))*(10^4+P1.技能获得怒气加成<JNNuQiJiaC>)/10^4
	#skillBaseCfg{rageRec = {UseRec, _}} = cfg_skillBase:getRow(SkillID),
	RageRec = UseRec * (10000 + attribute_map:get_object_property_value(AttackerID, AttackerRoleId, ?P_JNNuQiJiaC)) / 10000 * get_map_rage_radio(),
	map:updateObjectRage(AttackerID, AttackerRoleId, trunc(RageRec)),
	SkillItem = skill_map:get_object_skill(AttackerID, AttackerRoleId, SkillID),
	#skill_map_info{cost = CostList} = SkillItem,
	F = fun
			({1, Rage}) -> map:updateObjectRage(AttackerID, AttackerRoleId, -Rage);
			({2, Rage}) ->
				DecHp = trunc(mapdb:getObjectHp(AttackerID, AttackerRoleId) * max(5000, Rage) / 10000),
				mapdb:changeObjectHp(0, 0, AttackerID, AttackerRoleId, -DecHp, ?FALSE);
			(_) -> skip
		end,
	lists:foreach(F, CostList),
	ok.

%% 技能前置处理  FIXME
on_skill_pre_event(AttackerID, SkillID) ->
	%% 使用技能，攻击者下马
	case id_generator:id_type(AttackerID) of
		?ID_TYPE_Player ->
			case cfg_skillBase:getRow(SkillID) of
				#skillBaseCfg{skillType = {_, _, SkillType}} when SkillType =:= 1 orelse SkillType =:= 2 orelse SkillType =:= 5 ->
					mapPlayer:removeMountStatus(AttackerID);
				_ -> skip
			end;
		?ID_TYPE_MirrorPlayer ->
			mapView:broadcastByView(#pk_GS2U_BattleStatus{playerID = AttackerID, battleStatus = 1}, AttackerID, AttackerID);
		_ ->
			ok
	end,
	?TRUE.

%%能否对目标使用技能
can_use_skill_2_target(AttackerType, AttackerID, AttackerRoleId, TargetID, TargetIDRoleID, SkillID) ->
	#skillBaseCfg{skillEffect = {SkillEffect, _, _}, cDPara = {CDGroup, _, _, _, _}, canBreak = CanBreak} = cfg_skillBase:row(SkillID),
	TargetType = id_generator:id_type(TargetID),
	%%技能伤害类型
	MyFunDead = fun() ->    %%伤害技能，恢复技能 玩家没有死才有效
		case SkillEffect of
			1 -> %% 1 攻击技能
				charDefine:getRelation_Enemy2(AttackerType, AttackerID, AttackerRoleId, TargetType, TargetID, TargetIDRoleID);
			2 -> %% 2 恢复技能
				not mapdb:isObjectDead(TargetID, TargetIDRoleID);
			3 -> %% 3 宠物攻击技能
				charDefine:getRelation_Enemy2(AttackerType, AttackerID, AttackerRoleId, TargetType, TargetID, TargetIDRoleID);
			4 -> %% 3 宠物恢复技能
				not mapdb:isObjectDead(TargetID, TargetIDRoleID);
			5 ->%% 5 宠物技能-分担伤害
				charDefine:getRelation_Enemy2(AttackerType, AttackerID, AttackerRoleId, TargetType, TargetID, TargetIDRoleID);
			_ -> ?TRUE
		end
				end,

	SkillSpecial = fun() ->
		case {CDGroup =:= 999, TargetType =:= ?ID_TYPE_Monster} of
			{?TRUE, ?TRUE} ->
				case mapdb:getMonster(TargetID) of
					#mapMonster{skill_use = SKillUseList} -> not lists:member({AttackerRoleId, SkillID}, SKillUseList);
					_ -> ?FALSE
				end;
			{?TRUE, ?FALSE} -> ?FALSE;
			{?FALSE, _} -> ?TRUE
		end
				   end,

	%%攻击者检测(昏迷状态,禁止攻击状态),受击者检查(无敌状态)
	CanNotState1 = (?State_Flag_Disable_Hold) bor (?State_Flag_Disable_Attack),
	Ret = (CanBreak =:= 0 orelse mapActorStateFlag:isStateFlag(AttackerID, AttackerRoleId, CanNotState1) =:= ?FALSE) andalso
		MyFunDead() andalso
		machineTrap:canUseSkill(AttackerID, SkillID) andalso map:is_out_safe_area(TargetID, SkillID)
%%		andalso holy_war_map:can_attack(TargetID) andalso god_fight_map:can_attack(AttackerID, TargetID)
%%		andalso dark_lord_map:can_attack(AttackerID, TargetID)
		andalso elemental_continent_map:can_attack(AttackerID, TargetType, TargetID)
		andalso domain_fight_map:check_domain_chariots_atk(AttackerID, AttackerRoleId, TargetID, TargetIDRoleID)
		andalso check_demon(AttackerType, AttackerID, TargetType, TargetID) andalso SkillSpecial() andalso expedition_map:can_attack(AttackerID, TargetID)
		andalso manor_war_map:can_attack(AttackerID, AttackerRoleId, TargetID, TargetIDRoleID)
		andalso not monsterAttach:is_attach_monster(TargetType, TargetID),
	Ret.
%%能否对目标使用技能Buff
can_use_skill_buff_2_target(_AttackerType, AttackerID, _AttackerRoleId, AttackerID, _TargetIDRoleID) ->
	?TRUE;
can_use_skill_buff_2_target(AttackerType, AttackerID, AttackerRoleId, TargetID, TargetIDRoleID) ->
	TargetType = id_generator:id_type(TargetID),
	map:is_out_safe_area(TargetID, 0) andalso domain_fight_map:check_domain_chariots_atk(AttackerID, AttackerRoleId, TargetID, TargetIDRoleID)
		andalso check_demon(AttackerType, AttackerID, TargetType, TargetID) andalso expedition_map:can_attack(AttackerID, TargetID)
		andalso not monsterAttach:is_attach_monster(TargetType, TargetID) andalso elemental_continent_map:can_attack(AttackerID, TargetType, TargetID)
		andalso manor_war_map:can_attack(AttackerID, AttackerRoleId, TargetID, TargetIDRoleID).

check_demon(AttackerType, AttackerID, TargetType, TargetID) ->
	{OwnerAttackerType, OwnerAttackerID} = case AttackerType =:= ?ID_TYPE_Monster andalso mapdb:getMonster(AttackerID) of
											   #mapMonster{attach_owner_id = AttachOid} when AttachOid > 0 ->
												   {id_generator:id_type(AttachOid), AttachOid};
											   _ ->
												   {AttackerType, AttackerID}
										   end,
	case OwnerAttackerType =:= ?ID_TYPE_Player andalso TargetType =:= ?ID_TYPE_Monster
		andalso (lists:member(map:getMapAI(), [?MapAI_Demon, ?MapAI_DemonCx, ?MapAI_DemonCluster, ?MapAI_Pantheon, ?MapAI_PantheonCluster,
			?MapAI_Border, ?MapAI_HolyWar, ?MapAI_HolyRuins, ?MapAI_WorldBoss, ?MapAI_DarkLord, ?MapAI_WorldBossSingle, ?MapAI_BlzForest,
			?MapAI_ElementTrial])) of
		?TRUE ->
			Flag1 = case map:getMapAI() of
						?MapAI_HolyWar ->
							case mapdb:get_monster_type(TargetID) of
								?MonsterType_ManorWarPillar -> ?TRUE;
								_ ->
									MapPlayer = mapdb:getMapPlayer(OwnerAttackerID),
									not MapPlayer#mapPlayer.isMaxFatigue
							end;
						?MapAI_DemonCx ->
							MapPlayer = mapdb:getMapPlayer(OwnerAttackerID),
							demon_map:is_super_boss_can_atk(MapPlayer, TargetID);
						?MapAI_BlzForest ->
							MapPlayer = mapdb:getMapPlayer(OwnerAttackerID),
							blizzard_forest_map:is_monster_can_atk(MapPlayer, TargetID);
						_ ->
							MapPlayer = mapdb:getMapPlayer(OwnerAttackerID),
							not MapPlayer#mapPlayer.isMaxFatigue
					end,
			Flag2 = guild_help_map:check_player_in_help(OwnerAttackerID, TargetID, Flag1),
			team_map:check_team_damage(OwnerAttackerID, Flag2);
		?FALSE -> ?TRUE
	end.

check_hp_back(_, _, [], _, _) -> ok;
check_hp_back(AttackerID, AttackerRoleId, [#pk_Object_Damage{objectId = AttackerID} | T], SkillID, DefDamageList)  ->
	check_hp_back(AttackerID, AttackerRoleId, T, SkillID, DefDamageList);
check_hp_back(AttackerID, AttackerRoleId, [#pk_Object_Damage{objectId = TargetID, role_id = TargetRoleId, type = Type, value = Value} | T], SkillID, DefDamageList) when Value >= 0 ->
	DamageList = case mapdb:isObjectDead(AttackerID, AttackerRoleId) orelse mapdb:isObjectDead(TargetID, TargetRoleId) of
					 ?TRUE -> [];
					 _ ->
						 case (Type band 16#FF) of
							 HitType when HitType =:= ?HitType_Miss orelse HitType =:= ?HitType_AbsoluteMiss -> %% 反击
								 {P1, P2} = attribute_map:get_map_attr_from_skill(AttackerID, AttackerRoleId, TargetID, TargetRoleId, SkillID),
								 case attribute_map:check_Counterattack(P1, P2) of
									 {?HitType_Counterattack, DamageRate} ->
										 [make_damage_info(AttackerID, AttackerRoleId, 0, 0, ?HitType_Counterattack, trunc(attribute_map:get_base_damage(attribute_map:get_attribute(TargetID, TargetRoleId),
											 attribute_map:get_attribute(AttackerID, AttackerRoleId)) * DamageRate / 10000))];
									 _ -> []
								 end;
							 HitType when HitType =/= ?HitType_Immune andalso HitType =/= ?HitType_Immune_1 andalso HitType =/= ?HitType_Holy_Shield_Resist andalso HitType =/= ?HitType_Shield_Resist -> %% 反弹
								 {P1, P2} = attribute_map:get_map_attr_from_skill(AttackerID, AttackerRoleId, TargetID, TargetRoleId, SkillID),
								 Ret = attribute_map:check_Recoil(P1, P2),
								 case Ret of
									 {?HitType_Recoil, DamageRate} ->
										 case lists:keyfind({TargetID, TargetRoleId}, 1, DefDamageList) of
											 {_, HurtValue} ->
												 [make_damage_info(AttackerID, AttackerRoleId, 0, 0, ?HitType_Recoil, trunc(HurtValue * DamageRate / 10000))];
											 _ -> []
										 end;
									 _ -> []
								 end;
							 _ ->
								 []
						 end
				 end,
	case DamageList =/= [] of
		?TRUE ->
			MsgDamageList = [Damage#pk_Object_Damage{value = hurt_value_4_sync(V)} || #pk_Object_Damage{value = V} = Damage <- DamageList],
			Msg = #pk_GS2U_SKillHitRet{
				skillid = 0,
				attackerid = TargetID,
				attacker_role_id = TargetRoleId,
				damageList = MsgDamageList
			},
			TargetType = id_generator:id_type(TargetID),
			sync_hit_msg(TargetType, TargetID, Msg, MsgDamageList),
			HurtList = [Element || #pk_Object_Damage{type = Tp} = Element <- DamageList, not (Tp =:= ?HitType_Holy_Shield_Imbibe orelse Tp =:= ?HitType_Holy_Shield_Resist orelse Tp =:= ?HitType_Shield_Resist)],
			change_object_hp(TargetType, TargetID, TargetRoleId, HurtList, SkillID);
%%			do_damage_event(TargetID, TargetRoleId, 0, HurtList);
%%			check_object_dead(TargetID, TargetRoleId, 0, AttackerID, AttackerRoleId);
		_ ->
			ok
	end,
	check_hp_back(AttackerID, AttackerRoleId, T, SkillID, DefDamageList);
check_hp_back(AttackerID, AttackerRoleId, [_ | T], SkillID, DefDamageList) ->
	check_hp_back(AttackerID, AttackerRoleId, T, SkillID, DefDamageList).

get_damage({_, V}) when V > 0 -> V;
get_damage([{_, V} | _]) when V > 0 -> V;
get_damage(_) -> 0.


check_skill_damage_corr_effect([], _P1ObjectId, _P1RoleId, _P2ObjectId, _P2RoleId, _GetEffectType, Ret) -> Ret;
check_skill_damage_corr_effect([{TriggerType, TriggerParam, EffectType, Pram1, Param2} | T], P1ObjectId, P1RoleId, P2ObjectId, P2RoleId, GetEffectType, Ret) ->
	case EffectType =:= GetEffectType andalso buff_map:get_buff(P2ObjectId, P2RoleId) of
		#objectBuff{dataList = BuffList} ->
			case lists:any(fun(#buff_obj{buff_data_id = BuffId, caster_id = CasterID}) ->
				case CasterID =:= P1ObjectId andalso cfg_buffBase:getRow(BuffId) of
					#buffBaseCfg{buffType = BT} when TriggerType =:= 1 andalso element(2, BT) =:= TriggerParam -> ?TRUE;
					#buffBaseCfg{buffType = BT} when TriggerType =:= 2 andalso element(3, BT) =:= TriggerParam -> ?TRUE;
					_ -> ?FALSE
				end end, BuffList) of
				?TRUE -> {Pram1, Param2};
				?FALSE ->
					check_skill_damage_corr_effect(T, P1ObjectId, P1RoleId, P2ObjectId, P2RoleId, GetEffectType, Ret)
			end;
		_ -> check_skill_damage_corr_effect(T, P1ObjectId, P1RoleId, P2ObjectId, P2RoleId, GetEffectType, Ret)
	end.

skill_damage_corr_cure([], _SkillCfg, _AttackerID, _AttackerRoleId, Ret) -> Ret;
skill_damage_corr_cure([#pk_Object_Damage{objectId = TargetID, role_id = TargetRoleId, value = V} | T], SkillCfg, AttackerID, AttackerRoleId, Ret) ->
	case skill_new:check_skill_damage_corr_effect(SkillCfg#skillBaseCfg.damageCorrEffect, AttackerID, AttackerRoleId, TargetID, TargetRoleId, 2, {0, 0}) of
		{_, 0} -> Ret;
		{TargetType, Percent} when V > 0 ->
			case V * Percent div 10000 of
				CureValue when CureValue > 0 ->
					{CureTargetID, CureTargetRoleID} = case TargetType of
														   1 -> {AttackerID, AttackerRoleId};
														   2 -> {AttackerID, map_role:get_leader_id(AttackerID)};
														   3 -> case mapdb:getMonster(AttackerID) of
																	#mapMonster{attach_owner_id = AttachOwnerID} when AttachOwnerID > 0 ->
																		{AttachOwnerID, map_role:get_leader_id(AttachOwnerID)};
																	_ -> {0, 0}
																end;
														   _ ->
															   ?LOG_ERROR("error type ~p", [TargetType]),
															   {0, 0}
													   end,
					NewRet = ?IF(CureTargetID > 0, [make_damage_info(CureTargetID, CureTargetRoleID, 1, 0, 1, -CureValue) | Ret], Ret),
					skill_damage_corr_cure(T, SkillCfg, AttackerID, AttackerRoleId, NewRet);
				_ -> Ret
			end;
		_ -> Ret
	end.