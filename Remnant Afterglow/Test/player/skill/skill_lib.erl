%%%-------------------------------------------------------------------
%%% @author xiehonggang
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%           技能修正
%%% @end
%%% Created : 24. 七月 2018 10:31
%%%-------------------------------------------------------------------
-module(skill_lib).
-author("xiehonggang").

-include("skill_new.hrl").
-include("cfg_skillBase.hrl").
-include("cfg_skillCorr.hrl").

-include("logger.hrl").
-include("global.hrl").
%% API
-export([
	make_map_skill_list/1
]).

make_map_skill_list(SkillList) ->
	[make_map_skill(ID, Level, FixList) || {ID, Level, FixList, _} <- SkillList].

make_map_skill(ID, Level, FixList) ->
%% TODO  在地图里面获取是否存在此技能 如果存在需要继承它的冷却时间 等私有参数
	S = #skill_map_info{
		skill_id = ID,
		level = Level,
		fix_list = FixList
	},
	skill_fix(S, FixList).

d(_, 0) -> 0;
d(A, B) -> A / B.
skill_fix(S, FixList) ->
	SkillID = S#skill_map_info.skill_id,
	Cfg = cfg_skillBase:getRow(SkillID),

	#skillBaseCfg{skillEffect = E, lvValue = V, lvMax = LvMax} = Cfg,
	%% (SkillEffect[SkillBase]参数2+LvValue[SkillBase]参数3*(技能等级-1)/(LvMax[SkillBase]-1){分母为0时,值为0})
	SkillFactor = element(2, E) + d(element(3, V) * (S#skill_map_info.level - 1), (LvMax - 1)),
	%% (SkillEffect[SkillBase]参数3+LvValue[SkillBase]参数4*(技能等级-1)/(LvMax[SkillBase]-1){分母为0时,值为0})
	SkillBaseValue = element(3, E) + d(element(4, V) * (S#skill_map_info.level - 1), (LvMax - 1)),
	%%
	SkillInfo = S#skill_map_info{
		%%必须初始化和修正后面的参数
		%%skillBase中可以被修正的参数
		trig_para = Cfg#skillBaseCfg.trigPara,
		para_corr = Cfg#skillBaseCfg.paraCorr,
		target = Cfg#skillBaseCfg.target,
		cd_para = Cfg#skillBaseCfg.cDPara,
		cost = Cfg#skillBaseCfg.cost,
		skill_factor = SkillFactor,
		skill_base_value = SkillBaseValue,
		activate_effect = Cfg#skillBaseCfg.activateEffect,
		attr_para = Cfg#skillBaseCfg.attrPara,
		other_effect = Cfg#skillBaseCfg.otherEffect,
		spec_effect = Cfg#skillBaseCfg.speEffect,
		oth_eff_limit = Cfg#skillBaseCfg.othEffLimit,
		displacement = Cfg#skillBaseCfg.displacement,
		spec_eff_limit = Cfg#skillBaseCfg.speEffLimit
	},
	{F1, F2, F3, F4} = filter_fix(FixList),

	SkillInfo_1 = skill_fix_1(SkillInfo, F1),
	SkillInfo_2 = skill_fix_2(SkillInfo_1, F2),
	SkillInfo_3 = skill_fix_4(SkillInfo_2, F4),
	SkillInfo_4 = skill_fix_3(SkillInfo_3, F3),
%%	?LOG_ERROR("Fix Skill Info :~p", [SkillInfo_4]),
%%	NewMap = case SkillInfo_4#skill_map_info.cd_para of
%%					  {_CdGroup, CD, InitCd, _N, _Interval} when InitCd > 0 ->
%%						  maps:put(SkillID, {time:time_ms() - CD + InitCd, 0}, Map);
%%					  _ -> Map
%%				  end,
	SkillInfo_4.


%% 修正方式  1- 替换  2-添加  3-修改1 值修改  4-修改2 百分比修改
filter_fix(FixList) ->
	F = fun(FixId, {R1, R2, R3, R4}) ->
		case cfg_skillCorr:getRow(FixId) of
			#skillCorrCfg{corrWay = CorrType, priority = Priority} ->
				N = {Priority, FixId},
				case CorrType of
					1 -> {[N | R1], R2, R3, R4};
					2 -> {R1, [N | R2], R3, R4};
					3 -> {R1, R2, [N | R3], R4};
					4 -> {R1, R2, R3, [N | R4]};
					_ -> ?LOG_ERROR("Err Fix Type :~p", [FixId]), {R1, R2, R3, R4}
				end;
			_ ->
				?LOG_ERROR("no skillcorr cfg ~p", [FixId]),
				{R1, R2, R3, R4}
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
skill_fix_1(SkillInfo, {}) -> SkillInfo;
skill_fix_1(SkillInfo, {_, FixId}) ->
	#skillCorrCfg{
		trigPara = TrigPara,
		paraCorr = ParaCorr,
		target = Target,
		cDPara = CdPara,
		cost = Cost,
		skillEffect = SkillEffect,
		attrPara = AttrPara,
		speEffect = SpeEffect,
		otherEffect = OtherEffect,
		othEffLimit = OthEffLimit,
		activateEffect = ActivateEffect,
		displacement = Displacement,
		speEffLimit = SpeEffLimit
	} = cfg_skillCorr:getRow(FixId),
	SkillInfo#skill_map_info{
		trig_para = common:getTernaryValue(TrigPara =:= [], SkillInfo#skill_map_info.trig_para, TrigPara),
		para_corr = common:getTernaryValue(ParaCorr =:= [], SkillInfo#skill_map_info.para_corr, ParaCorr),
		target = common:getTernaryValue(Target =:= [], SkillInfo#skill_map_info.target, Target),
		cd_para = common:getTernaryValue(CdPara =:= {0, 0, 0, 0, 0}, SkillInfo#skill_map_info.cd_para, CdPara),
		cost = common:getTernaryValue(Cost =:= [], SkillInfo#skill_map_info.cost, Cost),
%%		skill_effect = common:getTernaryValue(SkillEffect =:= {0, 0, 0}, SkillInfo#skill_map_info.skill_effect, SkillEffect),
		skill_factor = common:getTernaryValue(SkillEffect =:= {0, 0, 0}, SkillInfo#skill_map_info.skill_factor, element(2, SkillEffect)),
		skill_base_value = common:getTernaryValue(SkillEffect =:= {0, 0, 0}, SkillInfo#skill_map_info.skill_base_value, element(3, SkillEffect)),
		spec_effect = common:getTernaryValue(SpeEffect =:= [], SkillInfo#skill_map_info.spec_effect, SpeEffect),
		attr_para = common:getTernaryValue(AttrPara =:= [], SkillInfo#skill_map_info.attr_para, AttrPara),
		other_effect = common:getTernaryValue(OtherEffect =:= {0, 0, 0, 0}, SkillInfo#skill_map_info.other_effect, OtherEffect),
		oth_eff_limit = common:getTernaryValue(OthEffLimit =:= {0, 0, 0}, SkillInfo#skill_map_info.oth_eff_limit, OthEffLimit),
		activate_effect = common:getTernaryValue(ActivateEffect =:= [], SkillInfo#skill_map_info.activate_effect, ActivateEffect),
		displacement = common:getTernaryValue(Displacement =:= {0, 0}, SkillInfo#skill_map_info.displacement, Displacement),
		spec_eff_limit = common:getTernaryValue(SpeEffLimit =:= {0, 0, 0}, SkillInfo#skill_map_info.spec_eff_limit, SpeEffLimit)
	}.

%% 增加
skill_fix_2(SkillInfo, []) -> SkillInfo;
skill_fix_2(SkillInfo, [{_, FixId} | T]) ->
	#skillCorrCfg{
		trigPara = TrigPara,
		paraCorr = ParaCorr,
		target = Target,
		speEffect = SpecEffect,
		attrPara = AttrPara,
		activateEffect = ActivateEffect
	} = cfg_skillCorr:getRow(FixId),

	New = SkillInfo#skill_map_info{
		trig_para = SkillInfo#skill_map_info.trig_para ++ TrigPara,
		para_corr = SkillInfo#skill_map_info.para_corr ++ ParaCorr,
		target = SkillInfo#skill_map_info.target ++ Target,
		spec_effect = SkillInfo#skill_map_info.spec_effect ++ SpecEffect,
		attr_para = SkillInfo#skill_map_info.attr_para ++ AttrPara,
		activate_effect = SkillInfo#skill_map_info.activate_effect ++ ActivateEffect
	},
	skill_fix_2(New, T).

%% 修改1 直接加
skill_fix_3(SkillInfo, []) -> SkillInfo;
skill_fix_3(SkillInfo, [{_, FixId} | T]) ->
	#skillCorrCfg{
		trigPara = TrigPara,
		paraCorr = ParaCorr,
		target = Target,
		cDPara = CdPara,
		cost = CostPara,
		skillEffect = SkillEffect,
		attrPara = AttrPara,
		otherEffect = OtherEffect,
		speEffect = SpeEffect,
		othEffLimit = OthEffLimit,
		activateEffect = ActivateEffect,
		displacement = Displacement,
		speEffLimit = SpeEffLimit
	} = cfg_skillCorr:getRow(FixId),
	FixInfo = {TrigPara, ParaCorr, Target, CdPara, CostPara, SkillEffect, AttrPara, OtherEffect, SpeEffect, OthEffLimit, ActivateEffect, Displacement, SpeEffLimit},
	New = skill_fix_3_or_4(SkillInfo, FixInfo, fun f3/2),
	skill_fix_3(New, T).

skill_fix_4(SkillInfo, []) -> SkillInfo;
skill_fix_4(SkillInfo, FixList) ->
	FixInfo = merge_fix_list(FixList, []),
	skill_fix_3_or_4(SkillInfo, FixInfo, fun f4/2).

f3(A, B) -> A + B.
f4(A, B) -> trunc(A * (10000 + B) / 10000).

skill_fix_3_or_4(SkillInfo, FixInfo, Func) ->
	{TrigPara, ParaCorr, Target, CdPara, CostPara, SkillEffect, AttrPara,
		OtherEffect, SpeEffect, OthEffLimit, ActivateEffect, Displacement, SpeEffLimit} = FixInfo,

	#skill_map_info{
		trig_para = OldTrigPara,
		para_corr = OldParaCorr,
		target = OldTarget,
		cd_para = OldCdPara,
		cost = OldCostPara,
		skill_factor = OldSkillFactor,
		skill_base_value = OldSkillBaseValue,
		attr_para = OldAttrPara,
		other_effect = OldOtherEffect,
		spec_effect = OldSpecEffect,
		oth_eff_limit = OldOthEffLimit,
		activate_effect = OldActivateEffect,
		displacement = OldDisplacement,
		spec_eff_limit = OldSpecEffectLimit
	} = SkillInfo,


	TrigParaFun = fun({Index, Add}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
%%				?LOG_ERROR("Fix Index > TrigPara Length :~p", [{Ret, Index, SkillInfo, FixInfo}]),
				Ret;
			_ ->
				{P1, P2} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {P1, Func(P2, Add)})
		end end,
	NewTrigPara = lists:foldl(TrigParaFun, OldTrigPara, TrigPara),

	ParaCorrFun = fun({Index, A2, A3, A4, _A5, A6, A7}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
%%				?LOG_ERROR("Fix Index > ParaCorrFun Length :~p", [{Ret, Index, SkillInfo, FixInfo}]),
				Ret;
			_ ->
				{P1, P2, P3, P4, P5, P6, P7} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {P1, Func(P2, A2), Func(P3, A3), Func(P4, A4), P5, Func(P6, A6), Func(P7, A7)})
		end end,
	NewParaCorr = lists:foldl(ParaCorrFun, OldParaCorr, ParaCorr),

	TargetFun = fun({Index, _, _, Add}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
%%				?LOG_ERROR("Fix Index > TargetFun Length :~p", [{Ret, Index, SkillInfo, FixInfo}]),
				Ret;
			_ ->
				{P1, P2, P3, P4} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {P1, P2, P3, Func(P4, Add)})
		end end,
	NewTarget = lists:foldl(TargetFun, OldTarget, Target),

	{_, CdP2, CdP3, CdP4, _} = CdPara,
	{OldCdP1, OldCdP2, OldCdP3, OldCdP4, OldCdP5} = OldCdPara,
	NewCdPara = {OldCdP1, Func(OldCdP2, CdP2), Func(OldCdP3, CdP3), Func(OldCdP4, CdP4), OldCdP5},

	NewCostPara = lists:foldl(fun({Index, CostFixParam}, Ret) ->
		case lists:keytake(Index, 1, Ret) of
			?FALSE -> Ret;
			{_, {_, OldCost}, Left} ->
				[{Index, Func(OldCost, CostFixParam)} | Left]
		end
							  end, OldCostPara, CostPara),

	{_, SeP2, SeP3} = SkillEffect,
	NewSkillFactor = Func(OldSkillFactor, SeP2),
	NewSkillBaseValue = Func(OldSkillBaseValue, SeP3),

	AttrParaFun = fun({Index, _, Add, Multi}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
%%				?LOG_ERROR("Fix Index > AttrParaFun Length :~p", [{Ret, Index, SkillInfo, FixInfo}]),
				Ret;
			_ ->
				{P1, P2, P3, P4} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {P1, P2, Func(P3, Add), Func(P4, Multi)})
		end end,
	NewAttrPara = lists:foldl(AttrParaFun, OldAttrPara, AttrPara),

	{_, _, OeP3, _} = OtherEffect,
	{OldOeP1, OldOeP2, OldOeP3, OldOeP4} = OldOtherEffect,
	NewOtherEffect = {OldOeP1, OldOeP2, Func(OldOeP3, OeP3), OldOeP4},

	SpecEffectFun = fun({_, Index, SpecP3, SpecP4}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
				Ret;
			_ ->
				{OldSpcP1, OldSpcP2, OldSpcP3, OldSpcP4} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {OldSpcP1, OldSpcP2, Func(OldSpcP3, SpecP3), Func(OldSpcP4, SpecP4)})
		end
					end,

	NewSpecEffect = lists:foldl(SpecEffectFun, OldSpecEffect, SpeEffect),

	{_, _, OeLP3} = OthEffLimit,
	{OldOeLP1, OldOeLP2, OldOeLP3} = OldOthEffLimit,
	NewOthEffLimit = {OldOeLP1, OldOeLP2, Func(OldOeLP3, OeLP3)},

	ActivateEffectFun = fun({Index, Add, _, _, _}, Ret) ->
		case length(Ret) < Index of
			?TRUE ->
%%				?LOG_ERROR("Fix Index > AttrParaFun Length :~p", [{Ret, Index, SkillInfo, FixInfo}]),
				Ret;
			_ ->
				{P1, P2, P3, P4, P5} = lists:nth(Index, Ret),
				common:set_list_index(Index, Ret, {P1, Func(P2, Add), P3, P4, P5})
		end end,
	NewActivateEffect = lists:foldl(ActivateEffectFun, OldActivateEffect, ActivateEffect),

	{_, Dis2} = Displacement,
	{OldDis1, OldDis2} = OldDisplacement,
	NewDisplacement = {OldDis1, Func(OldDis2, Dis2)},

	{_, SeLP2, SeLP3} = SpeEffLimit,
	{OldSeLP1, OldSeLP2, OldSeLP3} = OldSpecEffectLimit,
	NewSpecEffectLimit = {OldSeLP1, Func(OldSeLP2, SeLP2), Func(OldSeLP3, SeLP3)},

	SkillInfo#skill_map_info{
		trig_para = NewTrigPara,
		para_corr = NewParaCorr,
		target = NewTarget,
		cd_para = NewCdPara,
		cost = NewCostPara,
		skill_factor = NewSkillFactor,
		skill_base_value = NewSkillBaseValue,
		attr_para = NewAttrPara,
		other_effect = NewOtherEffect,
		spec_effect = NewSpecEffect,
		oth_eff_limit = NewOthEffLimit,
		activate_effect = NewActivateEffect,
		displacement = NewDisplacement,
		spec_eff_limit = NewSpecEffectLimit
	}.



merge_fix_list([], Ret) -> Ret;
merge_fix_list([{_, FixId} | T], Ret) ->
	{Ret_TrigPara, Ret_ParaCorr, Ret_Target, Ret_CdPara, Ret_CostPara, Ret_SkillEffect, Ret_AttrPara,
		Ret_OtherEffect, Ret_SpeEffect, Ret_OthEffLimit, Ret_ActivateEffect, Ret_Displacement, Ret_SpeEffectLimit} =
		case Ret of
			[] -> {[], [], [], {0, 0, 0, 0, 0}, [], {0, 0, 0}, [], {0, 0, 0, 0}, [], {0, 0, 0}, [], {0, 0}, {0, 0, 0}};
			_ -> Ret
		end,
	#skillCorrCfg{
		trigPara = TrigPara,
		paraCorr = ParaCorr,
		target = Target,
		cDPara = CdPara,
		cost = CostPara,
		skillEffect = SkillEffect,
		attrPara = AttrPara,
		otherEffect = OtherEffect,
		othEffLimit = OthEffLimit,
		activateEffect = ActivateEffect,
		displacement = Displacement,
		speEffLimit = SpeEffLimit
	} = cfg_skillCorr:getRow(FixId),

	NewTrigPara = Ret_TrigPara ++ TrigPara,
	NewParaCorr = Ret_ParaCorr ++ ParaCorr,
	NewTarget = Ret_Target ++ Target,
	NewCostPara = Ret_CostPara ++ CostPara,
	NewSpeEffect = Ret_SpeEffect,

	{_, CdP2, _, CdP4, _} = CdPara,
	{OldCdP1, OldCdP2, OldCdP3, OldCdP4, OldCdP5} = Ret_CdPara,
	NewCdPara = {OldCdP1, OldCdP2 + CdP2, OldCdP3, OldCdP4 + CdP4, OldCdP5},

	{_, SeP2, SeP3} = SkillEffect,
	{OldSeP1, OldSeP2, OldSeP3} = Ret_SkillEffect,
	NewSkillEffect = {OldSeP1, OldSeP2 + SeP2, OldSeP3 + SeP3},
	NewAttrPara = Ret_AttrPara ++ AttrPara,

	{_, _, OeP3, _} = OtherEffect,
	{OldOeP1, OldOeP2, OldOeP3, OldOeP4} = Ret_OtherEffect,
	NewOtherEffect = {OldOeP1, OldOeP2, OldOeP3 + OeP3, OldOeP4},

	{_, _, OeLP3} = OthEffLimit,
	{OldOeLP1, OldOeLP2, OldOeLP3} = Ret_OthEffLimit,
	NewOthEffLimit = {OldOeLP1, OldOeLP2, OldOeLP3 + OeLP3},

	NewActivateEffect = Ret_ActivateEffect ++ ActivateEffect,
	{_, Dis2} = Displacement,
	{OldDis1, OldDis2} = Ret_Displacement,
	NewDisplacement = {OldDis1, OldDis2 + Dis2},

	{_, SeLP2, SeLP3} = SpeEffLimit,
	{OldSeLP1, OldSeLP2, OldSeLP3} = Ret_SpeEffectLimit,
	NewSpeEffectLimit = {OldSeLP1, OldSeLP2 + SeLP2, OldSeLP3 + SeLP3},

	NewRet = {NewTrigPara,
		NewParaCorr,
		NewTarget,
		NewCdPara,
		NewCostPara,
		NewSkillEffect,
		NewAttrPara,
		NewOtherEffect,
		NewSpeEffect,
		NewOthEffLimit,
		NewActivateEffect,
		NewDisplacement,
		NewSpeEffectLimit
	},
	merge_fix_list(T, NewRet).
