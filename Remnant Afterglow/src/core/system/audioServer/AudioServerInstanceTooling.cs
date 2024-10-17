using Godot;
using Godot.Collections;

// 定义一个继承自Node的类，用于处理音频服务实例
public partial class AudioServerInstance : Node
{
    // 一个私有字段，用于存储当前选中的声音，初始值为_PickSound_
    private Sounds backingFieldForNothing = Sounds._PickSound_;

    // 一个可导出的属性，用于在编辑器中设置和获取要添加的新声音
    [Export]
    public Sounds AddNewSound
    {
        get
        {
            // 获取当前选中的声音
            return backingFieldForNothing;
        }
        set
        {
            // 当设置了新的声音时，首先将backingFieldForNothing重置为_PickSound_
            backingFieldForNothing = Sounds._PickSound_;

            // 确保soundsToLoad数组已初始化
            soundsToLoad ??= new Array<Sounds>();

            // 如果新添加的声音不在soundsToLoad列表中，则添加它
            if (!soundsToLoad.Contains(value))
                soundsToLoad.Add(value);

            // 通知属性列表发生了变化
            NotifyPropertyListChanged();
        }
    }

    // 一个私有字段，用于存储当前选中的声音类别，初始值为_PickCategory_
    private SoundLists backingFieldForNothing1 = SoundLists._PickCategory_;

    // 一个可导出的属性，用于在编辑器中设置和获取要添加的声音类别
    [Export]
    public SoundLists AddCategory
    {
        get
        {
            // 获取当前选中的声音类别
            return backingFieldForNothing1;
        }
        set
        {
            // 当设置了新的声音类别时，首先将backingFieldForNothing1重置为_PickCategory_
            backingFieldForNothing1 = SoundLists._PickCategory_;

            // 从AudioServer获取指定类别的所有声音
            var soundsToAdd = AudioServer.GetSoundsFromCategory(value);

            // 确保soundsToLoad数组已初始化
            soundsToLoad ??= new Array<Sounds>();

            // 遍历要添加的声音列表，如果某个声音不在soundsToLoad列表中，则添加它
            foreach (var sound in soundsToAdd)
                if (!soundsToLoad.Contains(sound))
                    soundsToLoad.Add(sound);

            // 通知属性列表发生了变化
            NotifyPropertyListChanged();
        }
    }

    // 一个可导出的私有数组，用于存储待加载的声音
    [Export]
    private Array<Sounds> soundsToLoad = new Array<Sounds>();
}