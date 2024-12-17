-ifndef(cfg_roulettePreviewBig_hrl).
-define(cfg_roulettePreviewBig_hrl, true).

-record(roulettePreviewBigCfg, {
	%% 预览调用ID
	iD,
	%% 展示道具ID
	%% （职业,道具ID,品质，星级）
	previewItemID,
	%% 展示
	%% （职业,物品ID,模型ID,x轴位移,y轴位移,z轴位移,x轴旋转,y轴旋转,z轴旋转,比例)
	%% 字段配置为100倍,前端自己去除100
	previewBigShow,
	%% 展示（图片）路径
	previewPic,
	%% 展示对应的文字说明
	%% 文字ID，配置在文字表server分页，保证修改文字后，只更新文字表后端能生效
	text
}).

-endif.
