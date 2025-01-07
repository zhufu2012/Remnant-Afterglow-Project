-ifndef(cfg_randomValue_hrl).
-define(cfg_randomValue_hrl, true).

-record(randomValueCfg, {
	%% 作者:
	%% 随机组ID
	%% 1，代表非VIP装备强化
	%% 2，代表VIP装备强化
	%% 3，代表超VIP装备强化
	%% 4，代表培养洗练HP
	%% 5，代表培养洗练Attack
	%% 6，代表培养洗练Defence
	%% 7，代表洗练装备HP-不用了
	%% 8，代表洗练装备Attack-不用了
	%% 9，代表洗练装备Defence-不用了
	%% 10，大闹天宫BUFF1
	%% 11，大闹天宫购买BUFF2
	%% 12，大闹天宫购买BUFF3
	%% 13，帮派任务品质随机 1为一星，2为二星，3为三星
	%% 14，英雄，主角培养随机项
	%% 15，武器，洗练随机项
	%% 16，项链，洗练随机项
	%% 17，护手，洗练随机项
	%% 18，腰带，洗练随机项
	%% 19，衣服，洗练随机项
	%% 20，头盔，洗练随机项
	%% 21，腰带，洗练随机项
	%% 22，鞋子，洗练随机项
	%% 23，信物单次升级提升经验
	%% 101-107，星期一到星期天比武BUFF随机列
	%% 201-204,隐藏副本组
	%% 301- ，信物洗练
	iD,
	%% 作者:
	%% 数组{权值，对应值}
	%% l例：{6000,1}|{3000,2}|{1000,3}
	%% 加1的概率为6000/(6000+3000+1000)
	%% 加2的概率为3000/(6000+3000+1000)
	%% 加3的概率为1000/(6000+3000+1000)
	array
}).

-endif.