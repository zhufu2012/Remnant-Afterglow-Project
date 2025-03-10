using Godot;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;

namespace Remnant_Afterglow
{
    public class Vector3IConverter : JsonConverter<Vector3I>
    {
        public override Vector3I ReadJson(JsonReader reader, Type objectType, Vector3I existingValue, bool hasExistingValue, JsonSerializer serializer)
        {
            if (reader.TokenType != JsonToken.StartObject)
                throw new JsonSerializationException("Unexpected token when deserializing object: Expected StartObject.");

            JObject jObject = JObject.Load(reader);

            var x = jObject.Value<int>("x");
            var y = jObject.Value<int>("y");
            var z = jObject.Value<int>("z");

            return new Vector3I(x, y, z);
        }

        public override void WriteJson(JsonWriter writer, Vector3I value, JsonSerializer serializer)
        {
            writer.WriteStartObject();
            writer.WritePropertyName("x");
            writer.WriteValue(value.X);
            writer.WritePropertyName("y");
            writer.WriteValue(value.Y);
            writer.WritePropertyName("z");
            writer.WriteValue(value.Z);
            writer.WriteEndObject();
        }
    }
}