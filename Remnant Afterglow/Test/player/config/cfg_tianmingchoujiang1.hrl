-ifndef(cfg_tianmingchoujiang1_hrl).
-define(cfg_tianmingchoujiang1_hrl, true).

-record(tianmingchoujiang1Cfg, {
	iD,
	%% 按顺序调用[Tianmingchoujiang2_1_天命转盘抽奖]的ID。
	%% ·前一个抽奖ID抽取完所有物品后，才出来后面那个。
	%% ·最后一个抽奖ID抽完后，不再刷新转盘，不能再抽取.
	activitys,
	%% 积分途径
	%% （类型，参数1，参数2）
	%% 1.活动期间每充值X绿钻获得Y积分，参数1=绿钻数量，参数2=积分数；
	%% 2.活动期间每消耗X绿钻获得Y积分，参数1=绿钻数量，参数2=积分数。
	integral,
	%% 积分获得途径，跳转ID
	recommend,
	%% 积分获得途径，跳转ID
	%% （位置序号，跳转ID）
	%% ·位置序号相同的，配置在前面的跳转ID完成后才显示后面的跳转ID 
	%% 功能做好后删除Recommend字段
	recommendNew,
	%% 活动运营活动途径
	%% （位置序号，具体的活动入口表ID）
	%% (3,111)|(3,112):
	%% ·按照配置顺序优先判断111，在判断112.
	%% ·如果当前时间有活动111，则替换RecommendNew字段位置序号为3的途径
	%% ·如果当前时间没有活动111，则判断是否有112，有的话就用112替换.
	%% ·如果当前时间也没有112，就不用替换.
	%% ·如果成功替换了具体获得获取途径，名称和图标就用具体活动的显示。
	%% ·整体配置0也表示不替换。
	activeBaseID,
	%% 积分获取途径上是否显示推荐标签
	%% 1、是
	%% 0、否
	%% 对应位置进行配置
	recommend_Show,
	%% 跳转功能的icon图
	recommend_Icon
}).

-endif.
