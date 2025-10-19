// Godot 4.4 Post-Processing Glitch Shader (CanvasItem Version for SubViewport)
shader_type canvas_item;

// 【重要】当此着色器用于 SubViewportContainer 时，
// hint_screen_texture 会自动获取 SubViewport 的渲染结果作为纹理。
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// --- 可调节参数 ---
// Glitch 效果的总强度
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.1;
// 色差分离的偏移量
uniform float color_shift_amount : hint_range(0.0, 0.1) = 0.01;
// 块状位移的闪烁速度
uniform float block_speed : hint_range(0.1, 10.0) = 5.0;
// 控制故障条纹的数量。数值越小，条纹越宽、越少。
uniform float stripe_count : hint_range(1.0, 100.0) = 10.0;

// --- 扫描线相关参数 ---
// 【新增】是否启用扫描线效果。在编辑器中会显示为一个复选框。
uniform bool enable_scanlines = false;
// 【重新添加】扫描线的强度 (只有在开关打开时才有效)
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.1;


// 伪随机数生成函数
float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// 片段着色器主函数
void fragment() {
    // SCREEN_UV 是当前像素在屏幕上的归一化坐标

    // --- 1. 块状位移效果 ---
    float time = TIME * block_speed;

    float block_noise = rand(vec2(time, floor(SCREEN_UV.y * stripe_count)));

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

    // --- 3. 扫描线效果 (可开关) ---
    // 【核心修改】使用 if 语句来检查开关是否打开
    if (enable_scanlines) {
        float scanline_value = 1.0 - sin(SCREEN_UV.y * 800.0) * scanline_intensity;
        final_color *= scanline_value;
    }

    // --- 4. 输出最终颜色 ---
    // 在 canvas_item 着色器中，我们使用 COLOR 来输出颜色
    COLOR = vec4(final_color, 1.0);
}