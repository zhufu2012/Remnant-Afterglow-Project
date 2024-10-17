-ifndef(cfg_characterSwitch_hrl).
-define(cfg_characterSwitch_hrl, true).

-record(characterSwitchCfg, {
	%% 职业枚举
	%% 1004为战士，1005为法师，1006为弓手，1007为圣职，其他的暂时没有用
	iD,
	%% 是否开启
	%% 1为开启
	%% 0为没开启
	open,
	%% 激活方式
	%% {激活方式组，条件类型，条件参数1，条件参数2}
	%% 完成一个激活方式组里所有的条件就可以激活。
	%% 条件类型：
	%% 1为等级，参数1代表需求等级
	%% 2为VIP等级，参数1代表需求VIP等级
	%% 3为物品，参数1为道具ID，参数2为道具数量
	%% 4为货币，参数1为货币类型，参数2为货币数量
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
	activationWay,
	%% 重生消耗
	%% {消耗方式组，进阶等级，消耗类型，类型参数，消耗数量}
	%% 消耗一个消费方式组里所有的条件就可以重生。
	%% 若找不到，按最大配置进阶等级的算
	%% 消耗类型
	%% 1为道具消耗，类型参数为道具ID，消耗数量为道具数量
	%% 2为货币消耗，类型参数为货币类型，消耗数量为货币数量
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
	restoreCons,
	%% 根据职业对应的在石板路面移动的特效
	%% 慢跑|快跑
	runVFX,
	%% 根据职业对应的跑步特效文件名
	runVFX_FLY,
	%% 根据职业对应的在石板路面移动的音效，战斗状态
	%% 慢跑|快跑
	runSound,
	%% 根据职业对应的跑步音效文件名，非城里用，战斗状态跑步
	runSound_FLY,
	%% 根据职业对应的跑步音效文件名，城里用（非战斗状态跑步）
	runSoundCity_FLY,
	%% 模型缩放，控制后面模型的缩放比例
	%% 0.1标示10%，包括身体模型、武器模型、变身模型
	modelScal,
	%% 主角不穿衣服不拿武器默认的模型ID
	%% {职业1身体模型,职业1武器模型}
	model,
	%% 主角不穿衣服不拿武器默认的模型ID
	%% {职业1身体模型,职业1武器模型}
	skinModel,
	%% 初始头像ID
	headInit,
	%% 主角不同品质对应的头像ID
	%% {品质，职业1头像}
	headIcon,
	%% 主角勾选高级显示时的装备ID
	%% {职业1铠甲,职业1武器}
	topgear,
	%% 1.攻击
	%% 2.防御
	%% 3.生命
	%% 4.技能
	%% 1-10每个数字代表半星
	vocational,
	%% 1.大圣之路达到对应目标
	%% 2.VIP达到对应等级
	%% 若是1则填写大圣之路对应ID
	%% 2则填写VIP等级
	target,
	%% 麒麟洞旗子偏移和旋转数据
	meleeQizi,
	%% 乘客上载具时分职业播放的特效
	aboardVFX,
	%% 麒麟洞HUD胶囊放大
	meleeHUD,
	%% 初始套装ID
	%% 创角展示不走这里！！走Character_Create的Show_Equip
	equipSuitIndex,
	%% 职业性别，仙侣试炼用
	%% 0 男
	%% 1 女
	%% 2 人妖
	sex,
	%% 职业飞行后的HUD高度偏移
	fly
}).

-endif.
