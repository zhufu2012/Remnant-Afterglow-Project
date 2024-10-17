-ifndef(cfg_buff_hrl).
-define(cfg_buff_hrl, true).

-record(buffCfg, {
	%% ID
	%% 300000000-? 一些特点BUFF
	%% 400000000-? BOSS_AI调用BUFF
	iD,
	buffInfo_CeHua,
	%% 名称
	name,
	%% 描述
	buffDescribe,
	%% 是否在界面底部显示Buff描述
	%% 0：不显示
	%% 1：显示
	buffDescribeIsVisable,
	%% 是否在全部地图都显示Buff特效
	%% 0：否
	%% 1：是
	buffVfxBymAllMap,
	%% 特效路径文件名
	%% 多个特效用 |分开
	buffVfx,
	%% buff出现时的音效路径文件名|延迟毫秒|播放速度
	%% 多个特效用 ,分开
	buffSound,
	%% buff消失时的音效路径文件名||延迟毫秒|播放速度
	%% 多个特效用 ,分开
	buffOverSound,
	%% 特效缩放
	%% 有多少个特效就填多少个值，用|分开  
	%% 例如 1.0 | 1.2
	vfxScal,
	%% 特效绑定点
	%% 头顶 slot_head01
	%% 颅腔内部 slot_head02
	%% 左眼 slot_eyeL01
	%% 右眼 slot_eyeR01
	%% 肩部（左） slot_shoulderL01
	%% 肩部（右） slot_shoulderR01
	%% 肘部（左） slot_elbowL01
	%% 肘部（右） slot_elbowR01
	%% 手腕（左） slot_wristL01
	%% 手腕（右） slot_wristR01
	%% 胸部（命中） slot_hit
	%% 腹部（骨盆中间位置） slot_abdomen01
	%% 背部（翅膀） slot_wing01
	%% 膝盖（左） slot_kneeL01
	%% 膝盖（右） slot_kneeR01
	%% 脚（左） slot_footL01
	%% 脚（右） slot_footR01
	%% 原点 slot_origin
	%% 左手臂挂盾 slot_wristLD01
	%% 挂武器点左手 slot_handL01
	%% 挂武器点右手 slot_handR01
	%% 特殊需求点01 slot_effect01
	%% 特殊需求点02 slot_effect02
	%% 特殊需求点03 slot_effect03
	buffVfxSlots,
	%% 0 不是头顶
	%% 1 头顶
	vfxIsOnHead,
	%% BUFF的ICON ID
	bUFF_ICON,
	bUFF_ICON2,
	%% 图标特效优先级
	%% 分为敌方和自身
	%% 数值越大越优先显示,同级优先显示最后获得的
	%% 自身优先级|敌方优先级
	iconVfxpriority,
	%% ：-define(Buff_Type_BUFF, 0).   %%增益
	%% ：-define(Buff_Type_DEBUFF, 1).  %%减益
	%% ：-define(Buff_Type_OTHER, 2).  %%其他
	%% 显示位置、消除增益、减益BUFF时候用
	type,
	%% BUFF技能详细分类
	%% 1:增益属性效果
	%% 2:增益恢复效果(HOT)
	%% 3:减益属性效果
	%% 4:减益伤害效果(DOT)
	%% 5:清除BUFF/DEBUFF类
	%% 6:硬控类（受控制减免影响）
	%% 7:软控类（不受控制减免影响）
	%% 8:BOSS虚化
	%% 9:盾类
	%% 100:其他
	typeSubclass,
	%% BUFF第三层分类
	%% 1.属性增益
	%% 2.属性减益
	%% 3.吸收盾
	%% 4.反伤盾
	%% 5.治疗盾
	%% 6.无敌
	%% 7.灼烧
	%% 8.中毒
	%% 9.流血
	%% 10.晕眩
	%% 11.定身
	%% 12.减速
	%% 13.沉默
	%% 14.锁足
	%% 15.虚化
	%% 16.魅惑
	%% 17.恐惧
	%% 18.清除BUFF
	%% 19.清除DEBUFF
	%% 20.HOT
	%% 21.嘲讽
	%% 22.支配
	%% 23.致盲
	%% 100.其他
	%% 216：断筋
	%% 217：碎骨
	%% 226：破绽
	%% 242：缚足
	typeMinSubclass,
	%% 是否可见(1可见，0不可见)
	%% 是否在buff栏位显示
	%% 不可见BUFF也需要广播
	%% 用于管理是否可被清除Buff清除
	canBeenVisable,
	%% buff组
	%% 同组，高级替换低级并刷新，低级不替换高级，同级刷新时间
	%% 不同组共存
	%% 10000-10999 系统产生给予玩家的，不与玩家冲突
	%% 11000-11999 系统产生给予怪物的
	%% 20000-------- 技能BUFF
	groupID,
	%% BUFF满时优先删除优先级低的BUFF
	%% 数字越小优先级越低
	priority,
	%% 同组的buff，不同的buff的释放者
	%% buff是否共存。
	%% 0  不共存
	%% 1  共存
	diffCasterKeep,
	%% 是否强制替换同组BUFF
	%% 1 强制替换
	%% 0 非强制替换,按等级替换
	replace,
	%% 等级
	level,
	%% BUFF_1创建BUFF概率
	createRate,
	%% 创建时动作,主要用于多BUFF效果联合使用
	%% 可填写多个动作,用"|"分隔
	%% 0:无动作         0
	%% 1:执行新技能　{1,技能ID}
	%% 2:执行新BUFF  {2,BUFFID}
	%% 3:移除BUFF     {3,BUFFID,是否包含不可见BUFF,移除数量},用于子母BUFF
	%% 4:移除BUFF     {4,BUFF type,是否包含不可见BUFF,移除数量}
	%% 5:移除BUFF     {4,BUFF typeSubclass,是否包含不可见BUFF,移除数量}
	createAction,
	%% buff可以堆叠的层数，默认为1 
	maxLayoutNum,
	%% BUFF持续总时间,次数移除与时间移除,谁触发则移除
	allLastTime,
	%% BUFF触发机制
	%% 1. 时间有效触发:             创建时触发,持续时间内有效
	%% 2. 时间间隔触发:             时间间隔有效,每隔固定时间触发
	%% 3. 受到伤害触发:             BUFF携带者受到伤害时触发
	%% 4. 造成伤害触发:             BUFF携带者造成伤害后触发
	%% 5. 造成暴击触发:             BUFF携带者造成暴击后触发
	%% 6. 伤害被格挡触发:         BUFF携带者造成伤害被格挡后触发
	%% 7. 被暴击触发:                 BUFF携带者受到伤害为暴击时触发
	%% 8. 格挡伤害触发:             BUFF携带者格挡时触发
	%% 9: 生命低于万分比触发: 生命值低于万分比时触发(triggerRate为生命万分比概率,触发概率100%)
	%% 10：
	%% 11:攻击时触发:               BUFF携带者攻击时(伤害结算前触发)
	%% 12:被攻击时触发:           BUFF携带者被攻击时触发(伤害结算前触发)
	%% 13：释放技能并造成伤害时触发： BUFF携带者新释放一个技能且该技能造成伤害
	%% 触发1次,可触发次数-1
	triggerType,
	%% 触发参数
	%% 触发概率，万分比
	triggerRate,
	%% BUFF可触发总次数
	%% 填X就可触发X次,0为无次数限制
	allLastCount,
	%% BUFF触发间隔时间
	singleTime,
	%% 0 第0秒不起作用
	%% 1 第0秒起作用
	%% 在时间类触发下有效
	%% （时间有效及时间间隔都需要填，时间有效必填1）
	isStart,
	%% 是否受 属性加成与属性减免影响
	%% 0 不受影响
	%% 1 受影响
	%% PS:当前版本无此字段属性
	isAdditionLastTime,
	%% buff效果类型
	%% 1. 改变属性                            effectTypeParam:{属性类型,固定值,万分比}|{属性类型,固定值,万分比}
	%% 2. 伤害                                effectTypeParam:0
	%% 3. 治疗                                effectTypeParam:0
	%% 4. 晕眩（不可攻击、不可移动）           0
	%% 5. 定身（不可攻击、不可移动）           0
	%% 6. 虚化（不可选中、不可攻击）           0
	%% 7. 沉默/缴械/迟缓                               {skillType类型}
	%% 8. 恐惧（向后转身逃跑，随机移动，不可攻击）        0
	%% 9. 无敌（不可受伤）                     0
	%% 10.使用技能                            {技能ID,概率}
	%% 11.伤害转治疗(触发机制必须为受到伤害)   {固定治疗,伤害转化万分比,吸收伤害万分比}
	%%     治疗=原始伤害*伤害转化万分比+固定治疗
	%%     吸收伤害A=原始伤害*吸收伤害万分比
	%% 12.吸收伤害盾   {固定吸收,属性类型,属性转化万分比,每次吸收万分比}
	%%     盾可吸收伤害=固定吸收+某属性类型值*属性转化万分比
	%%     盾每次吸收值=原始伤害*每次吸收万分比 
	%%     PS:实际受到伤害=max(原始伤害-(吸收伤害A+盾每次吸收值),0)
	%% 13.反伤盾       {固定反伤,反伤万分比}
	%%      反射伤害=固定反伤+基础伤害*反伤万分比
	%%      基础伤害为非暴击非格挡下的伤害
	%% 14.清除BUFF    {groupID,是否可清除未显示BUFF}           
	%% 15.清除BUFF    {type,是否可清除未显示BUFF}               
	%% 16.嘲讽        
	%% 17.变身        {模型ID}
	%% 18.清除BUFF    {typeSubclass,是否可清除未显示BUFF}
	%% 19.清除BUFF    {typeMinSubclass,是否可清除未显示BUFF}
	%% 20.支配（改变阵营）          0
	%% 21.魅惑 （不可攻击）                   effectTypeParam:降低移动速度比例
	%% 22.致盲 （不可命中）                   0
	%% 23.禁锢（不可选中、不可攻击、不可移动）  0
	%% 24.狂怒                          {自身某属性百分比伤害值，属性类型}
	%% 25.固定治疗                        effectTypeParam:0
	%% 26.免疫BUFF(并且清除身上所有该类型) {type,数量,是否可清除未显示BUFF}
	%% 29.怒气恢复    {恢复怒气值}
	%% 30.变身        {变身ID}
	%% 31.CD缩短      {技能类型，CD固定值,CD万分比}|{技能类型，CD固定值,CD万分比}
	%%                 新CD=原CD*（10000+CD万分比)/10000+CD固定值
	%% 32.冰冻(晕眩）        0
	%% 33.固定伤害盾（护盾每次只能收到1点伤害） ，{护盾血量}
	%% 34.追击
	%% 35.被追击
	%% 36.红名Buff
	%% 是否可清除未显示BUFF
	%% 0:不清除未显示BUFF 
	%% 1:清除未显示BUFF
	effectType,
	%% 效果参数
	%% {类型,固定值,万分比}
	%% 终值=原始值*万分比+固定值
	%% 属性类型,多个用|隔开举例：{1,200,0}|{2,100，0}|{3,130,500}
	%% 不能修改万分比的属性万分比填0
	%% 属性类型
	%% 2:生命值
	%% 3:生命值修正
	%% 4:击中生命恢复
	%% 5:击中生命恢复比（万分比）
	%% 6:治疗效果比（万分比）
	%% 7:被治疗效果比（万分比）
	%% 8:魔力值
	%% 9:魔力恢复每秒恢复值
	%% 10:霸体值
	%% 11:霸体恢复，每秒恢复值
	%% 12:硬直
	%% 13:硬直抵抗
	%% 14:伤害强度
	%% 15:防御强度
	%% 16:基础伤害加深
	%% 17:基础伤害减免
	%% 18:真实伤害
	%% 19:真实防御
	%% 20:火焰元素强度
	%% 21:冰冻元素强度
	%% 22:雷电元素强度
	%% 23:火焰元素防御
	%% 24:元素防御
	%% 25:雷电元素防御
	%% 26:暴击值
	%% 27:抗暴值
	%% 28:暴击伤害
	%% 29:格挡值
	%% 30:格挡抗性
	%% 31:格挡减免
	%% 32:沉默值
	%% 33:沉默抗性
	%% 34:晕眩值
	%% 35:晕眩抗性
	%% 36:减速值
	%% 37:减速抗性
	%% 38:冻结值
	%% 39:冻结抗性
	%% 40:控制加成
	%% 41:控制减免
	%% 42:移动速度
	%% 43:元素伤害加成
	%% 44:元素伤害减免
	%% 45:最终伤害加成
	%% 46:最终伤害减免
	%% 47:对妖造成的最终基础伤害加成万分比
	%% 48:对仙造成的最终基础伤害加成万分比
	%% 49:对佛造成的最终基础伤害加成万分比
	%% 50:对魔造成的最终基础伤害加成万分比
	%% 51:对無造成的最终基础伤害加成万分比
	%% 52:妖对自己造成的最终基础伤害减免万分比
	%% 53:仙对自己造成的最终基础伤害减免万分比
	%% 54:佛对自己造成的最终基础伤害减免万分比
	%% 55:魔对自己造成的最终基础伤害减免万分比
	%% 56:对無自己造成的最终基础伤害减免万分比
	%% 57:鼓舞：提供给目标自身生命，攻击，防御的万分比
	%% 58:鼓舞时间：变身的持续时间S被提供鼓舞的时间
	%% 59:休整：离场时，每秒恢复的生命上限的万分比
	%% 60:休整时间：休整状态持续的时间
	effectTypeParam,
	%% 1：附加固定伤害                                                   {1,0,固定伤害}
	%% 2：附加最终对方生命万分比固定伤害（有BUFF影响）{2,0,属性万分比}
	%% 3：附加属性                                                         {3,属性类型,属性值}
	%% 4：附加原自身万分比属性到攻击（无BUFF影响）    {4,源属性类型,万分比}
	%% 5：附加原对方万分分属性到攻击（无BUFF影响）    {5,源属性类型,万分比}
	%% 6：附加最终自身万分比属性到攻击（有BUFF影响） {6，原属性类型,万分比}
	%% 7：附加最终对方万分比属性到攻击（有BUFF影响） {7，原属性类型,万分比}
	%% 该字段整合原技能表AttackAttach，AttributeAttach，RealDamage，SkllAddAttribute字段
	%% 无视防御万分比在现在战斗公式下和附加对方防御属性万分比效果重复，已经取消
	%% 附加固定伤害在现在战斗公式下和附加固定属性效果重复，战斗公式会修改其效果
	addAttribute,
	%% {最小值，最大值}
	%% 普通伤害修正|真实伤害修正|火属性伤害修正|冰属性伤害修正|雷属性伤害修正
	damageFix,
	%% 伤害万分比转换仇恨，对怪产生了100点伤害，填入20000，那么就产生200点仇恨值
	hateDamagePercent,
	%% 1:死亡删除
	%% 2:切换地图删除
	%% 4:下线删除
	%% 8:战斗进场删除
	%% 16:战斗出场删除
	%% --------------------------------------
	%% {删除机制,是否触发移除机制}
	%% 0：不触发移除机制
	%% 1：触发移除机制
	delType,
	%% 离线计时
	%% 0 不及时
	%% 1 计时
	isCountOfflineTime,
	%% 控制能否被消除BUFF的技能移除
	%% 1可以移除
	%% 0不可以 (时间结束或次数结束自动移除)
	%% 举例：关卡开局购买的buff
	canBeOtherDel,
	%% 移除BUFF时,是否触发delAction
	%% {正常移除,非正常移除}
	%% 正常移除包含:时间移除,次数移除
	%% 非正常移除包含:被清除类BUFF移除
	%% 0:不触发
	%% 1:触发
	canBeDoDelAction,
	%% BUFF移除\删除后执行效果
	%% 可填写多个动作,用"|"分隔
	%% 若填写的是移除BUFF,则移除BUFF的delAction将继承触发该delAction的条件(正常移除,非正常移除,delType)
	%% 0:无动作         0
	%% 1:执行新技能　{1,技能ID}
	%% 2:执行新BUFF  {2,BUFFID}
	%% 3:移除BUFF     {3,BUFFID,是否包含不可见BUFF,移除数量}
	%% 4:移除BUFF     {4,BUFF type,是否包含不可见BUFF,移除数量}
	%% 5:移除BUFF     {4,BUFF typeSubclass,是否包含不可见BUFF,移除数量}
	%% 1:包含不可见
	%% 0：不包含不可见
	%% 0：移除所有
	%% n: 最大移除n个
	delAction,
	%% 模型缩放
	bodyScale,
	%% 透明比例
	transparency,
	%% Buff不可作用的对象类型,0代表所有对象类型可附加Buff,任意其他值代表该对象类型不可附加该Buff
	%% 对象类型：
	%% %%物体类型，玩家
	%% -define(Object_Type_Player, 1).
	%% %%物体类型，npc
	%% -define(Object_Type_Npc, 2).
	%% %%物体类型，monster
	%% -define(Object_Type_Monster, 3).
	%% %%物件类型，聊天缓存
	%% -define(Object_Type_Chat, 4).
	%% %%物件类型，信息提示
	%% -define(Object_Type_MessageNotify, 5).
	%% %%物件类型，地图
	%% -define(Object_Type_Map, 6).
	%% %%物体类型，召唤物
	%% -define(Object_Type_Summon, 7).
	%% %%物件类型，采集物
	%% -define(Object_Type_Collection, 8).
	%% %%物件类型，物品
	%% -define(Object_Type_Item, 9).
	%% %%物件类型，红包
	%% -define(Object_Type_Red_Envelope, 10).
	%% %%BUFF类型
	%% -define(Object_Type_BUFF, 11).
	%% %% r_playerbag 记录
	%% %%-define(Object_Type_playerbag, 12).
	%% %% 帮派
	%% -define(Object_Type_Guild, 13).
	%% %% 帮派
	%% -define(Object_Type_GuildApplicant, 14).
	%% %%传送门
	%% -define(Object_Type_Teleporter, 15).
	%% %%队伍
	%% -define(Object_Type_Team, 16).
	%% %%翻牌
	%% -define(Object_Type_PlayerCard, 17).
	%% %%神秘副本
	%% -define(Object_Type_SecretCopyMap, 18).%%区分拥有的神秘副本
	%% %%机关
	%% -define(Object_Type_MachineTrap, 19).
	%% %%奖励
	%% -define(Object_Type_Rewards, 20).
	%% %% 摇钱树
	%% -define(Object_Type_Tree, 21).
	%% %% 双修莲座
	%% -define(Object_Type_Pactice, 22).
	%% %%物体类型，玩家镜像
	%% -define(Object_Type_MirrorPlayer, 23).
	%% %%物体类型，英雄镜像
	%% -define(Object_Type_MirrorHero, 24).
	%% %% 公会仓库 物品ID
	%% -define(Object_Type_GuildBag, 25).
	%% %% 系统公告
	%% -define(Object_Type_Announce, 26).
	%% %%BUFF球
	%% -define(Object_Type_BuffObject, 27).
	%% %% GM留言
	%% -define(Object_Type_GMAsk, 28).
	%% %%房间类型
	%% -define(Object_Type_Room, 29).
	%% %%转盘
	%% -define(Object_Type_Roulette, 30).
	%% %% 镖车
	%% -define(Object_Type_Convoy, 31).
	objectType,
	%% 是否狂暴的
	%% 0：否
	%% 1：是
	%% 狂暴的有狂暴特效
	isBoom,
	%% buff持续时间内变色效果ID
	%% 0不变色
	%% 需要变色填写CharacterShader表的shaderID
	shaderID,
	%% BUFF来源描述，客户端用
	buffFrom
}).

-endif.
