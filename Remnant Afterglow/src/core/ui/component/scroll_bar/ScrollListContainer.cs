using Godot;
using System;
namespace Remnant_Afterglow
{
    [Tool]
    public partial class ScrollListContainer : Container
    {
        private VScrollBar ScrollbarV;
        private HScrollBar ScrollbarH;
        private Vector2 ScrollOffset = new Vector2();

        public enum ALIGN
        {
            ALIGN_START,
            ALIGN_MIDDLE,
            ALIGNMENT_END
        }

        [Export] private bool Vertical = true;
        [Export] private bool FollowFocus = true;

        [Export] private float Spacing = 0.0f;
        [Export] private float InitialSpacing = 0.0f;
        [Export] private float SideMargin = 0.0f;

        [Export] private bool AutoHideScrollbars = true;

        [Export] private Texture2D BackgroundTexture = null;
        [Export] private Rect2 BackgroundInnerRect = new Rect2();


        public ScrollListContainer()
        {
            SetNotifyTransform(true);
            CheckScrollbars();
            ScrollbarV.ValueChanged += ScrollN;
            ScrollbarH.ValueChanged += ScrollN;
            SortChildren += Reflow;
            ClipContents = true;
        }
        public override void _Ready()
        {
            GetViewport().GuiFocusChanged += CheckFocus;
            FixBg();
            SetProcess(true); // TODO: If/when Godot 4 re-adds NOTIFICATION_MOVED_IN_PARENT, use that instead.
        }

        public void SetBg(Texture2D _BackgroundTexture)
        {
            BackgroundTexture = _BackgroundTexture;
            if (IsInsideTree())
                FixBg();
            QueueRedraw();
        }

        public void SetBgRect(Rect2 _BackgroundInnerRect)
        {
            BackgroundInnerRect = _BackgroundInnerRect;
            if (IsInsideTree())
                FixBg();
            QueueRedraw();
        }

        public void SetFollowFocus(bool _FollowFocus)
        {
            FollowFocus = _FollowFocus;
            QueueSort();
            QueueRedraw();
        }

        public void SetVertical(bool _Vertical)
        {
            Vertical = _Vertical;
            QueueSort();
            QueueRedraw();
        }

        public void SetSpacing(float _Spacing)
        {
            Spacing = _Spacing;
            QueueSort();
            QueueRedraw();
        }

        public void SetSideMargin(float _Margin)
        {
            SideMargin = _Margin;
            QueueSort();
            QueueRedraw();
        }

        public void SetInitialSpacing(float _InitialSpacing)
        {
            InitialSpacing = _InitialSpacing;
            QueueSort();
            QueueRedraw();
        }

        public void SetAutohide(bool _Autohide)
        {
            AutoHideScrollbars = _Autohide;
            QueueSort();
            QueueRedraw();
        }

        private void CheckScrollbars()
        {
            if (ScrollbarV == null)
            {
                ScrollbarV = new VScrollBar();
                ScrollbarV.Name = "_scrollbar_v";
                AddChild(ScrollbarV);
            }
            if (ScrollbarH == null)
            {
                ScrollbarH = new HScrollBar();
                ScrollbarH.Name = "_scrollbar_h";
                AddChild(ScrollbarH);
            }
        }

        private void ScrollN(double new_value)
        {
            if (!Vertical)
                ScrollOffset.X = (float)ScrollbarH.Value;
            else
                ScrollOffset.Y = (float)ScrollbarV.Value;
            QueueSort();
            QueueRedraw();
        }

        private void CheckFocus(Control FocusOwner)
        {
            if (!FollowFocus)
                return;
            if (FocusOwner == null || !IsInstanceValid(FocusOwner) || !IsAncestorOf(FocusOwner))
                return;
            var FocusRect = FocusOwner.GetRect();
            var Rect = GetRect();
            Rect.Position = new Vector2();
            if (Vertical)
            {
                FocusRect.Position -= new Vector2(0, InitialSpacing);
                FocusRect.End += new Vector2(0, InitialSpacing * 2.0f);
                if (FocusRect.End.Y > Rect.End.Y)
                    ScrollbarV.Value += FocusRect.End.Y - Rect.End.Y;
                else if (FocusRect.Position.Y < Rect.Position.Y)
                    ScrollbarV.Value += FocusRect.End.Y - Rect.Position.Y;
            }
            else
            {
                FocusRect.Position -= new Vector2(InitialSpacing, 0);
                FocusRect.End += new Vector2(InitialSpacing * 2.0f, 0);
                if (FocusRect.End.X > Rect.End.X)
                    ScrollbarH.Value += FocusRect.End.X - Rect.End.X;
                else if (FocusRect.Position.X < Rect.Position.X)
                    ScrollbarH.Value += FocusRect.Position.X - Rect.Position.X;
            }
        }

        // native override
        private int CurrentIndex = -1;
        public override void _Notification(int What)
        {
            if (What == Node.NotificationProcess)
            {
                // TODO: If/when Godot 4 re-adds NOTIFICATION_MOVED_IN_PARENT, use that instead.
                var NewIndex = GetIndex();
                if (NewIndex != CurrentIndex)
                {
                    CurrentIndex = NewIndex;
                    FixBg();
                }
                return;
            }
            // fix background transform/size and draw index if anything changes
            if (What == 2000 || What == 31 || What == 40 || What == 30)
            {
                FixBg();
            }
            // clean up the background when we get deleted
            if (What == 1)
            {
                // TODO: If/when Godot 4 re-adds NOTIFICATION_PREDELETE, handle cleanup here.
            }
            // keep scrollbars drawing above contents
            // we don't get a notification when our children change -- but it DOES trigger a redraw
            if (What == 30)
            {
                var ChildCount = GetChildCount();
                if (ScrollbarV != null)
                {
                    var VPos = ScrollbarV.GetIndex();
                    if (VPos + 2 < ChildCount)
                        MoveChild(ScrollbarV, ChildCount - 1);
                }
                if (ScrollbarH != null)
                {
                    var HPos = ScrollbarH.GetIndex();
                    if (HPos + 2 < ChildCount)
                        MoveChild(ScrollbarH, ChildCount - 1);
                }
            }
        }

        private CanvasItem GetParentCanvasItemOf(CanvasItem Node)
        {
            CanvasItem Parent = (CanvasItem)Node.GetParent();
            if (Parent is CanvasItem)
                return Parent;
            else if (Parent != null)
                return GetParentCanvasItemOf(Parent);
            else
                return null;
        }

        private Rect2 GetNinePatchRect()
        {
            var Rect = BackgroundInnerRect;
            if (Rect == new Rect2())
            {
                Vector2 TexSize = BackgroundTexture != null ? BackgroundTexture.GetSize() : Vector2.Zero;
                Rect = new Rect2(TexSize / 2, new Vector2());
            }
            return Rect;
        }

        private Rect2 CalculateBgRect()
        {
            var T = BackgroundTexture;
            if (T != null)
            {
                var TexSize = T.GetSize();
                var Rect = GetNinePatchRect();
                var Left = Rect.Position.X;
                var Top = Rect.Position.Y;
                var Right = TexSize.X - Rect.End.X;
                var Bottom = TexSize.Y - Rect.End.Y;
                var Pos = new Vector2(-Left, -Top);
                var BgExtraSize = new Vector2();
                BgExtraSize.X = Left + Right;
                BgExtraSize.Y = Top + Bottom;
                var BgRectSize = Size + BgExtraSize;
                return new Rect2(Pos, BgRectSize);
            }
            else
            {
                return GetRect();
            }
        }

        private Rid? SiblingCiRid = null;

        private void FixBg()
        {
            if (SiblingCiRid == null)
            {
                SiblingCiRid = RenderingServer.CanvasItemCreate();
            }

            var Rid = SiblingCiRid;
            RenderingServer.CanvasItemClear((Rid)Rid);

            if (!Visible)
                return;

            var Parent = GetParentCanvasItemOf(this);

            var SelfRid = GetCanvasItem();
            var ParentRid = GetCanvas();
            if (Parent != null)
                ParentRid = Parent.GetCanvasItem();

            RenderingServer.CanvasItemSetParent((Rid)Rid, ParentRid);
            RenderingServer.CanvasItemSetTransform((Rid)Rid, GetTransform());
            RenderingServer.CanvasItemSetDrawIndex((Rid)Rid, GetIndex() - 1);

            var T = BackgroundTexture;
            var S = new Rect2(Vector2.Zero, T.GetSize());
            var R = CalculateBgRect();
            var Rect = GetNinePatchRect();
            var P = Rect.Position;
            var D = S.Size - Rect.End;
            RenderingServer.CanvasItemAddNinePatch((Rid)Rid, R, S, T.GetRid(), P, D);
        }

        private bool DoReflow(bool VisibleScroll)
        {
            CheckScrollbars();

            var Cursor = new Vector2();
            var RawRect = GetRect();
            var Rect = RawRect;
            Rect.Position = new Vector2();

            if (Vertical)
            {
                ScrollOffset.X = 0;
                ScrollbarH.Hide();
                if (VisibleScroll)
                {
                    var ScrollSize = ScrollbarV.GetCombinedMinimumSize().X;
                    ScrollbarV.Show();
                    FitChildInRect(ScrollbarV, new Rect2(Rect.Size.X - ScrollSize, 0, ScrollSize, Rect.Size.Y));
                    Rect.Size -= new Vector2(ScrollSize, 0);
                }
            }
            else
            {
                ScrollOffset.Y = 0;
                ScrollbarV.Hide();
                if (VisibleScroll)
                {
                    var ScrollSize = ScrollbarH.GetCombinedMinimumSize().Y;
                    ScrollbarH.Show();
                    FitChildInRect(ScrollbarH, new Rect2(0, Rect.Size.Y - ScrollSize, Rect.Size.X, ScrollSize));
                    Rect.Size -= new Vector2(0, ScrollSize);
                }
            }
            Vector2 rectsize = Rect.Size;
            Vector2 pos = Rect.Position;
            if (Vertical)
            {
                pos.X += SideMargin;
                rectsize.X -= SideMargin * 2.0f;
                Cursor.Y += InitialSpacing;
            }
            else
            {
                pos.Y += SideMargin;
                rectsize.Y -= SideMargin * 2.0f;
                Cursor.X += InitialSpacing;

            }
            Rect.Size = rectsize;
            Rect.Position = pos;
            var RemainSizePart = new Vector2(Rect.Size.X, 0.0f);
            if (!Vertical)
                RemainSizePart = new Vector2(0.0f, Rect.Size.Y);

            foreach (CanvasItem node in GetChildren())
            {
                if (node == ScrollbarV || node == ScrollbarH || node.TopLevel || !node.IsVisibleInTree())
                    continue;
                if (node is Control ChildControl)
                {
                    var Ms = ChildControl.GetCombinedMinimumSize();
                    var RemainMsPart = Ms * (new Vector2(0.0f, 1.0f));
                    if (!Vertical)
                        RemainMsPart = Ms * (new Vector2(1.0f, 0.0f));

                    var Remaining = new Rect2(Rect.Position + Cursor, RemainSizePart + RemainMsPart);
                    FitChildInRect(ChildControl, Remaining);
                    if (Vertical)
                        Cursor.Y = ChildControl.GetRect().End.Y + Spacing;
                    else
                        Cursor.X = ChildControl.GetRect().End.X + Spacing;
                    ChildControl.Position -= ScrollOffset;
                }
                else if (node is Node2D ChildNode2D)
                {
                    ChildNode2D.Position = Cursor;
                    ChildNode2D.Position -= ScrollOffset;
                }
            }

            var C = Cursor;
            if (Vertical)
            {
                Cursor.Y += InitialSpacing;
                Cursor.Y -= Spacing;
            }
            else
            {
                Cursor.X += InitialSpacing;
                Cursor.X -= Spacing;
            }

            if (Vertical)
            {
                ScrollbarV.MaxValue = Math.Max(Rect.Size.Y, Cursor.Y);
                ScrollbarV.Page = Rect.Size.Y;
            }
            else
            {
                ScrollbarH.MaxValue = Math.Max(Rect.Size.X, Cursor.X);
                ScrollbarH.Page = Rect.Size.X;
            }

            if (VisibleScroll)
                return true;
            else
            {
                if (Vertical)
                    return ScrollbarV.Value == 0.0f && ScrollbarV.MaxValue <= ScrollbarV.Page;
                else
                    return ScrollbarH.Value == 0.0f && ScrollbarH.MaxValue <= ScrollbarH.Page;
            }
        }

        public void Reflow()
        {
            if (AutoHideScrollbars)
            {
                var NoOverflow = DoReflow(false);
                if (!NoOverflow)
                    DoReflow(true);
                else
                {
                    ScrollbarV.Hide();
                    ScrollbarH.Hide();
                }
            }
            else
            {
                DoReflow(true);
            }

            FixBg();
        }
    }
}