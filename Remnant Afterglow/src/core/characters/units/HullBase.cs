using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 机壳类，用于支持武器旋转和索敌
	/// </summary>
	public partial class HullBase : Area2D
	{
		/// <summary>
		/// 挂载在哪个实体上（单位）
		/// </summary>
		public UnitBase unitBase;

		/// <summary>
		/// 机壳旋转速度
		/// </summary>
		public float RotationSpeed = 90f; // 每秒旋转90度
		/// <summary>
		/// 默认方向
		/// </summary>
		public float DefaultDirection = 0f;

		/// <summary>
		/// 锁定目标
		/// </summary>
		public BaseObject targetObject { get; set; } = null;

		/// <summary>
		/// 旋转是否完成
		/// </summary>
		public bool isRotatedToTarget = false;

		public void InitData(UnitBase unitBase)
		{
			this.unitBase = unitBase;
			// 设置碰撞等相关属性
			CollisionLayer = 0;
			CollisionMask = CampBase.GetCampLayer(unitBase.Camp);

			// 初始化时与单位底盘方向一致
			UnitBaseDirection = unitBase.AnimatedSprite.GlobalRotation;
			GlobalRotationDegrees = Mathf.RadToDeg(UnitBaseDirection);
		}
		public override void _PhysicsProcess(double delta)
		{
			UpdateRotation(delta);
		}


		// 机壳的攻击范围列表
		public HashSet<BaseObject> RangeList = new HashSet<BaseObject>();

		// 扇形角度限制（弧度）
		public float SectorAngle { get; set; } = Mathf.Pi * 2 / 3; // 默认120度

		// 机壳角度限制（相对于单位底盘）
		public float HullRotationLimit { get; set; } = Mathf.Pi; // 默认180度

		// 单位底盘的参考方向
		public float UnitBaseDirection { get; set; } = 0f;

		/// <summary>
		/// 实体进入可攻击区域
		/// </summary>
		private void Area2DEntered(Area2D body)
		{
			BaseObject enteringObj = body as BaseObject;
			if (enteringObj != null && enteringObj.Camp != unitBase.Camp)
			{
				RangeList.Add(enteringObj);
			}
		}

		/// <summary>
		/// 当有实体退出攻击范围
		/// </summary>
		private void Area2DExited(Area2D body)
		{
			BaseObject exitingObj = body as BaseObject;
			if (exitingObj != null && RangeList.Contains(exitingObj))
			{
				RangeList.Remove(exitingObj);
				if (targetObject == exitingObj) FindTarget();
			}
		}

		/// <summary>
		/// 在攻击范围内寻找最近的目标（考虑扇形限制）
		/// </summary>
		public void FindTarget()
		{
			float minDistanceSq = float.MaxValue;
			Vector2 myPos = GlobalPosition;
			BaseObject newTarget = null;

			foreach (BaseObject obj in RangeList)
			{
				if (IsInstanceValid(obj))
				{
					// 检查目标是否在扇形范围内
					if (IsInSector(obj.GlobalPosition, myPos))
					{
						float distanceSq = myPos.DistanceSquaredTo(obj.GlobalPosition);
						if (distanceSq < minDistanceSq)
						{
							minDistanceSq = distanceSq;
							newTarget = obj;
						}
					}
				}
			}

			targetObject = newTarget;
			isRotatedToTarget = false; // 重置旋转完成标志，确保开始旋转
			// 清理无效对象
			RangeList.RemoveWhere(obj => !IsInstanceValid(obj));
		}

		// 检查目标是否在机壳的扇形范围内
		private bool IsInSector(Vector2 targetPos, Vector2 hullPos)
		{
			Vector2 directionToTarget = targetPos - hullPos;
			float targetAngle = directionToTarget.Angle();

			// 计算机壳当前朝向
			float hullAngle = GetHullRotationRad();

			// 计算相对角度差
			float angleDiff = Mathf.Abs(Mathf.Wrap(targetAngle - hullAngle, -Mathf.Pi, Mathf.Pi));

			return angleDiff <= SectorAngle / 2;
		}

		// 检查机壳旋转是否在允许范围内（相对于单位底盘）
		private bool IsHullRotationInLimit(float targetAngle)
		{
			float angleDiff = Mathf.Abs(Mathf.Wrap(targetAngle - UnitBaseDirection, -Mathf.Pi, Mathf.Pi));
			return angleDiff <= HullRotationLimit / 2;
		}

		/// <summary>
		/// 旋转角度（考虑限制）
		/// </summary>
		private void UpdateRotation(double delta)
		{
			if (targetObject == null) return;
			if (!IsInstanceValid(targetObject))
			{
				targetObject = null;
				return;
			}

			Vector2 direction = targetObject.GlobalPosition - GlobalPosition;
			float targetAngleRad = direction.Angle();
			float targetAngleDeg = Mathf.RadToDeg(targetAngleRad) + 90f;

			// 检查目标方向是否在机壳旋转限制内
			if (!IsHullRotationInLimit(targetAngleRad))
			{
				// 如果超出限制，寻找新目标
				targetObject = null;
				FindTarget();
				return;
			}

			float angleDifference = Mathf.Wrap(targetAngleDeg - GlobalRotationDegrees, -180f, 180f);
			GlobalRotationDegrees = Mathf.MoveToward(GlobalRotationDegrees, GlobalRotationDegrees + angleDifference, RotationSpeed * (float)delta);
			isRotatedToTarget = Mathf.Abs(angleDifference) < 1f;
		}



		/// <summary>
		/// 获取机壳的全局旋转角度（弧度）
		/// </summary>
		public float GetHullRotationRad()
		{
			return Mathf.DegToRad(GlobalRotationDegrees);
		}
	}
}
