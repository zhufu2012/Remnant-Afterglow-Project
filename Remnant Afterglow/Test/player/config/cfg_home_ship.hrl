-ifndef(cfg_home_ship_hrl).
-define(cfg_home_ship_hrl, true).

-record(home_shipCfg, {
	%% 家园功能对应ID
	%% （仙船，双修）
	iD,
	%% 所需副本ID.是副本表（不是地图表）的id
	mapid,
	%% 探索获得道具。纯显示
	map_award,
	%% 探索消耗的基础单位耐力值。（小时）最终扣除耐力值需要乘以小时数
	jingli,
	%% 分时奖励调用LevelDrop-ID
	time_award,
	%% 仙船分时的随机文字
	%% 按照序号在string里面的仙船随机文字部分找
	suiji_info,
	%% 调用最终奖励概率
	%% 探索三类时间，从小到大依次对应一下概率
	%% 每满1个10000，调用依次最终奖励，不满10000的随机
	final_award,
	%% 分时奖励最大加成
	%% 最大品质加成|最大星数加成
	%% 万分比
	addMax,
	%% 种族加成
	%% {种族编号1，加成万分比1}|{种族编号2，加成万分比2}
	%% 种族
	%% 1：妖
	%% 2：仙
	%% 3：佛
	%% 4：魔
	%% 5：無
	addRace,
	%% 英雄类型加成
	%% {类型1,万分比1}|{类型2,万分比2}
	%% 英雄类型:
	%% 1为刺客型
	%% 2为战士型
	%% 3为技能型
	addProf
}).

-endif.