using Godot;
using Newtonsoft.Json;
namespace Remnant_Afterglow
{
    public class Frame
    {
        public int x { get; set; }
        public int y { get; set; }
        public int w { get; set; }
        public int h { get; set; }
        public Rect2I GetRect2I()
        {
            return new Rect2I(new Vector2I(x, y), new Vector2I(w, h));
        }
    }

    public class FrameData
    {
        public Frame frame { get; set; }
        public int duration { get; set; }
    }

    public class MetaSize
    {
        public int w { get; set; }
        public int h { get; set; }
    }

    public class FrameAnimation
    {
        public string name { get; set; }
        public int fps { get; set; }
        public float speed_scale { get; set; }
        public int from { get; set; }
        public int to { get; set; }
    }

    public class MetaData
    {
        public string app { get; set; }
        public string version { get; set; }
        public string filepath { get; set; }
        public FrameAnimation[] frameAnimations { get; set; }
        public MetaSize size { get; set; }
        public string view { get; set; }
        public void InitMetaData()
        {
            int lastSlashIndex = filepath.LastIndexOf('/');
            filepath = PathConstant.GetPathUser(PathConstant.SequenceMap_PATH_USER) + filepath.Substring(lastSlashIndex + 1);

        }
    }
    //从json中读取出的SequenceMapType类
    //序列图
    public class SequenceMapType
    {
        public FrameData[] frames { get; set; }
        public MetaData meta { get; set; }
        [JsonIgnore]
        public SpriteFrames spriteFrames { get; set; }
        [JsonIgnore]
        public string AnimName { get; set; }
        [JsonIgnore]
        public float SpeedScale { get; set; }
        public void InitSequenceMap()
        {
            spriteFrames = new SpriteFrames();
            Image image = GD.Load<Texture2D>(meta.filepath).GetImage();
            FrameAnimation animation = meta.frameAnimations[0];
            AnimName = animation.name;//动画名称
            SpeedScale = meta.frameAnimations[0].speed_scale;
            spriteFrames.AddAnimation(AnimName);
            for (int j = animation.from; j <= animation.to; j++)
            {
                FrameData data = frames[j];
                Rect2I rect2 = data.frame.GetRect2I();
                Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
                spriteFrames.AddFrame(AnimName, texture2D);
            }
            spriteFrames.SetAnimationSpeed(AnimName, animation.fps);
            spriteFrames.SetAnimationLoop(AnimName, true);
            spriteFrames.RemoveAnimation("default");
        }
    }
}