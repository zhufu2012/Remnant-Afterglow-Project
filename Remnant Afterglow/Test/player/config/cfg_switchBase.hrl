-ifndef(cfg_switchBase_hrl).
-define(cfg_switchBase_hrl, true).

-record(switchBaseCfg, {
	%% 作者:
	%% 活动ID
	%% 替换原有精彩活动或转盘的ID
	iD,
	%% 此表已废弃
	name,
	%% 备注
	name_EN,
	%% 印尼
	name_IN,
	%% 泰语
	name_TH,
	%% 引用此开关的项是否开启
	%% 0=关闭
	%% 1=开启
	switch,
	%% 作者:
	%% 开服时间在这个日期区间内的服务器，才生效
	%% {起始GSID,结束GSID}|{起始GSID,结束GSID}
	serverID,
	%% 开服天数限制：该ID活动需要生效的开服天数（>此天数）
	%% 每个活动的开服天数是取该活动开启时间（startTime）当天来计算；
	%% 比如：A服5月1号开服，B服5月2号开服，有个5月10号开启的活动，那么该活动的针对A服的开服天数是10，针对B服是9；再根据本字段的天数限制用以控制不同服务器的活动生效情况
	%% -1： startTime&endTime不使用自然日期来计算，改用开服时间计算
	%% 0： 大于0天（即不限制）
	%% n： 大于n天
	%% %--
	%% -1：startTime
	sevOpenLimit,
	%% 作者:
	%% {year，month，day，hour，minute，second}
	startTime,
	endTime,
	%% 作者:
	%% {时间参数（秒），时间参数（秒）}|{时间参数（秒），时间参数（秒）}
	%% 每天的生效时间区间，以秒计算
	%% 没有限制填0
	usableTime,
	%% 作者:
	%% 开始前多久可以显示
	%% -1：活动开始前一小时开始显示
	show_start,
	%% 作者:
	%% 结束后多久结束显示
	%% 1：活动结束后一小时不显示
	show_end,
	%% 活动列表分页的名称
	title,
	%% 英语
	title_EN,
	%% 印尼
	title_IN,
	%% 泰语
	title_TH,
	%% 活动banner上的说明文字
	desribe,
	%% 英语
	desribe_EN,
	%% 印尼
	desribe_IN,
	%% 泰语
	desribe_TH,
	%% 活动banner上的说明文字（大）
	%% 中文
	desribe_Big,
	%% 活动banner上的说明文字（大）
	%% 英语
	desribe_Big_EN,
	%% 活动banner上的说明文字（大）
	%% 印尼
	desribe_Big_IN,
	%% 活动banner上的说明文字（大）
	%% 泰语
	desribe_Big_TH,
	%% 作者:
	%% 活动类型|对应ID
	%% 活动类型：
	%% 100为版本公告
	%% 1为精彩活动PromotionBase
	%% 2为转盘 RouletteA
	%% 3为飞镖 RouletteB
	%% 4庆典活动
	%% 5为云购PromotiontypeM
	%% 6为门票类PromotionTypeN
	%% 7为新云购 有个人和全服奖励，模拟购买
	%% 2018/3/26以后，配置的话：类型1/2/3对应的ID就不用了。填到WorldGrade列。
	%% 99为设置四海和平模式，跟随的地图ID设为和平
	%%     2109000=东海海岸
	%%     2109001=南海海岸
	%%     2109002=西海海岸
	%%     2109003=北海海岸
	typeID,
	%% 作者:
	%% 当TypeID=0时，里面的为公告图片，有多个即为多图
	%% 当TypeID参数1为1及精彩活动时：
	%% 活动入口图片(参数1)|背景图片(参数2)
	%% 参数2：
	%% 1=等级
	%% 2=累计充值
	%% 3=累计消费
	%% 4=参与玩法
	%% 5=玩法奖励翻倍
	%% 6=物品兑换
	%% 7=贩卖
	%% 8=打折
	%% 9=VIP福利
	%% 10=在线
	%% 11=连续充值
	%% 12=连续登陆
	%% 13=开服抽英雄
	%% 14=开服抽装备
	%% 15=开服多日充值
	%% 16=单次充值
	%% 101=端午登录
	%% 102=端午消费
	%% 103=端午累充
	%% 104=端午打折
	%% 105=六一累充
	%% 当TypeID参数1为2及转盘时：
	%% 活动入口图片（参数1）|背景图片（参数2）|转盘（参数3）|按钮（参数4）
	%% 入口按钮：XYZP_“参数1”
	%% 背景：CJ_back_“参数2”
	%% 转盘：CJ_zhuanpan_“参数3”
	%% 上按钮：CJ_BtnUp_“参数4”
	%% 中按钮：CJ_BtnLeft_“参数4”
	%% 下按钮：CJ_BtnRight_“参数4”
	%% 当TypeID参数1为3，限时副本时：
	%% 只有1个参数，指定的是配套入口图标、背景、音效、特效的编号
	%% 当TypeID参数1为4，庆典活动时：
	%% 活动入口图片（参数1）|背景图片（参数2）|预留1（参数3）|预留2（参数4）
	%% 当typeID为5时，参数1为入口图片
	%% 当typeID为6时，参数1为入口图片，参数2为banner图片，参数3为门票图片
	pic,
	%% {世界等级，对应ID}
	%% TypeID为：
	%% 1为精彩活动 PromotionBase 表ID
	%% 2为转盘 RouletteA 表ID
	%% 3为飞镖 RouletteB 表ID
	%% 如：TypeID填2，这里填{0,1001}|{101,1002}，则表示：
	%% 世界等级0-100级时取【RouletteA 表ID 1001】，世界等级1>=101级时，取值【RouletteA 表ID 1002】
	%% 世界等级超出配置的最大世界等级时，按照配置的最大等级对应的ID来取值.
	%% TypeID为0时：
	%% 0=无限制
	%% {0,100}=世界等级0到100级生效
	worldGrade,
	%% 此功能暂不可用
	%% 用于充值区间是否推送该活动的判断
	%% 截止该活动生效时判断，在这个区间内才推送该活动.
	%% 没有此限制填“0”.
	%% 玩家充值区间（最低充值，最高充值）
	%% 最低充值：没限制最低填“0”，单位：钻石；
	%% 最高充值：没限制最高填“0”，单位：钻石.
	%% 例如：
	%% (0,100):没充值、充值金额≤100钻，则推送该活动.
	%% (6,100):6≤充值金额≤100，则推送该活动.
	%% (6,0):6≤充值金额，则推送该活动.
	%% (6,100)|(200,300):6≤充值金额≤100、200≤充值金额≤300，则推送该活动.
	recharge,
	%% 作者:
	%% 策划分组用，可将精彩活动分好组，不同组不同入口；不同入口只能看到本组的活动
	%% 不能填写0
	%% 登陆游戏后，会优先弹出分组最小的活动
	teamType,
	%% 左上排banner图中的文字
	bannerTextUpLeft,
	%% 英文
	bannerTextUpLeft_EN,
	%% 印尼
	bannerTextUpLeft_IN,
	%% 泰语
	bannerTextUpLeft_TH,
	%% 左下排banner图中的文字
	bannerTextLowLeft,
	%% 英文
	bannerTextLowLeft_EN,
	%% 印尼
	bannerTextLowLeft_IN,
	%% 泰语
	bannerTextLowLeft_TH,
	%% 右上排banner图中的文字
	bannerTextUpRight,
	%% 英文
	bannerTextUpRight_EN,
	%% 印尼
	bannerTextUpRight_IN,
	%% 泰语
	bannerTextUpRight_TH,
	%% 右下排banner图中的文字
	bannerTextLowRight,
	%% 英文
	bannerTextLowRight_EN,
	%% 印尼
	bannerTextLowRight_IN,
	%% 泰语
	bannerTextLowRight_TH,
	%% 左上排banner图中的文字
	bannerTextUpLeft2,
	%% 英文
	bannerTextUpLeft2_EN,
	%% 印尼
	bannerTextUpLeft2_IN,
	%% 泰语
	bannerTextUpLeft2_TH,
	%% 左下排banner图中的文字
	bannerTextLowLeft2,
	%% 英文
	bannerTextLowLeft2_EN,
	%% 印尼
	bannerTextLowLeft2_IN,
	%% 泰语
	bannerTextLowLeft2_TH,
	%% 右上排banner图中的文字
	bannerTextUpRight2,
	%% 英文
	bannerTextUpRight2_EN,
	%% 印尼
	bannerTextUpRight2_IN,
	%% 泰语
	bannerTextUpRight2_TH,
	%% 右下排banner图中的文字
	bannerTextLowRight2,
	%% 英文
	bannerTextLowRight2_EN,
	%% 印尼
	bannerTextLowRight2_IN,
	%% 泰语
	bannerTextLowRight2_TH,
	%% 活动下拉列表分组
	%% 将不同的活动ID填在这里，会组成对应的活动下拉列表分组
	%% 转盘类（矩阵寻宝，烟花盛典等）和独立入口的活动此配置无效
	activeGroup,
	%% 活动下拉列表的名称
	activeGroupName,
	%% 英语
	activeGroupName_EN,
	%% 印尼
	activeGroupName_IN,
	%% 泰语
	activeGroupName_TH
}).

-endif.
