-ifndef(cfg_activeBase_hrl).
-define(cfg_activeBase_hrl, true).

-record(activeBaseCfg, {
	%% 作者:
	%% 活动ID
	%% 替换原有精彩活动或转盘的ID
	iD,
	%% 备注
	name,
	%% 引用此开关的项是否开启
	%% 0=关闭
	%% 1=开启
	switch,
	%% 是否受到VIP降档配置的影响
	%% 0=不受
	%% 1=受
	vipConditionOpen,
	%% 是否显示推荐卷标
	%% 1：显示
	%% 0：不显示
	pushTitle,
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
	%% {year，month，day，hour，minute，second}
	startTime,
	%% {year，month，day，hour，minute，second}
	endTime,
	%% 作者:
	%% {时间参数（秒），时间参数（秒）}|{时间参数（秒），时间参数（秒）}
	%% 每天的生效时间区间，以秒计算
	%% 没有限制填0
	%% 玩法活动相邻两场的间隔时间不要小于2分钟（恶魔之海：地图销毁和创建）
	%% 时间不要跨天或0点
	usableTime,
	%% 开始前多久可以显示
	%% -1：活动开始前一小时开始显示
	%% ·可显示时，不能参与完成活动，要真正开始时才能正常参与活动
	%% ·真正开始是根据【sevOpenLimit、startTime、endTime】来确定的
	%% ·
	show_start,
	%% 结束后多久结束显示
	%% 1：活动结束后一小时不显示
	show_end,
	%% 控制当前活动主接口是否显示出来，还是只显示入口
	%% 1、显示出活动主接口及活动入口
	%% 0、不显示活动主接口，只显示活动入口，且活动入口背景颜色置灰（点击入口时给飘字提示：活动暂未开启）
	%% ·配合【show_start】使用，单独使用无效
	%% ·例如：
	%% show_start配置-12，表示活动提前12小时可见；
	%% Enter_show配置1，表示在这提前12小时时，显示出活动主接口及活动入口；
	%% Enter_show配置0，表示在这提前12小时时，不显示活动主接口，只显示活动入口。
	enter_show,
	%% 作者:
	%% 策划分组用，可将精彩活动分好组，不同组不同入口；不同入口只能看到本组的活动
	%% teamType=0：常规活动，固定在右方
	%% teamType>0：放主界面顶部
	teamType,
	%% 活动下拉列表分组
	%% 将不同的活动ID填在这里，会组成对应的活动下拉列表分组
	%% 转盘类（矩阵寻宝，烟花盛典等）和独立入口的活动此配置无效
	activeGroup,
	%% 活动风格编号
	%% 编号不同将调用不同的预支
	%% 没有多风格的活动默认填0
	style,
	%% 活动拍脸弹窗类型
	%% 1、每次登录弹窗
	%% 2、每日登录弹窗
	%% 配置0时，表示不拍脸；
	%% ·每次登陆弹窗时，有以下规则：
	%% 功能写死：活动的每次登录拍脸： 1天各时段内只弹1次  5-12点，12-18点，18-24点，0-5点；
	%% ·同一个活动只能配置一种类型的弹窗
	%% ·同一个活动弹窗类型中进行判断
	%% ·额外关联规则，备注：活动单次弹出上限：全局表配置控制，UIPushLmit【globalSetup_13_VIP和商业化】.
	%% 整体规则：
	%% 1、前提：当前生效活动中判断
	%% 2、先判断弹出类型
	%% 3、在相同的弹窗类型中判断弹窗优先级
	%% 4、有弹窗优先级配置的活动，根据VIP区间判断是否会有该活动的弹窗
	%% 5、单次，弹窗的数量上限受到全局表控制
	uIPushType,
	%% 活动拍脸逻辑，允许配置多个活动拍脸
	%% --------------
	%% （拍脸优先级，VIP等级下限，VIP等级上限）
	%% ·配置0时，表示不拍脸；
	%% ·在当前生效的活动中判断拍脸；
	%% ·拍脸优先级：配置参数大于0时，按照参数从小到大的顺序拍脸，数值越小优先级越高；
	%% ·VIP等级下限，VIP等级上限：区间取等，在该VIP区间内的玩家才会有该活动的拍脸；
	uIPush,
	%% 主界面活动icon
	iconID,
	%% 主接口活动icon上是否挂特效
	%% 1、挂特效
	%% 0、不挂特效
	iconID_Show,
	%% 主界面活动icon上是否挂角标
	%% 0、不挂角标
	%% 1、角标“限定”，00_YYHD_Tag1
	%% 2、角标“聯動”，00_YYHD_Tag2
	iconID_Mark,
	%% 活动接口下方底条功能图标icon
	menuID,
	%% bannerID
	pic,
	%% 活动入口列表中，活动底板资源ID
	listpic,
	%% 是否个人活动
	%% 1、是，是个人活动时需要判断该活动由什么功能开启，由[ActiveBase2_1_个人活动入口]表判断
	%% 2、否，为全服活动
	activeType,
	%% 活动类型：
	%% 100为版本公告
	%% 1达成类活动（PromotionReachBase_1_达成条件活动）
	%% 2公会骑士团
	%% 3问卷调查
	%% 4荣耀献礼
	%% 5限时特惠
	%% 6无尽宝藏
	%% 7觉醒狂欢
	%% 8BOSS首杀
	%% 9、ActiveRoulette1_1_普通转盘
	%% 10、ActiveRoulette2_1_排行榜转盘
	%% 11、ActiveRoulette3_1_聚宝盆转盘
	%% 12、ActiveRoulette4_1_迷宫
	%% 13、ActiveRoulette5_1_矩阵寻宝
	%% 14、捐献活动
	%% 15、寒风森林
	%% 16、天神秘宝
	%% 17、直购活动1（DirectPurchaseSummary1_1_直购1）
	%% 18、直购活动2（DirectPurchaseSegmented1_1_直购2）
	%% 19、任意充（ArbitraryCharge1_1_任意充）
	%% 20、龙神殿((DragonTempleBase_1_龙神殿)
	%% 21、盛典(GrandCeremonyBase_1_盛典)
	%% 22、光荣战纪（D2荣耀龙徽）
	%% 23、道具兑换活动（ItemExchangeBase_1_道具兑换基础）
	%% 24、ContinuousRecharge1_1_连充豪礼(带展示)
	%% 25、活动特权周卡(ActivityWeeklyCard_1_活动周卡)，独立入口。
	%% 26、悬赏
	%% 27、招财猫
	%% 28、幸运钻石转盘[LuckyDiamondTurntable_1_幸运钻石转盘]
	%% 29、鸿运当头钻石[SuperLuckyTurntable_1_鸿运当头转盘]
	%% 30、云购
	%% 31、消费排名奖励
	%% 32、天命大转盘（Tianmingchoujiang1_1_天命转盘基础）单独活动入口
	%% 33、自选直购（DirectPurchaseSelect1_1_自选直购）
	typeID,
	%% 活动对应ID
	%% 活动对应的分表的活动ID，当需要根据世界等级或者服务器开服时间区别时，填写WorldGrade字段或者是Recharge字段
	%% 三个字段只填写其中一个
	activeID,
	%% {世界等级，对应ID}
	%% 活动对应ID：活动对应的分表的活动ID
	%% 如：TypeID填1，这里填{0,1001}|{101,1002}，则表示：
	%% 世界等级0-100级时取【达成类活动 表ID 1001】，世界等级1>=101级时，取值【RouletteA 表ID 1002】
	%% 世界等级超出配置的最大世界等级时，按照配置的最大等级对应的ID来取值.
	%% 特殊世界等级要求需要先确认能否在这里取值，比如：恶魔之海要求联服最大世界等级，在这里就取不到
	worldGrade,
	%% “ServerID字段的服务器”在该时间段内开服的服务器才生效该活动.
	%% （参数1，参数2，参数3，…，参数12，参数13）
	%% 参数1--参数12：代表开服时间区间段，精确到秒；
	%% 参数13：指[WorldGrade]或[TypeID]字段的“对应ID”.即具体活动ID
	%% 如果参数13：全部填0，表示“该开服时间区间段内的服务器不生效该活动，活动不会出来，且剩下的服务器根据之前的逻辑正常判断是否出现该活动”.
	%% 如果参数13：部分填0且有非0的，表示“填0的那组时间区间内的服务器不生效该活动，且其他非0的根据“参数13的ID”推送该活动.
	%% 如果参数13：都不填0，则为正常的“对应ID”，判断服务器开服时间推送对应ID的活动.
	%% 1.  (2019,4,17,0,0,0，2019,4,30,23,59,59，0）|(2019,5,17,0,0,0，2019,5,30,23,59,59，0）:
	%% [ServerID]中的服务器在19年4月17--4月30和5月17--5月30开服的服务器不生效该活动，剩下的不在该时间区间开服的服务器根据之前的逻辑正常判断是否出现该活动.
	%% 2.  (2019,4,17,0,0,0，2019,4,30,23,59,59，0）|(2019,5,17,0,0,0，2019,5,30,23,59,59，11431）:
	%% [ServerID]中的服务器在19年4月17--4月30开服的服务器不生效该活动，且在19年5月17--5月30开服的服务器生效“对应ID为11431”的活动，不在此范围内的服务器也不生效该活动.
	%% 3.  (2019,4,17,0,0,0，2019,4,30,23,59,59，11431）|(2019,5,17,0,0,0，2019,5,30,23,59,59，11432）:
	%% [ServerID]中的服务器在19年4月17--4月30开服的服务器生效“对应ID为11431”的活动，在19年5月17--5月30开服的服务器生效“对应ID为11432”的活动,不在此范围内的服务器不生效该活动.
	%% 该字段整体填0，表示此字段没实际作用，走之前的逻辑判断活动的生效情况.
	%% 以下含义之后用作其他字段来处理：
	%% 【用于充值区间是否推送该活动的判断
	%% 截止该活动生效时判断，在这个区间内才推送该活动.
	%% 没有此限制填“0”.
	%% 玩家充值区间（最低充值，最高充值）
	%% 最低充值：没限制最低填“0”，单位：钻石；
	%% 最高充值：没限制最高填“0”，单位：钻石.
	%% 例如：
	%% (0,100):没充值、充值金额≤100钻，则推送该活动.
	%% (6,100):6≤充值金额≤100，则推送该活动.
	%% (6,0):6≤充值金额，则推送该活动.
	%% (6,100)|(200,300):6≤充值金额≤100、200≤充值金额≤300，则推送该活动.】
	recharge,
	%% 可见等级
	%% 大于等于此等级才有活动入口
	%% 和可见VIP等级是且的关系
	levelLimit,
	%% 2、活动开启时VIP 1,VIP实时刷新，0，VIP0点刷新
	vIPType,
	%% 可见VIP
	%% 大于等于此VIP等级才有活动入口
	%% 和可见等级是且的关系
	vIPlimit,
	%% 本活动调用【直购活动的ID】，通过该配置判断是否在本活动接口上显示【直购活动的入口】
	%% 显示直购活动入口的条件：本活动和直购活动，需要同服务器的同时间段内都有。
	%% ·配置多个直购活动ID时，本身活动主接口上调用的直购活动依次从配置顺序的从左至右开始调用显示，且只会显示1个。且需要根据同时间段内的活动生效情况判断显示生效的那个。
	%% 例如配置：101|102
	%% 如果当时101和102都生效，那么显示101的入口；
	%% 如果101已过期，102在活动时间内，那么显示102的入口；
	%% 如果101和102都过期了，那么就都不显示。
	%% ·暂时支持调用的直购活动入口的活动有：
	%% 9、ActiveRoulette1_1_普通转盘
	%% 10、ActiveRoulette2_1_排行榜转盘
	%% 11、ActiveRoulette3_1_聚宝盆转盘
	%% 12、ActiveRoulette4_1_迷宫
	%% 13、ActiveRoulette5_1_矩阵寻宝
	%% 14、捐献活动
	%% 16、天神秘宝
	%% （后续有需求再添加其他活动）
	%% ·可支持调用的直购活动有：
	%% 17、直购活动1
	%% 18、直购活动2
	%% （后续有需求再添加其他直购活动）
	directPurchaseID,
	%% 主接口活动入口名称
	teamName,
	%% 英语
	teamName_EN,
	%% 印度尼西亚
	teamName_IN,
	%% 泰语
	teamName_TH,
	%% RU
	teamName_RU,
	%% FR
	teamName_FR,
	%% GE
	teamName_GE,
	%% TR
	teamName_TR,
	%% SP
	teamName_SP,
	%% PT
	teamName_PT,
	%% KR
	teamName_KR,
	%% TW
	teamName_TW,
	%% JP
	teamName_JP,
	%% 活动接口左上角标题文字
	toptitle,
	%% 英语
	toptitle_EN,
	%% 印度尼西亚
	toptitle_IN,
	%% 泰语
	toptitle_TH,
	%% RU
	toptitle_RU,
	%% FR
	toptitle_FR,
	%% GE
	toptitle_GE,
	%% TR
	toptitle_TR,
	%% SP
	toptitle_SP,
	%% PT
	toptitle_PT,
	%% KR
	toptitle_KR,
	%% TW
	toptitle_TW,
	%% JP
	toptitle_JP,
	%% 活动接口底部入口名称
	title,
	%% 英语
	title_EN,
	%% 印度尼西亚
	title_IN,
	%% 泰语
	title_TH,
	%% RU
	title_RU,
	%% FR
	title_FR,
	%% GE
	title_GE,
	%% TR
	title_TR,
	%% SP
	title_SP,
	%% PT
	title_PT,
	%% KR
	title_KR,
	%% TW
	title_TW,
	%% JP
	title_JP,
	%% 活动banner上的说明文字
	desribe,
	%% 英语
	desribe_EN,
	%% 印度尼西亚
	desribe_IN,
	%% 泰语
	desribe_TH,
	%% RU
	desribe_RU,
	%% FR
	desribe_FR,
	%% GE
	desribe_GE,
	%% TR
	desribe_TR,
	%% SP
	desribe_SP,
	%% PT
	desribe_PT,
	%% KR
	desribe_KR,
	%% TW
	desribe_TW,
	%% JP
	desribe_JP,
	%% banner图中的文字
	bannerText,
	%% 英文
	bannerText_EN,
	%% 印度尼西亚
	bannerText_IN,
	%% 泰语
	bannerText_TH,
	%% RU
	bannerText_RU,
	%% FR
	bannerText_FR,
	%% GE
	bannerText_GE,
	%% TR
	bannerText_TR,
	%% SP
	bannerText_SP,
	%% PT
	bannerText_PT,
	%% KR
	bannerText_KR,
	%% TW
	bannerText_TW,
	%% JP
	bannerText_JP,
	%% 活动预告大致奖励说明的飘字文字配置
	%% 如果是【show_start配置-12、Enter_show配置0】，那么该字段配了文字的，则显示上该配置的飘字，没配置文字就不显示。
	%% 和“活动XX后开启”组合成两排进行飘字
	%% 例如：该字段配置“奖励有SSS外显等大奖”
	%% 那么点击时的飘字显示为：
	%%   活动3天后开启
	%% 奖励有SSS外显等大奖
	enter_show_Text,
	%% 英文
	enter_show_Text_EN,
	%% 印度尼西亚
	enter_show_Text_IN,
	%% 泰语
	enter_show_Text_TH,
	%% RU
	enter_show_Text_RU,
	%% FR
	enter_show_Text_FR,
	%% GE
	enter_show_Text_GE,
	%% TR
	enter_show_Text_TR,
	%% SP
	enter_show_Text_SP,
	%% PT
	enter_show_Text_PT,
	%% KR
	enter_show_Text_KR,
	%% TW
	enter_show_Text_TW,
	%% JP
	enter_show_Text_JP
}).

-endif.
