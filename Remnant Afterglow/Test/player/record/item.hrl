%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 物品定义
%%% @end
%%% Created : 2018-06-02 10:00
%%%-------------------------------------------------------------------
-ifndef(item_hrl).
-define(item_hrl, true).

-define(Item_Type_Mission, 1).          %任务背包
-define(Item_Type_Bag, 2).          % 道具背包
-define(Item_Type_Hero, 3).        % 英雄背包
-define(Item_Type_HeroPiece, 4).     %英雄碎片
-define(Item_Type_Equip, 5).        % 装备背包
-define(Item_Type_EquipPiece, 6).   % 装备碎片
-define(Item_Type_BattleSoult, 7).        % 战魂
-define(Item_Type_Eq, 8).     % 8.装备
-define(Item_Type_Arms, 9).     %9.纹章
-define(Item_Type_Trea, 10).     % 10.神石
-define(Item_Type_TreaPiece, 11).     % 11.神石碎片
-define(Item_Type_Fashion, 12).      %% 时装
-define(Item_Type_Gem_Old, 13).          %% 宝石
-define(Item_Type_FashionPiece, 14).      %% 时装碎片
-define(Item_Type_Mount, 15).      %% 坐骑
-define(Item_Type_MountPiece, 16).      %% 坐骑碎片
-define(Item_Type_Wing, 17).      %% 神翼
-define(Item_Type_WingPiece, 18).      %% 神翼碎片
-define(Item_Type_Soul, 19).      %% 灵魂
-define(Item_Type_Rune, 20).      %% 符文
-define(Item_Type_AEquip, 21).      %% 万神殿装备
-define(Item_Type_Gem, 22).      %% 宝石
-define(Item_Type_PetEq, 23).      %% 宠物装备
-define(Item_Type_MountEq, 24).      %% 坐骑装备
-define(Item_Type_WingEq, 25).      %% 翅膀装备
-define(Item_Type_Card, 27).      %% 图鉴
-define(Item_Type_LordRing, 28).      %% 魔戒
-define(Item_Type_HolyPiece, 31).       %% 圣物碎片
-define(Item_Type_GDMainPiece, 33).     %% 主战龙神碎片
-define(Item_Type_GDElfPiece, 35).     %% 精灵龙神碎片
-define(Item_Type_GDWeaponPiece, 37).     %% 龙神武器碎片
-define(Item_Type_GDConsPiece, 39).     %% 龙神秘典碎片
-define(Item_Type_Ornament, 42).    %% 配饰
-define(Item_Type_WeaponPiece, 44).     %% 神兵碎片
-define(Item_Type_Constellation, 49).   %% 星魂装备
-define(Item_Type_Ancient_holy_eq, 50). %% 古神圣装
-define(Item_Type_HolyWing, 51). %% 圣翼
-define(Item_Type_HolyWingRune, 52). %% 圣翼符文
-define(Item_Type_ShengWen, 54).    %% 圣纹
-define(Item_Type_DarkFlameEq, 55).     %% 暗炎魔装
-define(Item_Type_DragonO, 56). %% 龙神相关道具
-define(Item_Type_SkillBook, 88). %% 技能书
-define(Item_Type_PetIllusion, 103). %% 英雄幻化

-define(BAG_NO, 0).            %% 无背包分类
-define(BAG_PLAYER, 1).            %% 个人背包
-define(BAG_REPOSITORY, 2).        %% 个人仓库
-define(BAG_SOUL, 3).        %% 灵魂背包
-define(BAG_SOUL_EQUIP, 4).        %% 灵魂装备背包
-define(BAG_RUNE, 5).        %% 符文背包
-define(BAG_RUNE_EQUIP, 6).        %% 符文装备背包
-define(BAG_AEQUIP, 7).        %% 神兽装备背包
-define(BAG_AEQUIP_EQUIP, 8).        %% 神兽装备穿戴背包
-define(BAG_EQUIP, 9).        %% 玩家装备穿戴背包
-define(BAG_GEM_EQUIP, 10).        %% 玩家镶嵌宝石背包
-define(BAG_ML_EQ, 11).            %% D3 英雄装备背包 (原D2 魔灵装备)
-define(BAG_ML_EQ_EQUIP, 12).        %% D3 英雄装备穿戴背包 (原D2 魔灵穿戴的装备)
-define(BAG_YL_EQ, 13).            %% 翼灵装备
-define(BAG_YL_EQ_EQUIP, 14).        %% 翼灵穿戴的装备
-define(BAG_SL_EQ, 15).            %% 兽灵装备
-define(BAG_SL_EQ_EQUIP, 16).        %% 兽灵穿戴的装备
-define(BAG_CARD, 17).        %% 图鉴背包
-define(BAG_LORD_RING, 18).        %% 魔戒穿戴背包
-define(BAG_MATERIALS, 19).        %% 材料背包
-define(BAG_FRAGMENT, 20).         %% 碎片背包
-define(BAG_CONSUMABLE, 21).         %% 消耗品背包
-define(BAG_ORNAMENT, 22).          %% 英雄圣装背包（原D2 原配饰背包）
-define(BAG_ORNAMENT_EQUIP, 23).    %% 英雄圣装穿戴背包（原D2 原配饰穿戴背包）
-define(BAG_CONSTELLATION, 29).     %% 星座星魂装备背包
-define(BAG_CONSTELLATION_EQUIP, 30).     %% 星座星魂装备已装备背包
-define(BAG_ANCIENT_HOLY_EQ, 31).     %% 古神圣装背包
-define(BAG_ANCIENT_HOLY_EQ_EQUIP, 32).     %% 古神圣装已装备背包
-define(BAG_HOLY_WING_EQUIP, 33).     %% 圣翼已装备背包
-define(BAG_HOLY_WING_RUNE, 34).     %% 圣翼符文背包
-define(BAG_HOLY_WING_RUNE_EQUIP, 35).    %% 圣翼符文已装备背包
-define(BAG_BLOODLINE, 36).             %% 血脉背包
-define(BAG_GEM, 37).                    %% 宝石背包
-define(BAG_SW, 38).                    %% 圣纹背包
-define(BAG_SW_EQUIP, 39).                    %% 圣纹装备背包
-define(BAG_DARK_FLAME_EQ, 40).             %% 暗炎魔装
-define(BAG_DARK_FLAME_EQ_EQUIP, 41).       %% 暗炎魔装已装备背包
-define(BAG_COLLECT_EQ, 44).       %% 装备收藏已装备背包


-define(BAG_XUN_BAO_1, 50).        %% 1装备寻宝仓库
-define(BAG_XUN_BAO_2, 51).        %% 2龙印寻宝仓库
-define(BAG_XUN_BAO_3, 52).        %% 3坐骑寻宝仓库
-define(BAG_XUN_BAO_4, 53).        %% 4神翼寻宝仓库
-define(BAG_XUN_BAO_5, 54).        %% 5魔宠寻宝仓库
-define(BAG_XUN_BAO_6, 55).        %% 6巅峰寻宝仓库
-define(BAG_RING, 56).             %% 魔戒背包
-define(BAG_XUN_BAO_7, 57).        %% 7圣纹寻宝背包
-define(BAG_DRAGON_STATUE_EQUIP, 58).       %% 龙神雕像已装备背包
-define(BAG_DRAGON_WEAPON_EQUIP, 59).       %% 龙神武器已装备背包
-define(BAG_DRAGON_EQ_EQUIP, 60).       %% 龙神圣装已装备背包
-define(BAG_XUN_BAO_8, 61).        %% 8 神兵寻宝仓库
-define(BAG_XUN_BAO_9, 62).        %% 9 神魂寻宝仓库
-define(BAG_SKILL_BOOK, 66).       %% 技能书背包
-define(BAG_NEW_CARD, 67).       %% 卡片背包
-define(BAG_XUN_BAO_10, 68).       %% 10 宝石寻宝仓库
-define(BAG_XUN_BAO_11, 69).       %% 11 卡片寻宝仓库
-define(BAG_HOLY_SEAL_EQUIP, 70).       %% 圣印已装备背包
-define(BAG_FAZHEN, 71).                %% 法阵背包
-define(BAG_FAZHEN_RUNE, 72).            %% 符文背包
-define(BAG_FAZHEN_EQUIP, 73).            %% 法阵已装配背包
-define(BAG_FAZHEN_RUNE_EQUIP, 74).        %% 符文已装配背包
-define(BAG_FAZHEN_ESSENCE, 75).        %% 符文精华
-define(BAG_CONSTELLATION_GEM, 76). %%星座星石背包
-define(BAG_CONSTELLATION_GEM_EQUIP, 77). %%星座星石已穿戴背包
-define(BAG_EXPEDITION_EXPLORE, 78). %%远征探险储存背包
-define(BAG_EXPEDITION_CARD, 79). %% 边境图鉴背包
-define(BAG_PET_EQ, 80).           %% OB4魔宠装备
-define(BAG_PET_EQ_EQUIP, 81).     %% OB4穿戴的宠物装备
-define(BAG_PET_CITY, 82).            %% 家园背包
-define(BAG_XUN_BAO_12, 83).        %% 12 黄金寻宝仓库
-define(BAG_HERO_STONE, 84).%% 英雄魂石背包
-define(BAG_HERO_STONE_EQUIP, 85).%% 英雄魂石已装备背包
-define(BAG_XUN_BAO_13, 86).        %% 13 坐骑装备寻宝仓库
-define(BAG_AltarStoneEquip, 87).        %% 英雄圣坛阵石穿戴背包
-define(BAG_XUN_BAO_14, 88).        % 17 泰坦寻宝仓库
%% 穿戴背包列表
-define(EQUIP_BAG_LIST, [?BAG_SOUL_EQUIP, ?BAG_RUNE_EQUIP, ?BAG_AEQUIP_EQUIP, ?BAG_EQUIP, ?BAG_GEM, ?BAG_ML_EQ_EQUIP,
	?BAG_YL_EQ_EQUIP, ?BAG_SL_EQ_EQUIP, ?BAG_LORD_RING, ?BAG_ORNAMENT_EQUIP, ?BAG_CONSTELLATION_EQUIP, ?BAG_ANCIENT_HOLY_EQ_EQUIP,
	?BAG_HOLY_WING_EQUIP, ?BAG_HOLY_WING_RUNE_EQUIP, ?BAG_SW_EQUIP, ?BAG_DARK_FLAME_EQ_EQUIP, ?BAG_COLLECT_EQ, ?BAG_DRAGON_STATUE_EQUIP,
	?BAG_DRAGON_WEAPON_EQUIP, ?BAG_DRAGON_EQ_EQUIP, ?BAG_SKILL_BOOK, ?BAG_HOLY_SEAL_EQUIP, ?BAG_FAZHEN_EQUIP, ?BAG_FAZHEN_RUNE_EQUIP,
	?BAG_CONSTELLATION_GEM_EQUIP, ?BAG_PET_EQ_EQUIP, ?BAG_HERO_STONE_EQUIP, ?BAG_AltarStoneEquip]).

-define(AllBagList, [
	?BAG_NO,
	?BAG_PLAYER,
	?BAG_REPOSITORY,
	?BAG_SOUL,
	?BAG_SOUL_EQUIP,
	?BAG_RUNE,
	?BAG_RUNE_EQUIP,
	?BAG_AEQUIP,
	?BAG_AEQUIP_EQUIP,
	?BAG_EQUIP,
	?BAG_GEM_EQUIP,
	?BAG_ML_EQ,
	?BAG_ML_EQ_EQUIP,
	?BAG_YL_EQ,
	?BAG_YL_EQ_EQUIP,
	?BAG_SL_EQ,
	?BAG_SL_EQ_EQUIP,
	?BAG_CARD,
	?BAG_LORD_RING,
	?BAG_MATERIALS,
	?BAG_FRAGMENT,
	?BAG_CONSUMABLE,
	?BAG_ORNAMENT,
	?BAG_ORNAMENT_EQUIP,
	?BAG_CONSTELLATION,
	?BAG_CONSTELLATION_EQUIP,
	?BAG_ANCIENT_HOLY_EQ,
	?BAG_ANCIENT_HOLY_EQ_EQUIP,
	?BAG_HOLY_WING_EQUIP,
	?BAG_HOLY_WING_RUNE,
	?BAG_HOLY_WING_RUNE_EQUIP,
	?BAG_BLOODLINE,
	?BAG_GEM,
	?BAG_SW,
	?BAG_SW_EQUIP,
	?BAG_DARK_FLAME_EQ,
	?BAG_DARK_FLAME_EQ_EQUIP,
	?BAG_COLLECT_EQ,

	?BAG_XUN_BAO_1,
	?BAG_XUN_BAO_2,
	?BAG_XUN_BAO_3,
	?BAG_XUN_BAO_4,
	?BAG_XUN_BAO_5,
	?BAG_XUN_BAO_6,
	?BAG_XUN_BAO_7,
	?BAG_XUN_BAO_8,
	?BAG_XUN_BAO_9,
	?BAG_XUN_BAO_10,
	?BAG_XUN_BAO_11,
	?BAG_XUN_BAO_12,
	?BAG_XUN_BAO_13,
	?BAG_XUN_BAO_14,

	?BAG_RING,
	?BAG_DRAGON_STATUE_EQUIP,
	?BAG_DRAGON_WEAPON_EQUIP,
	?BAG_DRAGON_EQ_EQUIP,
	?BAG_SKILL_BOOK,
	?BAG_NEW_CARD,
	?BAG_HOLY_SEAL_EQUIP,
	?BAG_FAZHEN,
	?BAG_FAZHEN_RUNE,
	?BAG_FAZHEN_EQUIP,
	?BAG_FAZHEN_RUNE_EQUIP,
	?BAG_FAZHEN_ESSENCE,
	?BAG_CONSTELLATION_GEM,
	?BAG_CONSTELLATION_GEM_EQUIP,
	?BAG_EXPEDITION_EXPLORE,
	?BAG_EXPEDITION_CARD,
	?BAG_PET_EQ,
	?BAG_PET_EQ_EQUIP,
	?BAG_PET_CITY,
	?BAG_HERO_STONE,
	?BAG_HERO_STONE_EQUIP,
	?BAG_AltarStoneEquip
]).

-define(REPOSITORY_LIST, [
	?BAG_XUN_BAO_1,
	?BAG_XUN_BAO_2,
	?BAG_XUN_BAO_3,
	?BAG_XUN_BAO_4,
	?BAG_XUN_BAO_5,
	?BAG_XUN_BAO_6,
	?BAG_XUN_BAO_7,
	?BAG_XUN_BAO_8,
	?BAG_XUN_BAO_9,
	?BAG_XUN_BAO_10,
	?BAG_XUN_BAO_11,
	?BAG_XUN_BAO_12,
	?BAG_XUN_BAO_13,
	?BAG_XUN_BAO_14
]).

-record(item, {id, cfg_id, bind = 0, expire_time = 0, amount = 1}).


-endif.        %% -ifndef
