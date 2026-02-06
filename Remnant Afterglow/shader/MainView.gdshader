shader_type canvas_item;

uniform float outline_width = 1.0;
uniform vec4 outline_color : source_color = vec4(0, 0, 0, 1);

void fragment() {
    // 计算描边采样UV（上下左右偏移）
    vec2 uv_up = UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y) * outline_width;
    vec2 uv_down = UV + vec2(0.0, -TEXTURE_PIXEL_SIZE.y) * outline_width;
    vec2 uv_left = UV + vec2(-TEXTURE_PIXEL_SIZE.x, 0.0) * outline_width;
    vec2 uv_right = UV + vec2(TEXTURE_PIXEL_SIZE.x, 0.0) * outline_width;

    // 采样周围像素的alpha（仅用于描边检测）
    float alpha_up = texture(TEXTURE, uv_up).a;
    float alpha_down = texture(TEXTURE, uv_down).a;
    float alpha_left = texture(TEXTURE, uv_left).a;
    float alpha_right = texture(TEXTURE, uv_right).a;

    // 计算描边区域（取周围像素alpha的最大值）
    float outline_alpha = max(max(alpha_up, alpha_down), max(alpha_left, alpha_right));

    // 描边颜色（固定不透明度=1.0，不受任何透明度影响）
    vec4 outline = vec4(outline_color.rgb, 1.0) * outline_alpha;

    // 原始颜色（受modulate.a影响）
    vec4 original_color = texture(TEXTURE, UV);

    // 混合描边和原始内容（描边在下，原始内容在上）
    vec4 final_color = mix(outline, original_color, original_color.a);

    // 最终输出：
    // - RGB = 混合后的颜色
    // - A = 原始alpha * modulate.a（让图片透明度可控）
    COLOR = vec4(final_color.rgb, original_color.a * COLOR.a);
}