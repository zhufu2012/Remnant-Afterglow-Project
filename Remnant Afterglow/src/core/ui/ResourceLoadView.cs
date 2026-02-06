using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 添加资源任务组类
	/// </summary>
	public class ResourceTaskGroup
	{
		public string GroupName { get; set; }
		public Queue<Action> Tasks { get; set; }
		public int TotalTasks { get; set; }
		public int CompletedTasks { get; set; }

		public ResourceTaskGroup(string name)
		{
			GroupName = name;
			Tasks = new Queue<Action>();
			TotalTasks = 0;
			CompletedTasks = 0;
		}
	}
	/// <summary>
	/// 资源加载界面
	/// </summary>
	public partial class ResourceLoadView : Control
	{
		[Export]
		public ProgressBar progressBar;
		[Export]
		public Label label;

		// 资源生成任务队列
		private Queue<Action> resourceGenerationTasks = new Queue<Action>();
		private int totalTasks = 0;
		private int completedTasks = 0;

		// 在 ResourceLoadView.cs 中添加以下字段
		private List<ResourceTaskGroup> taskGroups = new List<ResourceTaskGroup>();
		private int currentGroupIndex = 0;
		private const int RESOURCES_PER_FRAME = 4; // 每帧加载的资源数，可配置


		private int now_time = 0;
		[Export]
		public int await = 60;
		[Export]
		public int task_await = 90;

		public override void _Ready()
		{
			InitializeResourceGenerationTasks();
			totalTasks = resourceGenerationTasks.Count;
		}

		public override void _PhysicsProcess(double delta)
		{
			now_time++;
			if (now_time > await && taskGroups.Count > 0)
			{
				ProcessResourceGeneration(RESOURCES_PER_FRAME);
			}
		}

		/// <summary>
		/// 初始化所有资源生成任务
		/// </summary>
		private void InitializeResourceGenerationTasks()
		{
			string targetDir = "res://assets/animate/";
			if (!DirAccess.DirExistsAbsolute(targetDir))
			{
				DirAccess.MakeDirAbsolute(targetDir);
			}

			// 添加建筑动画资源生成任务
			AddBuildTasks(targetDir);

			// 添加炮塔动画资源生成任务
			AddTowerTasks(targetDir);

			// 添加单位动画资源生成任务
			AddUnitTasks(targetDir);

			// 添加武器动画资源生成任务
			AddWeaponTasks(targetDir);

			// 添加无人机动画资源生成任务
			AddWorkerTasks(targetDir);

			// 设置总任务组数
			totalTasks = taskGroups.Count;
			completedTasks = 0;

			if (taskGroups.Count > 0)
			{
				UpdateGroupLabel(taskGroups[0].GroupName);
			}
		}


		/// <summary>
		/// 添加建筑资源生成任务
		/// </summary>
		private void AddBuildTasks(string targetDir)
		{
			ResourceTaskGroup group = new ResourceTaskGroup("建筑");
			List<BuildData> buildDatas = ConfigCache.GetAllBuildData();
			foreach (BuildData buildData in buildDatas)
			{
				if (buildData != null && buildData.AnimaTypeList.Count > 0 && buildData.Type == 0)
				{
					var dataCopy = buildData; // 避免闭包问题
					group.Tasks.Enqueue(() =>
					{
						SpriteFrames spriteFrames = CreateSpriteFramesFromBuildData(dataCopy);
						string filePath = $"{targetDir}build_{dataCopy.ObjectId}.tres";
						try
						{
							ResourceSaver.Save(spriteFrames, filePath);
						}
						catch (Exception)
						{
							Log.Error($"加载配置时报错！路径:{filePath}，建筑id:{dataCopy.ObjectId}");
						}
					});
				}
			}
			group.TotalTasks = group.Tasks.Count;
			if (group.Tasks.Count > 0)
			{
				taskGroups.Add(group);
			}
		}

		/// <summary>
		/// 添加炮塔资源生成任务
		/// </summary>
		private void AddTowerTasks(string targetDir)
		{
			ResourceTaskGroup group = new ResourceTaskGroup("炮塔");
			List<BuildData> towerDatas = ConfigCache.GetAllBuildData();
			foreach (BuildData towerData in towerDatas)
			{
				if (towerData != null && towerData.AnimaTypeList.Count > 0 && towerData.Type == 1)
				{
					var dataCopy = towerData; // 避免闭包问题
					group.Tasks.Enqueue(() =>
					{
						SpriteFrames spriteFrames = CreateSpriteFramesFromTowerData(dataCopy);
						string filePath = $"{targetDir}tower_{dataCopy.ObjectId}.tres";
						try
						{
							ResourceSaver.Save(spriteFrames, filePath);
						}
						catch (Exception)
						{
							Log.Error($"加载配置时报错！路径:{filePath}，炮塔id:{dataCopy.ObjectId}");
						}
					});
				}
			}
			group.TotalTasks = group.Tasks.Count;
			if (group.Tasks.Count > 0)
			{
				taskGroups.Add(group);
			}
		}

		/// <summary>
		/// 添加单位资源生成任务
		/// </summary>
		private void AddUnitTasks(string targetDir)
		{
			ResourceTaskGroup group = new ResourceTaskGroup("单位");
			List<UnitData> unitDatas = ConfigCache.GetAllUnitData();
			foreach (UnitData unitData in unitDatas)
			{
				if (unitData != null && unitData.AnimaTypeList.Count > 0)
				{
					var dataCopy = unitData; // 避免闭包问题
					group.Tasks.Enqueue(() =>
					{
						SpriteFrames spriteFrames = CreateSpriteFramesFromUnitData(dataCopy);
						string filePath = $"{targetDir}unit_{dataCopy.ObjectId}.tres";
						try
						{
							ResourceSaver.Save(spriteFrames, filePath);
						}
						catch (Exception)
						{
							Log.Error($"加载配置时报错！路径:{filePath}，单位id:{dataCopy.ObjectId}");
						}
					});
				}
			}
			group.TotalTasks = group.Tasks.Count;
			if (group.Tasks.Count > 0)
			{
				taskGroups.Add(group);
			}
		}

		/// <summary>
		/// 添加武器资源生成任务
		/// </summary>
		private void AddWeaponTasks(string targetDir)
		{
			ResourceTaskGroup group = new ResourceTaskGroup("武器");
			List<WeaponData> weaponDatas = ConfigCache.GetAllWeaponData();
			foreach (WeaponData weaponData in weaponDatas)
			{
				if (weaponData != null && weaponData.AnimaTypeList.Count > 0)
				{
					var dataCopy = weaponData; // 避免闭包问题
					group.Tasks.Enqueue(() =>
					{
						SpriteFrames spriteFrames = CreateSpriteFramesFromWeaponData(dataCopy);
						string filePath = $"{targetDir}weapon_{dataCopy.WeaponId}.tres";
						try
						{
							ResourceSaver.Save(spriteFrames, filePath);
						}
						catch (Exception)
						{
							Log.Error($"加载配置时报错！路径:{filePath}，武器id:{dataCopy.WeaponId}");
						}
					});
				}
			}
			group.TotalTasks = group.Tasks.Count;
			if (group.Tasks.Count > 0)
			{
				taskGroups.Add(group);
			}
		}

		/// <summary>
		/// 添加无人机资源生成任务
		/// </summary>
		private void AddWorkerTasks(string targetDir)
		{
			ResourceTaskGroup group = new ResourceTaskGroup("无人机");
			List<WorkerData> workerDatas = ConfigCache.GetAllWorkerData();
			foreach (WorkerData workerData in workerDatas)
			{
				if (workerData != null && workerData.AnimaTypeList.Count > 0)
				{
					var dataCopy = workerData; // 避免闭包问题
					group.Tasks.Enqueue(() =>
					{
						SpriteFrames spriteFrames = CreateSpriteFramesFromWorkerData(dataCopy);
						string filePath = $"{targetDir}worker_{dataCopy.ObjectId}.tres";
						try
						{
							ResourceSaver.Save(spriteFrames, filePath);
						}
						catch (Exception)
						{
							Log.Error($"加载配置时报错！路径:{filePath}，无人机id:{dataCopy.ObjectId}");
						}
					});
				}
			}
			group.TotalTasks = group.Tasks.Count;
			if (group.Tasks.Count > 0)
			{
				taskGroups.Add(group);
			}
		}

		/// <summary>
		/// 处理资源生成任务
		/// </summary>
		private void ProcessResourceGeneration(int resourcesPerFrame)
		{
			if (currentGroupIndex >= taskGroups.Count)
			{
				SetPhysicsProcess(false);
				GD.Print("所有资源生成完成");
				SceneManager.ChangeSceneName("MainView", this);
				return;
			}

			ResourceTaskGroup currentGroup = taskGroups[currentGroupIndex];
			int processed = 0;

			// 处理当前组的部分任务
			while (processed < resourcesPerFrame && currentGroup.Tasks.Count > 0)
			{
				Action task = currentGroup.Tasks.Dequeue();
				task.Invoke();
				currentGroup.CompletedTasks++;
				processed++;
			}

			UpdateGroupProgressBar(currentGroup);

			// 如果当前组完成，准备下一组
			if (currentGroup.Tasks.Count == 0)
			{
				completedTasks++;
				currentGroupIndex++;

				// 如果还有下一组，更新标签文字
				if (currentGroupIndex < taskGroups.Count)
				{
					UpdateGroupLabel(taskGroups[currentGroupIndex].GroupName);
				}

				// 重置等待时间，让下一组稍后再开始加载
				now_time = 0;
				await = task_await;
			}
		}


		/// <summary>
		/// 更新当前组的进度条
		/// </summary>
		private void UpdateGroupProgressBar(ResourceTaskGroup group)
		{
			if (group.TotalTasks > 0)
			{
				float progress = (float)group.CompletedTasks / group.TotalTasks;
				progressBar.Value = progress * 100;
			}
			else
			{
				progressBar.Value = 100;
			}
		}

		/// <summary>
		/// 更新组标签文字
		/// </summary>
		private void UpdateGroupLabel(string groupName)
		{
			label.Text = $"正在加载{groupName}动画...";
		}

		/// <summary>
		/// 从BuildData创建SpriteFrames
		/// </summary>
		private SpriteFrames CreateSpriteFramesFromBuildData(BuildData buildData)
		{
			SpriteFrames spriteFrames = new SpriteFrames();
			List<int> AnimaTypeList = buildData.AnimaTypeList;

			foreach (int AnimaType in AnimaTypeList)
			{
				AnimaBuild animaUnit = ConfigCache.GetAnimaBuild(buildData.ObjectId + "_" + AnimaType);
				if (animaUnit == null) continue;

				Image image = animaUnit.Picture.GetImage();
				string AnimaName = "" + AnimaType;
				spriteFrames.AddAnimation(AnimaName);
				spriteFrames.SetAnimationSpeed(AnimaName, animaUnit.SpeedFps);

				int Index = 1;
				for (int i = 1; i <= animaUnit.Size.X; i++)
				{
					for (int j = 1; j <= animaUnit.Size.Y; j++)
					{
						if (Index <= animaUnit.MaxIndex)
						{
							Rect2I rect2 = new Rect2I(
								new Vector2I((i - 1) * animaUnit.LengWidth.X, (j - 1) * animaUnit.LengWidth.Y),
								animaUnit.LengWidth);
							Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
							spriteFrames.AddFrame(AnimaName, texture2D,
								AnimationCommon.FindSecondItemIfFirstIsOne(animaUnit.RelativeList, Index));
						}
						else
						{
							break;
						}
						Index++;
					}
				}
			}

			if (AnimaTypeList.Count > 0)
			{
				// 确保动画"1"存在后再设置循环
				if (spriteFrames.HasAnimation("1"))
				{
					spriteFrames.SetAnimationLoop("1", true);
				}
				if (spriteFrames.HasAnimation("default"))
					spriteFrames.RemoveAnimation("default");
			}

			return spriteFrames;
		}

		/// <summary>
		/// 从TowerData创建SpriteFrames
		/// </summary>
		private SpriteFrames CreateSpriteFramesFromTowerData(BuildData towerData)
		{
			SpriteFrames spriteFrames = new SpriteFrames();
			List<int> AnimaTypeList = towerData.AnimaTypeList;

			foreach (int AnimaType in AnimaTypeList)
			{
				AnimaTower animaUnit = ConfigCache.GetAnimaTower(towerData.ObjectId + "_" + AnimaType);
				if (animaUnit == null) continue;

				Image image = animaUnit.Picture.GetImage();
				string AnimaName = "" + AnimaType;
				spriteFrames.AddAnimation(AnimaName);
				spriteFrames.SetAnimationSpeed(AnimaName, animaUnit.SpeedFps);

				int Index = 1;
				for (int i = 1; i <= animaUnit.Size.X; i++)
				{
					for (int j = 1; j <= animaUnit.Size.Y; j++)
					{
						if (Index <= animaUnit.MaxIndex)
						{
							Rect2I rect2 = new Rect2I(
								new Vector2I((i - 1) * animaUnit.LengWidth.X, (j - 1) * animaUnit.LengWidth.Y),
								animaUnit.LengWidth);
							Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
							spriteFrames.AddFrame(AnimaName, texture2D,
								AnimationCommon.FindSecondItemIfFirstIsOne(animaUnit.RelativeList, Index));
						}
						else
						{
							break;
						}
						Index++;
					}
				}
			}

			if (AnimaTypeList.Count > 0)
			{
				// 确保动画"1"存在后再设置循环
				if (spriteFrames.HasAnimation("1"))
				{
					spriteFrames.SetAnimationLoop("1", true);
				}
				if (spriteFrames.HasAnimation("default"))
					spriteFrames.RemoveAnimation("default");
			}

			return spriteFrames;
		}

		/// <summary>
		/// 从UnitData创建SpriteFrames
		/// </summary>
		private SpriteFrames CreateSpriteFramesFromUnitData(UnitData unitData)
		{
			SpriteFrames spriteFrames = new SpriteFrames();
			List<int> AnimaTypeList = unitData.AnimaTypeList;

			foreach (int AnimaType in AnimaTypeList)
			{
				AnimaUnit animaUnit = ConfigCache.GetAnimaUnit(unitData.ObjectId + "_" + AnimaType);
				if (animaUnit == null) continue;

				Image image = animaUnit.Picture.GetImage();
				string AnimaName = "" + AnimaType;
				spriteFrames.AddAnimation(AnimaName);
				spriteFrames.SetAnimationSpeed(AnimaName, animaUnit.SpeedFps);

				int Index = 1;
				for (int i = 1; i <= animaUnit.Size.X; i++)
				{
					for (int j = 1; j <= animaUnit.Size.Y; j++)
					{
						if (Index <= animaUnit.MaxIndex)
						{
							Rect2I rect2 = new Rect2I(
								new Vector2I((i - 1) * animaUnit.LengWidth.X, (j - 1) * animaUnit.LengWidth.Y),
								animaUnit.LengWidth);
							Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
							spriteFrames.AddFrame(AnimaName, texture2D,
								AnimationCommon.FindSecondItemIfFirstIsOne(animaUnit.RelativeList, Index));
						}
						else
						{
							break;
						}
						Index++;
					}
				}
			}

			if (AnimaTypeList.Count > 0)
			{
				// 确保动画"1"存在后再设置循环
				if (spriteFrames.HasAnimation("1"))
				{
					spriteFrames.SetAnimationLoop("1", true);
				}
				if (spriteFrames.HasAnimation("default"))
					spriteFrames.RemoveAnimation("default");
			}

			return spriteFrames;
		}

		/// <summary>
		/// 从WeaponData创建SpriteFrames
		/// </summary>
		private SpriteFrames CreateSpriteFramesFromWeaponData(WeaponData weaponData)
		{
			SpriteFrames spriteFrames = new SpriteFrames();
			List<int> AnimaTypeList = weaponData.AnimaTypeList;

			foreach (int AnimaType in AnimaTypeList)
			{
				AnimaWeapon animaUnit = ConfigCache.GetAnimaWeapon(weaponData.WeaponId + "_" + AnimaType);
				if (animaUnit == null) continue;

				Image image = animaUnit.Picture.GetImage();
				string AnimaName = "" + AnimaType;
				spriteFrames.AddAnimation(AnimaName);
				spriteFrames.SetAnimationSpeed(AnimaName, animaUnit.SpeedFps);

				int Index = 1;
				for (int i = 1; i <= animaUnit.Size.X; i++)
				{
					for (int j = 1; j <= animaUnit.Size.Y; j++)
					{
						if (Index <= animaUnit.MaxIndex)
						{
							Rect2I rect2 = new Rect2I(
								new Vector2I((i - 1) * animaUnit.LengWidth.X, (j - 1) * animaUnit.LengWidth.Y),
								animaUnit.LengWidth);
							Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
							spriteFrames.AddFrame(AnimaName, texture2D,
								AnimationCommon.FindSecondItemIfFirstIsOne(animaUnit.RelativeList, Index));
						}
						else
						{
							break;
						}
						Index++;
					}
				}
			}

			if (AnimaTypeList.Count > 0)
			{
				// 确保动画"1"存在后再设置循环
				if (spriteFrames.HasAnimation("1"))
				{
					spriteFrames.SetAnimationLoop("1", true);
				}
				if (spriteFrames.HasAnimation("default"))
					spriteFrames.RemoveAnimation("default");
			}

			return spriteFrames;
		}

		/// <summary>
		/// 从WorkerData创建SpriteFrames
		/// </summary>
		private SpriteFrames CreateSpriteFramesFromWorkerData(WorkerData workerData)
		{
			SpriteFrames spriteFrames = new SpriteFrames();
			List<int> AnimaTypeList = workerData.AnimaTypeList;

			foreach (int AnimaType in AnimaTypeList)
			{
				AnimaWorker animaUnit = ConfigCache.GetAnimaWorker(workerData.ObjectId + "_" + AnimaType);
				if (animaUnit == null) continue;

				Image image = animaUnit.Picture.GetImage();
				string AnimaName = "" + AnimaType;
				spriteFrames.AddAnimation(AnimaName);
				spriteFrames.SetAnimationSpeed(AnimaName, animaUnit.SpeedFps);

				int Index = 1;
				for (int i = 1; i <= animaUnit.Size.X; i++)
				{
					for (int j = 1; j <= animaUnit.Size.Y; j++)
					{
						if (Index <= animaUnit.MaxIndex)
						{
							Rect2I rect2 = new Rect2I(
								new Vector2I((i - 1) * animaUnit.LengWidth.X, (j - 1) * animaUnit.LengWidth.Y),
								animaUnit.LengWidth);
							Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
							spriteFrames.AddFrame(AnimaName, texture2D,
								AnimationCommon.FindSecondItemIfFirstIsOne(animaUnit.RelativeList, Index));
						}
						else
						{
							break;
						}
						Index++;
					}
				}
			}

			if (AnimaTypeList.Count > 0)
			{
				// 确保动画"1"存在后再设置循环
				if (spriteFrames.HasAnimation("1"))
				{
					spriteFrames.SetAnimationLoop("1", true);
				}
				if (spriteFrames.HasAnimation("default"))
					spriteFrames.RemoveAnimation("default");
			}

			return spriteFrames;
		}
	}
}
