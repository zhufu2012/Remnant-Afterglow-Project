-ifndef(cfg_rebateRedPacket_hrl).
-define(cfg_rebateRedPacket_hrl, true).

-record(rebateRedPacketCfg, {
	%% 充值红包类型
	%% ·1类型一：每日首次充值任意金额，向战盟派发一个红包；注意，是首次才发              
	%% ·2类型二：每日累充：领取完每日累充里的三档奖励后，向战盟派发一个红包              
	%% ·3类型三：周卡：达成周卡后，向战盟派发一个红包（这个版本不做）              
	%% ·4类型四：月基金：达成月基金后，向战盟派发一个红包（这个版本不做）              
	%% ·5类型五：订阅特权：达成订阅特效后，向战盟派发一个红包（这个版本不做）              
	type,
	%% 每日首充，充值区间
	%% 这里填充值的非绑钻石数量；
	%% 区间读取规则：向前取值
	%% Type=1时使用，
	%% 其他Type填“0”
	section,
	%% 索引
	index,
	%% （派发绑钻总数量，红包数）
	%% 个人每天能领取的红包总金额：
	%% 没订阅特权的人，由GuildRedPacket_NotVIPNum[globalSetup]限制；
	%% 订阅了特权的人，由GuildRedPacket_NotVIPNum[globalSetup]和ID=9[Subscribe_1_订阅特权]一起限制
	redPacket,
	%% 红包名称
	%% 配置后端可到的文字表
	redName,
	%% 红包介绍文字
	%% 配置后端可到的文字表
	redIntroduce
}).

-endif.
