-ifndef(cfg_heroRoulette3_hrl).
-define(cfg_heroRoulette3_hrl, true).

-record(heroRoulette3Cfg, {
	%% 1、普通英雄抽奖
	%% 2、高级英雄抽奖
	%% 3、未知召唤
	iD,
	%% 英雄阵营
	%% 0、未区分
	%% 1风、2火、3土
	camp,
	%% 序号
	%% 用于开服天数的区分
	oder,
	%% 索引
	index,
	%% 开服天数区间
	%% （开服第几天，开服第几天）
	%% 取等
	%% 0表示：无限
	serviceDays,
	%% 规则说明文字读取文字表字段
	%% ID=1时，英雄召唤的概率公示文字
	%% ID=2时，命运召唤的概率公示文字，配置3个概率公示文字ID，宠物类别依次是：1风、2火、3土。
	xunbao_text
}).

-endif.
