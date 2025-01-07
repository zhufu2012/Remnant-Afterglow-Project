-ifndef(cfg_heroCountry_hrl).
-define(cfg_heroCountry_hrl, true).

-record(heroCountryCfg, {
	%% 建筑ID
	%% 每个ID都要单独处理
	%% 然后星光祭坛三个是独立的ID
	iD,
	%% 建筑等级
	%% （默认未解锁是0级，解锁为1级）
	level,
	%% Key
	index,
	%% 升级上限
	levelMax,
	%% 升级/开启前置条件
	%% 【类型，参数1，参数2】
	%% 类型1：人物等级，参数1=具体值，参数2=0
	%% 类型2：建筑条件，参数1=建筑ID，参数2=建筑等级
	%% 类型3：功能开启，参数1=功能ID，参数2=0
	%% 这里配的是升到下一级的条件
	needCondition,
	%% 功能相关
	%% 英雄大厅：解锁对应建筑（前端界面展示）
	%% 研究圣所：解锁对应研究序号（前端界面展示）
	%% 次元召唤：对应普通召唤的高级出货概率（前后端实现）
	%% 星光祭坛：对应生产速率及存储值（前后端实现）
	%% 装备工坊：基础打造的高级出货概率（前后端实现）
	%% 神像相关：对应属性提升（前后端实现）
	%% 祈愿所：祈愿台数量（前后端实现）
	%% 英雄商店：配置商店ID（前后端实现）
	%% 【类型1，参数1，参数2】
	%% 类型1：建筑等级；参数1=建筑ID，参数2=建筑等级
	%% 类型2：具体研究；参数1=研究序号，参数2=0
	%% 类型3：增加概率；参数1=库ID，参数2=万分比值（后端需处理）
	%% 类型4：具体生产速率；参数1=货币ID，参数2=每分钟的值（后端需处理）
	%% 类型5：具体存储；参数1=具体值，参数2=0（后端需处理）
	%% 类型6：属性增加；参数1=属性ID，参数2=具体值（后端需处理）
	%% 类型7：祈愿台数量；参数1=具体数量，参数2=0
	%% 类型8：跳转商店，参数1=跳转的商店ID，参数2=0
	functionRelevant,
	%% 建筑图片
	bulidImage,
	%% 升到下一级级消耗
	%% (货币ID，数量）
	needConsume,
	%% 升级时间
	%% （秒）
	needTime,
	%% 战力增加
	%% 这里是升到每一级增加的战力，不做覆盖
	addNum
}).

-endif.