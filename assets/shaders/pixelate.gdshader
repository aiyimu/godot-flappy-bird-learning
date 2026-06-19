shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 4.0;
uniform int color_count : hint_range(2, 256) = 32;
uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;

void fragment() {
	// 像素化：获取屏幕尺寸，将 UV 坐标量化到指定像素块大小
	ivec2 tex_size = textureSize(screen_tex, 0);
	vec2 pixel_uv = floor(SCREEN_UV * vec2(tex_size) / pixel_size) * pixel_size / vec2(tex_size);

	// 从屏幕纹理采样
	COLOR = texture(screen_tex, pixel_uv);

	// 颜色量化：限制调色板，模拟复古色彩
	COLOR = floor(COLOR * float(color_count)) / float(color_count);
}