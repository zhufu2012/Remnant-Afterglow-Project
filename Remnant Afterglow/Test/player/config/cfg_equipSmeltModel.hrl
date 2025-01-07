-ifndef(cfg_equipSmeltModel_hrl).
-define(cfg_equipSmeltModel_hrl, true).

-record(equipSmeltModelCfg, {
	%% 炼金等级
	%% 从上往下遍历，取能满足的最大条件的等级ID
	%% 例如：现在炼金等级495级。配置上为1到500，则满足的是1级，取1级的模型数据
	iD,
	%% ModelID
	modelID,
	%% 对应的炼金模型
	%% (X偏移,Y偏移,Z偏移,X旋转,Y旋转,Z旋转,缩放值)
	modelTransform
}).

-endif.
