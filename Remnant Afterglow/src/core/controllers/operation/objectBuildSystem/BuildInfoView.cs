using GameLog;
using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

public partial class BuildInfoView : NinePatchRect
{
	public ImageNum ImageNum1;

	public ImageNum ImageNum2;

	public ImageNum ImageNum3;
	public Dictionary<int, ImageNum> ImageNumDict = new Dictionary<int, ImageNum>();
	/// <summary>
	/// 建筑名称
	/// </summary>
	public RichTextLabel richTextName;
	/// <summary>
	/// 建筑描述
	/// </summary>
	public RichTextLabel richTextDescribe;
	/// <summary>
	/// 当前显示的实体id
	/// </summary>
	public int ShowObjectId;

	/// <summary>
	/// 建筑数据
	/// </summary>
	public BuildData buildData;

	/// <summary>
	/// 设置页面数据
	/// </summary>
	public void SetView(MapBuildItem item)
	{
		if (item == null)
		{
			Visible = false;
		}
		else
		{
			ShowObjectId = item.ObjectId;
			buildData = item.GetBuildData();
			List<List<int>> list = buildData.Price;
			for (int i = 0; i < list.Count; i++)
			{
				if (GameConstant.PriceIdList.Contains(list[i][0]))
				{
					ImageNumDict[list[i][0]].SetNum(list[i][1]);
				}
			}
			richTextDescribe.Text = buildData.Describe;
			richTextName.Text = buildData.BuildingName;
			Visible = true;
		}
	}


	public override void _Ready()
	{
		Visible = false;
		ImageNum1 = GetNode<ImageNum>("齿轮数量");
		ImageNum2 = GetNode<ImageNum>("水晶数量");
		ImageNum3 = GetNode<ImageNum>("溶剂数量");
		richTextDescribe = GetNode<RichTextLabel>("文本");
		richTextName = GetNode<RichTextLabel>("建筑名称");
		ImageNumDict[GameConstant.PriceIdList[0]] = ImageNum1;
		ImageNumDict[GameConstant.PriceIdList[1]] = ImageNum2;
		ImageNumDict[GameConstant.PriceIdList[2]] = ImageNum3;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
