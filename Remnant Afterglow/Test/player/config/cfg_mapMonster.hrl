-ifndef(cfg_mapMonster_hrl).
-define(cfg_mapMonster_hrl, true).

-record(mapMonsterCfg, {
	%% 只有副本生效
	%% 地图id
	%% 2开头7位数id
	%% 详情见数值表id分段
	iD,
	%% 当前波数
	born,
	%% 同一编组的优先级
	%% 优先级越低，怪物数值难度配置越低，初始为1
	selectMonsterPriority,
	index,
	%% (触发类型,时间毫秒)
	%% 类型1：普通触发方式。第1波进入地图触发，非第1波在上波死完后触发。类型为1时参数2配置为上波死完之后延迟时间触发。
	%% 类型2：时间触发，副本开始后指定时间触发这波。类型为2时参数2配置为副本时间。
	bornTrigger,
	%% 同波不同分组之间的刷怪间隔时间（毫秒）
	bornCD,
	%% 0不显示提示消息，1显示波数提示消息，2不显示提示消息，显示boss来袭特效并切换为boss音乐
	bornTips,
	%% 作者:
	%% 刷怪。在一波里将怪物分组。同波数里按顺序一组一组的刷，有间隔时间。(组号,怪物id,怪物x坐标,怪物z坐标,朝向)|(组号,怪物id,怪物x坐标,怪物z坐标,朝向)
	monster
}).

-endif.
