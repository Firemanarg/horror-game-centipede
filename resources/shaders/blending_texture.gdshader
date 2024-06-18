shader_type spatial;

//ported from gehtsiegarnixan's Sahdertoy project: https://www.shadertoy.com/view/cdBfD3
// The MIT License
// Copyright © 2023 Gehtsiegarnixan
//adapted for practical use with Godot 4.x by Kalamster

uniform sampler2D albedo_tex : repeat_enable, filter_linear_mipmap, hint_default_white;
uniform sampler2D orm_tex : repeat_enable,filter_linear_mipmap, hint_default_white;
uniform float roughness :hint_range(0.0, 1.0) = 1.0;
uniform float metalness :hint_range(0.0, 1.0) = 0.0;
uniform float ao_strength :hint_range(0.0, 1.0) = 0.0;
uniform sampler2D normal_map : hint_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_map_scale :hint_range(-15.0, 15.0) = 1.0;
uniform vec3 uv_scale = vec3(1.0);
group_uniforms uniplanar_settings;
uniform float blend_factor = 16.0;
uniform float _tOffset = 0.0;
varying vec3 my_pos;
varying vec3 my_normal;

float ScreenSpaceDither12(vec2 vScreenPos, float time)
{
    float vDither = dot( vec2( 171.0, 231.0 ), vScreenPos.xy + time);
    return fract( vDither / 103.0);
}

vec3 smoothContrast(vec3 alpha, float contrast) {
    vec3 powAlpha = pow(alpha, vec3(contrast));
    return powAlpha/(powAlpha.x + powAlpha.y + powAlpha.z);
}

vec4 uniplanar( sampler2D sam, vec3 normal, vec3 position, vec4 fragCoord, float contrast, float tOffset) {
    vec2 uvX = position.zy;
	uvX.y *= 1.0;
    vec2 uvY = position.zx;
	uvY.x *= 1.0;
    vec2 uvZ = -position.xy;
	uvZ.y *= -1.0;
    vec3 alpha = abs(normal);
    alpha = smoothContrast(alpha, contrast);
    float dither = ScreenSpaceDither12(fragCoord.xy, TIME-float(tOffset));
    dither = clamp(dither, 0.01, 0.99);
    // Mip caculation as the automatic ones don't work
    vec3 duvwdx = dFdx(position);
    vec3 duvwdy = dFdy(position);
    // uvs for derivatives Mips
    vec2 duvdx;
    vec2 duvdy;
    // "interpolate" the UVs using dither
    vec2 uv;
    if (alpha.x > dither) {
        uv = uvX;
        duvdx = duvwdx.zy;
        duvdy = duvwdy.zy;
    } else if (1.0-alpha.z > dither) {
        uv = uvY;
        duvdx = duvwdx.zx;
        duvdy = duvwdy.zx;
    } else {
        uv = uvZ;
        duvdx = duvwdx.xy;
        duvdy = duvwdy.xy;
    }
    vec4 col = textureGrad( sam, uv, duvdx, duvdy);
 	return col;
}

void vertex() {
my_pos = VERTEX;
my_pos *= vec3(-1.0,-1.0, 1.0);
my_pos = my_pos.xyz;
my_normal = abs(NORMAL);

//taken from a converted Spatial3D material
TANGENT = vec3(0.0,0.0,-1.0) * abs(my_normal.x);
TANGENT+= vec3(1.0,0.0,0.0) * abs(my_normal.y);
TANGENT+= vec3(1.0,0.0,0.0) * abs(my_normal.z);
TANGENT = normalize(TANGENT);
BINORMAL = vec3(0.0,1.0,0.0) * abs(my_normal.x);
BINORMAL+= vec3(0.0,0.0,-1.0) * abs(my_normal.y);
BINORMAL+= vec3(0.0,1.0,0.0) * abs(my_normal.z);
BINORMAL = normalize(BINORMAL);
}

void fragment() {
vec3 col = uniplanar(albedo_tex, my_normal, my_pos*uv_scale, FRAGCOORD, blend_factor, _tOffset).rgb;
ALBEDO *= col;
ALBEDO *= ALBEDO;
vec3 nm = uniplanar(normal_map, my_normal, my_pos*uv_scale, FRAGCOORD, blend_factor, _tOffset).rgb;
NORMAL_MAP = nm;
NORMAL_MAP_DEPTH *= normal_map_scale;
vec3 orm = uniplanar(orm_tex, my_normal, my_pos*uv_scale, FRAGCOORD, blend_factor, _tOffset).rgb;
ROUGHNESS = orm.g * roughness;
METALLIC = orm.b * metalness;
AO = orm.r;
AO_LIGHT_AFFECT = ao_strength;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
