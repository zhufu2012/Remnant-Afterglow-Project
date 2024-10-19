-ifndef(cfg_gloryDragonEmblem3_hrl).
-define(cfg_gloryDragonEmblem3_hrl, true).

-record(gloryDragonEmblem3Cfg, {
	%% 商店ID
	iD,
	%% 商品ID
	goodsId,
	index,
	%% 商店物品显示排序
	%% 数值小的在前，后端将物品顺序排好发给前端
	%% 以“ID、Snum、Refresh”三个字段来分组，同一组中的物品进行排序
	sort,
	%% 出售物品：
	%% 道具/货币/装备
	%% (职业，类型，ID，数量，品质，星级，是否绑定序)
	%% 职业:0
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	itemNew,
	%% (购买货币类型,价格)
	currType,
	%% (类型，参数1，参数2）
	%% 填0：表示不限购
	%% 类型1：个人限购，参数1=限购次数，参数2=0；
	%% 暂时只有类型1.
	limit,
	%% 特殊转圈特效
	%% 0没有
	%% 1有
	show,
	%% 推荐标识
	%% 0没有
	%% 1有
	push,
	%% 可购买条件
	%% （条件，参数）
	%% 0.代表无需条件
	%% 1.战纪等级，参数=对应等级
	conditionType,
	%% 可显示条件
	%% （条件，参数）
	%% 0.代表无需条件
	%% 1.战纪等级，参数=对应等级
	showType
}).

-endif.
