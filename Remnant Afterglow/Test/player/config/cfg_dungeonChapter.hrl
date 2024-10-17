-ifndef(cfg_dungeonChapter_hrl).
-define(cfg_dungeonChapter_hrl, true).

-record(dungeonChapterCfg, {
	%% 副本类型
	%% 1普通主线
	%% 2家园船副本
	%% 3隐藏副本
	%% 4组队副本
	%% 5活动副本
	%% 6神器副本
	%% 7竞技场
	%% 8大闹天宫
	%% 11仙盟副本
	%% 15精英副本
	%% 25魔宠副本
	%% 26坐骑副本
	%% 27翅膀副本
	%% 41新魔宠副本
	%% 50新主线【OB4】
	iD,
	%% 章节id
	oder,
	%% 客户端索引
	index,
	%% 技能副本类型
	%% 1：技能挑战
	%% 2：战技试炼
	dungeonINT,
	%% 初始副本ID
	dunInitID,
	%% 最大章节
	maxOder,
	%% 章节名称
	sceneName,
	%% 地图对应的图片
	mapPic,
	%% 星级需求
	star,
	%% 章节开启等级限制
	%% （客户端用）
	openLevel,
	%% 开启隐藏副本ID组
	%% 0为无
	%% randomvalue
	openHidden,
	%% 主线副本章节图片名称
	imageName,
	%% 图片坐标和图片大小{X，Y}|{W,H}
	imageInfo,
	%% 章节标题坐标（X,Y,Z）
	%% 预制中对应trans节点
	titleInfo,
	%% 副本图片点击响应区域大小
	buttonArea,
	%% 征服任务数量
	conqNum,
	%% 星级物品产出
	%% 装备Item中没有品质和星级，走单独的掉落包，其他走直接配置
	%% （星级序列,职业，掉落ID，掉落是否绑定,掉落数量，掉落概率）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 掉落是否绑定：0为非绑 1为绑定
	%% 掉落数量为掉落包的个数，开启时每个包独立开启
	%% 掉落概率值为万分比，上限为10000，下限为0
	equipAward,
	%% 星级物品产出
	%% 其他产出，用掉落包太费
	%% (星级序列,职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	%% 显示和实际产出都用这个字段
	itemAward
}).

-endif.