using System;
using Godot;
using Godot.Community.ManagedAttributes;
using Newtonsoft.Json;

namespace Remnant_Afterglow;

public class AttributeConverter : JsonConverter<ManagedAttributeContainer>
{
    /// <summary>
    /// 反序列化
    /// </summary>
    /// <param name="reader"></param>
    /// <param name="objectType"></param>
    /// <param name="existingValue"></param>
    /// <param name="hasExistingValue"></param>
    /// <param name="serializer"></param>
    /// <returns></returns>
    /// <exception cref="JsonSerializationException"></exception>
    public override ManagedAttributeContainer ReadJson(JsonReader reader, Type objectType, ManagedAttributeContainer existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        if (reader.TokenType != JsonToken.StartObject)
            throw new JsonSerializationException();

        reader.Read(); // Read start object

        reader.Read(); // Read property's name
        ManagedAttributeContainer Currency = new ManagedAttributeContainer();
        Currency.Deserialize((string)reader.Value);

        reader.Read(); // Read end object

        return Currency;
    }

    /// <summary>
    /// 序列化
    /// </summary>
    /// <param name="writer"></param>
    /// <param name="value"></param>
    /// <param name="serializer"></param>
    public override void WriteJson(JsonWriter writer, ManagedAttributeContainer value, JsonSerializer serializer)
    {
        writer.WriteStartObject();
        writer.WritePropertyName("ManagedAttributeContainer");
        writer.WriteValue(value.Serialize());
        writer.WriteEndObject();
    }
}