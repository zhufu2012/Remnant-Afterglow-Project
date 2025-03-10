

using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 建造中
    /// </summary>
    public class UnderBuild_State : IState
    {
        public StateMachine stateMachine { get; set; }

        /// <summary>
        /// 是否播放建造时的颜色默认动画
        /// </summary>
        public bool IsPlayBlue = false;
        /// <summary>
        /// 开始的透明度
        /// </summary>
        public float StartAlpha = 0.5f;
        /// <summary>
        /// 结束的透明度
        /// </summary>
        public float EndAlpha = 1f;

        /// <summary>
        /// 当前进度
        /// </summary>
        public int NowProgress = 0;
        /// <summary>
        /// 最大进度
        /// </summary>
        public int MaxProgress = 240;
        /// <summary>
        /// 一次进度新增量
        /// </summary>
        float OneProgress;

        public UnderBuild_State(StateMachine stateMachine)
        {
            this.stateMachine = stateMachine;
        }
        public void Enter(StateMachine stateMachine)
        {
            this.stateMachine = stateMachine;
            if (stateMachine.baseObject.AnimatedSprite.SpriteFrames.HasAnimation(ObjectStateNames.UnderBuild))
            {//有建造动画
                stateMachine.baseObject.PlayAnima(ObjectStateNames.UnderBuild);//播放动画
                IsPlayBlue = false;
            }
            else//没有建造动画
            {
                BuildData buildData = null;
                switch (stateMachine.baseObject.object_type)
                {
                    case BaseObjectType.BaseTower:
                        TowerBase towerBase = (TowerBase)stateMachine.baseObject;
                        buildData = towerBase.buildData;
                        MaxProgress = buildData.BuildProgress;
                        break;
                    case BaseObjectType.BaseBuild:
                        BuildBase buildBase = (BuildBase)stateMachine.baseObject;
                        buildData = buildBase.buildData;
                        MaxProgress = buildData.BuildProgress;
                        break;
                    default:
                        break;
                }
                IsPlayBlue = true;
                OneProgress = (EndAlpha - StartAlpha) / MaxProgress;
                stateMachine.baseObject.SetNodeColor(new Color(1, 1, 1, StartAlpha));
            }
        }

        public void Exit()
        {
            stateMachine.baseObject.SetNodeColor(new Color(1, 1, 1, EndAlpha));
        }

        public void Update(double delta)
        {
            // 每帧更新闲置状态逻辑
        }


        public void FixedUpdate(double delta)
        {
            if (NowProgress + 1 >= MaxProgress)
            {
                stateMachine.ChangeState(new Default_State(stateMachine));//修改为默认
                switch (stateMachine.baseObject.object_type)
                {
                    case BaseObjectType.BaseTower:
                        TowerBase towerBase = (TowerBase)stateMachine.baseObject;
                        foreach(var info in towerBase.WeaponList)
                        {
                            info.InitWeaponState();
                        }
                        break;
                    case BaseObjectType.BaseBuild:
                        BuildBase buildBase = (BuildBase)stateMachine.baseObject;
                        buildBase.workState = WorkState.Work;
                        break;
                    default:
                        break;
                }
            }
            else
            {
                NowProgress += 1;
                stateMachine.baseObject.SetNodeColor(new Color(1, 1, 1, 0.5f + NowProgress * OneProgress));
            }
        }
    }

}