using GameLog;
using Godot;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;
namespace Project_Core_Test
{

    public partial class MapTest : Node2D
    {
        //生成地图时
        //构造好敌人对象池
        //然后按照对象池来刷新兵种对象
        //刷新点属性
        List<BrushPoint> BrushPointList = new List<BrushPoint>();
        //兵种对象池
        Pool enemyPool; // 声明一个对象池实例

        Camera2D camera2d; // 相机

        Godot.Label frame_number_label;    //帧数标签//可以写死也可以代码加 看情况
        Godot.Label wave_number_label;    //波数标签


        //建筑列表 节点   分组 build_group
        Node2D BuildListNode;

        //兵种列表 节点   分组 unit_group
        Node2D UnitListNode;

        //塔列表 节点     分组  tower_group
        Node2D TowerListNode;

        /////////////////////地图内数据//////////////////////
        //每个兵种创建最多5个对象
        [Export] public int pool_max = 5;
        //当前波数
        [Export] public int wave_num = 0;
        //是否使用 敌人对象池
        [Export] public bool is_pool = true;

        //总时长 单位秒
        public double all_time = 0;

        //记录当前地图 敌人死亡数
        public int enemy_die = 0;//记录用特殊脚本来记录


        /////////////////////地图内数据//////////////////////
        private double _accumulatedTime1;//逻辑更新计时
        private double _accumulatedTime2;//绘制更新计时
        private double maxLogicTime;//每帧间隔 单位秒
        private double maxDrawTime;//每帧间隔 单位秒

        //地图
        public override void _Ready()
        {
            maxLogicTime = 1.0 / 60;
            maxDrawTime = 1.0 / 60;
            camera2d = GetNode<Camera2D>("Camera2D");
            BuildListNode = GetNode<Node2D>("BuildTest");
            UnitListNode = GetNode<Node2D>("UnitList");//敌人父节点
            TowerListNode = GetNode<Node2D>("TowerList");

            //对应地图配置
           /** Dictionary<string, object> map_keydict = ConfigLoadSystem.GetCfgIndex("cfg_MapBrushMonster", "0_1");
            List<int> BrushId_List = (List<int>)map_keydict["BrushId_List"];
            foreach (int BrushId in BrushId_List)
            {
                BrushPointList.Add(new BrushPoint(BrushId));
            }
            **/
            //Log.PrintList(BrushPointList);
            //对象池
            if (false)// 是否初始化敌人对象池
            {
                Dictionary<int, int> enemy_dict = EnemyLists();
                Dictionary<int, List<Units>> enemyScenes = new Dictionary<int, List<Units>>();
                PackedScene pack = GD.Load<PackedScene>("res://Test/UnitTest/Unit.tscn");
                foreach (var key in enemy_dict)
                {
                    List<Units> units_list = new List<Units>();
                    int min = Math.Max(pool_max, key.Value);
                    for (int i = 0; i < min; i++)
                    {
                        Units units = pack.Instantiate<Units>();
                        units.IniData(key.Key);
                        // new Units(key.Key);
                        units_list.Add(units);
                    }

                    enemyScenes[key.Key] = units_list;
                }
                enemyPool = new Pool(enemyScenes, UnitListNode); // 创建对象池实例，传入 PackedScene 数组和父节点
            }
        }

        //
        public override void _Process(double delta)
        {
            _accumulatedTime2 += delta;
            while (_accumulatedTime2 >= maxDrawTime)
            {

                base._Process(delta);
                _accumulatedTime2 -= maxDrawTime;
            }
            base._Process(delta);
        }

        //逻辑帧
        public override void _PhysicsProcess(double delta)
        {

            _accumulatedTime1 += delta;
            while (_accumulatedTime1 >= maxLogicTime)
            {
                all_time += maxLogicTime;
                CheckRefreshEnemies(delta);
                base._PhysicsProcess(delta);
                _accumulatedTime1 -= maxLogicTime;
            }
            base._PhysicsProcess(delta);
        }

        /// <summary>
        /// 检查刷怪
        /// </summary>
        private void CheckRefreshEnemies(double delta)
        {
            foreach (BrushPoint brushPoint in BrushPointList)
            {
                Dictionary<int, int> flush_dict = brushPoint.Check_RefreshEnemies(all_time, delta);
                if (flush_dict.Count > 0)
                {
                    Log.Print("时间：",Engine.GetFramesPerSecond());
                }
                foreach (var key in flush_dict)//刷新怪物
                {
                    for (int i = 0; i < key.Value; i++)
                    {
                        if (is_pool)
                        {
                            Units enemy = enemyPool.Get(key.Key);// 从对象池获取敌人节点
                            if (enemy != null)
                            {

                                enemy.Position = brushPoint.Pos;
                                UnitListNode.AddChild(enemy);
                            }

                        }
                        else//不使用对象池
                        {
                            Units enemy = GD.Load<PackedScene>("res://Test/UnitTest/Unit.tscn").Instantiate<Units>();
                            enemy.IniData(key.Key);
                            enemy.Position = brushPoint.Pos;
                            UnitListNode.AddChild(enemy);
                        }
                    }
                }


            }
        }


        //返回所有本地图可能需要刷新的怪
        public Dictionary<int, int> EnemyLists()
        {
            Dictionary<int, int> dict = new Dictionary<int, int>();
            for (int i = 0; i < BrushPointList.Count; i++)
            {
                Dictionary<int, int> dict2 = BrushPointList[i].GetEnemy();
                foreach (var kvp in dict2)
                {
                    if (dict.ContainsKey(kvp.Key))
                    {
                        dict[kvp.Key] += kvp.Value;
                    }
                    else
                    {
                        dict.Add(kvp.Key, kvp.Value);
                    }
                }
            }
            return dict;
        }
    }
}
