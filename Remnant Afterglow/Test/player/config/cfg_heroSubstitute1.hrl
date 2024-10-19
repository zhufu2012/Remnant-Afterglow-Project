-ifndef(cfg_heroSubstitute1_hrl).
-define(cfg_heroSubstitute1_hrl, true).

-record(heroSubstitute1Cfg, {
	%% 1、宠物置换
	%% 2、高星转换
	iD,
	%% 可被置换/转换的的宠物星级
	star1,
	%% 高星转换时，大于等于多少星，可转换为其他元素类别的宠物
	%% 配置：星数
	%% 10：表示，大于或等于10星的宠物可任意转换为列表中各类别宠物
	star2,
	%% 可被置换/转换的的宠物品质
	%% 品质：
	%% 0、白、N
	%% 1、蓝、R
	%% 2、紫、SR
	%% 3、橙、SSR
	%% 4、红、SP
	%% 5、粉、UR
	quality,
	%% 高星转换时，大于等于配置品质，可转换为其他元素类别的宠物
	%% 配置：品质
	%% 4：表示，大于或等于SP的宠物可任意转换为列表中各类别宠物
	quality2,
	%% 置换消耗
	%% （货币，值）
	consume
}).

-endif.
