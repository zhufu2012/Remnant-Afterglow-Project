-ifndef(cfg_teamgoal_hrl).
-define(cfg_teamgoal_hrl, true).

-record(teamgoalCfg, {
	%% 作者:
	%% 目标ID
	iD,
	%% 作者:
	%% 对应分类
	%% 1.全部
	%% 2.组队副本
	%% 3.恶魔入侵
	%% 4.恶魔巢穴
	%% 5.恶魔禁地
	%% 6.神魔战场
	%% 7.恶魔深渊
	%% 8.神魔幻域
	%% 9.圣战遗迹
	classification,
	%% 作者:
	%% 客户端索引
	%% 地图ID_怪物ID
	index,
	%% 作者:
	%% 对应大分类的功能ID（Openaction表）
	system,
	%% 作者:
	%% 副本ID，主要用于组队副本，没有填0
	copyID,
	%% 作者:
	%% 怪物ID，主要用于世界BOSS类，没有填0
	bOSSID,
	%% 作者:
	%% 目标可选限制等级，第一个为默认等级
	%% 第一个参数：
	%% 第二个参数：
	%% 第三个参数：
	grade,
	%% 作者:
	%% 目标所需展示图片
	picture,
	%% 作者:
	%% 组队喊话的文字
	teamYelling,
	%% 是否有次数合并
	%% 0没有
	%% 1有
	merge,
	%% 可组队人数
	number
}).

-endif.
