# Tear Drop Shader

A real-time [fragment shader](https://en.wikipedia.org/wiki/Shader#Pixel_shaders) that simulates raindrops falling on a camera feed, built with [Processing](https://processing.org/) and [GLSL](https://en.wikipedia.org/wiki/OpenGL_Shading_Language). Each frame the live webcam image is distorted by a ripple effect derived from the [Sombrero function](https://en.wikipedia.org/wiki/Sombrero_function), with randomly positioned drops across the screen.

![](./animation.gif)

---

## Controls

| Action | Input |
|---|---|
| Toggle shader on / off | Mouse click |

---

## How It Works

### Pipeline

1. The Processing sketch captures a live webcam feed using the [`Capture`](https://processing.org/reference/libraries/video/Capture.html) class and draws it to the canvas each frame.
2. A [GLSL fragment shader](https://en.wikipedia.org/wiki/Shader#Pixel_shaders) (`tear_drop.glsl`) is applied on top, running on the GPU and distorting the texture coordinates of every pixel before sampling the camera image.

### Shader — Ripple Distortion

The core effect in `tear_drop.glsl` works as follows for each pixel:

```glsl
vec2 cPos = -1.0 + A + 2.0 + B * vertTexCoord.st;
float cLength = length(cPos);
vec2 tc0 = vertTexCoord.st + (cPos / cLength) * cos(cLength * 10.0 - time * 4.0) * 0.03;
gl_FragColor = texture2D(texture, tc0);
```

- `cPos` defines a vector from a random origin point (controlled by uniforms `A` and `B`) to the current pixel — placing the centre of each ripple at a random screen location.
- `cLength` is the distance from that centre.
- The texture coordinate is displaced radially by `cos(cLength × 10 − time × 4) × 0.03`, producing an outward-travelling circular wave — the characteristic shape of a [Sombrero / sinc function](https://en.wikipedia.org/wiki/Sombrero_function) profile when viewed radially.
- Multiplying by `cPos / cLength` (the unit direction vector) makes the displacement point away from the drop centre, giving the ripple its expanding ring appearance.

### Randomness

Each frame, the Processing sketch passes new random values for `A` and `B` (both in the range −9 to 9) to the shader via `tear_drop.set()`. This repositions the ripple centre every frame, simulating new drops landing at random positions across the screen.

### Uniforms

| Uniform | Type | Description |
|---|---|---|
| `resolution` | `vec2` | Canvas size in pixels |
| `time` | `float` | Elapsed time in seconds (animates the wave) |
| `A` | `float` | Random X offset for drop centre |
| `B` | `float` | Random Y offset for drop centre |
| `texture` | `sampler2D` | The live camera frame |

---

## Project Structure

```
tear_shader/
├── CIU_Shader.pde       # Processing sketch: camera capture and shader setup
└── tear_drop.glsl       # GLSL fragment shader: ripple distortion
```

---

## Requirements

- [Processing 3+](https://processing.org/download) with P2D renderer
- Processing **Video** library — install via *Sketch → Import Library → Add Library → Video*
- A connected webcam

---

## License

MIT

---

## Credits

Developed by Leopoldo López Reverón — School of Computer Engineering, Universidad de Las Palmas de Gran Canaria.