using Godot;
using Newtonsoft.Json;
using System.Collections.Frozen;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;

public enum Sounds
{
    Bloop = 0,
    Bleep = 1,
    Explosion = 2,
    Mrrp = 3,
    ExplosionB = 4,
    ShortSong = 5,

    _PickSound_ = int.MaxValue, // leave this untouched for nice editor adding
}

public enum SoundLists
{
    Menu = 0,
    Sfx = 1,
    Player = 2,
    Music = 3,

    _PickCategory_ = int.MaxValue, // leave this untouched for nice editor adding
}

public enum SoundTags
{
    General = 0,
    Detonations = 1,
    Music = 2,
}

public static partial class AudioServer
{
    private static readonly FrozenDictionary<Sounds, (string resourceLocation, int polyphony, SoundTags tag)> soundDict = new Dictionary<Sounds, (string resourceLocation, int polyphony, SoundTags tag)>()
    {
        // sound identifier         resource location           polyphony           tag
        { Sounds.Bleep,         ("res://AudioServer/sfx/bleep.wav",        1,      SoundTags.General)       },
        { Sounds.Bloop,         ("res://AudioServer/sfx/bloop.wav",        1,      SoundTags.General)       },
        { Sounds.Explosion,     ("res://AudioServer/sfx/explosion.wav",    1,      SoundTags.Detonations)   },
        { Sounds.Mrrp,          ("res://AudioServer/sfx/mrrrrp.wav",       1,      SoundTags.General)       },
        { Sounds.ExplosionB,    ("res://AudioServer/sfx/explosionB.wav",   1,      SoundTags.Detonations)   },
        { Sounds.ShortSong,     ("res://AudioServer/music/shortMusic.mp3", 1,      SoundTags.Music)         },

    }.ToFrozenDictionary();

    private static readonly FrozenDictionary<SoundLists, Sounds[]> soundLists = new Dictionary<SoundLists, Sounds[]>()
    {
        // list identifier             sound list
        { SoundLists.Menu,      new Sounds[]{ Sounds.Bleep, Sounds.Bloop, }},
        { SoundLists.Sfx,       new Sounds[]{ Sounds.Explosion, Sounds.ExplosionB, }},
        { SoundLists.Player,    new Sounds[]{ Sounds.Mrrp, }},
        { SoundLists.Music,     new Sounds[]{ Sounds.ShortSong, }},

    }.ToFrozenDictionary();

    public static Dictionary<Sounds, float> IndividualVolumes = new Dictionary<Sounds, float>();
    public static Dictionary<SoundTags, float> CategoryVolumes = new Dictionary<SoundTags, float>();
    public static float MasterVolume { get; private set; } = 1.0f;

    static AudioServer()
    {
        Load();
    }

    /// <summary>
    /// Loads and returns volumes
    /// </summary>
    /// <returns>A triple of volume data for use in AudioServerInstance</returns>
    public static (float masterVolume, Dictionary<Sounds, float> individualVolumes, Dictionary<SoundTags, float> categoryVolumes) Load()
    {
        var json = File.ReadAllText("soundSettings.json");
        var saveStructure = GetSaveData(empty: true);
        var load = (dynamic)JsonConvert.DeserializeAnonymousType(json, saveStructure)!;

        MasterVolume = (float)load.masterVolume;
        CategoryVolumes = load.categoryVolumes.ToObject<Dictionary<SoundTags, float>>();
        IndividualVolumes = load.individualVolumes.ToObject<Dictionary<Sounds, float>>();
        return (MasterVolume, IndividualVolumes, CategoryVolumes);
    }

    /// <summary>
    /// Sets and saves the provided parameter
    /// </summary>
    public static void Save(float masterVolume, Dictionary<Sounds, float> individualVolumes, Dictionary<SoundTags, float> categoryVolumes)
    {
        MasterVolume = masterVolume;
        IndividualVolumes = new(individualVolumes);
        CategoryVolumes = new(categoryVolumes);

        var saveData = GetSaveData();
        var json = JsonConvert.SerializeObject(saveData);
        File.WriteAllText("soundSettings.json", json);
    }

    private static object GetSaveData(bool empty = false)
    {
        return new
        {
            masterVolume = empty ? 0.0f : MasterVolume,
            categoryVolumes = empty ? new Dictionary<SoundTags, float>() : CategoryVolumes,
            individualVolumes = empty ? new Dictionary<Sounds, float>() : IndividualVolumes,
        };
    }

    /// <summary>
    /// Sets the master volume of every loaded sound to volume
    /// </summary>
    /// <param name="volume">The new volume</param>
    public static void SetLinearVolumeMaster(float volume)
    {
        MasterVolume = volume;
    }

    /// <summary>
    /// Sets the individual volume of the sound given by its identifier
    /// </summary>
    /// <param name="volume">The new volume</param>
    /// <param name="sound">The sound</param>
    public static void SetLinearVolume(float volume, Sounds sound)
    {
        if (!IndividualVolumes.ContainsKey(sound))
        {
            Debug.Print("Sound '" + sound.ToString() + "' was not loaded or does not exist, so its volume can't be set (from static audioserver)");
            return;
        }
        IndividualVolumes[sound] = volume;
    }

    /// <summary>
    /// Sets the the category volume of every sound of the given category to volume
    /// </summary>
    /// <param name="volume">The new volume</param>
    /// <param name="tag">The category of sounds</param>
    public static void SetLinearVolumeTagged(float volume, SoundTags tag)
    {
        if (!CategoryVolumes.ContainsKey(tag))
        {
            Debug.Print("Sound category '" + tag.ToString() + "' was not loaded or does not exist, so its volume can't be set (from static audioserver)");
            return;
        }
        CategoryVolumes[tag] = volume;
    }

    /// <summary>
    /// Takes a category and returns all sounds from that category. For use in <c>AudioServer.GetSoundList()</c>
    /// </summary>
    /// <param name="category">The category to get the sounds of</param>
    /// <returns>An array of enum values from "Sounds"</returns>
    public static Sounds[] GetSoundsFromCategory(SoundLists category)
    {
        if (!soundLists.TryGetValue(category, out var ret))
        {
            Debug.Print("Tried getting sounds, but the category '" + category.ToString() + "' doesn't exist or doesn't have an entry in 'soundLists' (from static audioserver)");
            return [];
        }
        return ret;
    }

    /// <summary>
    /// 获取字典中提供的IEnumerable中的所有声音
    /// </summary>
    /// <param name="sounds">The sounds to retrieve from the server</param>
    /// <returns>A frozen dicitonary, that can not be altered, but has nice lookup times</returns>
    public static FrozenDictionary<Sounds, Sound> GetSoundList(IEnumerable<Sounds> sounds)
    {
        var soundList = new Dictionary<Sounds, Sound>();
        foreach (var sound in sounds)
        {
            var soundName = "'" + sound.ToString() + "'";
            if (!soundDict.ContainsKey(sound))
            {
                Debug.Print("Tried loading " + soundName + " but it either doesn't exist or wasn't yet setup in the (static) AudioServer.");
                continue;
            }

            if (soundList.ContainsKey(sound))
            {
                Debug.Print("The sound " + soundName + " was already added. duplicate in 'SoundsToAdd'. Nothing *should* break, but you should remove the duplicate entry in your AudioServerInstance.");
                continue;
            }

            var (resourceLocation, polyphony, tag) = soundDict[sound];
            soundList.Add(sound, GetSoundResource(sound, tag, resourceLocation, polyphony));
        }
        return soundList.ToFrozenDictionary();
    }

    private static Sound GetSoundResource(
        Sounds sound, SoundTags tag, string resourceLocation = null, int polyphony = 1)
    {
        var stream = resourceLocation is null ? null : GD.Load(resourceLocation);
        var ret = new Sound(stream, polyphony, tag);
        ret.SetSelfLinearVolume(IndividualVolumes[sound]);
        ret.SetTagLinearVolume(CategoryVolumes[tag]);
        ret.SetMasterLinearVolume(MasterVolume);
        return ret;
    }
}