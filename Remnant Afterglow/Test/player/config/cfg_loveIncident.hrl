-ifndef(cfg_loveIncident_hrl).
-define(cfg_loveIncident_hrl, true).

-record(loveIncidentCfg, {
	%% 事件ID
	%% 1-5为无礼物事件
	%% 6-9为有贺礼事件
	%% 99为特殊事件
	iD,
	%% 作者:
	%% 文字信息
	%% 泡泡条文字
	text1,
	%% 作者:
	%% 头像icon
	%% 泡泡条头像
	head1,
	%% 作者:
	%% ui显示时间 毫秒
	time,
	%% stingID
	%% 喊话语音
	commonTalk,
	%% 作者:
	%% 文字信息
	%% 弹幕文字
	text2,
	%% 作者:
	%% 头像ICON
	%% 弹幕头像
	head2,
	%% 作者:
	%% 称号ID
	%% 弹幕称号
	title,
	%% 作者:
	%% 名称文字
	%% 弹幕发起者名称文字
	text3,
	%% 作者:
	%% 贺礼NPC头像
	head3,
	%% 作者:
	%% 贺礼NPC名字
	text4,
	%% 作者:
	%% 贺礼火箭等后面跟的一句话
	text5,
	%% 作者:
	%% {弹幕贺礼ID,贺礼数量}
	damuGiftsID
}).

-endif.
