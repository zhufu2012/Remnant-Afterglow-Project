using Godot;


namespace Remnant_Afterglow
{
    public partial class UndergroundBuild : BuildBase
    {
        public override void InitData(int ObjectId, int Source)
        {
            base.InitData(ObjectId, Source);
            // 特殊的初始化逻辑
            SetupUndergroundProperties();
        }

        private void SetupUndergroundProperties()
        {
            // 设置不参与碰撞检测
            Collision?.SetDeferred("disabled", true);
            area2DShape?.SetDeferred("disabled", true);

            // 移除碰撞层设置，使其不与其他物体交互
            CollisionLayer = 0;
            CollisionMask = 0;

            // 或者只保留特定的碰撞层（如果需要与某些特殊物体交互）
        }

        public override void InitView()
        {
            base.InitView();
            // 禁用碰撞检测，使其不阻挡单位移动
            Collision?.SetDeferred("disabled", true);
            area2DShape?.SetDeferred("disabled", true);
        }
    }
}