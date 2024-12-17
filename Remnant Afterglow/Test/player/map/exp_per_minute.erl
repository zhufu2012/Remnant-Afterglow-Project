%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%  		 每X秒获得经验
%%% @end
%%% Created : 25. 九月 2018 14:36
%%%-------------------------------------------------------------------
-module(exp_per_minute).
-author("cbfan").

-include("logger.hrl").
-include("gameMap.hrl").
-include("record.hrl").
-include("attribute.hrl").
-include("global.hrl").
-include("reason.hrl").

-include("cfg_yanMoBase.hrl").
-include("cfg_expDistribution.hrl").
-include("cfg_realmsBattlefield.hrl").
-include("cfg_meleeBase.hrl").
-include("cfg_ashuraBase.hrl").
-include("netmsgRecords.hrl").
-include("worldBoss.hrl").
-include("cfg_guildFight.hrl").
-include("cfg_dcitywar.hrl").
-include("cfg_activePlay.hrl").
-include("cfg_starrySkyRuins.hrl").
-include("cfg_elementTrial.hrl").
-include("cfg_lingDiZhanBase.hrl").
-include("cfg_unionGuildFight2.hrl").
-include("cfg_coldForestMap.hrl").

%% API
-export([on_tick/2]).


%%  炎魔试炼
on_tick(?MapAI_YanMo, TimeStamp) ->
	case yanmo:get_wb_element(#yanmo_info.state) of
		State when State =:= ?YANMO_STATE_ACTIVE orelse State =:= ?YANMO_STATE_KILLED ->
			#yanMoBaseCfg{timeExp = TimeExp} = cfg_yanMoBase:first_row(),
			on_tick_1(TimeExp, TimeStamp);
		_ -> skip
	end;
%% 永恒战场 三界战场
on_tick(?MapAI_Battlefield, TimeStamp) ->
	BattlefieldInfo = battlefield:getBattlefieldInfo(),
	case BattlefieldInfo#battlefieldInfo.state =/= ?BattlefieldState_Idle of
		?TRUE ->
			case cfg_realmsBattlefield:getRow(mapSup:getMapDataID()) of
				#realmsBattlefieldCfg{timeExp = TimeExp} ->
					on_tick_1(TimeExp, TimeStamp);
				_ -> skip
			end;
		_ -> skip
	end;
%% 魔龙洞窟 麒麟洞
on_tick(?MapAI_Melee, TimeStamp) ->
	#meleeBaseCfg{timeExp = TimeExp} = cfg_meleeBase:first_row(),
	on_tick_1(TimeExp, TimeStamp);
%% 雷霆要塞
on_tick(?MapAI_ThunderFort, TimeStamp) ->
	TimeExp = thunder_fort_map:get_time_exp(),
	on_tick_1(TimeExp, TimeStamp);
on_tick(?MapAI_ThunderFortCluster, TimeStamp) ->
	TimeExp = thunder_fort_map:get_time_exp(),
	on_tick_1(TimeExp, TimeStamp);

%% 星空圣墟
on_tick(?MapAI_HolyRuins, TimeStamp) ->
	MapKey = holy_ruins_logic:get_map_key(mapSup:getMapDataID()),
	case cfg_starrySkyRuins:row(MapKey) of
		#starrySkyRuinsCfg{timeExp = TimeExp} ->
			on_tick_1(TimeExp, TimeStamp);
		_ -> ok
	end;
%% 领地战
on_tick(?MapAI_DomainFight, TimeStamp) ->
	case domain_fight_logic:is_in_active(TimeStamp) of
		?TRUE ->
			case cfg_lingDiZhanBase:first_row() of
				#lingDiZhanBaseCfg{timeExp = {Time, ExpParam}} ->
					on_tick_1({Time, ExpParam}, TimeStamp);
				_ -> skip
			end;
		_ -> ok
	end;
%% 元素试炼
on_tick(?MapAI_ElementTrial, TimeStamp) ->
	case cfg_elementTrial:getRow(mapSup:getMapDataID(), 1) of
		#elementTrialCfg{timeExp = TimeExp} ->
			on_tick_1(TimeExp, TimeStamp);
		_ -> ok
	end;
%% 联服公会战
on_tick(?MapAI_GuildWar, TimeStamp) ->
	case cfg_unionGuildFight2:getRow(mapSup:getMapDataID()) of
		#unionGuildFight2Cfg{timeExp = TimeExp} ->
			on_tick_1(TimeExp, TimeStamp);
		_ -> ok
	end;
%% 寒风森林
on_tick(?MapAI_BlzForest, TimeStamp) ->
	case cfg_coldForestMap:getRow(blizzard_forest_map:layer()) of
		#coldForestMapCfg{timeExp = {Time, ExpParam}} ->
			on_tick_1({Time, ExpParam / 100}, TimeStamp);
		_ -> skip
	end;
%% 龙城争霸
on_tick(?MapAI_ManorWar, TimeStamp) ->
	case manor_war_map:is_battle_open() of
		?TRUE ->
			case cfg_dcitywar:getRow(mapSup:getMapDataID()) of
				#dcitywarCfg{expCoef = ExpParam} ->
					Time = cfg_globalSetup:dCityScoreTime(),
					on_tick_1({Time, ExpParam / 100}, TimeStamp);
				_ -> ok
			end;
		?FALSE -> ok
	end;
on_tick(_, _) ->
	ok.

on_tick_1({Interval, Rate}, TimeStamp) ->
	case TimeStamp rem Interval =:= 0 of
		?FALSE -> skip;
		_ ->
			send_exp(Rate)
	end.

send_exp(Rate) ->
	lists:foreach(fun(MapPlayer) -> send_exp_1(MapPlayer, Rate) end, mapdb:getMapPlayerList()).


%% TODO 具体玩法经验加成 策划说先不做
send_exp_1(#mapPlayer{level = Level, id = PlayerId, pid = Pid}, Rate) ->
	{Exp, W} = attribute_economic:fix_exp_with_w(get_base_exp(Level) * Rate, PlayerId, 0),
	case map:getMapAI() of
		?MapAI_BlzForest -> Pid ! ?ModHandleMsg(blizzard_forest_player, {add_exp, Exp});
		_ -> skip
	end,
	map:sendMsgToPlayerProcess(PlayerId, {addPlayerExp, Exp, ?Reason_GG_KillExp, ?AddExpType_2, W div 100}).

get_base_exp(Lv) ->
	case cfg_expDistribution:getRow(Lv) of
		{} ->
			#expDistributionCfg{standardEXP = Exp} = cfg_expDistribution:last_row(),
			Exp;
		#expDistributionCfg{standardEXP = Exp} -> Exp
	end.
