-ifndef(cfg_dragonBaseNew_hrl).
-define(cfg_dragonBaseNew_hrl, true).

-record(dragonBaseNewCfg, {
	%% 神像ID
	iD,
	%% 类型
	%% 1.主战神像
	%% 2.精灵龙
	%% 3.神像秘典
	%% 4.神像翅膀
	%% 5.神像武器
	type,
	%% TransfrommodelID
	tfmId,
	%% 是否生效
	open,
	%% 名字
	name,
	%% 主战神像关联神像翅膀ID，其他神像没有填0
	belong,
	%% 激活方式
	%% 1.神器激活
	%% 2.道具激活
	%% 3.副本激活
	activation,
	%% 是否弹出快捷激活
	%% 1.弹出
	%% 0.不弹出
	%% 只有道具激活的可配置弹出
	quick,
	%% 激活消耗道具
	%% 1.神器激活填写对应神器道具ID和数量，排序按照顺序排
	%% 2.道具激活填写所需道具和数量
	%% 3.道具激活填写所需的道具和数量
	consume,
	%% 获得重复神像或者神像武器时，对应分解成的道具和数量
	%% {道具ID，数量}
	%% Type=1、2时，为重复获得神像时分解成的道具数量；
	%% Type=4时，为重复获得神像武器时分解成的道具数量；
	%% 其他无效，填“0”
	recount,
	%% 神器激活属性奖励
	%% {属性类别，属性值}
	%% 顺序需对应前面顺序
	attribute,
	%% 神像激活获得属性
	attribute2,
	%% 神像激活神器道具ID仅用于客户端读取名字
	%% 道具ID,tips缩放百分比
	%% 位置根据填写顺序判定，需要和Equipment字段匹配。非神器激活以外的此处填哦
	artifact,
	%% 激活神器的特效路径
	%% 位置根据填写顺序判定，需要和Equipment字段匹配
	effect,
	%% 为了共用方便，单独配置镜头资源
	equipmentCinematicsResName,
	%% 资源中的镜头名字
	equipmentCinematicsPath,
	%% 为了共用方便，单独配置镜头资源
	godCinematicsResName,
	%% 激活时的初始星级，没有星级的填0 
	baseStar,
	%% 神像/神像神像翅膀对应模型ID
	mode1,
	%% 神像神像翅膀对应模型ID（无翅膀）
	mode2,
	%% 激活增加技能iD
	sKIll,
	%% 神像初始技能（不需替换的)
	%% (技能ID1,学习位1)|(技能ID2,学习位2)
	%% 学习位:为0时不可直接获得
	%% 7为神像怒气技
	%% 9为神像普攻
	%% 10为神像技能1
	%% 11为神像技能2
	%% 113为神像技能3
	%% 12为神像公用技能(变身后可用)
	skillInit,
	%% 获取是否走马灯公告
	%% 0为不开放
	%% 1为开放
	notice,
	%% 神像界面进场动画音效
	enterSound,
	%% 神像show时的音效
	showSound,
	%% 未激活状态音效
	unShowSound,
	%% 神像界面待定动作循环音效
	idelSound,
	%% 神像奔跑时的音效
	runSound,
	%% 激活神像时的条件
	activate_Info,
	%% 当前可激活神器的标识光柱的特效路径
	activeEffect,
	%% 排序字段
	orderId,
	%% 神像人形态预览音效
	willSeeVoice,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 该神像圣装激活影响的下一位神像ID
	influence
}).

-endif.
