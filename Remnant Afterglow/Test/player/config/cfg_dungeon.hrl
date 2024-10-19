-ifndef(cfg_dungeon).
-define(cfg_dungeon, 1).

-record(dungeonCfg, {
	%% 机关ID
	iD,
	%% 名称的stringid
	name,
	%% 机关名称
	namestring,
	%% 注释列，策划自己看，程序不用
	info1,
	%% 注释列，策划自己看，程序不用
	info2,
	%% 0：玩家阵营
	%% 1：怪物阵营（攻击玩家，也可被玩家攻击，对怪物中立）
	%% 4：机关：对玩家敌对NPC（攻击玩家，但无法被玩家攻击，对怪物中立）
	%% 5：机关：对玩家友方NPC（对玩家友好，对怪物中立）
	%% 6：帮派进攻方：帮派进攻方，对同阵营敌对
	%% 7：帮派防守方：帮派防守方，对同阵营友好
	%% 8：领地建筑非争夺战：对6中立，对7友好
	%% 阵营关系读取CampRelation表
	camp,
	%% 机关类型
	%% 1墓地旗子
	%% 2buff1圈机关
	%% 3领地旗子
	%% 4喷火
	%% 5裂缝
	%% 6铡刀
	%% 7光环
	%% 8地雷
	%% 9罐子
	%% 10宝箱
	%% 11援助机关
	%% 12擂台柱子
	%% 13boss墓碑
	type,
	%% 半径:
	%% 铡刀，光环机关和建筑机关的范围
	%% 宝箱和泉水的触发半径
	range,
	%% 机关模型
	model,
	%% 机关出生的特效
	bornEffect,
	%% 待机时模型上加载的特效
	idleEffect,
	%% 激活后模型性加载的特效
	activeEffect,
	%% 模型缩放
	scale,
	%% 机关生命
	hp,
	%% 机关的技能
	skill,
	%% 泉水的CD（毫秒）
	att_CD,
	%% 激活参数，
	%% 与前面的TYPE对应
	%% 援助机关刷出的怪物id
	%% 光环机关填buffid
	%% buff圈机关填buffid
	active_Param,
	%% 激活类型
	%% 1目标进入视野激活
	%% 2副本创建（延时）激活
	%% 3生命值为0时激活
	active_type,
	%% 激活延时时间（毫秒）
	active_Delay,
	%% 罐子掉钱概率万分比
	guanziDrop,
	%% 货币类型 
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	dropType,
	%% 罐子掉钱最小
	drop_money_min,
	%% 罐子最大掉钱
	drop_money_max,
	%% 罐子和宝箱掉落道具的drop ID
	drop,
	%% 死亡给玩家经验
	die_exp,
	%% 伤害机关的伤害基础数值。服务器在这个数值基础上做5%上下随机浮动
	damage,
	%% 承受伤害
	%% 最小伤害|最大伤害
	takeDamage,
	%% 机关创建出来后一直循环播放的声音。龙卷风，铡刀用这个类型。资源地址Resources\Sounds\SFX\
	sound,
	%% 机关激活时播放的声音。只播放一次。罐子，援助机关，宝箱用这个。资源地址跟前面一样
	activeSound,
	%% 援助机关泡泡文字的id
	bubbleID,
	%% 泡泡文字。策划自己看。
	bubble,
	%% 破碎后开始溶解的时间，单位秒
	dissolveBegin,
	%% 溶解时间，单位秒
	dissolveTime,
	%% 溶解边缘颜色
	dissolveShader
}).

-endif.
