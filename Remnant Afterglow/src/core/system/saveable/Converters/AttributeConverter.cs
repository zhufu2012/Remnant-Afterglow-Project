using System;
using Godot;
using Newtonsoft.Json;

namespace Remnant_Afterglow;

public class AttributeConverter : JsonConverter<ManagedAttributeContainer>
{
    //反序列化
    public override ManagedAttributeContainer ReadJson(JsonReader reader, Type objectType, ManagedAttributeContainer existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        if (reader.TokenType != JsonToken.StartObject)
            throw new JsonSerializationException();

        reader.Read(); // Read start object

        reader.Read(); // Read property's name
        ManagedAttributeContainer Currency = new ManagedAttributeContainer();
        Currency.Deserialize(reader.Value);
        var position = serializer.Deserialize<Vector3>(reader);

        reader.Read(); // Read end object

        return Currency;
    }

    //序列化
    public override void WriteJson(JsonWriter writer, ManagedAttributeContainer value, JsonSerializer serializer)
    {
        writer.WriteStartObject();
        writer.WritePropertyName("ManagedAttributeContainer");
        writer.WriteValue(value.Serialize());
        writer.WriteEndObject();
    }
}