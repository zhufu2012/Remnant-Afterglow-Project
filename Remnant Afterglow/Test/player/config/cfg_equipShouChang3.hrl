-ifndef(cfg_equipShouChang3_hrl).
-define(cfg_equipShouChang3_hrl, true).

-record(equipShouChang3Cfg, {
	%% 装备阶数
	iD,
	%% 部位
	%% 头盔 6
	%% 战甲 5
	%% 护腿 9
	%% 护手 3
	%% 护肩 7
	%% 武器 1
	%% 副手武器 14
	%% 项链 2
	%% 护符 10
	%% 戒指 4
	type,
	%% 再生等级
	regenerateLv,
	%% 索引
	index,
	%% 再生最大等级
	regenerateMaxLv,
	%% 再生消耗材料（类型，道具ID，数量）
	%% 类型1.道具，2.货币
	use,
	%% 再生基础属性增加（属性ID，属性值）
	%%  填的数据为总值
	attribute,
	%% 随机规则：
	%% 0.使用pseudorandom字段的规则；
	%% 1.取RegenerateAttr3字段的属性.
	%% 【RegenerateAttr1,RegenerateAttr2,RegenerateAttr3】三个字段，在同一件装备的再生养成中，只能随机取到1次，如过已经取用过，则后面随机直接排除在外.
	excellence,
	%% (必定失败次数a，初始成功率b，成功率涨幅c)
	%% 必定失败次数：必定失败这么多次后，才开始用成功率计算是否合成成功；
	%% 初始成功率：排除必定失败次数后，第1次的成功率；
	%% 成功率涨幅：排除必定失败次数后，第2次开始每次成功率增长数；
	%% 排除必定失败次数后的，每次成功率= b+（次数-1)*c ≤1.
	%% 成功后重置：重新用以上逻辑判断是否成功.
	%% (1,5000,2000)表示：
	%% 第1次必定失败；
	%% 第2次成功率=50% 
	%% 第3次成功率=70%
	%% 第4次成功率=90%
	%% 第5次成功率=110%≤1，取100%，必定成功
	%% 只要成功，表示这一轮结束，重新开始判断. 
	%% 排除必定失败次数后开始用这个公式：b + (次数 - 1 - 必定失败次数) * c
	%% 成功，取RegenerateAttr2字段的属性；
	%% 失败，取RegenerateAttr1字段的属性。
	pseudorandom,
	%% 再生属性1
	%% 属性库ID|属性库ID
	regenerateAttr1,
	%% 再生属性2
	%% 属性库ID|属性库ID
	regenerateAttr2,
	%% 再生属性3
	%% 属性库ID|属性库ID
	regenerateAttr3,
	%% 达到再生最大等级（目前规划是4级）后，额外获得一条完美再生属性
	%% 属性库ID
	regenerateAttr4
}).

-endif.
