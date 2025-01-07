-ifndef(cfg_auctionSell_hrl).
-define(cfg_auctionSell_hrl, true).

-record(auctionSellCfg, {
	%% 这里查询不到的为不能上架交易的道具
	iD,
	%% 装备用
	%% 该装备含有的品质和星级情况
	%% ｛品质，星级｝
	%% 品质（颜色）
	%% 0白，1蓝，2紫，3橙，4红 ，5龙，6神，7龙神
	%% 星级
	%% 0为0星，1-3为1-3星
	chaStar,
	%% 装备用
	%% 可求购的展示类型
	needBuyChaStar,
	%% 装备用
	%% 穿戴的最低等级要求
	lvLimit,
	%% 装备用
	%% 穿戴的转职数要求
	changeRole,
	%% 装备用
	%% 装备保留数量
	%% 和ChaStar对应
	%% 不清理填0
	holdEquipNum,
	%% 道具阶数（0-16，原来的阶数显示是STR，增加这个SHORT的）
	order,
	%% 道具权重值（权重值越高，道具在拍卖中的位置就越靠前，同样权重值则按先后拍卖时间排序，越先排序越前）
	weight,
	%% ItemType
	itemType,
	%% DetailedType
	detailedType,
	%% DetailedType2
	detailedType2,
	%% DetailedType3
	detailedType3,
	%% 关注列表展示
	%% 1.在关注列表展示
	%% 0.在关注列表隐藏
	iFShow,
	%% 道具品质
	%% 装备默认为0
	character,
	%% 物品单次购买数下限
	%% “你最少只能购买*个该道具”
	itemBuyMin,
	%% 物品单次购买数上限
	%% “当前输入已达可购买单次最大数量”
	itemBuyMax,
	%% 价格
	%% （货币ID,购买标准价格,购买上限，购买下限）
	buyPrice,
	%% OB+4用不到
	%% 玩家出售价格
	%% （货币ID,出售标准价格,出售上限，出售下限）
	sellPrice,
	%% 价格变动日期
	%% 统计几天的数据
	changeDate,
	%% OB+4用不到
	%% 价格变动方案ID
	%% ContrastChange_1_对照表的PricePlan"X"
	choosePricePlan,
	%% 物品变动方案ID
	%% ContrastChange_1_对照表的NumberPlan"X"
	chooseNumberPlan,
	%% 开启条件
	%% （功能ID，后台开关ID）
	%% 调用【Openaction_1_功能开放条件】表的ID，通过该ID的条件，来控制具体拍卖大分页的开启和显示.
	%% 后台开关默认开启，特殊情况可手动关闭
	openItemCondition,
	%% 无限补货开关
	%% （1开 0不补）
	infiniteOpen,
	%% 无限补货虚假展示个数
	%% （个数上限，个数下限）
	fakeInfinite,
	%% 无限补货内
	%% 时长后下架个数
	%% （不足则为0）
	fakeInfiniteDown,
	%% 系统延时回收相关
	%% （时间节点【秒】，出售概率【万分比】）
	%% 即在每次玩家上架后的N秒时会对单个道具进行一次概率判断来收购
	sellChance
}).

-endif.
