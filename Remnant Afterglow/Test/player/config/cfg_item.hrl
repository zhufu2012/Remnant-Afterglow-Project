-ifndef(cfg_item_hrl).
-define(cfg_item_hrl, true).

-record(itemCfg, {
	%% 道具杂项目 ID段：1100000-1199999
	%% (配置时根据道具杂项具体类型预留ID依次配置）
	iD,
	%% 道具的昵称
	name,
	%% 道具功能描述
	%% tpos使用
	sDesc,
	%% 道具的显示ICON
	iconPath,
	%% 背包大类型
	%% 50~60 服务器那边做私用，这边不做枚举
	%% 0隐藏背包
	%% 1个人背包
	%% 2个人仓库
	%% 3聚魂背包
	%% 4聚魂已装配背包（存放已装配的灵魂）
	%% 5符文背包
	%% 6符文已装配背包
	%% 7神兽（神祗）装备背包
	%% 8神兽（神祗）装备已穿戴背包
	%% 9玩家装备已穿戴背包
	%% 10玩家已镶嵌宝石背包
	%% 11魔宠装备背包
	%% 12魔宠装备已穿戴背包
	%% 13翅膀装备背包
	%% 14翅膀装备已穿戴背包
	%% 15坐骑装备背包
	%% 16坐骑装备已穿戴背包
	%% 17图鉴背包
	%% 18魔戒穿戴背包
	%% 19套装石背包
	%% 20碎片背包（龙神/魔宠/坐骑/翅膀/圣物等）
	%% 21消耗品背包
	%% 22佩饰背包
	%% 23佩饰已装备背包
	bagType,
	%% 背包筛选
	%% 背包大类型1时。0全部。1装备。2消耗品
	bagType1,
	%% 道具的宏观类型
	%% 1.任务道具
	%% 2.背包道具
	%% 3.英雄卡片（魔宠激活道具）
	%% 4.英雄碎片（魔宠碎片）
	%% 5.英雄装备
	%% 6.装备碎片
	%% 7.战魂
	%% 8.装备
	%% 9.纹章
	%% 10.神石
	%% 11.神石碎片
	%% 12.时装
	%% 13.宝石
	%% 14.时装碎片
	%% 15.坐骑（激活道具）
	%% 16.坐骑碎片
	%% 17.翅膀（激活道具）
	%% 18.翅膀碎片
	%% 19.聚魂道具
	%% 20.符文道具
	%% 21.神灵装备（神兽装备）
	%% 22.新D2-宝石
	%% 23.魔宠装备背包，24坐骑装备背包，25翅膀装备背包，26龙神装备背包
	%% 27.图鉴
	%% 28.魔戒
	%% 29.套装水晶
	%% 30.圣物
	%% 31.圣印
	%% 32.主战龙神（激活道具）
	%% 33.主战龙神碎片
	%% 34.精灵龙神（激活道具）
	%% 35.精灵龙神碎片
	%% 36.龙神武器（激活道具）
	%% 37.龙神武器碎片
	%% 38.龙神秘典
	%% 39.龙神秘典碎片
	%% 40.时装道具
	%% 41.龙神神器碎片
	%% 42.佩饰（海神套装）
	%% 43.神兵（激活、升阶）
	%% 44.神兵碎片
	%% 45.信物碎片
	%% 46.通用外显碎片
	itemType,
	%% 道具的详细类型
	%% ItemType=2（1为普通道具，2为普通礼包，3为货币袋，4为等级货币袋，5为条件宝箱，6为体力丹，7为耐力丹（未使用）,8为免战令牌,9为神石合成材料，10为纹章合成材料，11为英雄经验丹,12人物技能点丹，13选择宝箱，14为星级英雄礼包，15为装备经验石，16为英雄升品材料，17为大圣之路经验丹 18 战盟令 19 建筑材料 20VIP经验礼包 21.BUFF药剂（血瓶）,22.披风升星符，将披风从限制等级提升一级,23.剧情任务完成令,24.坐骑提升星级,25坐骑经验丹,26称号礼包，27图鉴礼包.28头像卡.29角色改名卡.30战盟改名卡31.人物多倍经验丹,32为信息手机道具,33为炼丹辅助材料,34为神兽装备强化道具35-36-37-38经验药水39离线挂机时长道具40经验小鬼41守护仙女42玩家固定经验丹,43玩家动态经验丹,44Buff药水,45疲劳药水,46Boss刷新卡，47神兽拓展卡，48背包格子拓展钥匙，49玩法门票，50关卡扫荡券，51祝福石，52洗炼道具，53坐骑升级道具，54坐骑突破道具，55坐骑精炼道具，56坐骑丹，57坐骑强化石，58坐骑技能解锁道具，59坐骑触发技打造石，60翅膀升级道具，61翅膀突破道具，62翅膀炼魂道具，63翅膀丹，64翅膀强化道具，65翅膀技能解锁道具，66翅膀触发技打造石，67飞翼升级道具，68魔宠升级道具，69魔宠突破道具，70魔宠炼魂道具，71魔宠丹，72翅膀强化道具，73聚魂合成和晋升辅助材料，74符文合成辅助材料，75神灵拓展卡，76宝石精炼道具,77高级宝石合成道具，78圣灵升级道具，79圣灵突破道具，80圣物丹，81龙神升级道具，82龙神秘典觉醒道具，83圣物精炼道具，84表情道具，85神装石，86神装石碎片，87高级洗炼石，88头衔材料，89时装胸甲道具(弃用)，90时装武器道具(弃用)、91时装帽子道具(弃用)、92头像道具(弃用)、93头像框道具(弃用)、94聊天气泡道具(弃用)、95喇叭气泡道具(弃用)，96门票材料，97魔宠装备龙装石，98魔宠装备龙装石碎片，99魔宠装备强化石，100魔宠装备突破石，101坐骑装备龙装石，102坐骑装备龙装石碎片，103坐骑装备强化石，104坐骑装备突破石，105翅膀装备龙装石，106翅膀装备龙装石碎片，107翅膀装备强化石，108翅膀装备突破石，109追加石，110神灵龙装石，111神灵龙装石碎片，112战盟祭祀,113装备强化石,114VIP相关，115兑换券,116假道具材料,117假道具丹药，118假道具装备，119婚戒升级材料，120婚戒淬炼材料，121转职材料，122通行证 增加次数，123等级限制经验丹，124装备碎片，125寻宝道具，126魔戒碎片，127魔戒合成石,128次数限制礼包，129XO房间道具，130饰品升阶石，131饰品碎片，132佩饰升阶石，133直升卡，134结界卡，135小飞鞋，140龙装石，141龙装石碎片，142魂器升级材料，143魂器突破材料，144魂器碎片，145，魂器激活道具，146魂器丹，147海神道具），148骑装神装石，149骑装神装石碎片，150宠装神装石，151宠装神装石碎片，152翼装神装石，153翼装神装石碎片，154神灵装神装石，155神灵装神装石碎片，156海神祝福石，157海神祝福石碎片，158龙印升星石，160海神龙装石，161海神龙装石碎片，162海神神装石，163海神神装石碎片，164海神突破石）
	%% ItemType=3，4（1为战士型，2为技能型，3为刺客型，9为经验）
	%% ItemType=5，6为大圣老装备（1为武器，2为项链，3为护手，4为戒指，5胸甲，6头盔，7腰带，8鞋子）
	%% ItemType=8和29（1武器，2项链，3护手，4戒指，5胸甲，6头盔，7护肩，8鞋子，9护腿，10护符）
	%% ItemType=9(1为技能激活纹章，2为基础强化纹章，3为特殊强化纹章)
	%% ItemType=10
	%% ItemType=11(2为宝石碎片)
	%% ItemType=12（1为武器，2为胸甲）
	%% ItemType=13（1为血攻宝石,2攻防宝石，3血宝石，4攻宝石,9为开孔器）
	%% ItemType=14（1为武器，2为胸甲）
	%% ItemType=19（1为灵魂，2为仙尘，3为灵魂碎片，4为辅助材料）
	%% ItemType=20（1为符文，2为符文经验，3符文精华，4为辅助材料）
	%% ItemType=21（1为神灵装备经验道具，2为王冠，3为戒指，4为面具，5为宝石，6为眼泪,7为项链）
	%% ItemType=22（1攻击宝石，2为防御宝石）
	%% ItemType=23（1短刃，2铭牌，3头甲，4战盔）
	%% ItemType=24（1面甲，2座鞍，3脚蹬，4铁蹄）
	%% ItemType=25（1尾翼，2流羽，3幻彩，4边镶）
	%% ItemType=27（1图鉴升品材料，2图鉴升星/激活材料）
	%% ItemType=28（1麻痹戒指，2治疗戒指，3复活戒指，4护身戒指）
	%% ItemType=3、4、15、16、17、18、30、31，为稀有度0A，1S，2SS，3SSS，
	%% ItemType=40时 1时装胸甲道具，2时装武器道具、3时装帽子道具、4头像道具、5头像框道具、6聊天气泡道具、7喇叭气泡道具
	%% ItemType=42时，1为海王战戟，2为海鲨背鳍，3海妖手套，4为海龙鳞甲，5为海蛇腰带，6为海鲛长靴.
	detailedType,
	%% 进一步细类区分
	%% 如果ItemType=8
	%% （1攻击类装备,2防御类装备
	%% 如果ItemType=21
	%% 1表示通用类，目前神兽装备只有一类
	%% 如果ItemType=22，此列表示宝石品级（1-N级）
	%% ItemType=29，（1普通套装水晶，2完美套装水晶,3高级完美套装水晶，4套装水晶碎片）
	%% 如果ItemType=20，此列表示符文属性
	%% 1.防御 2.攻击 3.生命值 4.破甲 5.命中值 6.闪避值 7.暴击值 8.韧性值 9.装备基础防御万分比 10.装备基础攻击万分比
	%% 11.装备基础生命万分比 12.装备基础破甲万分比 13.攻击命中双属性符文 14.攻击装备基础攻击双属性
	%% 15.破甲暴击双属性 16.破甲装备基础破甲双属性 17.生命闪避 18.生命韧性 19.生命基础防御 20.生命装备基础生命值
	%% 21.防御闪避 22.防御韧性 23.防御基础防御 24。防御基础生命值25追命一击26绝对闪避27追命绝闪双属性
	%% ItemType=30和31（1火、2水、3风、4土）
	%% ItemType=2，DetailedType=78,80时，1火、2水、3风、4土
	%% 很多1、2、3表示小类，不一一描述
	%% ItemType=49、96门票和门票材料，1恶魔广场2诅咒禁地3.个人BOSS
	%% ItemType=2，DetailedType=76时，1攻击宝石精炼（红）。2、防御宝石精炼（率）；
	%% ItemType=27、DetailedType=2时：图鉴稀有度：0为A，1为S，2为SS，3为SSS；
	%% ItemType=2、DetailedType=125时：寻宝道具分类：1装备寻宝，2龙印寻宝，3坐骑寻宝，4神翼寻宝，5魔宠寻宝；
	%% ItemType=2、DetailedType=126时，魔戒分为：1麻痹戒指，2治疗戒指，3复活戒指，4护身戒指
	%% ItemType=2、DetailedType=127时，魔戒石分为：1完美魔戒石，2传奇魔戒石，3传说魔戒石
	detailedType2,
	%% 进一步细类区分
	%% 如果ItemType=8和29时
	%% （1004战士，1005法师，1006弓手）
	%% 如果ItemType=20表示龙印，0普通龙印，1核心龙印
	%% 如果ItemType=21表示战神殿装备
	%% 则1表示1星，2表示2星，3表示3星
	%% ItemType=27表示魔戒星级
	%% 0为0星，1为1星，2为2星，3为3星，4为4星，5为5星，6为6星
	%% ItemType=29表示宝石级别
	%% 1为普通宝石，2为高级宝石
	%% ItemType=2，DetailedType=56、63、71、80时1、2、3表示属性丹的属性类型
	%% ItemType=2，DetailedType=52时，1普通洗炼。2、橙色洗炼3红色洗炼
	%% ItemType=2，DetailedType=76、88时，1初级2中级3高级
	%% 如果ItemType=42表示佩饰装备，0为0星，1为1星，2为2星，3为3星
	detailedType3,
	%% 道具使用类型
	%% 0.为不能使用
	%% 1.为普通礼包
	%% 2.【未使用】为获得货币（UseParam1为货币类型，UseParam2为货币数量）
	%% 3.【未使用】为按等级获得货币（UseParam1为货币类型，UseParam2为货币数量） 实际获得货币数量=UseParam2*玩家等级
	%% 4.为条件宝箱
	%% 5.为获得体力值
	%% 6.【未使用】为获得耐力值（未使用）
	%% 7.【未使用】为获得神器
	%% 8.【未使用】为获得免战时间
	%% 9.【未使用】为获得经验(无效)
	%% 10.【未使用】为获得技能点
	%% 11.为选择宝箱
	%% 12.【未使用】为获得装备经验
	%% 13.【未使用】为获得VIP值
	%% 14.【未使用】为披风进阶符
	%% 返还道具ID：Needitem[Poncho]
	%% 指定披风等级=UseParam2时，披风等级+1,且清空祝福值：
	%% 返回道具数量：=ItemNum[Poncho]*剩余祝福值/Blessing[Poncho](向下取整)
	%% 指定披风等级>UseParam2时,返还一定道具，不清空祝福值：
	%% 返回道具数量：=ItemNum[Poncho]*BlessingValueMax[Poncho]/3/Blessing[Poncho](向下取整)
	%% 15.【未使用】为星级礼包
	%% 16.【未使用】为剧情任务完成令
	%% 17.【未使用】为提升坐骑星级
	%% 将指定星级的坐骑提升1星（物品指定星级为0时,及获得1星该坐骑；星级≥最大星级，则道具无效）
	%% 指定坐骑星级＜该物品指定星级，无法使用
	%% 指定坐骑星级＞该物品指定星级，返回指定坐骑星级对应的NeedItem[MountStar];
	%% 18.称号礼包
	%%    使用获得指定称号，不能重复使用
	%% 19.图鉴选择礼包
	%% 20.【未使用】头像卡, 参数1为头像ID
	%% 21.【未使用】获得一次免费改名机会
	%% 22.【未使用】获得一次修改战盟名字的机会
	%% 23 【未使用】为信息收集道具
	%% 24.聚魂系统灵魂碎片分解
	%% 25.符文系统符文精华分解
	%% 26.跳转到对应功能上,UseParam1为：100000+跳转ID；
	%% 27.玩家固定经验丹,UseParam1为等级，Useparam2为倍数，玩家经验=倍数*ExpDistribution[EXPPowder]（Useparam1等级对应）；
	%% 28.玩家动态经验丹,UseParam1为倍数,玩家经验=倍数*ExpDistribution[EXPPowder]
	%% 29.BUff药水,UseParam1为BuffID(替换与叠加规则是Buff规则,buff叠加时长与叠加时长上限规则)
	%% 30.离线挂机卡(S),UseParam1为增加挂机时长(要超过上限时,不能使用)；
	%% 31.疲劳药水,UseParam1为玩法(1为恶魔入侵,2为战神殿),UseParam2为减少归属奖疲劳次数(没疲劳时不能用)；
	%% 32.Boss刷新卡,玩法(1为恶魔入侵,2为恶魔巢穴,4为战神殿)可叠加,使用时选择当前地图的Boss刷新
	%% 33.VIP正式卡（UseParam1是使用之后增加的时间单位分钟，UseParam2是第一次使用该道具赠送的VIP经验（多次使用不赠送VIP经验））
	%% 34.VIP体验卡（UseParam1是时间，单位分钟，UseParam2是VIP等级）
	%% 35.激活表情包（Usepararm1是表情ID，useParam2是获得钻石数量）
	%% 36.炼金经验石（Useparam1为其提供的炼金经验值）
	%% 37.坐骑激活道具，Useparam1为ID【MountBaseNew_1_基础和模型】；
	%% 38.翅膀激活道具，Useparam1为ID【WingBaseNew_1_基础和模型】；
	%% 39.魔宠激活道具，Useparam1为ID【PetBase_1_基础和模型】；
	%% 40.主战龙神激活道具，Useparam1为ID【DragonBaseNew_1_基础】，其中Type【DragonBaseNew_1_基础】=1；
	%% 41.精灵龙神激活道具，Useparam1为ID【DragonBaseNew_1_基础】，其中Type【DragonBaseNew_1_基础】=2；
	%% 42激活道具，Useparam1为ID【DragonBaseNew_1_基础】，其中Type【DragonBaseNew_1_基础】=4；
	%% 43.圣物激活道具，Useparam1为ID【HallowsBaseNew_1_基础和模型】；
	%% 44.圣印，Useparam1为ID【DHallowsRune_1_圣物圣印基础】；
	%% 45.副本玩法挑战次数增加道具 Usetype=46时 useparam1=共用次数id useparam2=增加次数
	%% 46.等级限制经验丹
	%% 47.次数限制礼包
	%% 48充值卡
	%% 49.VIP经验到XXX
	%% 50.vip时长（VIP0时不能使用）
	%% 51.订阅，周卡，终生卡道具
	%% 52.直升卡
	%% 53.期限使用礼包
	%% 95.时装
	%% 96.为获得主线副本体力值
	useType,
	%% 使用参数1
	%% UseType=0为不可使用
	%% 1为“dropID”改为【DorpBox_1_道具礼包奖励ID】
	%% 2为获得货币类型
	%% 3为获得货币类型
	%% 4为“dropID”改为【DorpBox_1_道具礼包奖励ID】
	%% 5为恢复体力值
	%% 6为恢复耐力值
	%% 7为获得神器的创建ID
	%% 8
	%% 9为获得英雄经验
	%% 10为获得技能点数
	%% 11为选择包ID（SelectItem）
	%% 12为获得装备经验
	%% 13为获得VIP值
	%% 14为对应披风ID（人物ID）
	%% 15为dropID
	%% 17为指定坐骑ID
	%% 18指定称号ID
	%% 19为选择包ID（SelectItem）
	%% 20为头像ID
	%% 26时为跳转的ID，待确定
	%% UseType=31和33和34时为buff id
	%% UseType=32时为具体挂机时长，单位秒
	%% ItemType=2,DetailedType=17 ,提供的大圣之路经验
	%% ItemType=2,DetailedType=18 ,提供的繁荣度值
	%% ItemType=2,DetailedType=19 ,提供升级所需经验值
	%% ItemType=2,DetailedType=21 ,提供调用Buff,ID
	%% ItemType=2,DetailedType=25 ,提供的坐骑经验
	%% ItemType=2,DetailedType=31,额外经验倍数万分比
	%% ItemType=2,DetailedType=33,影响炼丹序号（范围）,0为所有丹药，其他为指定序号
	%% ItemType=3或5或7、8时，此项代表单位资质物品的基础属性的ID（0代表无基础属性）
	%% ItemType=4或6或11或14时，此项代表合成对应的英雄或装备的ID或时装ID
	%% ItemType=8
	%% ItemType=9，此项代表纹章创建ID
	%% ItemType=12，此项代表时装所属人物ID
	%% ItemType=2且DetailedType=8，此项代表免战时间/S
	%% ItemType=13时,宝石或圣印等级
	%% ItemType=16,坐骑碎片对应坐骑ID
	%% ItemType=19,灵魂碎片分解获得仙尘货币类型
	%% ItemType=20,符文精华分解获得符文经验货币类型
	%% ItemType=21,分解获得神兽装备经验数量
	%% ItemType=22,分解获得宝石精炼经验值
	%% [ItemType=27,DetailedType=2]表示：该材料可激活或升星的图鉴的ID
	%% ItemType=42，分解获得佩饰升级经验【分解成道具移到配置表】
	%% UseType=48,充值对应的充值档位rebate表AmmountX字段，X=Useparam1的值
	useParam1,
	%% 使用参数2
	%% UseType=2为获得货币数量
	%% UseType=3为获得货币基础数量
	%% UseType=4为使用该物品所需消耗的物品ID(小于10000为货币ID）
	%% UseType=14为使用该道具对应披风最低的等级
	%% UseType=15为星级礼包最大提升英雄星级
	%% UseType=17为指定坐骑星级，若指定坐骑星级为0则自动使用
	%% UseType=18位指定子渠道才能使用
	%% UseType=23持续时间(S)
	%% UseType=28.增加魔宠进阶经验
	%% UseType=29.增加坐骑进阶经验
	%% UseType=30.增加翅膀进阶经验
	%% ItemType=3或5或7时，此项代表物品的资质
	%% ItemType=6或14，此项代表合成对应的英雄或装备或时装的本身数量
	%% ItemType=9，此项代表可使用的神器类型，0代表全类型，1代表火系（108001001，108002001），2代表水系（108001002，108002002），3代表风系（108001003，108002003）。
	%% ItemType=2,DetailedType=18 ,提供的帮贡
	%% ItemType=2,DetailedType=21 ,该项为使用间隔时间
	%% ItemType=2,DetailedType=31 ,持续时间(S)
	%% ItemType=2,DetailedType=33,丹药的提升概率万分比
	%% 当itemTpye=2的时候， DetailedType=14的时候 
	%% 这里填写对应英雄星级礼包的星数，用于此类物品的tips去读取英雄预览，并且切换到对应的星数预览
	%% ItemType=12，此项代表是否开放时装
	%% 当itemTpye=2的时候， DetailedType=2的时候 :
	%% 0代表随机普通礼包，最小文字tips
	%% 1代表固定普通礼包，显示物品的新UI
	%% 2代表随机包含有英雄、坐骑礼包，最小文字tips(打开此礼包不弹恭喜获得英雄，坐骑）
	%% 3代表固定包含有英雄、坐骑礼包，显示物品的新UI(打开此礼包不弹恭喜获得英雄，坐骑）
	%% UseType=24为分解灵魂获得的仙尘数量
	%% UseType=25为分解符文获得的符文精华数量
	%% 如果ItemType=8，合成用分类：1攻击类装备,2防御类装备，3饰品类装备
	useParam2,
	%% 使用参数3
	%% UseType=4为使用该物品所需消耗的物品数量
	%% UseType=15为星级礼包对应英雄ID
	%% ItemType=3或4,此项代表势力（1为妖，2为仙，3为佛，4为魔，5为第五势力）
	%% ItemType=5或12，该项代表，套装ID
	%% 当itemTpye=2，DetailedType=14这里填写星级礼包对应的英雄ID
	%% ItemType=2,DetailedType=18 ,提供的帮派经验
	useParam3,
	%% 使用参数4
	%% UseType=15为{开启所需对应最低星级,0}
	%% 当itemTpye=5的时候，DetailedType=1或
	%% 当itemTpye=12的时候，DetailedType=1或
	%% 这里填写对应武器模型ID
	%% 当itemTpye=5的时候，DetailedType=5
	%% 当itemTpye=12的时候，DetailedType=2
	%% 这里填写对应身体器模型ID
	%% {职业1ID，职业1模型（武器或者胸甲}|{职业2ID，职业2模型（武器或者胸甲}|。。。
	%% {1001,31001}|{1002,32001}
	%% 职业对应：
	%% 1001、刀剑男
	%% 1002、萝莉女·
	%% 1003、双刀女
	%% 1004、猴子
	%% 1005、江流儿
	%% 当itemTpye=2,DetailedType=14时，{开启所需对应最低星级,0}
	%% 0代表不需要获得该英雄,且该道具自动使用
	useParam4,
	%% 使用时间
	%% 道具在该时间后才能使用
	%% 例如：20141212,既2014年12月12日0点才能使用
	useTime,
	%% 道具叠加上限
	%% 当值不等于1时，堆叠上限无限制
	maxAmount,
	%% 道具单次使用上限
	useMaxCount,
	%% 物品等级，及道具使用最低战队等级
	%% 英雄初始等级
	level,
	%% 道具的出售铜币价格
	%% （货币ID， 价格）
	price,
	%% 道具品质
	%% 0为普通白
	%% 1为优秀蓝
	%% 2为史诗紫
	%% 3为传说橙
	%% 4为神话红
	%% 5为龙
	%% 6为神装
	%% 7龙神装
	character,
	%% 每日使用上限类型
	%% 0为无使用上限类型
	dailyCDType,
	%% 同使用类型每日使用上限
	%% 0为无限制
	dailyCDCount,
	%% 道具使用记录
	%% 0为不记录
	%% 1为记录
	needSaveLog,
	%% 道具掉落提示
	%% 0为不提示
	needBrodCast,
	%% 道具可执行操作
	%% 二进制
	%% 1 不可删除
	%% 2 不可出售
	%% 填3就是包含2和2不可删除且不可出售
	operate,
	%% 道具获得方式
	%% {获得方式，参数1,参数2}
	%% 1详细副本获得，参数1：副本类型；参数2：副本ID
	%% （副本类型：1普通主线 3妖魔来袭 4组队副本 5活动副本 6神器副本 15精英副本）【打开指定副本进入界面，主线副本只留指定难度】
	%% 2商店获得，参数1：商店类型；参数2：商店分页【直接打开对应的商店分页UI】：2_1_1 商城 2_1_3 仙坊 2_3_1 声望商店 2_4_1 战绩商店 2_5_1 战盟商店 2_7_1 荣誉商店 2_9_1 功勋商店 2_10_1 爱心商店  2_1_2VIP礼包商店
	%% 3竞技场获得，参数1：竞技场类型；参数2排名(0代表就竞技场)【直接打开竞技场UI】
	%% 4比武，参数1：比武官职类型【直接打开比武UI】
	%% 5抽卡，参数1：抽卡类型
	%% （抽卡类型：1.普通抽卡 2.高级英雄抽卡3.高级装备抽卡）【直接打开抽卡UI】
	%% 6.世界BOSS，参数1：Boss类型【直接打开世界BossUI】
	%% 9.家园摇钱树【直接】
	%% 10.家园双修【直接】
	%% 12.家园仙船【直接】
	%% 14.充值【弹出是否进入充值界面确认，点击确认再打开】
	%% 18.活动副本（金钱，经验，进阶丹，精炼石等等）【直接】
	%% 19.剧情副本，参数1：副本章节（0代表剧情副本）【打开对应章节的UI】
	%% 21战盟【直接】
	%% 23主线剧情副本章节宝箱
	%% 24精英副本首通奖励
	%% 25精英副本首领掉落
	%% 26参数1没用，大圣之路指定ID-参数2，
	%% 27诛仙
	%% 28夺宝
	%% 29日常
	%% 30战盟祭祀
	%% 31战盟许愿
	%% 32组队试炼协助
	%% 33三界战场
	%% 34战盟副本
	%% 35_0_1领地战抽奖 35_0_2领地战拍卖行（拍卖行配的时候请注意领地界面上开没有）
	%% 36成就
	%% 37首充
	%% 38累充
	%% 39开服嘉年华
	%% 40七天奖
	%% 41精彩活动
	%% 42指定VIP等级赠送跳转VIP界面，参数3配置等级 
	%% 43（没有途径时的预告填充）
	%% 44黄金宝箱
	%% 45钻石宝箱
	%% 46幸运转盘
	%% 47.四海平乱 
	%% 48.威望
	%% 49.荣耀
	%% 50.
	%% 51.神翼石
	%% 52.百鬼夜行
	%% 53.符文塔
	%% 54.神兽岛
	%% 55.魔宠副本
	%% 56.坐骑副本
	%% 57.翅膀副本
	getWay,
	%% 时效性类型
	%% （廖龙用的）
	%% 0为永久
	%% 1为时效
	%% 暂时只有装备与英雄为永久性
	timeType,
	%% 掉在地上的特效
	dropGroundVFX,
	%% 飞行特效
	dropBulletVFX,
	%% 掉在地上同个道具是否堆叠
	%% 0不堆
	%% 1堆
	dropPile,
	%% 装备阶数填写
	%% 只用做客户端显示
	equipLevel,
	%% 品质框的沿边框环绕运动帧动画和扫光帧动画
	characterVFX,
	%% 标识该道具的突出表现特效，层级在最上层 
	importantVFX,
	%% 道具阶数（0-16，原来的阶数显示是STR，增加这个SHORT的）
	order,
	%% 是否是任务道具
	missionJun,
	%% 公告渠道
	%% 填写对应玩法功能ID
	%% 如果填0则不公告
	affiche,
	%% 道具单次使用上限
	useMaxControl,
	%% 宝石用（装备分类枚举
	%% 1.攻击类
	%% 2.防御类
	%% 3.饰品类）
	%% 当道具ItemType=8,分类则用这个
	equipType,
	%% 是否为绑定道具
	%% 1.绑定；0.非绑
	isBindItem,
	%% 极品获得途径
	%% 1、普通礼包
	%% 2、选择礼包
	%% 3、世界boss
	%% 4、死亡地狱
	%% 5、死亡森林
	%% 6、特权BOSS
	%% 7、明日领奖
	%% 8、主线通关
	%% 9、首充
	%% 10、无尽宝藏
	%% 11、觉醒之路
	%% 12、连冲豪礼
	%% 13、限时特惠
	%% 14、寻宝
	%% 15、七日盛典
	%% 16、等级礼包
	%% 17、至尊终身卡
	%% 18、商店
	%% 19、直购礼包
	%% 20.积分兑换
	%% 21.远征（远征内所有产出第途径）
	%% 22、超级英雄塔
	%% 23、快捷合成
	%% 填0为无突出展示
	prominentShow,
	%% 极品获得显示
	%% （类型，参数）
	%% 类型：1.等级
	%% 如果有多种条件配置，则用或的条件限制
	prominentShowLimit,
	%% 道具对应功能id（若功能未开启不可使用道具，且飘字提示功能未开启）
	%% 配0为无限制
	openActionLimit
}).

-endif.