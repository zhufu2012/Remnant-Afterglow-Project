-ifndef(cfg_directPurchaseGiftBag_hrl).
-define(cfg_directPurchaseGiftBag_hrl, true).

-record(directPurchaseGiftBagCfg, {
	%% 1、新手礼包
	%% 2、日礼包
	%% 3、周礼包
	%% 4、月礼包
	%% 5、寻宝礼包（每日刷新）
	%% 6、转生礼包
	%% 7、远征礼包
	%% 8、1V1礼包
	%% 默认显示优先级：新手礼包->转生礼包->每日礼包->周礼包；
	%% 如果当前页转生礼包售卖完毕，优先级：新手礼包->每日礼包->周礼包->转生礼包
	iD,
	%% 分组编号
	%% ·同组编号，每期只出1个
	%% ·同组编号，每期按照GiftBagId字段中直购直购出现次数来判断显示哪个直购
	%% 下次显示规则：1.出现次数最少的；2.出现次数相同时按照GiftBagId优先级高的先出.
	group,
	%% 礼包ID，即同组中优先级.
	%% 值越大，优先级越高.
	giftBagId,
	index,
	%% ID=6时使用，表示转生数
	%% ID=7时，表示远征赛季，配置赛季ID，大于等于该赛季时，才显示出该分页
	%% ID=8时，表示1V1赛季，配置赛季ID，玩家开启功能经历的赛季才显示，1年之后循环回来之后需要清除对应赛季的购买记录
	reincarnation,
	%% 作者:
	%% 开服时间在这个日期区间内的服务器，才生效
	%% {起始GSID,结束GSID}|{起始GSID,结束GSID}
	serverID,
	%% 个人等级段区间
	%% 向前取
	lv,
	%% （礼包类型，版本号）
	%% 礼包类型=字段ID
	%% 版本号：每次修改的时候，需要重置Group字段中“出现次数”时，则对版本号进行修改，程序会判断两次版本号的大小，修改后>修改前，才重置生效.
	%% ·只需要取一行（第一行）数据进行判断就行
	%% ·为了方便配置所有把所有行数据配成一样的.
	%% (1,2021011801)|(2,2021011801)|(3,2021011801)|(4,2021011801)|(5,2021011801)
	edition,
	%% 礼包显示顺序
	%% 值小的显示在前面
	showOder,
	%% 购买方式
	%% 1、货币
	%% 2、直购
	%% 3、免费
	%% ·免费需要红点提示，购买完后排到最后
	type,
	%% 货币消耗
	%% （货币ID，数量）
	directPurchase1,
	%% 直购商品ID，要和运营核对好价格.
	%% 货币消耗或者直购商品ID只能配置其中一个
	directPurchase2,
	%% 伴随以下功能开启ID开启
	%% 默认开启填：0
	openactionId,
	%% 对应后台开关ID
	%% 默认开启填：0
	functionSwitchId,
	%% 礼包可见条件
	%% （编号，条件，参数1，参数2）
	%% 编号：编号相同的需要同时满足，编号不同只需要满足其中一个；
	%% 条件1：玩家等级，参数1=等级，参数2=0；
	%% 条件2：VIP等级，参数1=VIP等级，参数2=0.
	%% 条件3：开服天数，参数1=开服第几天，参数2=0
	%% 条件4：限时特惠推送时间结束（没买，时间到了之后）后，才显示出，然后才能购买；
	%% 条件4时，参数1=ID[PushSalesBase_1_限时特惠推送]；
	%% 条件4时，参数2=Order[PushSalesBase_1_限时特惠推送]；
	%% 限时特惠还未触发，或者没有找到配置的限时特惠ID，都不显示。
	%% 条件5：激活第X职业，参数1=X（2或3），参数2=0；
	%% 条件6：奥义技能礼包1367117被玩家出售，且玩家未激活PVE群体奥义技能（技能位89）。
	%% 条件7：奥义技能礼包1367117被玩家出售或海盗时装宝箱1367118被玩家出售，且玩家未激活对应自己职业的海盗时装主武器。
	%% 条件8：限时特惠活动推送某某过期后触发，参数1=ID[PushSalesBase_1_限时特惠推送]，参数2=Order[PushSalesBase_1_限时特惠推送]，某某通过参数和参数2的配置确定具体是哪个限时特惠推送
	%% 条件9：远征赛季，参数1=赛季ID区间，参数2=ID区间.
	%% 条件10：1V1赛季，参数1=赛季ID区间，参数2=ID区间.
	%% 条件11：任意英雄达到X星，参数1=星级，参数2=0.
	%% 填0表示：没有可视条件.
	%% 如果在大分类（ID字段）中所有的直购礼包都没有达到条件显示，即时功能开了，对应标签也不显示出来.
	%% 优先级：
	%% OpenactionId、FunctionSwitchId > Show
	show,
	%% 排除部分玩家不显示出来
	%% （组号，类型，参数1，参数2，参数3）
	%% 组号：组号相同需要同时满足，组号不同任意满足一个组号的条件
	%% 类型：
	%% 6、激活某技能，参数1=角色序号，参数2=技能位；
	exclude,
	%% 直购项目标题名称索引
	id_Name,
	%% 标题参数
	%% 文字字段加{0}时
	%% 取实际显示的第一个道具的ID
	%% 类型1：去【道具表】读[UseParam4]字段的技能ID，用技能ID去【技能表】读技能名字[Name]
	%% 类型2：去【道具表】读道具名字[Name]
	%% 填0代表礼包标题不需读度参数
	id_NamePara,
	%% 奖励序号分段.
	%% （开服天数区间1，开服天数区间2，等级区间1，等级区间2，奖励序号）
	%% (1,2,1,9999,1)|(3,0,1,9999,2)
	%% 区间1≤天数或等级≤区间2（区间取到“等”）
	%% 区间2=0时，表示无限大.
	awardOder,
	%% 奖励
	%% (奖励序号，职业,类型，物品ID，是否绑定，数量,角色序号)
	%% 奖励序号：AwardOder字段中的序号
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	%% 角色序号：当区分职业时，1.判断第一个角色的职业；2.判断第二个角色的职业；3.判断第3个角色的职业，不区分职业时填写0
	%% 显示：显示上根据配置从左至右显示
	%% 在不同“开服天数/等级区间”读取不同的直购奖励，“开服天数/等级”变化后需要及时刷新，限购计次不变.
	gift,
	%% 假折扣显示
	%% 折扣参数万分比
	%% 1000，表示1折
	%% 1500，表示1.5折
	%% 10000，表示：不显示折扣
	discountParam,
	%% 可购买条件
	%% （类型，参数1，参数2）
	%% 1、VIP等级，参数1=等级，参数2=0
	conditionType,
	%% 限购类型
	%% 0为不限购
	%% 1为普通限购
	%% 2为VIP限购
	limitType,
	%% 限购参数
	%% 普通限购：限购次数
	%% VIP限购：VipFunNew表ID
	limitParam,
	%% 商品刷新类型
	%% 1、日刷新
	%% 2、周刷新
	%% 3、月刷新
	%% 4、永不刷新
	refreshType,
	%% 公告字段
	notice,
	%% 需要被公告的道具ID
	%% (奖励序号,职业，ID)
	%% 1004=战士，1005=法师，1006=弓手
	item,
	%% 后端直接调用条件
	%% 0、需要进行正常功能开启判断
	%% 1、在不开启功能的情况下能直接调用
	directed
}).

-endif.