// Godot 4.4 Post-Processing Glitch Shader (CanvasItem Version for SubViewport)
shader_type canvas_item;

// 【重要】当此着色器用于 SubViewportContainer 时，
// hint_screen_texture 会自动获取 SubViewport 的渲染结果作为纹理。
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Glitch 效果的总强度
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.1;
// 色差分离的偏移量
uniform float color_shift_amount : hint_range(0.0, 0.1) = 0.01;
// 扫描线的强度
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.1;
// 块状位移的闪烁速度
uniform float block_speed : hint_range(0.1, 10.0) = 5.0;

// 伪随机数生成函数
float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// 片段着色器主函数
void fragment() {
    // SCREEN_UV 是当前像素在屏幕上的归一化坐标
    
    // --- 1. 块状位移效果 ---
    float time = TIME * block_speed;
    float block_noise = rand(vec2(time, floor(SCREEN_UV.y * 20.0)));
    float displacement = pow(block_noise, 15.0) * 0.25 * glitch_intensity;
    
    vec2 displaced_uv = SCREEN_UV;
    if (rand(vec2(time)) > 0.9) {
        displaced_uv.x += displacement;
    }

    // --- 2. 色差分离效果 ---
    float color_offset = displacement * 0.5 + color_shift_amount * glitch_intensity;
    
    // 从 SubViewport 的渲染结果 (SCREEN_TEXTURE) 中采样
    float r = texture(SCREEN_TEXTURE, displaced_uv - vec2(color_offset, 0.0)).r;
    float g = texture(SCREEN_TEXTURE, displaced_uv).g;
    float b = texture(SCREEN_TEXTURE, displaced_uv + vec2(color_offset, 0.0)).b;
    
    vec3 final_color = vec3(r, g, b);
    
    // --- 3. 扫描线效果 ---
    float scanline_value = 1.0 - sin(SCREEN_UV.y * 800.0) * scanline_intensity;
    final_color *= scanline_value;
    
    // --- 4. 输出最终颜色 ---
    // 在 canvas_item 着色器中，我们使用 COLOR 来输出颜色
    COLOR = vec4(final_color, 1.0);
}