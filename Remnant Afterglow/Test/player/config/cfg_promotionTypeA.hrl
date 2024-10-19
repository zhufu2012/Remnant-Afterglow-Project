-ifndef(cfg_promotionTypeA_hrl).
-define(cfg_promotionTypeA_hrl, true).

-record(promotionTypeACfg, {
	iD,
	%% {条件类型，目标，附加参数}
	%% 条件类型枚举：
	%% 1  等级(不能配置多次领取)
	%% 2.累计充值
	%% 3.消耗元宝
	%% 4.单次充值(不能配置多次领取)
	%% 5.参与次数 竞技场
	%% 9.参与次数 炎魔试炼
	%% 13.精英副本次数
	%% 18. 累计充值天数，每天至少【附加参数】钻石(不能配置多次领取)
	%% 19 累计登陆天数(不能配置多次领取)
	%% 20.参与剧情副本次数
	%% 21.参与永恒战场次数
	%% 23 参与转盘次数
	%% 32 日常活跃度达到X(不能配置多次领取)
	%% 33 在线时长达到X分钟(不能配置多次领取)
	%% 34 使用指定道具次数：{34，次数，道具ID}
	%% 35 参与次数 魔龙洞窟
	%% 36 参与次数 护送魔晶
	%% 37 血色争霸
	%% 40 巅峰3V3参与次数
	%% 43参数圣物材料副本次数
	%% 44情侣2V2次数
	%% 46消耗元宝（仅非绑）
	%% 49达到积分领取奖励，目标：积分值；参数：0 （特殊：对应活动积分馈赠使用）(不能配置多次领取)
	%% 50 击杀恶魔入侵boss数量 
	%% 51 约会次数 
	%% 52 聚宝盆抽奖次数
	%% 55 参与恶魔入侵或恶魔深渊次数
	%% 56 神魔战场次数
	%% 57 情侣试炼次数
	%% 58 世界boss
	%% 59 举办婚礼次数
	%% 60 参加婚礼次数
	%% 61 参加翅膀材料本次数
	%% 62 赏金任务完成次数
	%% 63 战盟任务完成次数
	%% 64 参加宠物材料本次数
	%% 65 参加坐骑材料本次数
	%% 66 参与龙王宝库次数
	%% 67 参与翅膀材料本次数
	%% 68 参与精英副本次数
	%% 69 参与矮人宝藏/精灵宝藏次数
	%% 70 参与龙神秘典副本次数
	%% 71 参与龙神塔次数
	%% 72 参与恶魔巢穴次数
	%% 73 参与个人BOSS次数
	%% 74 参与诅咒之地次数
	%% 76 参与守卫战盟次数
	%% 77 参与王者1V1次数
	%% 78 献花次数
	%% 93 创建战盟
	%% 94 任命执法者
	%% 95 任命2个副盟主
	%% 96 战盟成员达到30人
	%% 97 战盟等级达到2级
	%% 98 战盟等级达到3级
	%% 99 恶魔入侵210级地图boss击杀次数（全局配置bossID）
	%% 100 恶魔入侵260级地图boss击杀次数（全局配置bossID）
	%% 101 恶魔巢穴V4地图boss击杀次数（全局配置bossID）
	%% 102 恶魔巢穴V5地图boss击杀次数（全局配置bossID）
	%% 103 恶魔巢穴V7地图boss击杀次数（全局配置bossID）
	%% 104 诅咒禁地boss击杀次数（全局配置bossID）
	%% 105 世界boss击杀次数（全局配置bossID）
	%% 106 天空霸主战盟的盟主
	%% 107 天空霸主战盟的执法者
	%% 108 天空霸主战盟的成员
	%% 109 参与战盟联赛的其他战盟成员
	%% 110 装备寻宝
	%% 111 龙印寻宝
	%% 112 坐骑寻宝
	%% 113 魔宠寻宝
	%% 114 翅膀寻宝
	%% 119 可配置地图的恶魔入侵枚举
	%% 120 个人boss全服首杀计数
	%% 121 XO大作战次数
	%% 122 烟花盛典转盘计数
	%% 123 恶魔深渊计数
	%% 124 深渊之海副本次数
	%% 125 巅峰寻宝次数
	%% 126 龙神副本次数
	%% 127 探宝矩阵次数
	%% 201 活动期间：翅膀升级次数
	%% 202 活动期间：翅膀升星次数
	%% 203 活动期间：翅膀觉醒次数
	%% 204 活动期间：翅膀炼魂次数
	%% 205 活动期间：翅膀嗑丹次数
	%% 206 活动期间：翼灵升级次数
	%% 207 活动期间：飞翼升级次数
	%% 208 活动期间：坐骑升级次数
	%% 209 活动期间：坐骑升星次数
	%% 210 活动期间：坐骑觉醒次数
	%% 211 活动期间：坐骑炼魂次数
	%% 212 活动期间：坐骑嗑丹次数
	%% 213 活动期间：兽灵升级次数
	%% 214 活动期间：宠物升级次数
	%% 215 活动期间：宠物升星次数
	%% 216 活动期间：宠物觉醒次数
	%% 217 活动期间：宠物炼魂次数
	%% 218 活动期间：宠物嗑丹次数
	%% 219 活动期间：魔灵升级次数
	%% 220 活动期间：装备强化次数
	%% 221 活动期间：装备追加次数
	%% 222 活动期间：装备洗练次数
	%% 223 活动期间：装备炼金次数
	conditions,
	%% 群组
	%% (编号，排序ID，达成后是否显示）
	%% 编号：同一个区群组使用同一个编号
	%% 排序ID：同一个群组中，当前一个排序ID的条件还未达成时，后一个排序ID的添加不会显示出来，排序ID可以多个相同，相同则表示前一个排序ID条件达成时，一起显示出来
	%% 达成后是否显示：0表示即使条件已经达成，但是前一个排序ID没有达成时，不显示任务；1表示条件达成后，无视前一个排序ID是否达成，都显示出来
	%% 龙神神殿活动中，最终大奖的达成显示配置为2
	group,
	%% VIP等级可见限制
	%% 如果达成条件不满足，则需要满足VIP等级后才可见具体的达成列表
	%% 如果达成条件以满足，则无视VIP等级限制，直接可见对应列表，而且还下一级达成条件
	vIPlimit,
	%% 作者:
	%% {类型，参与次数}
	%% 0：无限制
	%% 1：每日限制
	%% 2：活动期间达成（针对不可逆的条件，比如：等级，活动中只完成一次）
	%% 3:活动期间反复可达成（龙神神殿使用）
	%% 慎用类型1，目前类型1只限制了每天的领取次数，但没有重置达成的进度。这个以后优化
	%% 类型1一般只在售卖物品的活动中使用
	%% {1,0}表示每日不限次数
	%% 显示文字：
	%% 1：YYHD_DesXX_2(每……)
	%% 2：YYHD_DesXX_0(活动内……)
	limit,
	%% 作者:
	%% 单次获得积分
	score,
	%% 作者:
	%% 奖励物品
	%% {序号，职业，类型，ID，数量，品质，星级，是否绑定，是否显示转圈特效是否装备}
	%% 序号，从1开始，选择性，序号填不一样的
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 是否显示转圈特效：1.显示  0.不显示
	%% 注：显示的前后顺序，按照配置的顺序
	%% 做好后“coin、item”两字字段删除
	itemNew,
	%% 龙神神殿界面奖励模型的参数配置
	%% （职业，模型ID，缩放，位置X,位置Y，位置Z,旋转X，旋转Y，旋转Z）
	%% 缩放：100表示缩放的100%
	model
}).

-endif.