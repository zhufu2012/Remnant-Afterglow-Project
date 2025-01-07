%%%-------------------------------------------------------------------
%%% @author zhufu
%%% @copyright (C) 2023, DoubleGame
%%% @doc
%%% 	英雄幻化
%%% @end
%%% Created : 26. 7月 2023 17:59
%%%-------------------------------------------------------------------
-module(pet_illusion).
-author("zhufu").

-include("global.hrl").
-include("record.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("pet_illusion.hrl").
-include("variable.hrl").
-include("player_private_list.hrl").
-include("netmsgRecords.hrl").
-include("attribute.hrl").
-include("pet_new.hrl").
-include("db_table.hrl").
-include("item.hrl").
-include("attainment.hrl").

-include("cfg_item.hrl").
-include("cfg_petSkinLevel.hrl").
-include("cfg_petSkinBase.hrl").
-include("cfg_collectionroom.hrl").
-include("cfg_collectionExp.hrl").
-include("time_limit_gift_define.hrl").

%% API
-export([on_load/0, on_player_online/0, on_function_open/0, on_tick/1]).
-export([on_active_illusion/2, on_illusion_info/0, on_illusion_equip/2, on_illusion_refine/1, on_collect_item/1]).
-export([get_illusion/1, get_illusion_cfg/2, get_illusion_id_list/2, get_illusion_item_num/0, get_illsuion_refine_num/1]).
-export([get_pet_prop/2, get_pet_skill/2]).
-export([gm_clean/1, gm_clean_all/0, gm_clean_collect/0]).
-export([list_2_illusion/1, illusion_2_list/1]).
-export([is_active/1]).
%%%===================================================================
%%% API
%%%===================================================================
%%加载数据
on_load() ->
	List = table_player:lookup(?Table_Illusion, player:getPlayerID()),
	CollectList = table_player:lookup(?Table_Illusion_collect, player:getPlayerID()),
	NewList = lists:foldl(fun(#pet_illusion{cfg_id = CfgId, pet_cfg_id = PetCfgId} = Info, Acc) ->
		case cfg_petSkinBase:getRow(CfgId) of
			#petSkinBaseCfg{rareUpHero = HeroCfgIdList} ->
				[Info#pet_illusion{pet_cfg_list = [PetCfgId | HeroCfgIdList]} | Acc];
			_ -> [Info#pet_illusion{pet_cfg_list = [PetCfgId]} | Acc]
		end end, [], List),
	set_pet_illusion_list(NewList),
	set_illusion_collect(CollectList).

%%上线同步
on_player_online() ->
	case is_func_open() of
		?TRUE ->
			check_time(time:time()),
			calc_prop(),
			on_illusion_info();
		_ -> ok
	end.

%%功能开启同步
on_function_open() ->
	on_illusion_info().

%%心跳（每分钟一次），幻化过期处理
on_tick(NowTime) ->
	case is_func_open() of
		?TRUE -> check_time(NowTime);%%过期有邮件
		_ -> ok
	end.

%%同步英雄幻化数据，并且包括收藏室 等级和经验
on_illusion_info() ->
	#illusion_collect{lv = Lv, exp = Exp} = get_illusion_collect(),
	player:send(#pk_GS2U_pet_illusion_infoRet{
		list = [make_pet_illusion(Info) || Info <- get_pet_illusion_list()],
		lv = Lv,
		exp = Exp
	}).

%%英雄幻化激活
on_active_illusion(Cost, IllusionId) ->
	?metrics(begin active_illusion(Cost, IllusionId) end).


%%英雄幻化穿戴
on_illusion_equip(NewCfgId, Op) ->
	?metrics(begin
				 illusion_equip(NewCfgId, Op),
				 player_refresh:on_refresh_pet()
			 end).

%%英雄幻化精炼
on_illusion_refine(CfgId) ->
	?metrics(begin illusion_refine(CfgId) end).

%%收藏多余的英雄幻化道具 [{Key,Value}]
on_collect_item(CostList) ->
	?metrics(begin collect_item(CostList) end).

%%英雄幻化功能是否开启
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetIllusion) == 1 andalso guide:is_open_action(?OpenAction_PetIllusion).

%%获取穿戴了的，英雄配置对应的幻化数据
get_illusion(PetCfgId) ->
	case [Info || #pet_illusion{pet_cfg_list = PetCfgIdList, equip_type = 1} = Info <- get_pet_illusion_list(), lists:member(PetCfgId, PetCfgIdList)] of
		[] -> {};
		[#pet_illusion{} = P | _] -> P %%只会有一个
	end.

%%其他进程获取英雄配置对应的幻化id-注意检查是否过期,过期返回 0
get_illusion_cfg(PlayerId, PetCfgId) ->
	List = get_table_pet_illusion_list(PlayerId),
	case [Info || #pet_illusion{pet_cfg_list = PetCfgIdList, equip_type = 1} = Info <- List, lists:member(PetCfgId, PetCfgIdList)] of
		[] -> 0;
		[#pet_illusion{cfg_id = CfgId} | _] ->
			CfgId
	end.

%%其他进程获取对应英雄中穿戴的英雄幻化id列表-注意检查是否过期
get_illusion_id_list(PlayerId, PetMsgList) ->
	List = get_table_pet_illusion_list(PlayerId),
	lists:foldl(fun(#pet_illusion{cfg_id = CfgId, equip_type = 1, pet_cfg_list = PetCfgList}, Acc) ->
		Acc ++ [#pk_key_value{key = PetCfgId, value = CfgId} || PetCfgId <- PetCfgList,
			lists:keyfind(PetCfgId, #pk_pet_info.pet_cfg_id, PetMsgList) =/= ?FALSE];
		(_, Acc) -> Acc end, [], List).

%%获取背包中英雄幻化道具的数量
get_illusion_item_num() ->
	CfgIdList = lists:foldl(
		fun(#petSkinBaseCfg{temporary = Temporary, permanent = {Item1, _}}, Acc) ->
			[Item2 || {Item2, _} <- Temporary] ++ [Item1 | Acc]
		end, [], cfg_petSkinBase:rows()),
	ItemList = bag_player:get_bag_item_list(?BAG_PLAYER),
	lists:foldl(fun(#item{cfg_id = CfgId}, Acc) -> case lists:member(CfgId, CfgIdList) of
													   ?TRUE -> Acc + 1;
													   _ -> Acc
												   end end, 0, ItemList).

%%成就-519 获取 多少个英雄幻化同时达到Y段
get_illsuion_refine_num(Refine2) ->
	lists:foldl(fun
					(#pet_illusion{refine_lv = Refine}, Acc) when Refine >= Refine2 ->
						Acc + 1;
					(_, Acc) -> Acc end, 0, get_pet_illusion_list()).

%%获取对应英雄及链接英雄的加成资质 {[{PetCfgId,CfgId,资质列表}], Collect}
%% {[],[]}
get_pet_prop(PlayerId, PetCfgIDList) ->
	case player:getPlayerID() =:= PlayerId of%%是否为玩家进程
		?TRUE ->
			PropList = get_prop_list(),
			IllusionList = get_pet_illusion_list(),
			lists:append([get_pet_cfg_prop(IllusionList, PetCfgId, PropList) || PetCfgId <- PetCfgIDList]);
		?FALSE ->%%其他进程-计算注意是否过期
			List = get_table_pet_illusion_list(PlayerId),
			Increase = case table_player:lookup(?Table_Illusion_collect, PlayerId) of%%收藏室万分比加成
						   [] -> 0;
						   [#illusion_collect{lv = Lv}] ->
							   case cfg_collectionroom:getRow(Lv) of%%收藏属性，资质万分比加成
								   #collectionroomCfg{attrIncrease = Inc} -> Inc;
								   _ -> 0
							   end
					   end,
			Fun = fun(PetCfgIds) ->
				%%所有对应英雄类型的英雄幻化id及精炼等级
				IllusionCfgList = [{CfgId, RefineLv} || #pet_illusion{cfg_id = CfgId, pet_cfg_list = PetCfgList, refine_lv = RefineLv, type = Type} <- List,
					Type =/= 0 andalso lists:member(PetCfgIds, PetCfgList)],
				common:listValueMerge(lists:foldl(fun({IllusionCfgId, RefineLvs}, Acc) ->
					case cfg_petSkinBase:getRow(IllusionCfgId) of
						{} -> Acc;
						#petSkinBaseCfg{skinAttrBase = SkinAttrBase} ->
							case cfg_petSkinLevel:getRow(IllusionCfgId, RefineLvs) of
								{} -> Acc;
								#petSkinLevelCfg{qualiIncrease = QuIncrease} ->
									[{Key, round((Value * (QuIncrease + 10000) / 10000) * (Increase + 10000) / 10000)} || {Key, Value} <- SkinAttrBase] ++ Acc
							end
					end end, [], IllusionCfgList))
				  end,
			lists:append([Fun(PetCfgId) || PetCfgId <- PetCfgIDList])
	end.

%%获取对应英雄的替换的技能和额外的技能 {替换技能，额外技能}-列表中可能有多个数据，注意只取穿戴的
get_pet_skill(PlayerId, PetUid) ->
	case player:getPlayerID() =:= PlayerId of%%是否为玩家进程
		?TRUE ->
			case pet_new:get_pet(PetUid) of
				{} -> [];
				#pet_new{pet_cfg_id = PetCfgId} ->
					lists:flatten([SkillList || {CfgId, SkillList} <- get_skill_list(), CfgId =:= PetCfgId])
			end;
		?FALSE ->%%其他进程-注意是否存在过期
			List = get_table_pet_illusion_list(PlayerId),
			case lists:keyfind(PetUid, #db_pet_new.uid, table_player:lookup(db_pet_new, PlayerId)) of
				?FALSE -> [];
				#db_pet_new{pet_cfg_id = PetCfgId} ->
					case [Info || #pet_illusion{pet_cfg_list = PetCfgIdList} = Info <- List, lists:member(PetCfgId, PetCfgIdList)] of
						[] -> [];
						PetIllusionList ->
							lists:foldl(fun(#pet_illusion{cfg_id = CfgId, refine_lv = RefineLv}, SkillAcc) ->
								case cfg_petSkinLevel:getRow(CfgId, RefineLv) of
									{} ->
										?LOG_ERROR("~n cfg_petSkinLevel no cfg , key:~p", [{PlayerId, CfgId, RefineLv}]),
										SkillAcc;
									#petSkinLevelCfg{skill = Skill} ->
										check_skill_active(Skill, RefineLv) ++ SkillAcc
								end end, [], PetIllusionList)
					end
			end
	end.

%%刷新英雄幻化属性(全部)  在获取时操作而不是在这里检查，这里正常计算就可以了
calc_prop() ->
	calc_prop([PetCfgId || #pet_illusion{pet_cfg_id = PetCfgId} <- get_pet_illusion_list()]).
calc_prop(PetCfgIdList) ->%%刷新英雄幻化属性（对应英雄的）
	#illusion_collect{lv = Lv} = get_illusion_collect(),
	Increase = case cfg_collectionroom:getRow(Lv) of%%资质万分比加成
				   {} ->
					   ?LOG_ERROR("~n cfg_collectionroom no cfg,key~p", [Lv]),
					   0;
				   #collectionroomCfg{attrIncrease = Inc} ->
					   Inc
			   end,
	{OldQualityList, _} = lists:partition(fun({PetCfgId, _, _}) ->
		not lists:member(PetCfgId, PetCfgIdList) end, get_prop_list()),
	{OldSkillList, _} = lists:partition(fun({PetCfgId, _}) ->%%重新计算对应英雄幻化的技能
		not lists:member(PetCfgId, PetCfgIdList) end, get_skill_list()),
	NowTime = time:time(),
	Fun = fun
			  (#pet_illusion{type = 0}, Acc) -> %%未激活
				  Acc;
			  (#pet_illusion{type = 1, expire_time = EndTime}, Acc) when NowTime >= EndTime -> %%激活但过期，这里不管过期邮件也不计算过期的幻化属性
				  Acc;
			  (#pet_illusion{cfg_id = CfgId, pet_cfg_id = PetCfgId, refine_lv = RefineLv}, {PetPropAcc, SkillAcc} = Acc) ->
				  case cfg_petSkinBase:getRow(CfgId) of
					  {} ->
						  ?LOG_ERROR("~n cfg_petSkinBase no cfg,key:~p", [CfgId]),
						  Acc;
					  #petSkinBaseCfg{skinAttrBase = SkinAttrBase} ->
						  case cfg_petSkinLevel:getRow(CfgId, RefineLv) of
							  {} ->
								  ?LOG_ERROR("~n cfg_petSkinLevel no cfg,key:~p", [{CfgId, RefineLv}]),
								  Acc;
							  #petSkinLevelCfg{qualiIncrease = QuIncrease, skill = Skill} ->
								  QualityList = [{Key, round((Value * (QuIncrease + 10000) / 10000) * (Increase + 10000) / 10000)} || {Key, Value} <- SkinAttrBase],
								  ActiveSkill = check_skill_active(Skill, RefineLv),
								  NewPetPropAcc = case lists:keytake(PetCfgId, 1, PetPropAcc) of%%同英雄cfgid的资质加成合并
													  ?FALSE -> [{PetCfgId, CfgId, QualityList} | PetPropAcc];
													  {_, {_, _, QualityList2}, PetPropAcc2} ->
														  [{PetCfgId, CfgId, common:listValueMerge(QualityList2 ++ QualityList)} | PetPropAcc2]
												  end,
								  {NewPetPropAcc, [{PetCfgId, ActiveSkill} | SkillAcc]}
						  end
				  end
		  end,
	{AddQualityList, AddSkillList} = lists:foldl(Fun, {[], []}, [Info || #pet_illusion{pet_cfg_id = PetCfgId} = Info <- get_pet_illusion_list(), lists:member(PetCfgId, PetCfgIdList)]),
	set_prop_list(OldQualityList ++ AddQualityList),
	set_skill_list(OldSkillList ++ AddSkillList),
	case PetCfgIdList of
		[] ->%%仅刷新技能和英雄属性数据，不进行其他计算，保证获得该英雄时数据正常
			ok;
		_ ->%%刷新对应CfgId配置的英雄+其链接的一个或两个英雄
			FlushPetCfgIdList = lists:foldl(fun(#pet_illusion{pet_cfg_list = List}, Acc) ->%%获取需要刷新的英雄cfgid列表
				case [1 || Id <- List, lists:member(Id, PetCfgIdList)] of
					[] -> Acc;
					_ -> List ++ Acc
				end end, [], get_pet_illusion_list()),
			pet_battle:calc_player_add_fight(),
			pet_base:save_pet_sys_attr(?FALSE),
			pet_base:refresh_pet_and_skill(get_uid_list(FlushPetCfgIdList)),%%这里刷新包括上阵助战的链接的,还有所有没上阵的对应类型英雄以及链接的
			attribute_player:on_prop_change()
	end.

%%清除对应幻化的数据
gm_clean(IllusionId) ->
	case get_pet_illusion(IllusionId) of
		{} ->
			ok;
		#pet_illusion{pet_cfg_list = PetCfgList} = Info ->
			update_illusion(Info#pet_illusion{type = 0, expire_time = 0, refine_lv = 0, equip_type = 0}),
			calc_prop(PetCfgList),
			on_illusion_info()
	end.

%%清空所有幻化的数据,IsCollect
gm_clean_all() ->
	NewInfoList = [Info#pet_illusion{type = 0, expire_time = 0, refine_lv = 0, equip_type = 0} || Info <- get_pet_illusion_list()],
	update_illusion(NewInfoList),
	calc_prop(),
	on_illusion_info().

%%清空收藏室数据
gm_clean_collect() ->
	set_illusion_collect([]),
	table_player:delete(db_illusion_collect, player:getPlayerID()),
	calc_prop(),
	on_illusion_info().

list_2_illusion(List) ->
	Record = list_to_tuple([pet_illusion | List]),
	Record#pet_illusion{
		pet_cfg_list = gamedbProc:dbstring_to_term(Record#pet_illusion.pet_cfg_list)
	}.
illusion_2_list(Record) ->
	tl(tuple_to_list(Record#pet_illusion{
		pet_cfg_list = gamedbProc:term_to_dbstring(Record#pet_illusion.pet_cfg_list)
	})).

is_active(CfgId) ->
	case lists:keyfind(CfgId, #pet_illusion.cfg_id, get_pet_illusion_list()) of
		#pet_illusion{type = 2} -> ?TRUE;
		_ -> ?FALSE
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================
%%玩家幻化数据
set_pet_illusion_list(L) -> put({?MODULE, pet_illusion_list}, L).
get_pet_illusion_list() ->
	case get({?MODULE, pet_illusion_list}) of
		?UNDEFINED -> [];
		L -> L
	end.

%%读取英雄幻化数据，返回处理后的英雄幻化
get_table_pet_illusion_list(PlayerId) ->
	NowTime = time:time(),
	lists:foldl(fun
					(#pet_illusion{cfg_id = CfgId, type = 1, expire_time = EndTime} = Info, Acc) when NowTime >= EndTime ->%%临时激活过期
						[Info#pet_illusion{type = 0, equip_type = 0, expire_time = 0, pet_cfg_list = get_pet_cfg_list(CfgId)} | Acc];
					(#pet_illusion{cfg_id = CfgId} = Info, Acc) ->
						[Info#pet_illusion{pet_cfg_list = get_pet_cfg_list(CfgId)} | Acc]
				end, [], table_player:lookup(?Table_Illusion, PlayerId)).


%%获取对应cfgid的英雄幻化数据
get_pet_illusion(CfgId) ->
	case lists:keyfind(CfgId, #pet_illusion.cfg_id, get_pet_illusion_list()) of
		?FALSE -> {};
		Info -> Info
	end.

%%收藏室数据
set_illusion_collect(Info) -> put({?MODULE, illusion_collect}, Info).
get_illusion_collect() ->
	case get({?MODULE, illusion_collect}) of
		?UNDEFINED -> #illusion_collect{player_id = player:getPlayerID()};
		[] -> #illusion_collect{player_id = player:getPlayerID()};
		[Info | _] -> Info
	end.

%%保存英雄幻化属性{ [{PetCfgId,CfgId,{资质列表,属性列表}}]  , CollectProp}
%%未穿戴的，技能列表为空  （注意链接英雄）
set_prop_list(Prop) -> put({?MODULE, prop}, Prop).
get_prop_list() ->
	case get({?MODULE, prop}) of
		?UNDEFINED -> [];
		L -> L
	end.

%%获取对应英雄的属性
get_pet_cfg_prop(IllusionList, PetCfgId, PropList) ->
	PetCfgIdList = lists:foldl(fun(#pet_illusion{pet_cfg_id = CfgId, pet_cfg_list = List}, Acc) ->%%获取需要刷新的英雄cfgid列表
		case lists:member(PetCfgId, List) of
			?TRUE -> [CfgId | Acc];
			_ -> Acc
		end end, [], IllusionList),
	lists:foldl(fun(PetCfgId2, Acc) ->
		case lists:keyfind(PetCfgId2, 1, PropList) of
			?FALSE -> Acc;
			{_, _, Qu} -> common:listValueMerge(Qu ++ Acc)
		end end, [], PetCfgIdList).

%%保存英雄幻化的技能[{PetCfgId,{替换技能，额外技能}}] (注意链接英雄)--
set_skill_list(SkillList) -> put({?MODULE, skill}, SkillList).
get_skill_list() ->%%这里容纳晋升后的cfgid
	case get({?MODULE, skill}) of
		?UNDEFINED -> [];
		L -> L
	end.

%%获取对应pet_cfg列表的uid
get_uid_list(PetCfgList) ->%%这里容纳晋升后的cfgid
	[PetUid || #pet_new{pet_cfg_id = PetCfgId, uid = PetUid} <- pet_new:get_pet_list(), lists:member(PetCfgId, PetCfgList)].

%%获取当前幻化id的
get_pet_cfg_list(CfgId) ->
	case cfg_petSkinBase:getRow(CfgId) of
		#petSkinBaseCfg{hero = PetCfgId, rareUpHero = HeroCfgIdList} ->
			[PetCfgId | HeroCfgIdList];
		_ -> []
	end.


%%更新英雄幻化数据
update_illusion(#pet_illusion{} = Info) ->
	update_illusion([Info]);
update_illusion(L) ->
	update_illusion(L, ?TRUE).
update_illusion(#pet_illusion{} = Info, IsSy) ->
	update_illusion([Info], IsSy);
update_illusion(InfoList, IsSy) ->
	F = fun(#pet_illusion{cfg_id = CfgId} = Info, {Ret1, Ret2}) ->
		{lists:keystore(CfgId, #pet_illusion.cfg_id, Ret1, Info), [make_pet_illusion(Info) | Ret2]}
		end,
	{NewOrnList, UpdatePosMsg} = lists:foldl(F, {get_pet_illusion_list(), []}, InfoList),
	table_player:insert(?Table_Illusion, InfoList),
	set_pet_illusion_list(NewOrnList),
	IsSy andalso player:send(#pk_GS2U_pet_illusion_updata_ret{list = UpdatePosMsg}).

%%更新收藏数据
update_illusion_collect(#illusion_collect{} = Info) ->
	table_player:insert(?Table_Illusion_collect, [Info]),
	set_illusion_collect([Info]).

%%穿戴英雄幻化 {Err,[UnLoad,Equip]}
equip_on(#pet_illusion{cfg_id = CfgId, pet_cfg_id = PetCfgId} = NewInfo) ->%%这里容纳晋升后的cfgid
	case get_illusion(PetCfgId) of%%该英雄是否已穿戴
		{} ->%%该英雄未穿戴其他幻化
			{?ERROR_OK, {[NewInfo#pet_illusion{equip_type = 1}], []}};
		#pet_illusion{cfg_id = CfgId} ->%%该幻化已穿戴
			{?ERROR_PetIllusion_Equip, {[NewInfo], []}};
		OldInfo -> %%英雄已穿戴其他幻化
			{?ERROR_OK, {[OldInfo#pet_illusion{equip_type = 0}], [NewInfo#pet_illusion{equip_type = 1}]}}
	end.

%%激活英雄幻化
active_illusion({ItemCfgId, Num}, IllusionId2) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		ItemCfg = df:getItemDefineCfg(ItemCfgId),
		?CHECK_CFG(ItemCfg),
		#itemCfg{useParam1 = IllusionId, useParam2 = LimitTime} = ItemCfg,
		?CHECK_THROW(IllusionId =:= IllusionId2, ?ERROR_Param),
		BaseCfg = cfg_petSkinBase:getRow(IllusionId),
		?CHECK_CFG(BaseCfg),
		#petSkinBaseCfg{hero = PetCfgId, temporary = Temporary, permanent = Permanent, rareUpHero = PetCfgIdList} = BaseCfg,
		ActiveType = ?IF(LimitTime =:= 0, 2, 1),%%激活类型 1临时  2永久
		case lists:member({ItemCfgId, Num}, Temporary) of
			?TRUE when ActiveType =:= 1 -> ok;%%道具为临时，且数据正常
			?TRUE -> throw(?ERROR_Cfg);
			?FALSE when Permanent =:= {ItemCfgId, Num} andalso ActiveType =:= 2 -> ok;%%道具为永久激活，且数据正常
			?FALSE -> throw(?ERROR_Cfg)
		end,
		NowTime = time:time(),
		{NewInfo1, SeedActiveType} = case get_pet_illusion(IllusionId) of%%详细激活类型 1临时激活  2永久 3临时激活续时
										 {} ->%%未激活
											 case ActiveType of
												 1 ->%%限时激活
													 {#pet_illusion{player_id = player:getPlayerID(), cfg_id = IllusionId, pet_cfg_id = PetCfgId, type = ActiveType, refine_lv = 1,
														 expire_time = NowTime + LimitTime}, 1};
												 2 ->%%永久激活
													 {#pet_illusion{player_id = player:getPlayerID(), cfg_id = IllusionId, pet_cfg_id = PetCfgId, type = ActiveType, refine_lv = 1}, 2}
											 end;
										 #pet_illusion{type = 0} = OldInfo ->%%限时激活后又过期
											 case ActiveType of
												 1 ->%%限时激活
													 {OldInfo#pet_illusion{type = ActiveType, expire_time = NowTime + LimitTime, refine_lv = 1}, 1};
												 2 ->%%永久激活
													 {OldInfo#pet_illusion{type = ActiveType, expire_time = 0, refine_lv = 1}, 2}
											 end;
										 #pet_illusion{type = 1, expire_time = EndTime} = OldInfo2 ->%已限时激活
											 case ActiveType of
												 1 ->%%限时激活-叠加时间
													 {OldInfo2#pet_illusion{expire_time = EndTime + LimitTime}, 3};
												 2 ->%%限时激活后永久激活，需要弹
													 {OldInfo2#pet_illusion{type = ActiveType, expire_time = 0}, 2}
											 end;
										 #pet_illusion{type = 2} ->%%已永久激活
											 throw(?ERROR_PetIllusion_AlwaysEquip)
									 end,
		NewInfo = NewInfo1#pet_illusion{pet_cfg_list = [PetCfgId | PetCfgIdList]},
		{Err, Prepared} = player:delete_cost_prepare([{ItemCfgId, Num}], []),
		?ERROR_CHECK_THROW(Err),
		player:delete_cost_finish(Prepared, ?Reason_Pet_Illusion_Activity),
		{_, {UnList, EqList}} = equip_on(NewInfo),%%穿戴该英雄幻化
		update_illusion(UnList ++ EqList),
		calc_prop([PetCfgId | PetCfgIdList]),
		player_refresh:on_refresh_pet(),
		log_pet_illusion(SeedActiveType, IllusionId, {ItemCfgId, Num, LimitTime}),
		log_pet_illusion(6, IllusionId, {UnList, EqList}),
		attainment:check_attainment(?Attainments_Type_PetIllusionRefineNum),
		time_limit_gift:check_open(?TimeLimitType_PetIllusion),
		active_notice(IllusionId),
		player:send(#pk_GS2U_pet_illusion_activeRet{illusion_id = IllusionId, cost = #pk_key_value{key = ItemCfgId, value = Num}, type = SeedActiveType})
	catch
		Error ->
			player:send(#pk_GS2U_pet_illusion_activeRet{illusion_id = IllusionId2, cost = #pk_key_value{key = ItemCfgId, value = Num}, err_code = Error})
	end.

%%幻化穿戴
illusion_equip(IllusionId, 1) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		BaseCfg = cfg_petSkinBase:getRow(IllusionId),
		?CHECK_CFG(BaseCfg),
		NewInfo = get_pet_illusion(IllusionId),
		?CHECK_THROW(NewInfo =/= {} orelse NewInfo#pet_illusion.type =/= 0, ?ERROR_PetIllusion_NoActive),%%未激活或激活已过期
		#pet_illusion{pet_cfg_list = PetCfgList, equip_type = EquipType} = NewInfo,
		?CHECK_THROW(EquipType =:= 0, ?ERROR_PetIllusion_Equip),%%已穿戴
		{Err, {UnList, EqList}} = equip_on(NewInfo),%%穿戴该英雄幻化
		?ERROR_CHECK_THROW(Err),
		update_illusion(UnList ++ EqList),
		calc_prop(PetCfgList),
		log_pet_illusion(6, IllusionId, {UnList, EqList}),
		player:send(#pk_GS2U_pet_illusionEquipRet{illusion_id = IllusionId, op = 1})
	catch
		Error ->
			player:send(#pk_GS2U_pet_illusionEquipRet{illusion_id = IllusionId, op = 1, err_code = Error})
	end;
illusion_equip(IllusionId, 2) ->%%幻化脱下%
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		BaseCfg = cfg_petSkinBase:getRow(IllusionId),
		?CHECK_CFG(BaseCfg),
		NewInfo = get_pet_illusion(IllusionId),
		?CHECK_THROW(NewInfo =/= {} orelse NewInfo#pet_illusion.type =/= 0, ?ERROR_PetIllusion_NoActive),%%未激活或激活已过期
		#pet_illusion{pet_cfg_list = PetCfgList, equip_type = EquipType} = NewInfo,
		?CHECK_THROW(EquipType =:= 1, ?ERROR_PetIllusion_NoEquip),%%已穿戴
		update_illusion(NewInfo#pet_illusion{equip_type = 0}),
		calc_prop(PetCfgList),
		log_pet_illusion(7, IllusionId, {[NewInfo#pet_illusion{equip_type = 0}], []}),
		player:send(#pk_GS2U_pet_illusionEquipRet{illusion_id = IllusionId, op = 2})
	catch
		Error ->
			player:send(#pk_GS2U_pet_illusionEquipRet{illusion_id = IllusionId, op = 2, err_code = Error})
	end;
illusion_equip(IllusionId, _) ->
	player:send(#pk_GS2U_pet_illusionEquipRet{illusion_id = IllusionId, err_code = ?ERROR_Param}).

%%幻化精炼
illusion_refine(CfgId) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		BaseCfg = cfg_petSkinBase:getRow(CfgId),
		?CHECK_CFG(BaseCfg),
		Info = get_pet_illusion(CfgId),
		?CHECK_THROW(Info =/= {}, ?ERROR_PetIllusion_NoActive),%%未激活
		#pet_illusion{cfg_id = IllusionId, pet_cfg_list = PetCfgList, type = Type, refine_lv = OldLv} = Info,
		?CHECK_THROW(Type =:= 2, ?ERROR_PetIllusion_NoAlwaysActive),%%未永久激活
		LevelCfg = cfg_petSkinLevel:getRow(CfgId, OldLv),
		?CHECK_CFG(LevelCfg),
		#petSkinLevelCfg{levelMax = MaxLv} = LevelCfg,
		?CHECK_THROW(MaxLv > OldLv, ?ERROR_PetIllusion_MaxLv),%%已精炼到满级，不可继续精炼
		NewLv = OldLv + 1,
		MaxlCfg = cfg_petSkinLevel:getRow(CfgId, NewLv),
		?CHECK_CFG(MaxlCfg),
		#petSkinLevelCfg{needItem = NeedItem, petSkinNotice = IsNotice} = MaxlCfg,
		{Err, Prepared} = player:delete_cost_prepare(NeedItem, []),
		?ERROR_CHECK_THROW(Err),
		player:delete_cost_finish(Prepared, ?Reason_Pet_Illusion_Refine),
		update_illusion(Info#pet_illusion{refine_lv = NewLv}),
		calc_prop(PetCfgList),
		case IsNotice of%%是否需要公告
			0 -> ok;
			1 ->
				case df:getItemDefineCfg(IllusionId) of
					{} ->
						ok;
					#itemCfg{name = Name, character = Char} ->
						PlayerText = player:getPlayerText(),
						marquee:sendChannelNotice(0, 0, d3_Hero_pifu_text2,
							fun(Language) ->
								language:format(language:get_server_string("D3_Hero_pifu_text2", Language),
									[PlayerText, richText:getColorText(language:get_surface_string(Name, Language), Char), NewLv])
							end)
				end
		end,
		log_pet_illusion(5, CfgId, {NewLv, NeedItem}),
		attainment:check_attainment(?Attainments_Type_PetIllusionRefineNum),
		player:send(#pk_GS2U_pet_illusionRefineRet{illusion_id = CfgId})
	catch
		Error ->
			player:send(#pk_GS2U_pet_illusionRefineRet{illusion_id = CfgId, err_code = Error})
	end.

%%收藏
collect_item(CostList) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(CostList =/= [], ?ERROR_Param),
		%%计算是否存在精炼满了的英雄幻化
		?CHECK_THROW(check_refine_lv_max(), ?ERROR_PetIllusion_ReFineLvNoMax),
		#illusion_collect{lv = OldLv, exp = OldExp} = OldCollect = get_illusion_collect(),
		MaxLv = lists:max(cfg_collectionroom:getKeyList()),
		?CHECK_THROW(OldLv < MaxLv, ?ERROR_PetIllusion_CollectLvMax),
		{Err, Prepared} = player:delete_cost_prepare(CostList, []),
		?ERROR_CHECK_THROW(Err),
		{NewLv, NewExp} = calc_collect_exp(OldLv, OldExp, CostList),%%返还新的等级和新的经验
		player:delete_cost_finish(Prepared, ?Reason_Pet_Illusion_Collect),
		update_illusion_collect(OldCollect#illusion_collect{lv = NewLv, exp = NewExp}),
		calc_prop(),
		log_pet_illusion(8, 0, {{OldLv, OldExp}, {NewLv, NewExp}, CostList}),
		player:send(#pk_GS2U_pet_illusionCollectAddLvRet{lv = NewLv, exp = NewExp})
	catch
		Error ->
			player:send(#pk_GS2U_pet_illusionCollectAddLvRet{err_code = Error})
	end.


%%检查过期(过期后排行榜等相关需要修改)
check_time(NowTime) ->
	Fun = fun
			  (#pet_illusion{type = 1, cfg_id = CfgId, expire_time = EndTime, pet_cfg_id = PetCfgId, pet_cfg_list = PetCfgList} = Info) when NowTime >= EndTime ->%%临时激活需要检查
				  update_illusion(Info#pet_illusion{type = 0, equip_type = 0, expire_time = 0}),%%卸下英雄幻化
				  calc_prop(PetCfgList),
				  seed_timeout_mail(CfgId),
				  log_pet_illusion(4, CfgId, {PetCfgId}, EndTime);
			  (#pet_illusion{type = _}) -> ok
		  end,
	lists:foreach(Fun, get_pet_illusion_list()).

%%收藏室-检查是否存在精炼满了的英雄幻化
check_refine_lv_max() ->
	lists:any(fun(#pet_illusion{cfg_id = CfgId, refine_lv = Lv}) ->
		case cfg_petSkinLevel:getRow(CfgId, Lv) of
			#petSkinLevelCfg{levelMax = MaxLv} when Lv >= MaxLv ->
				?TRUE;
			_ -> ?FALSE
		end end, get_pet_illusion_list()).

%%计算道具获得的收藏室经验，返回新的等级和经验
calc_collect_exp(OldLv, OldExp, ItemList) ->
	AllExp = lists:foldl(fun({ItemId, Num}, ExpAcc) ->
		case cfg_collectionExp:getRow(ItemId) of
			{} ->
				?LOG_ERROR("~n cfg_collectionExp no cfg,key:~p", [ItemId]),
				throw(?ERROR_Cfg);
			#collectionExpCfg{itemExp = Exp} -> ExpAcc + Exp * Num
		end end, OldExp, ItemList),
	calc_new_exp(OldLv, AllExp).

%%计算新的等级和经验
calc_new_exp(OldLv, AllExp) ->
	case cfg_collectionroom:getRow(OldLv) of
		#collectionroomCfg{star = 0} -> %%到达最高等级了
			{OldLv, 0};
		#collectionroomCfg{star = NeedExp} ->
			case AllExp >= NeedExp of
				?TRUE -> calc_new_exp(OldLv + 1, AllExp - NeedExp);
				?FALSE -> {OldLv, AllExp}
			end;
		_ -> {OldLv, 0}
	end.

%%过期发送英雄幻化过期邮件
seed_timeout_mail(CfgId) ->
	case df:getItemDefineCfg(CfgId) of
		{} -> ok;
		#itemCfg{name = Name} ->
			Language = player:get_language(),
			ItemName = language:get_surface_string(Name, Language),
			mail:send_mail(#mailInfo{
				player_id = player:getPlayerID(),
				title = language:format(language:get_server_string("D3_Hero_pifu_text3", Language), [ItemName]),
				describe = language:format(language:get_server_string("D3_Hero_pifu_text4", Language), [ItemName])})
	end.

%%英雄幻化激活公告
active_notice(IllusionId) ->
	PlayerText = player:getPlayerText(),
	case df:getItemDefineCfg(IllusionId) of
		{} ->
			ok;
		#itemCfg{name = Name, character = Char} ->
			marquee:sendChannelNotice(0, 0, d3_Hero_pifu_text1,
				fun(Language) ->
					language:format(language:get_server_string("D3_Hero_pifu_text1", Language),
						[PlayerText, richText:getColorText(language:get_surface_string(Name, Language), Char)])
				end)
	end.

%%检查技能是否已激活
check_skill_active(SkillList, Lv) ->%%需替换技能
	lists:foldl(fun
					({Type, Parm1, SkType, SkId, SkIndex, SkLv}, Acc) ->
						case Type of%%激活条件
							0 -> [{SkType, SkId, SkIndex, SkLv} | Acc];
							1 -> case Lv >= Parm1 of%%精炼等级
									 ?TRUE ->
										 case SkType of
											 1 -> [{1, SkId, SkIndex, SkLv} | Acc];
											 2 -> [{2, SkId, SkIndex} | Acc]
										 end;
									 ?FALSE -> Acc
								 end;%%需要精炼等级激活
							_ -> Acc
						end
				end, [], SkillList).

%%拼接同步协议
make_pet_illusion(#pet_illusion{} = Info) ->
	#pk_pet_illusion{
		cfg_id = Info#pet_illusion.cfg_id,
		pet_cfg_id = Info#pet_illusion.pet_cfg_id,
		refine_lv = Info#pet_illusion.refine_lv,
		type = Info#pet_illusion.type,
		show_type = common:int_to_bool(Info#pet_illusion.equip_type),
		expire_time = Info#pet_illusion.expire_time
	}.

%%日志 op = 1临时激活 2永久激活 3限时激活续时（包括限时激活后永久激活）
%% 4临时激活过期（时间用过期的时间） 5精炼 6穿戴英雄幻化 7卸下 8收藏
log_pet_illusion(Op, CfgId, PramList) ->
	log_pet_illusion(Op, CfgId, PramList, time:time()).
log_pet_illusion(Op, CfgId, PramList, Time) ->
	%%, gamedbProc:term_to_dbstring(ItemList), gamedbProc:term_to_dbstring(CoinList)
	L = [player:getPlayerID(), Op, CfgId, common:formatString(PramList), Time],
	table_log:insert_row(log_pet_illusion, L).