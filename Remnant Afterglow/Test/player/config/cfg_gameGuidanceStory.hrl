-ifndef(cfg_gameGuidanceStory_hrl).
-define(cfg_gameGuidanceStory_hrl, true).

-record(gameGuidanceStoryCfg, {
	%% 故事id
	%% 1：冒险日记
	%% 2：龙神传说
	%% 3：恶魔图鉴
	%% 4：英雄介绍
	%% 5：上古传说
	%% 6：契约笔记
	%% 7：召唤笔记
	%% 8：翅膀笔记
	iD,
	%% 故事目录
	list,
	%% 故事内容段落
	section,
	%% 索引
	%% 界面显示顺序均按对应id从小到大排序，数值不需连续
	index,
	%% 故事书奖励
	%% （类型，ID，绑定状态，数量）
	%% 类型：1道具，2货币
	%% ID填对应类型ID
	%% 绑定状态：0.非绑，1绑定
	item
}).

-endif.
