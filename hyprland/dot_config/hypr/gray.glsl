#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    
    float gray = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));

    vec3 warmTone = vec3(1.05, 0.95, 0.85);
    vec3 warmColor = vec3(gray) * warmTone;

    fragColor = vec4(warmColor, pixColor.a);
}
