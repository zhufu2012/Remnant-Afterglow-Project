-ifndef(cfg_shopCreate_hrl).
-define(cfg_shopCreate_hrl, true).

-record(shopCreateCfg, {
	%% ID
	iD,
	%% 作者:
	%% {版本号，重置类型}
	%% 0为不重置
	%% 1为及时重置
	%% 2为公共列表及时重置（局部更新
	%% 只更新商品列表，不更新购买状态）
	edition,
	%% 作者:
	%% 创建方式
	%% 0为不创建
	%% 1为功能激活创建
	%% 2为角色激活创建
	createWay,
	%% 作者:
	%% 商店类型
	%% 1，普通商店
	%% 2，随机商店
	type,
	%% 作者:
	%% {商品序号，所需人物等级}
	%% Type=1时，商品序号读ShopMallNew表的ID；
	%% Type=2时，商品序号读ShopRand表的ID
	numb,
	%% 作者:
	%% 商店开放时间
	%% 0代表不限开放时间
	%% 2015032416代表
	%% 2015年 3月 24日 16点开放
	startTime,
	%% 作者:
	%% 商店开放时间
	%% 0代表不关闭
	%% 2015032416代表
	%% 2015年 3月 24日 16点关闭
	endTime,
	%% 作者:
	%% 0：小时刷新类型
	%% 1：天刷新类型
	%% 2：周刷新类型
	%% 3：月刷新类型
	%% 4：永不刷新类型，终身限购物品(只准用一个商店等级触发)；
	%% 5：按等级立即刷新（每次切换、每次等级有变化都判断一次）
	%% 21：按照功能开启后配置的时间间隔刷新
	%% 注1：刷新时，购买限制将重置，所以循环，随机商店不支持永久不刷新类型。
	%% 注2: 自动刷新与手动刷新没有任何关系
	resetType,
	%% 作者:
	%% ResetType
	%% =0，该项代表，每几小时更新，0点为基础。
	%% =1，该项代表，几点更新。
	%% =2，该项代表，周几0点更新
	%% =3，该项代表，几号0点更新
	%% =21时，该项代表刷新间隔（天），刷新后重置时间点为5:00点.
	resetParam,
	%% 作者:
	%% {刷新道具ID，消耗数量}
	%% 注：只有随机类型的商店
	%% 支撑手动刷新，其他类型不支持
	refItem,
	%% 作者:
	%% {货币类型，货币数量}
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	%% 9为爱心值
	%% 10为血玉
	refCoin,
	%% 作者:
	%% 每日最大属性次数
	%% 0为不限次数
	%% 其他为vipFunNew序号
	refMaxVIP,
	%% 作者:
	%% 商店免费刷新次数
	%% 注：消耗完了 才算其他次数
	%% vipFunNew的ID
	refFreeVIP,
	%% 作者:
	%% 刷新权限
	%% 1.个人限购
	%% 2.帮派限购
	%% 3.全服限购
	%% 确定商店限购类型
	%% 商店所有内容与其同一
	refJuri,
	%% 作者:
	%% 商店消耗类型
	%% 0为普通型
	%% 1为拍卖型
	%% 拍卖型商店，
	%% 理论上不允许RefJuri=1
	consType,
	%% 作者:
	%% 开放类型
	%% 0为详细日期型
	%% 1为周循环型
	openType,
	%% 作者:
	%% 开启时间段
	%% OpenType为0：开放详细日期；OpenTime为详细开放时间段，{开启年(4位)月(2位)日(2位)时(2位)分(2位)，结束年(4位)月(2位)日(2位)时(2位)分(2位)}
	%% 0为不限制
	%% OpenType为1：开放周循环；OpenTime为每周开放时间段，{开启周几(1位,参数为1-7)时(2位)分(2位),结束周几(1位,参数为1-7)时(2位)分(2位)}
	openTime
}).

-endif.