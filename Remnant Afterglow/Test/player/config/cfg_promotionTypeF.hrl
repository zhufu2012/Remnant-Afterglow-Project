-ifndef(cfg_promotionTypeF_hrl).
-define(cfg_promotionTypeF_hrl, true).

-record(promotionTypeFCfg, {
	iD,
	%% 调用副本ID
	dungeonBase,
	%% 运营活动副本每日最大次数
	maxTime,
	%% 作者:
	%% 进入条件
	%% {条件序列，条件类型，条件值}
	%% 同“条件序列”的条件要求都达到
	%% 才算该“条件序列”要求达到。
	%% 满足一个条件序列就有资格进入副本
	%% 条件类型
	%% 1玩家等级
	%% 2VIP等级
	%% 3所需通关其他关卡
	%% 4星期限制 参数1-7代表星期一至星期天
	entryCond,
	%% 掉落显示
	dropItem,
	%% 副本进度奖励
	%% 序号为1默认为宝箱关卡
	%% {序号,征服次数，物品ID，数量}
	conqItem,
	%% 掉落包
	%% 副本掉落相关参数
	%% {功能编号，掉落包ID，调用次数}
	%% 功能编号：1 客户端副本BOSS固定掉落或扫荡掉落包、服务器副本胜利掉落
	monsterDrop
}).

-endif.
