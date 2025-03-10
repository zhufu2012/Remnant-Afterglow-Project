using System;
using Godot;
using Newtonsoft.Json;

namespace Remnant_Afterglow;

public class CellConverter : JsonConverter<Cell>
{
    public override void WriteJson(JsonWriter writer, Cell value, JsonSerializer serializer)
    {
        writer.WriteStartObject();
        writer.WritePropertyName("x");
        writer.WriteValue(value.x);
        writer.WritePropertyName("y");
        writer.WriteValue(value.y);
        writer.WritePropertyName("index");
        writer.WriteValue(value.index);
        writer.WritePropertyName("PassTypeId");
        writer.WriteValue(value.PassTypeId);
        writer.WritePropertyName("MapImageId");
        writer.WriteValue(value.MapImageId);
        writer.WritePropertyName("MapImageIndex");
        writer.WriteValue(value.MapImageIndex);
        writer.WritePropertyName("ImagePos");
        writer.WriteStartObject();
        writer.WritePropertyName("x");
        writer.WriteValue(value.ImagePos.X);
        writer.WritePropertyName("y");
        writer.WriteValue(value.ImagePos.Y);
        writer.WriteEndObject();
        writer.WriteEndObject();
    }

    public override Cell ReadJson(JsonReader reader, Type objectType, Cell existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        var cell = new Cell();
        while (reader.Read())
        {
            if (reader.TokenType == JsonToken.PropertyName)
            {
                string propertyName = reader.Value.ToString();
                reader.Read();
                switch (propertyName)
                {
                    case "x":
                        cell.x = Convert.ToInt32(reader.Value);
                        break;
                    case "y":
                        cell.y = Convert.ToInt32(reader.Value);
                        break;
                    case "index":
                        cell.index = Convert.ToInt32(reader.Value);
                        break;
                    case "PassTypeId":
                        cell.PassTypeId = Convert.ToInt32(reader.Value);
                        break;
                    case "MapImageId":
                        cell.MapImageId = Convert.ToInt32(reader.Value);
                        break;
                    case "MapImageIndex":
                        cell.MapImageIndex = Convert.ToInt32(reader.Value);
                        break;
                    case "ImagePos":
                        if (reader.TokenType == JsonToken.StartObject)
                        {
                            while (reader.Read() && reader.TokenType != JsonToken.EndObject)
                            {
                                if (reader.TokenType == JsonToken.PropertyName)
                                {
                                    string imagePosProperty = reader.Value.ToString();
                                    reader.Read();
                                    switch (imagePosProperty)
                                    {
                                        case "x":
                                            cell.ImagePos.X = Convert.ToInt32(reader.Value);
                                            break;
                                        case "y":
                                            cell.ImagePos.Y = Convert.ToInt32(reader.Value);
                                            break;
                                    }
                                }
                            }
                        }
                        break;
                }
            }
            else if (reader.TokenType == JsonToken.EndObject)
            {
                return cell;
            }
        }
        return cell;
    }

}
