using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class GameCamera2 : Camera2D
    {
        /// <summary>
        /// 相机默认配置
        /// </summary>
        public CameraBase cfgData;

        /// <summary>
        /// 设置了相机的初始缩放目标值。当执行缩放操作后，TargetZoom会逐渐变为实际的缩放级别，这个值作为缩放过程的目标值
        /// </summary>
        public float TargetZoom = 0.5f;

        public float MotionMouseScrollModifier = 1.25f;
        public Vector2 ViewportSize;
        /// <summary>
        /// 目前正在缩放中
        /// </summary>
        public bool ProcessZoomEvent = false;
        /// <summary>
        /// 目前正在边缘滚动
        /// </summary>
        public bool ProcessEdgeScroll = false;
        /// <summary>
        /// 滚动方向
        /// </summary>
        public string EdgeScrollEvent;

        /// <summary>
        /// 组件父节点
        /// </summary>
        public CameraAssembly canvasLayer;

        public GameCamera2()
        {
            cfgData = new CameraBase(ConfigCache.GetGlobal_Int("MapDefineCameraId"));//地图默认相机id
            canvasLayer = new CameraAssembly(cfgData.AssemblyIdList);
        }
        public GameCamera2(int id)
        {
            cfgData = new CameraBase(id);
            canvasLayer = new CameraAssembly(cfgData.AssemblyIdList);
        }


        public override void _Ready()
        {
            this.SetViewportSize();
            this.SetMapBoundary();

            GetViewport().Connect(Viewport.SignalName.SizeChanged, Callable.From(TriggerResizeViewport));
        }

        public void SetViewportSize()
        {
            this.ViewportSize = GetViewport().GetVisibleRect().Size;
        }

        public void SetMapBoundary()
        {
            this.LimitLeft = 0;
            this.LimitTop = 0;
        }

        public void TriggerResizeViewport()
        {
            this.SetViewportSize();
        }

        public override void _PhysicsProcess(double delta)
        {
            if (this.ProcessZoomEvent)
            {
                this.Zoom = new Vector2(TargetZoom, TargetZoom);
                this.ProcessZoomEvent = false;
            }

            if (this.ProcessEdgeScroll)
            {
                var EdgeScrollZoomModifier = this.Zoom.Y * 1.5f;
                switch (this.EdgeScrollEvent)
                {
                    case "scroll_top_left":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX((this.Position.X - ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier)),
                            this.GetClampedScreenValueY((this.Position.Y - ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier))
                        );
                        break;
                    case "scroll_bottom_left":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX((this.Position.X - ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier)),
                            this.GetClampedScreenValueY((this.Position.Y + ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier))
                        );
                        break;
                    case "scroll_left":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX((this.Position.X - ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier)),
                            this.Position.Y
                        );
                        break;
                    case "scroll_top_right":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX((this.Position.X + ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier)),
                            this.GetClampedScreenValueY((this.Position.Y - ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier))
                        );
                        break;
                    case "scroll_bottom_right":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX((this.Position.X + ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier)),
                            this.GetClampedScreenValueY((this.Position.Y + ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier))
                        );
                        break;
                    case "scroll_right":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX((this.Position.X + ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier)),
                            this.Position.Y
                        );
                        break;
                    case "scroll_bottom":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX((this.Position.X)),
                            this.GetClampedScreenValueY((this.Position.Y + ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier))
                        );
                        break;
                    case "scroll_top":
                        this.SetScreenPosition(
                            this.GetClampedScreenValueX(this.Position.X),
                            this.GetClampedScreenValueY((this.Position.Y - ((float)delta * cfgData.BaseEdgeScrollSpeed) * EdgeScrollZoomModifier))
                        );
                        break;
                }
            }
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event is InputEventMouseButton eventMouseButton)//滚轮放大缩小
            {
                if (@event.IsPressed())
                {
                    switch (eventMouseButton.ButtonIndex)
                    {
                        case MouseButton.WheelDown:
                            ZoomIn();
                            break;
                        case MouseButton.WheelUp:
                            ZoomOut();
                            break;
                        case MouseButton.Middle:
                            Input.SetCustomMouseCursor(cfgData.CursorGrab);
                            break;
                    }
                }
                else
                {
                    if (eventMouseButton.ButtonIndex == MouseButton.Middle)
                    {
                        Input.SetCustomMouseCursor(cfgData.CursorPoint);
                    }
                }
            }

            if (cfgData.IsEdgeScroll)
                if (@event is InputEventMouseMotion eventMouseMotion)//边缘移动
                {
                    var MousePosition = GetViewport().GetMousePosition();
                    this.DetectEdgeScroll(MousePosition.X, MousePosition.Y);

                    if (eventMouseMotion.ButtonMask == MouseButtonMask.Middle)
                    {
                        var PositionX = this.GetClampedScreenValueX(this.Position.X - (eventMouseMotion.Relative[0] * this.MotionMouseScrollModifier));
                        var PositionY = this.GetClampedScreenValueY(this.Position.Y - (eventMouseMotion.Relative[1] * this.MotionMouseScrollModifier));

                        this.SetScreenPosition(PositionX, PositionY);
                    }
                }

            if (cfgData.IsMove && @event is InputEventKey eventKey)
            {
                if (Input.IsActionPressed("cam_w") || Input.IsActionPressed("cam_d") || Input.IsActionPressed("cam_a") || Input.IsActionPressed("cam_s"))
                {
                    if (Input.IsActionPressed("cam_w"))
                    {
                        MoveCamera(0, -1);
                    }
                    else if (Input.IsActionPressed("cam_s"))
                    {
                        MoveCamera(0, 1);
                    }
                    else if (Input.IsActionPressed("cam_a"))
                    {
                        MoveCamera(-1, 0);
                    }
                    else if (Input.IsActionPressed("cam_d"))
                    {
                        MoveCamera(1, 0);
                    }
                }
            }
        }

        public void DetectEdgeScroll(float x, float y)
        {
            if (x <= cfgData.EdgeScrollMargin)
            {
                if (y <= cfgData.EdgeScrollMargin)
                {
                    this.ProcessEdgeScroll = true;
                    this.EdgeScrollEvent = "scroll_top_left";
                }
                else if (y >= this.ViewportSize.Y - cfgData.EdgeScrollMargin)
                {
                    this.ProcessEdgeScroll = true;
                    this.EdgeScrollEvent = "scroll_bottom_left";
                }
                else
                {
                    this.ProcessEdgeScroll = true;
                    this.EdgeScrollEvent = "scroll_left";
                }
            }
            else if (x >= (this.ViewportSize.X - cfgData.EdgeScrollMargin))
            {
                if (y <= cfgData.EdgeScrollMargin)
                {
                    this.ProcessEdgeScroll = true;
                    this.EdgeScrollEvent = "scroll_top_right";
                }
                else if (y >= this.ViewportSize.Y - cfgData.EdgeScrollMargin)
                {
                    this.ProcessEdgeScroll = true;
                    this.EdgeScrollEvent = "scroll_bottom_right";
                }
                else
                {
                    this.ProcessEdgeScroll = true;
                    this.EdgeScrollEvent = "scroll_right";
                }
            }
            else if (y < cfgData.EdgeScrollMargin)
            {
                this.ProcessEdgeScroll = true;
                this.EdgeScrollEvent = "scroll_top";
            }
            else if (y >= (this.ViewportSize.Y - cfgData.EdgeScrollMargin))
            {
                this.ProcessEdgeScroll = true;
                this.EdgeScrollEvent = "scroll_bottom";
            }
            else
            {
                this.ProcessEdgeScroll = false;
                this.EdgeScrollEvent = "";
            }
        }

        public void SetScreenPosition(float? x, float? y)
        {
            this.Position = new Vector2(x ?? this.Position.X, y ?? this.Position.Y);
        }

        public float GetClampedScreenValueX(float xPos)
        {
            //Camera2D的长期存在的问题，忽略了边缘限制，导致相机边缘卡住。
            return Mathf.Clamp(
                 xPos,
                 (LimitLeft + (int)(this.ViewportSize[0] / 2 / this.Zoom.X)),
                 (LimitRight - (int)(this.ViewportSize[0] / 2 / this.Zoom.X))
             );
        }

        public float GetClampedScreenValueY(float yPos)
        {
            //Camera2D的长期存在的问题，忽略了边缘限制，导致相机边缘卡住。
            return Mathf.Clamp(
                yPos,
                (LimitTop + (int)(this.ViewportSize[1] / 2 / this.Zoom.X)),
                (LimitBottom - (int)(this.ViewportSize[1] / 2 / this.Zoom.X))
            );
        }

        public void ZoomIn()
        {
            if (cfgData.IsZoomIn)
            {
                //TargetZoom = Mathf.Max(TargetZoom - cfgData.ZoomIncrement, cfgData.MinZoom);
                this.ProcessZoomEvent = true;
            }
        }

        public void ZoomOut()
        {
            if (cfgData.IsZoomOut)
            {
               // TargetZoom = Mathf.Min(TargetZoom + cfgData.ZoomIncrement, cfgData.MaxZoom);
                this.ProcessZoomEvent = true;
            }
        }

        ///移动相机
        public void MoveCamera(int deltaX, int deltaY)
        {
            float newX = this.GetClampedScreenValueX(this.Position.X + deltaX * cfgData.MoveSpeed * (float)GetPhysicsProcessDeltaTime());
            float newY = this.GetClampedScreenValueY(this.Position.Y + deltaY * cfgData.MoveSpeed * (float)GetPhysicsProcessDeltaTime());
            this.SetScreenPosition(newX, newY);
        }
    }
}