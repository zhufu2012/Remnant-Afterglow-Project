using GameLog;
using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// EditorTileMap-绘制操作相关
    /// </summary>
    public partial class EditTileMap : TileMap
    {
        #region

        bool IsFirst = true;
        /// <summary>
        /// 数据是否脏了, 也就是否有修改
        /// </summary>
        public bool IsDirty { get; private set; }
        /// <summary>
        /// 鼠标坐标
        /// </summary>
        public Vector2 _mousePosition;
        /// <summary>
        /// 鼠标所在的cell坐标
        /// </summary>
        public Vector2I _mouseCellPosition;
        /// <summary>
        /// 上一帧鼠标所在的cell坐标
        /// </summary>
        private Vector2I _prevMouseCellPosition = new Vector2I(-99999, -99999);
        /// <summary>
        /// 单次绘制是否改变过tile数据
        /// </summary>
        private bool _changeFlag = false;
        /// <summary>
        /// 左键开始按下时鼠标所在的坐标
        /// </summary>
        private Vector2I _mouseStartCellPosition;
        /// <summary>
        /// 鼠标中建是否按下
        /// </summary>
        private bool _isMiddlePressed = false;

        /// <summary>
        /// 鼠标移动偏移
        /// </summary>
        private Vector2 _moveOffset;
        /// <summary>
        /// 左键是否按下
        /// </summary>
        private bool _isLeftPressed = false;
        /// <summary>
        /// 右键是否按下
        /// </summary>
        private bool _isRightPressed = false;
        /// <summary>
        /// 绘制填充区域
        /// </summary>
        private bool _drawFullRect = false;

        /// <summary>
        /// 左键功能
        /// </summary>
        public MouseButtonType MouseType = MouseButtonType.Pen;
        #endregion

        /// <summary>
        /// 鼠标能否操作
        /// </summary>
        /// <returns></returns>
        public bool IsMouse()
        {
            var mouse = GetViewport().GetMousePosition();
            if (mouse.X >= 1420 || mouse.Y < 75)//这个区域不操作
            {
                _isLeftPressed = false;
                _isRightPressed = false;
                _isMiddlePressed = false;
                return false;
            }
            Rect2 rect = EditMapView.Instance.SaveButton.GetRect();
            if (rect.HasPoint(mouse))
            {
                _isLeftPressed = false;
                _isRightPressed = false;
                _isMiddlePressed = false;
                return false;
            }
            return true;
        }


        public override void _Process(double delta)
        {
            if (!_initLayer)
            {
                return;
            }
            if (IsFirst)
            {
                FlushLayerEnabled();//刷新图层显示情况
                //SetCurrLayer(drawData.NowLayer);//默认当前绘制层
                IsFirst = false;
            }
            if (!IsMouse())
            {
                return;
            }

            var position = GetLocalMousePosition();

            _mouseCellPosition = LocalToMap(position);
            _mousePosition = new Vector2(
                _mouseCellPosition.X * MapConstant.TileCellSize,
                _mouseCellPosition.Y * MapConstant.TileCellSize
            );
            //左键绘制
            if (_isLeftPressed)
            {
                switch (MouseType)
                {
                    case MouseButtonType.Pen://笔，绘制单格
                        if (_prevMouseCellPosition != _mouseCellPosition || !_changeFlag) //鼠标位置变过
                        {
                            _changeFlag = true;
                            _prevMouseCellPosition = _mouseCellPosition;
                            //绘制图块
                            SetSingleCell(_mouseCellPosition);
                        }
                        break;
                    case MouseButtonType.Area://笔，绘制区域
                        _drawFullRect = true;
                        break;
                    case MouseButtonType.Brush://笔刷
                        if (_prevMouseCellPosition != _mouseCellPosition || !_changeFlag) //鼠标位置变过
                        {
                            _changeFlag = true;
                            _prevMouseCellPosition = _mouseCellPosition;
                            //绘制图块
                            SetBrushCell(_mouseCellPosition);
                        }
                        break;
                    default:
                        break;
                }
            }
            else if (_isRightPressed) //右键擦除
            {
                switch (MouseType)
                {
                    case MouseButtonType.Pen:
                        if (_prevMouseCellPosition != _mouseCellPosition || !_changeFlag) //鼠标位置变过
                        {
                            _changeFlag = true;
                            _prevMouseCellPosition = _mouseCellPosition;
                            EraseSingleCell(_mouseCellPosition);
                        }
                        break;
                    case MouseButtonType.Area:
                        _drawFullRect = true;
                        break;
                    case MouseButtonType.Brush://笔刷
                        if (_prevMouseCellPosition != _mouseCellPosition || !_changeFlag) //鼠标位置变过
                        {
                            _changeFlag = true;
                            _prevMouseCellPosition = _mouseCellPosition;
                            EraseBrushCell(_mouseCellPosition);
                        }
                        break;
                    default:
                        break;
                }
            }
            else if (_isMiddlePressed) //中键移动
            {
                SetMapPosition(GetGlobalMousePosition() + _moveOffset);
            }
        }


        /// <summary>
        /// 输入操作
        /// </summary>
        /// <param name="event"></param>
        public override void _Input(InputEvent @event)
        {

            var mouse = GetViewport().GetMousePosition();
            if (mouse.X >= 1420 || mouse.Y < 75)//这个区域不操作
            {
                return;
            }

            if (@event is InputEventMouseButton mouseButton)
            {
                if (mouseButton.ButtonIndex == MouseButton.Left) //左键
                {
                    if (mouseButton.Pressed) //按下
                    {
                        _moveOffset = Position - GetGlobalMousePosition();
                        _mouseStartCellPosition = LocalToMap(GetLocalMousePosition());
                    }
                    else
                    {
                        _changeFlag = false;
                        if (_drawFullRect) //松开, 提交绘制的矩形区域
                        {
                            SetRectCell(_mouseStartCellPosition, _mouseCellPosition);
                            _drawFullRect = false;
                        }
                    }
                    _isLeftPressed = mouseButton.Pressed;//左键是否按下
                }
                else if (mouseButton.ButtonIndex == MouseButton.Right) //右键
                {
                    if (mouseButton.Pressed) //按下
                    {
                        _moveOffset = Position - GetGlobalMousePosition();
                        _mouseStartCellPosition = LocalToMap(GetLocalMousePosition());
                    }
                    else
                    {
                        _changeFlag = false;
                        if (_drawFullRect) //松开, 提交擦除的矩形区域
                        {
                            EraseRectCell(_mouseStartCellPosition, _mouseCellPosition);
                            _drawFullRect = false;
                        }
                    }

                    _isRightPressed = mouseButton.Pressed;
                }
                else if (mouseButton.ButtonIndex == MouseButton.Middle)
                {
                    _isMiddlePressed = mouseButton.Pressed;
                    if (_isMiddlePressed)
                    {
                        _moveOffset = Position - GetGlobalMousePosition();
                    }
                }
            }
        }


        #region 绘制操作
        /// <summary>
        /// 获取当前选择的材料
        /// </summary>
        public MapFixedMaterial GetSelectMaterial()
        {
            return EditMapView.Instance.gridSelectPanel.GetSelectMaterial();
        }

        /// <summary>
        /// 擦除一个区域内的贴图
        /// </summary>
        /// <param name="start"></param>
        /// <param name="end"></param>
        private void EraseRectCell(Vector2I start, Vector2I end)
        {
            if (start.X > end.X)
            {
                var temp = end.X;
                end.X = start.X;
                start.X = temp;
            }
            if (start.Y > end.Y)
            {
                var temp = end.Y;
                end.Y = start.Y;
                start.Y = temp;
            }
            var width = end.X - start.X + 1;
            var height = end.Y - start.Y + 1;
            for (var i = 0; i < width; i++)
            {
                for (var j = 0; j < height; j++)
                {
                    EraseCell(CurrLayer, new Vector2I(start.X + i, start.Y + j));
                }
            }
        }
        /// <summary>
        /// 擦除单个图块
        /// </summary>
        /// <param name="position"></param>
        private void EraseSingleCell(Vector2I position)
        {
            List<int> layerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
            if (layerList.Contains(CurrLayer))//对应层显示着的
            {
                if (position.X <= drawData.Width && position.X >= 0 && position.Y <= drawData.Height && position.Y >= 0)
                {
                    if (layerData.ContainsKey(CurrLayer))
                    {
                        EraseCell(CurrLayer, position);
                        layerData[CurrLayer][position.X, position.Y] = new Cell();
                    }
                }
            }
        }

        /// <summary>
        /// 擦除笔刷范围内的图块
        /// </summary>
        /// <param name="position"></param>
        private void EraseBrushCell(Vector2I position)
        {
            List<int> layerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
            if (layerList.Contains(CurrLayer))//对应层显示着的
            {
                if (position.X <= drawData.Width && position.X >= 0 && position.Y <= drawData.Height && position.Y >= 0)
                {
                    //笔刷大小
                    int brushSize = EditMapView.Instance.toolContainer.brushSize;
                    int brushType = EditMapView.Instance.toolContainer.GetBrushType();
                    // 计算笔刷的范围
                    int halfBrushSize = brushSize / 2;
                    Vector2 start = new Vector2(position.X - halfBrushSize, position.Y - halfBrushSize);
                    Vector2 end = new Vector2(position.X + halfBrushSize, position.Y + halfBrushSize);
                    for (int x = (int)start.X; x <= end.X; x++)
                    {
                        for (int y = (int)start.Y; y <= end.Y; y++)
                        {
                            if (!IsPos(new Vector2(x, y)))
                            {
                                continue;
                            }
                            Vector2 currentPos = new Vector2(x, y);
                            switch (brushType)
                            {
                                case 1://圆形笔刷
                                       // 计算当前图块与笔刷中心的距离
                                    float distance = currentPos.DistanceTo(position);
                                    if (distance <= halfBrushSize)
                                    {
                                        EraseCell(CurrLayer, (Vector2I)currentPos);
                                        layerData[CurrLayer][x, y] = new Cell();
                                    }
                                    break;
                                case 2://正方形笔刷
                                    EraseCell(CurrLayer, (Vector2I)currentPos);
                                    layerData[CurrLayer][x, y] = new Cell();
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 绘制区域贴图
        /// </summary>
        /// <param name="start"></param>
        /// <param name="end"></param>
        private void SetRectCell(Vector2I start, Vector2I end)
        {
            if (start.X > end.X)
            {
                var temp = end.X;
                end.X = start.X;
                start.X = temp;
            }
            if (start.Y > end.Y)
            {
                var temp = end.Y;
                end.Y = start.Y;
                start.Y = temp;
            }
            var width = end.X - start.X + 1;
            var height = end.Y - start.Y + 1;

            for (var i = 0; i < width; i++)
            {
                for (var j = 0; j < height; j++)
                {
                    MapFixedMaterial material = GetSelectMaterial();//选择的材料
                    //祝福注释-图片序号，之后可以用二维的坐标表示
                    //选中的材料
                    SetCell(CurrLayer, new Vector2I(start.X + i, start.Y + j), material.ImageSetId,
                     LoadTileSetConfig.GetImageIndex_TO_Vector2(material.ImageSetId, material.ImageSetIndex));

                }
            }
        }

        /// <summary>
        /// 绘制单个贴图
        /// </summary>
        /// <param name="position"></param>
        private void SetSingleCell(Vector2I position)
        {
            if (IsPos(position))
            {
                MapFixedMaterial material = GetSelectMaterial();//选择的材料
                //祝福注释-图片序号，之后可以用二维的坐标表示
                //选中的材料
                if (material != null)
                {
                    List<int> layerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
                    if (layerList.Contains(CurrLayer))//对应层显示着的
                    {
                        if (layerData.ContainsKey(CurrLayer))
                        {
                            layerData[CurrLayer][position.X, position.Y] = new Cell(position.X, position.Y,
        material.MaterialId, material.PassTypeId, material.ImageSetId, material.ImageSetIndex);
                        }
                        else
                        {
                            layerData[CurrLayer] = new Cell[EditMapView.Instance.nowMapData.Width, EditMapView.Instance.nowMapData.Height];
                            layerData[CurrLayer][position.X, position.Y] = new Cell(position.X, position.Y,
    material.MaterialId, material.PassTypeId, material.ImageSetId, material.ImageSetIndex);
                        }
                        SetCell(CurrLayer, position, material.ImageSetId,
                        LoadTileSetConfig.GetImageIndex_TO_Vector2(material.ImageSetId, material.ImageSetIndex));
                    }
                }
            }
        }

        /// <summary>
        /// 设置笔刷范围内的格子
        /// </summary>
        /// <param name="position"></param>
        private void SetBrushCell(Vector2I position)
        {
            if (IsPos(position))
            {
                MapFixedMaterial material = GetSelectMaterial();//选择的材料
                if (material != null)
                {
                    List<int> layerList = EditMapView.Instance.layerSelectPanel.GetSelectLayerList();
                    if (layerList.Contains(CurrLayer))//对应层显示着的
                    {
                        if (!layerData.ContainsKey(CurrLayer))
                        {
                            layerData[CurrLayer] = new Cell[EditMapView.Instance.nowMapData.Width, EditMapView.Instance.nowMapData.Height];
                        }
                        //笔刷大小
                        int brushSize = EditMapView.Instance.toolContainer.brushSize;
                        int brushType = EditMapView.Instance.toolContainer.GetBrushType();
                        // 计算笔刷的范围
                        int halfBrushSize = brushSize / 2;
                        Vector2 start = new Vector2(position.X - halfBrushSize, position.Y - halfBrushSize);
                        Vector2 end = new Vector2(position.X + halfBrushSize, position.Y + halfBrushSize);
                        for (int x = (int)start.X; x <= end.X; x++)
                        {
                            for (int y = (int)start.Y; y <= end.Y; y++)
                            {
                                if (!IsPos(new Vector2(x, y)))
                                {
                                    continue;
                                }
                                Vector2 currentPos = new Vector2(x, y);
                                switch (brushType)
                                {
                                    case 1://圆形笔刷
                                        // 计算当前图块与笔刷中心的距离
                                        float distance = currentPos.DistanceTo(position);
                                        if (distance <= halfBrushSize)
                                        {
                                            layerData[CurrLayer][x, y] = new Cell(x, y,
material.MaterialId, material.PassTypeId, material.ImageSetId, material.ImageSetIndex);
                                            SetCell(CurrLayer, new Vector2I(x, y), material.ImageSetId,
LoadTileSetConfig.GetImageIndex_TO_Vector2(material.ImageSetId, material.ImageSetIndex));
                                        }
                                        break;
                                    case 2://正方形笔刷
                                        layerData[CurrLayer][x, y] = new Cell(x, y,
material.MaterialId, material.PassTypeId, material.ImageSetId, material.ImageSetIndex);
                                        SetCell(CurrLayer, new Vector2I(x, y), material.ImageSetId,
LoadTileSetConfig.GetImageIndex_TO_Vector2(material.ImageSetId, material.ImageSetIndex));
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                    }
                }
            }
        }
        #endregion


        #region 地图数据操作函数
        /// <summary>
        /// 设置地图坐标
        /// </summary>
        public void SetMapPosition(Vector2 pos)
        {
            Position = pos;
        }

        /// <summary>
        /// 缩小
        /// </summary>
        private void Shrink()
        {
            var pos = GetLocalMousePosition();
            var scale = Scale / 1.1f;
            if (scale.LengthSquared() >= 0.5f)
            {
                Scale = scale;
                SetMapPosition(Position + pos * 0.1f * scale);
            }
        }

        /// <summary>
        /// 放大
        /// </summary>
        private void Magnify()
        {
            var pos = GetLocalMousePosition();
            var prevScale = Scale;
            var scale = prevScale * 1.1f;
            if (scale.LengthSquared() <= 2000)
            {
                Scale = scale;
                SetMapPosition(Position - pos * 0.1f * prevScale);
            }
        }
        #endregion
    }
}