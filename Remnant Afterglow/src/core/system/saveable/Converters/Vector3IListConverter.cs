using System;
using System.Collections.Generic;
using Godot;
using Newtonsoft.Json;

namespace Remnant_Afterglow
{
    public class Vector3IListConverter : JsonConverter<List<Vector3I>>
    {
        public override List<Vector3I> ReadJson(JsonReader reader, Type objectType, List<Vector3I> existingValue, bool hasExistingValue, JsonSerializer serializer)
        {
            var list = new List<Vector3I>();

            if (reader.TokenType == JsonToken.Null)
                return null;

            if (reader.TokenType != JsonToken.StartArray)
                throw new JsonSerializationException("Unexpected token when deserializing array: Expected StartArray.");

            while (reader.Read())
            {
                if (reader.TokenType == JsonToken.EndArray)
                    break;

                if (reader.TokenType == JsonToken.StartObject)
                {
                    var vector3I = serializer.Deserialize<Vector3I>(reader);
                    list.Add(vector3I);
                }
                else
                {
                    throw new JsonSerializationException("Unexpected token when deserializing object: Expected StartObject.");
                }
            }

            return list;
        }

        public override void WriteJson(JsonWriter writer, List<Vector3I> value, JsonSerializer serializer)
        {
            writer.WriteStartArray();

            foreach (var vector3I in value)
            {
                serializer.Serialize(writer, vector3I);
            }

            writer.WriteEndArray();
        }

        public override bool CanRead => true;
        public override bool CanWrite => true;
    }
}