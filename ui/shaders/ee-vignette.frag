// https://www.shadertoy.com/view/4XSfzR
#pragma header

uniform float u_intensity;

void main() {
    // Get texture coordinates and size
    vec2 uv = openfl_TextureCoordv;
    vec2 fragCoord = uv * openfl_TextureSize.xy;
    vec2 center = openfl_TextureSize.xy * 0.5;
    
    // Calculate distance from center
    float max_diagonal = length(center);
    float center_distance = distance(fragCoord, center);
    
    // Apply intensity-controlled vignette
    float center_angle = atan(u_intensity * center_distance / max_diagonal);
    float vignette = pow(cos(center_angle), 4.0);
    
    // Apply to original texture
    vec4 color = texture2D(bitmap, uv);
    gl_FragColor = vec4(color.rgb * vignette, color.a);
}