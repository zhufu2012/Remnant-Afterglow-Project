%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 战盟许愿
%%% @end
%%% Created : 23. 十二月 2016 10:32
%%%-------------------------------------------------------------------
-module(guild_wish).
-author("Administrator").
-include("netmsgRecords.hrl").
-include("variable.hrl").
-include("record.hrl").
-include("guild.hrl").
-include("logDefine.hrl").
-include("error.hrl").
-include("chatDefine.hrl").
-include("logger.hrl").
-include("reason.hrl").
-include("cfg_guildMakeWish.hrl").
-include("cfg_cardBase.hrl").
-include("item.hrl").
-include("activity_new.hrl").
-include("cfg_guildMakeWishLImit.hrl").
-include("cfg_item.hrl").
-include("attainment.hrl").

%% API
-export([
	release_wish/4,
	on_release_wish/1,
	give_piece/5,
	on_give_piece/3,
	on_send_wish_msg/0,
	make_wish_info/1,
	make_give_piece_info/1,
	send_wish_msg/2,
	del_wish_info/2
	, on_get_give_record/0]).

%% ---------------------- 仙盟进程 ----------------------
%% 删除许愿信息
del_wish_info(GuildID, PlayerID) ->
	?metrics(begin
				 Guild = guild_pub:find_guild(GuildID),
				 case Guild of
					 {} -> ok;
					 _ ->
						 L = lists:keydelete(PlayerID, #guildWish.playerID, Guild#guild_base.wishList),
						 guild:update_guild(Guild#guild_base{wishList = L})
				 end end).

%% 发布一个许愿
release_wish(PlayerID, GuildID, CardIdList, WishTime) ->
	?metrics(begin
				 try
					 Guild =
						 case guild_pub:find_guild(GuildID) of
							 {} -> throw(?Guild_Wish_NoGuild);
							 GuildInfo -> GuildInfo
						 end,
					 Member = guild_pub:find_guild_member(PlayerID),
					 case Member =/= {} andalso Member#guild_member.guildID =:= GuildID of
						 ?FALSE -> throw(?Guild_Wish_NoMember);
						 M -> M
					 end,

					 WishList = Guild#guild_base.wishList,
					 case lists:keymember(PlayerID, #guildWish.playerID, WishList) of
						 ?TRUE -> throw(?Guild_Wish_HasWished);
						 ?FALSE -> ok
					 end,
					 NewWishInfo = #guildWish{
						 playerID = PlayerID,
						 card_list = [erlang:append_element(R, 0) || R <- common:count_list(CardIdList)],
						 msgTime = WishTime,
						 wishTime = WishTime
					 },
					 NewWishList = [NewWishInfo | WishList],

					 NewMember = Member#guild_member{giveList = []},
					 guild:update_guild_member(NewMember, ?FALSE),

					 NewGuild = Guild#guild_base{wishList = NewWishList},
					 guild:update_guild(NewGuild),

					 MemberIDList = guild_pub:get_guild_member_id_list(GuildID),
					 Msg = #pk_GS2U_releaseNewWish{wish_list = make_wish_info(NewWishInfo)},
					 [m_send:sendMsgToClient(ID, Msg) || ID <- MemberIDList],

					 m_send:sendMsgToClient(PlayerID, #pk_GS2U_releaseWishResult{card_id_list = CardIdList, result = 0})
				 catch
					 Result ->
						 m_send:sendMsgToClient(PlayerID, #pk_GS2U_releaseWishResult{card_id_list = CardIdList, result = Result})
				 end end).

%% 赠送
give_piece(PlayerID, GuildID, TargetID, CardID, Number) ->
	?metrics(begin
				 try
					 ItemCfg = cfg_item:getRow(CardID),
					 ?CHECK_THROW(ItemCfg =/= {}, ?Guild_Wish_NoPieceCfg),
					 #itemCfg{character = PieceType} = ItemCfg,
					 WishLimitCfg = cfg_guildMakeWishLImit:getRow(PieceType),
					 #guildMakeWishLImitCfg{times = PerTimes} = WishLimitCfg,
					 ?CHECK_THROW(Number =:= PerTimes, ?Guild_Wish_OverLimitNum),
					 Guild = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(Guild =/= {}, ?Guild_Wish_NoGuild),
					 Member = guild_pub:find_guild_member(TargetID),
					 case Member =/= {} andalso Member#guild_member.guildID =:= GuildID of
						 ?FALSE -> throw(?Guild_Wish_NoMember);
						 M -> M
					 end,
					 WishList = Guild#guild_base.wishList,
					 WishInfo =
						 case lists:keyfind(TargetID, #guildWish.playerID, WishList) of
							 false ->
								 throw(?Guild_Wish_NoWishInfo);
							 Info -> Info
						 end,
					 {_ID, WishNum, ReceiveNum} = case lists:keyfind(CardID, 1, WishInfo#guildWish.card_list) of
													  ?FALSE ->
														  throw(?Guild_Wish_NoWishInfo);
													  R -> R
												  end,
					 ?CHECK_THROW(ReceiveNum < WishNum, ?Guild_Wish_PieceFull),


					 GiveKey = {PlayerID, CardID},
					 GiveList = case lists:keytake(GiveKey, 1, WishInfo#guildWish.givenList) of
									?FALSE ->
										[{GiveKey, 1} | WishInfo#guildWish.givenList];
									{_, {_, Times}, Left} ->
										[{GiveKey, Times + 1} | Left]
								end,

					 Player_Mirror = mirror_player:get_player(PlayerID),
%%		Target_Mirror = mirror_player:get_player(TargetID),
					 %% 发送碎片
					 Language = language:get_player_language(TargetID),
					 RewardInfo = #mailInfo{
						 title = language:get_server_string("GuildWish14", Language),
						 describe = language:format(language:get_server_string("GuildWish15", Language), [
							 richText:getPlayerText(Player_Mirror#player.name, Player_Mirror#player.sex),
							 Number,
							 richText:getItemText(CardID, Language)
						 ]),
						 player_id = TargetID,
						 itemList = [#itemInfo{itemID = CardID, num = Number}],
						 attachmentReason = ?Get_Item_Reason_GuildWish
					 },
					 mail:send_mail(RewardInfo),

					 NewInfo = WishInfo#guildWish{
						 givenList = GiveList,
						 card_list = lists:keystore(CardID, 1, WishInfo#guildWish.card_list, {CardID, WishNum, ReceiveNum + 1})
					 },
					 %% 发送消息
					 NewGiveInfo = #giveInfo{
						 playerID = PlayerID,
						 card_id = CardID,
						 num = Number,
						 giveTime = time:time()
					 },
					 NewMember = Member#guild_member{giveList = [NewGiveInfo | Member#guild_member.giveList]},
					 guild:update_guild_member(NewMember, ?FALSE),

					 Msg = #pk_GS2U_giveNewPiece{give_list = [make_give_piece_info(NewGiveInfo)]},
					 m_send:sendMsgToClient(TargetID, Msg),

					 NewWishList = lists:keyreplace(TargetID, #guildWish.playerID, WishList, NewInfo),
					 NewGuild = Guild#guild_base{wishList = NewWishList},
					 guild:update_guild(NewGuild),

					 MemberIDList = guild_pub:get_guild_member_id_list(GuildID),
					 WishMsg = #pk_GS2U_releaseNewWish{wish_list = make_wish_info(NewInfo)},
					 [m_send:sendMsgToClient(ID, WishMsg) || ID <- MemberIDList],
					 player_offevent:save_offline_event(TargetID, ?Offevent_Type_Process_Msg, {attainment_addprogress, ?Attainments_Type_ReceiveGiftsCount, {1}}),

					 ?ERROR_OK
				 catch
					 Result -> Result
				 end end).

%% 发送许愿信息
send_wish_msg(PlayerID, GuildID) ->
	?metrics(begin
				 try
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_Wish_NoGuild);
						 _ -> ok
					 end,

					 case get_player_wish_info(GuildID, PlayerID) of
						 {} -> ok;
						 Info ->
							 NewWishList = lists:keyreplace(PlayerID, #guildWish.playerID, Guild#guild_base.wishList, Info#guildWish{msgTime = time:time()}),
							 NewGuild = Guild#guild_base{wishList = NewWishList},
							 guild:update_guild(NewGuild)
					 end,
					 ok
				 catch
					 Result -> Result
				 end end).
%% ---------------------- 玩家进程 ----------------------
%% 发布心愿
on_release_wish(CardIdList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(Guild =/= {}, ?Guild_Wish_NoGuild),
					 ?CHECK_THROW(length(CardIdList) =:= Guild#guild_base.wish_limit_num + recharge_subscribe:get_subscribe_value(?RechargeSubscribe5, 0), ?Guild_Wish_OverLimitNum),
					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_Wish_NoGuild)
								  end,
					 MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
					 case MemberRecord of
						 false -> throw(?Guild_Wish_NoMember);
						 _ -> ok
					 end,
					 case variable_player:get_value(?Variant_Index_44_GuildWishTimes) >= 1 of
						 ?TRUE -> throw(?Guild_Wish_HasWished);
						 ?FALSE -> ok
					 end,
					 case lists:keymember(PlayerID, #guildWish.playerID, Guild#guild_base.wishList) of
						 ?TRUE -> throw(?Guild_Wish_HasWished);
						 ?FALSE -> ok
					 end,
					 CardSingleIdList = lists:usort(CardIdList),
					 [throw(?Guild_Wish_NoPieceCfg) || ID <- CardSingleIdList, cfg_guildMakeWish:getRow(ID) =:= {}],
					 variable_player:set_value(?Variant_Index_44_GuildWishTimes, 1),
					 guildPID ! {releaseWish, PlayerID, GuildID, CardIdList, time:time()},
					 send_wish_notice(PlayerID, GuildID, CardIdList),
					 attainment:add_attain_progress(?Attainments_Type_GuildWishesCount, {1}),
					 ok
				 catch
					 Result ->
						 player:send(#pk_GS2U_releaseWishResult{card_id_list = CardIdList, result = Result})
				 end end).

%% 赠送碎片
on_give_piece(TargetID, CardID, GiveNum) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 case TargetID =:= PlayerID of
						 ?TRUE -> throw(?ErrorCode_Battle_Unknown);
						 ?FALSE -> ok
					 end,
					 GuildID = player:getPlayerProperty(#player.guildID),
					 GuildMemberMaps = guild_pub:get_guild_member_maps(GuildID),
					 Guild = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(Guild =/= {} andalso GuildMemberMaps =/= {}, ?Guild_Wish_NoGuild),
					 GiveTimes = variable_player:get_value(?Variant_Index_45_GuildWishGiveCount),
					 MaxGivenTimes = guild_pub:get_attr_value_by_index(Guild#guild_base.building_list, ?Guild_DonateNum)
						 + recharge_subscribe:get_subscribe_value(?RechargeSubscribe5, 0),
					 ?CHECK_THROW(GiveTimes < MaxGivenTimes, ?Guild_Wish_OutGiveTimes),
					 ?CHECK_THROW(lists:keymember(TargetID, 1, GuildMemberMaps#guild_member_maps.member_list), ?Guild_Wish_NoGuild),
					 WishInfo = case lists:keyfind(TargetID, #guildWish.playerID, Guild#guild_base.wishList) of
									?FALSE -> throw(?Guild_Wish_NoWishInfo);
									INf -> INf
								end,
%%					 case lists:keyfind({PlayerID, CardID}, 1, WishInfo#guildWish.givenList) of
%%						 ?FALSE -> ok;
%%						 {_, Times} ->
%%							 case Times >= df:getGlobalSetupValue(heroBaseSingleTimes, 0) of
%%								 ?TRUE -> throw(?Guild_Wish_OutSingleGiveTimes);
%%								 ?FALSE -> ok
%%							 end
%%					 end,
					 {_ID, WishNum, ReceiveNum} = case lists:keyfind(CardID, 1, WishInfo#guildWish.card_list) of
													  ?FALSE ->
														  throw(?Guild_Wish_NoWishInfo);
													  R -> R
												  end,

					 ItemCfg = cfg_item:getRow(CardID),
					 ?CHECK_THROW(ItemCfg =/= {}, ?Guild_Wish_NoPieceCfg),
					 WishCfg = cfg_guildMakeWish:getRow(CardID),
					 ?CHECK_CFG(WishCfg),
					 #itemCfg{character = PieceType} = ItemCfg,
					 WishLimitCfg = cfg_guildMakeWishLImit:getRow(PieceType),
					 ?CHECK_CFG(WishLimitCfg),
					 #guildMakeWishLImitCfg{times = PerTimes} = WishLimitCfg,
					 ?CHECK_THROW(GiveNum =:= PerTimes, ?Guild_Wish_OverLimitNum),

					 ?CHECK_THROW(WishNum > ReceiveNum, ?Guild_Wish_PieceFull),


					 {ItemError, ItemPrepared} = bag_player:delete_prepare([{CardID, GiveNum}]),
					 case ItemError =:= ?ERROR_OK of
						 ?FALSE -> throw(?Guild_Wish_NotPiece);
						 ?TRUE -> ok
					 end,
					 Reply = guild_pub:gen_call({giveMemberPiece, PlayerID, GuildID, TargetID, CardID, GiveNum}),
					 ?ERROR_CHECK_THROW(Reply),
					 %% 给自己发奖励
					 currency:add([WishCfg#guildMakeWishCfg.rewards], ?Money_Change_GuildWish),
					 bag_player:delete_finish(ItemPrepared, ?Reason_Guild_Wish),
					 variable_player:set_value(?Variant_Index_45_GuildWishGiveCount, GiveTimes + 1),
					 activity_new_player:on_active_condition_change(?SalesActivity_GivePiece_173, GiveNum),
					 activity_new_player:on_active_condition_change_ex(TargetID, ?SalesActivity_GetPiece_180, GiveNum),

					 %% 公告
					 PlayerText = player:getPlayerText(),
					 Target_Mirror = mirror_player:get_player(TargetID),
					 TargetPlayerText = richText:getPlayerText(Target_Mirror#player.name, Target_Mirror#player.sex),
					 marquee:sendGuildNotice(0, GuildID, guildWish12,
						 fun(Language) ->
							 language:format(language:get_server_string("GuildWish12", Language), [PlayerText, TargetPlayerText, richText:getItemText(CardID, Language), ReceiveNum + 1, WishNum])
						 end),
					 player:send(#pk_GS2U_givePieceResult{targetID = TargetID, card_id = CardID, giveNum = GiveNum, result = 0})
				 catch
					 Result ->
						 player:send(#pk_GS2U_givePieceResult{targetID = TargetID, card_id = CardID, giveNum = GiveNum, result = Result})
				 end end).

on_send_wish_msg() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 WishInfo =
						 case get_player_wish_info(GuildID, PlayerID) of
							 {} -> throw(?Guild_Wish_NoWishData);
							 Info -> Info
						 end,
					 NowTime = time:time(),
					 MsgCDTime = df:getGlobalSetupValue(heroBaseSpace, 0),
					 case NowTime >= WishInfo#guildWish.msgTime + MsgCDTime andalso MsgCDTime > 0 of
						 ?FALSE -> throw(?Guild_Wish_MsgCD);
						 ?TRUE -> ok
					 end,
					 guildPID ! {sendWishMsg, PlayerID, GuildID},
					 send_wish_notice_again(PlayerID, GuildID, WishInfo#guildWish.card_list),
					 player:send(#pk_GS2U_sendPieceMsgResult{result = 0, sendTime = NowTime})
				 catch
					 Result -> player:send(#pk_GS2U_sendPieceMsgResult{result = Result, sendTime = 0})
				 end end).

%% ------------------ 公共函数 ---------------------
%% 返回玩家的许愿信息
get_player_wish_info(GuildID, PlayerID) ->
	case guild_pub:find_guild(GuildID) of
		{} -> {};
		Guild ->
			case guild_pub:is_guild_member(GuildID, PlayerID) of
				false -> {};
				_ ->
					WishList = Guild#guild_base.wishList,
					case lists:keyfind(PlayerID, #guildWish.playerID, WishList) of
						false -> {};
						INf -> INf
					end
			end
	end.

%% 返回玩家被赠送的数据
get_player_be_give_list(GuildID, PlayerID, PieceID) ->
	Member = guild_pub:get_guild_member_record(GuildID, PlayerID),
	case Member of
		{} -> [];
		_ ->
			Func = fun(GiveInfo) ->
				case GiveInfo#giveInfo.card_id =:= PieceID of
					?TRUE -> GiveInfo;
					?FALSE -> ok
				end
				   end,
			common:listsFiterMap(Func, Member#guild_member.giveList)
	end.

make_wish_info(WishInfo) ->
	?metrics(begin
				 MirrorPlayer = mirror_player:get_player(WishInfo#guildWish.playerID),
				 lists:map(fun({CardID, WishNum, ReceiveNum}) ->
					 #pk_guildWishData{
						 playerID = WishInfo#guildWish.playerID,
						 strPlayerName = MirrorPlayer#player.name,
						 nPlayerLevel = MirrorPlayer#player.level,
						 sex = MirrorPlayer#player.sex,
						 nRank = guild_pub:get_guild_member_class(MirrorPlayer#player.guildID, WishInfo#guildWish.playerID),
						 vip = mirror_player:get_player_vip(WishInfo#guildWish.playerID),
						 headID = MirrorPlayer#player.head_id,
						 frame = MirrorPlayer#player.frame_id,
						 card_id = CardID,
						 wishNum = WishNum,
						 reciveCount = ReceiveNum,
						 wishTime = WishInfo#guildWish.wishTime,
						 msgTime = WishInfo#guildWish.msgTime,
						 subscribe_time = variable_player:get_player_value(WishInfo#guildWish.playerID, ?VARIABLE_PLAYER_subscribe),
						 give_List = [make_give_piece_info(GiveInfo) ||
							 GiveInfo <- get_player_be_give_list(MirrorPlayer#player.guildID, MirrorPlayer#player.player_id, CardID)]
					 }
						   end, WishInfo#guildWish.card_list) end).

make_give_piece_info(GiveInfo) ->
	MirrorPlayer = mirror_player:get_player(GiveInfo#giveInfo.playerID),
	#pk_givePieceInfo{
		playerID = GiveInfo#giveInfo.playerID,
		strPlayerName = MirrorPlayer#player.name,
		sex = MirrorPlayer#player.sex,
		nPlayerLevel = MirrorPlayer#player.level,
		nRank = guild_pub:get_guild_member_class(MirrorPlayer#player.guildID, GiveInfo#giveInfo.playerID),
		vip = mirror_player:get_player_vip(GiveInfo#giveInfo.playerID),
		headID = mirror_player:get_player_equip_head(GiveInfo#giveInfo.playerID),
		frame = mirror_player:get_player_equip_frame(GiveInfo#giveInfo.playerID),
		card_id = GiveInfo#giveInfo.card_id,
		num = GiveInfo#giveInfo.num,
		giveTime = GiveInfo#giveInfo.giveTime
	}.

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Guild) =:= 1 andalso guide:is_open_action(?OpenAction_guild).

send_wish_notice(PlayerID, GuildID, CardIdList) ->
	CardIDNumList = common:count_list(CardIdList),
	PlayerText = player:getPlayerText(),
	F = fun({CardID, Num}) ->
		marquee:sendGuildNoticeSpecial(0, GuildID, d3_GuildWish_Text1,
			fun(Language) ->
				language:format(language:get_server_string("D3_GuildWish_Text1", Language), [PlayerText, richText:getItemText(CardID, Language), Num])
			end, [3, 2, PlayerID, CardID])
		end,
	lists:foreach(F, CardIDNumList).
send_wish_notice_again(PlayerID, GuildID, CardList) ->
	PlayerText = player:getPlayerText(),
	F = fun({CardID, WishNum, GetNum}) ->
		case WishNum > GetNum of
			?TRUE ->
				marquee:sendGuildNoticeSpecial(0, GuildID, d3_GuildWish_Text2,
					fun(Language) ->
						language:format(language:get_server_string("D3_GuildWish_Text2", Language), [PlayerText, richText:getItemText(CardID, Language), GetNum, WishNum])
					end, [3, 2, PlayerID, CardID]);
			?FALSE -> ok
		end
		end,
	lists:foreach(F, CardList).

on_get_give_record() ->
	PlayerID = player:getPlayerID(),
	MsgList = case guild_pub:find_guild_member(PlayerID) of
				  {} -> [];
				  #guild_member{giveList = GiveList} ->
					  [make_give_piece_info(GiveInfo) || GiveInfo <- GiveList]
			  end,
	player:send(#pk_GS2U_givePieceRecordRet{give_list = MsgList}).