using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class AudioSettingsMenuBuilder : Node2D
{
    [Export]
    private HSlider sliderPrototype;

    [Export]
    private Button buttonPrototype;

    Dictionary<Sounds, float> individualVolumes;
    readonly Dictionary<Sounds, HSlider> individualVolumeSliders = [];

    Dictionary<SoundTags, float> categoryVolumes;
    readonly Dictionary<SoundTags, HSlider> categoryVolumeSliders = [];

    float masterVolume;
    HSlider masterVolumeSlider;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        masterVolume = AudioServer.MasterVolume;

        var allSounds = Enum.GetValues<Sounds>().Where(s => (int)s < int.MaxValue);
        var _audioServer = new AudioServerInstance(allSounds);
        AddChild(_audioServer);

        var soundDict = AudioServer.GetSoundList(allSounds);
        var soundsByTag = new Dictionary<SoundTags, List<(Sounds identifier, Sound sound)>>();
        individualVolumes = [];
        categoryVolumes = [];
        foreach (var pair in soundDict)
        {
            var identifier = pair.Key;
            var sound = pair.Value;
            var tag = sound.tag;

            soundsByTag.TryAdd(tag, new List<(Sounds identifiert, Sound sound)>());
            soundsByTag[tag].Add((identifier, sound));

            if(AudioServer.IndividualVolumes.TryGetValue(identifier, out float iValue))
                individualVolumes.Add(identifier, iValue);
            else
                individualVolumes.Add(identifier, 1.0f);

            if(AudioServer.CategoryVolumes.TryGetValue(tag, out float cValue))
                categoryVolumes.TryAdd(tag, cValue);
            else
                categoryVolumes.TryAdd(tag, 1.0f);
        }

        sliderPrototype.Visible = false;
        buttonPrototype.Visible = false;

        AddChild(new Label() { Text = "Master", Position = new Vector2(40, 0) });
        masterVolumeSlider = (HSlider)sliderPrototype.Duplicate();
        masterVolumeSlider.Position = new Vector2(140, 0);
        masterVolumeSlider.Size = new Vector2(100, 10);
        masterVolumeSlider.Visible = true;
        masterVolumeSlider.Value = masterVolume;
        masterVolumeSlider.ValueChanged += (newValue) => 
        { 
            _audioServer.SetLinearVolumeMaster((float)newValue); 
            masterVolume = (float)newValue; 
        };
        AddChild(masterVolumeSlider);

        var y = 50;
        var x = 50;
        foreach (var tag in soundsByTag.Keys)
        {
            var sounds = soundsByTag[tag];
            AddChild(GetLabel(tag, new Vector2(x, y)));

            var slider = GetSlider(tag, new Vector2(x + 100, y), _audioServer);
            AddChild(slider);
            categoryVolumeSliders.Add(tag, slider);

            #if DEBUG
            x = 60;
            foreach (var sound in sounds)
            {
                y += 40;

                var btn = GetButton(sound.identifier, new Vector2(x, y), _audioServer);
                AddChild(btn);

                var individualSlider = GetSlider(sound.identifier, new Vector2(x + btn.Size.X + 20, y), _audioServer);
                AddChild(individualSlider);
                individualVolumeSliders.Add(sound.identifier, individualSlider);
            }
            x = 50;
            #endif
            y += 80;
        }
    }

    private Button GetButton(Sounds sound, Vector2 pos, AudioServerInstance audioServer)
    {
        var btn = (Button)buttonPrototype.Duplicate();
        btn.Position = pos;
        btn.Visible = true;
        btn.Text = sound.ToString();
        btn.Pressed += () => 
        { 
            audioServer.Toggle(sound); 
        };
        return btn;
    }

    private HSlider GetSlider(Sounds sound, Vector2 pos, AudioServerInstance audioServer)
    {
        var individualSlider = (HSlider)sliderPrototype.Duplicate();
        individualSlider.Position = pos;
        individualSlider.Size = new Vector2(100, 10);
        individualSlider.Visible = true;
        if (AudioServer.IndividualVolumes.TryGetValue(sound, out var iValue))
            individualSlider.Value = iValue;
        else
            individualSlider.Value = 1.0f;

        individualSlider.ValueChanged += (newValue) => 
        { 
            audioServer.SetLinearVolume((float)newValue, sound); 
            individualVolumes[sound] = (float)newValue; 
        };
        return individualSlider;
    }

    private HSlider GetSlider(SoundTags tag, Vector2 pos, AudioServerInstance audioServer)
    {
        var slider = (HSlider)sliderPrototype.Duplicate();
        slider.Position = pos;
        slider.Size = new Vector2(100, 10);
        slider.Visible = true;
        if (AudioServer.CategoryVolumes.TryGetValue(tag, out float cValue))
            slider.Value = cValue;
        else
            slider.Value = 1.0f;

        slider.ValueChanged += (newValue) =>
        {
            audioServer.SetLinearVolumeTagged((float)newValue, tag);
            categoryVolumes[tag] = (float)newValue;
        };
        return slider;
    }


    private static Label GetLabel(SoundTags tag, Vector2 pos)
    {
        var tagAsString = tag.ToString();
        return new Label() { Text = tagAsString, Position = pos };
    }

    public void Save()
    {
        AudioServer.Save(masterVolume, individualVolumes, categoryVolumes);
    }

    public void Load()
    {
        var (mVol, iVol, cVol) = AudioServer.Load();
        masterVolume = mVol;
        masterVolumeSlider.Value = masterVolume;
        individualVolumes = new(iVol);
        categoryVolumes = new(cVol);

        foreach(var pair in individualVolumes)
            if(individualVolumeSliders.TryGetValue(pair.Key, out var slider))
                slider.Value = pair.Value;

        foreach(var pair in categoryVolumes) 
            if(categoryVolumeSliders.TryGetValue(pair.Key, out var slider))
                slider.Value = pair.Value;
    }
}