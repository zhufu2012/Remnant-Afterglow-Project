shader_type canvas_item;

uniform float angle : hint_range(0.5, 1);
uniform vec2 facing_direction ;
uniform float progress : hint_range(0.0, 1.0);
uniform float border_energy_offset : hint_range(0.0, 1.0);
uniform vec4 color : source_color;
uniform vec4 edges_color : source_color;
uniform float edges_valueable : hint_range(0.0, 1.0);
uniform float edges_fade : hint_range(0.0, 1.0);

void fragment() {
    vec2 center = vec2(0.5);
    vec2 center_uv = normalize(UV - center);
    float is = 1.0 - smoothstep(0.49*progress, 0.5*progress, distance(center, UV));

    // 计算护盾角度范围
    float start_angle = 0.0;
    float end_angle = angle * 360.0; // 将参数映射到 0-360 度的范围
    
    // 计算展开方向向量
    vec2 normalized_facing_dir = normalize(facing_direction);
    vec2 facing_dir = vec2(-normalized_facing_dir.x, -normalized_facing_dir.y);
    
    float is2 = step(cos(start_angle * 3.14159265 / 180.0), dot(center_uv, facing_dir));
    float is3 = step(dot(center_uv, facing_dir), cos(end_angle * 3.14159265 / 180.0));
    
    // how close to frontier is
    float border_factor = 1.0 - distance(2.0*(UV - center), center_uv);
    border_factor = pow(border_factor, border_energy_offset*50.0); // 加快中心淡出速度
    
    // how close to radial center is
    float radial_center_factor = 1.0 - distance(center_uv, vec2(0.0))/distance(vec2(1.0), vec2(0.0));
    
    // how close ro radial edges is
    float edge_radial_factor = (1.0 - radial_center_factor) * edges_valueable;
    
    // applying edge fading
    float edge_fade_factor = mix(radial_center_factor, 1.0, 1.0-edges_fade);
    
    COLOR.a = min(1.0, is2+is3)*is*border_factor*mix(color.a, edges_color.a, edge_radial_factor)*edge_fade_factor;
    COLOR.rgb = mix(color.rgb, edges_color.rgb, edge_radial_factor);
	
	
}
