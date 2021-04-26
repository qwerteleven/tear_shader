#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_TEXTURE_SHADER
uniform float time;
uniform float A;
uniform float B;
uniform vec2 resolution;
uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {

  vec2 cPos = -1.0 + A + 2.0 + B * vertTexCoord.st ;
  float cLength = length(cPos);

  vec2 tc0 = vertTexCoord.st + ((cPos / cLength)) * cos(cLength * 10.0 - time * 4.0) *0.03;
  
  vec4 col0 = texture2D(texture, tc0);

  gl_FragColor = vec4(col0.rgb, 1.0) * vertColor;

}