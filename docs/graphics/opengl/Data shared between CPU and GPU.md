
## Shaders

In the simplest possible configuration, you will need two shaders : one called Vertex Shader, which will be executed for each vertex, and one called Fragment Shader, which will be executed for each sample. If we use 4x antialising, we have 4 samples in each pixel.

Shaders are programmed in a language called GLSL : GL Shader Language, which is part of OpenGL. Unlike C or Java, GLSL has to be compiled at run time, which means that each and every time you launch your application, all your shaders are recompiled. Shaders code run in GPU, so we need some way to share data between CPU and GPU.
## Per-Vertex  Data 

Per-Vertex  Data in OpenGl is stored in a buffer called Vertex Buffer Object (VBO). VBO is  used to send the attributes (Vertex positions,  Vertex colors,  Texture coordinate, Normal vectors) of vertices to Vertex Shader, one item of buffer bind one vertex. The OpenGL buffer is created, bound, filled and configured with the standard functions (`glGenBuffers`, `glBindBuffer`, `glBufferData`, `glVertexAttribPointer`) ;
#### Step 1: Generate the Buffer

First, you ask OpenGL to create a buffer object for you. It returns a unique ID (an unsigned integer) that you use to refer to that buffer.

```c++
GLuint VBO_ID; 
glGenBuffers(1, &VBO_ID); // Generate 1 buffer and store its ID in VBO_ID
```

#### Step 2: Bind the Buffer

OpenGL is a state machine. To work with a specific buffer, you must first "bind" it, making it the currently active buffer for a specific target. For vertex data, the target isGL_ARRAY_BUFFER.
```c++
// Make our new buffer the active GL_ARRAY_BUFFER 
glBindBuffer(GL_ARRAY_BUFFER, VBO_ID);
```
AnyGL_ARRAY_BUFFERoperations will now affectVBO_ID.

#### Step 3: Buffer the Data

This is the crucial step where you copy your vertex data from your application's memory (on the CPU) to the buffer's memory (on the GPU).

```c++
// Our vertex data in an array on the CPU
float vertices[] = {
    // positions         // colors
    -0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f, // bottom left
     0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f, // bottom right
     0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f  // top center
};

// Copy the data into the currently bound buffer (VBO_ID)
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
```

Let's break down `glBufferData`:

- target:GL_ARRAY_BUFFER, the buffer type we're working with.
- size: The total size of the data in bytes (sizeof(vertices)).
- data: A pointer to the actual vertex data (vertices).
- usage: A hint to OpenGL about how we'll use this data.
    - GL_STATIC_DRAW: The data will be set once and used many times (e.g., a static model)  
    - GL_DYNAMIC_DRAW: The data will be changed frequently and used many times (e.g., a character's animation).
    - GL_STREAM_DRAW: The data will be set once and used only a few times.

#### Step 4: Configure - Set Vertex Attribute Pointers

The GPU now has your data, but it doesn't know how to interpret it. Is it just a big blob of floats? You need to tell it: "Okay, the first 3 floats of each vertex are its position. The next 3 floats are its color."

This is done with `glVertexAttribPointer`.

```c++
// Tell OpenGL how to interpret the position data (attribute 0)
glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
glEnableVertexAttribArray(0); // Enable attribute 0


// Tell OpenGL how to interpret the color data (attribute 1)
glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
glEnableVertexAttribArray(1); // Enable attribute 1

```

Let's break down `glVertexAttribPointer`:

- index: The vertex attribute's location. In shaders, you'd have`layout (location = 0) in vec3 aPos;`. This`0`matches the index.
- size: The number of components per vertex attribute (e.g., 3 for a vec3 position).
- type: The data type of the components (GL_FLOAT).
- normalized: Whether the data should be normalized (we don't need this for floats).
- stride: The byte-offset between consecutive vertices. Our vertex has 6 floats (3 pos + 3 color), so the stride is`6 * sizeof(float)`.
- pointer(offset): The offset of the first component of this attribute in the vertex. For position, it's 0. For color, it starts after the 3 position floats, so its offset is`3 * sizeof(float)`.

Corresponding code in  Vertex Shader
```Glsl
// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertexPosition_modelspace;
layout(location = 1) in vec3 vertexColor;
```
#### Step 5: Draw!

Now, in your render loop, you just need to bind the VBO and tell OpenGL to draw.

```c++
// In the render loop
glBindBuffer(GL_ARRAY_BUFFER, VBO_ID);
glDrawArrays(GL_TRIANGLES, 0, 3); // Draw 3 vertices, starting from index 0
```

**Improvement with VAOs:** The process in Step 4 and 5 is often simplified by a **Vertex Array Object (VAO)**, which "remembers" all the `glVertexAttribPointer` calls and VBO bindings for you. In modern OpenGL, you'd set up a VAO once, and in the render loop, you would just bind the VAO and call `glDrawArrays`.

#### Step 6: Cleanup

When you're done with the buffer (e.g., closing the application), you should delete it to free up GPU memory.

```c++
glDeleteBuffers(1, &VBO_ID);
```

## Global Data

Global Data in OpenGl called Uniform.  Uniform can be used to send global data to all shaders. Its key characteristic is that its value is **uniform** (constant and unchanging) for every single vertex and fragment processed within a single draw call.

#### Step 1: Declare the Uniform in the Shader (GLSL)
ou declare it in your shader code just like a global variable, using the uniform keyword.
```GLSL
uniform vec3 LightPosition_worldspace;
```
#### Step 2: Get the Uniform's "Location"

In your CPU-side code, after you've compiled and linked your shader program, you need to ask OpenGL for the "location" of your uniform. This is just an integer ID that OpenGL uses to refer to that specific uniform.

You only need to do this**once**after creating the shader program.
```c++
GLuint LightID = glGetUniformLocation(programID, "LightPosition_worldspace");
// It's good practice to check if the uniform was found. // It might not be found if it's unused in the shader, as the compiler may optimize it out. 
if (LightID == -1) { 
    // Handle error... 
}

```
#### Step 3: Set the Uniform's Value

This is done in your**render loop**, right before you make a draw call (glDrawArraysorglDrawElements).

**Crucially, you mustglUseProgramfirst**to make your shader active, as theglUniformfunctions operate on the currently active program.
```c++
// In the render loop...
glm::vec3 lightPos = glm::vec3(4, 4, 4);
glUniform3f(LightID, lightPos.x, lightPos.y, lightPos.z);
```

## Compare VBOs and  Uniforms
- **VBOs** hold data that is **different for each vertex** (like positions). They are loaded once into GPU memory.

- **Uniforms** hold data that is the **same for all vertices** in a draw call (like a transformation matrix or global color). They are set from the CPU just before drawing.

Together, VBOs and Uniforms form the fundamental way you communicate all necessary rendering data to the GPU in modern OpenGL.
 

| Feature         | Vertex Attribute (from VBO)                               | Uniform                                                           |
| --------------- | --------------------------------------------------------- | ----------------------------------------------------------------- |
| **Scope**       | Per-Vertex                                                | Per-Draw Call (Global to the shader program)                      |
| **Data Source** | Read from a Vertex Buffer Object (VBO)                    | Set directly from CPU application code before drawing.            |
| **Variability** | Value is **different** for each vertex.                   | Value is the **same** for all vertices and fragments.             |
| **Typical Use** | Position, per-vertex color, normals, texture coordinates. | Transformation matrices, time, lighting properties, global color. |


## Texture Data 
Texture data is stored in buffer, but unlike vertex data, it is global data rather than per-vertex data, so Texture Data  is a form of global buffer data.  Sending texture data is the third pillar of getting data to the GPU, alongside VBOs (per-vertex data) and Uniforms (global data).
### 1. What is a Texture in OpenGL?

In OpenGL, a **Texture** is a memory object, typically living on the GPU, that stores image data. This data can be 1D, 2D, or 3D, but the most common form is a 2D texture used to wrap an image around a 3D model.

The process involves:

1. Loading an image file (like a .png or .jpg) into your application's memory (CPU).
2. Creating an OpenGL texture object.
3. Uploading the pixel data from your application to the texture object on the GPU.
4. Telling the shader how to use this texture.

### 2. The Workflow: A Step-by-Step Guide

Here is the complete process for loading and using a texture.

#### Step 0: Load the Image from a File (CPU-Side)

OpenGL itself does **not** know how to open and read image files. You must use a third-party library for this. The most popular and easiest one for beginners is **stb_image.h**.

You include this library and it gives you a simple function to load an image into a byte array.
```c++
#include "stb_image.h" // A popular single-header image loading library

int width, height, nrChannels;
unsigned char *data = stbi_load("container.jpg", &width, &height, &nrChannels, 0);

if (data) {
    // Image loaded successfully!
    // 'width' and 'height' have the image dimensions.
    // 'nrChannels' is 3 for RGB, 4 for RGBA.
    // 'data' is a pointer to the raw pixel data.
} else {
    // Failed to load image
}
```
#### Step 1: Generate a Texture Object

Just like with VBOs, you ask OpenGL to generate a unique ID for your texture.
```c++
GLuint textureID;
glGenTextures(1, &textureID);
```
#### Step 2: Bind the Texture

You bind the texture to make it the active one for a specific target. For standard images, the target is GL_TEXTURE_2D.

```
glBindTexture(GL_TEXTURE_2D, textureID);
```

All subsequent texture commands for GL_TEXTURE_2D will now configure the texture with ID textureID.

#### Step 3: Set Texture Parameters (Wrapping and Filtering)

Before you upload the data, you should tell OpenGL how to handle the texture when it's rendered.

- **Wrapping:** What happens if the texture coordinates are outside the [0, 1] range?
    - GL_REPEAT: The texture repeats.
    - GL_CLAMP_TO_EDGE: The edge color is stretched.
- **Filtering:** What happens when the texture is scaled up (magnified) or down (minified)?
    - GL_NEAREST: "Pixelated" look. Fast but blocky.
    - GL_LINEAR: "Blurry" look. Smooth but can be blurry up close.

```c++
// Set texture wrapping parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); // S is for the x-axis (like U)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT); // T is for the y-axis (like V)

// Set texture filtering parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); // Minification (zoomed out)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); // Magnification (zoomed in)
```
#### Step 4: Upload the Texture Data to the GPU

This is the core step where you send the pixel data from Step 0 to the currently bound texture object on the GPU. The function for this is glTexImage2D.

```c++
// Using the variables from stb_image.h
// Note: We check nrChannels to determine the format
GLenum format = (nrChannels == 4) ? GL_RGBA : GL_RGB;

glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data);
```

Let's break down the glTexImage2D parameters:

- target: GL_TEXTURE_2D.
- level: Mipmap level. 0 is the base level.
- internalFormat: The format OpenGL should use to store the texture (e.g., GL_RGB).
- width, height: Dimensions of the image from Step 0.
- border: Legacy, should always be 0.
- format: The format of the source data you are providing (GL_RGB or GL_RGBA).
- type: The data type of the source data (GL_UNSIGNED_BYTE for standard images).
- data: The pointer to the image data we loaded with stb_image.
#### Step 5: Generate Mipmaps (Optional but Recommended)

Mipmaps are pre-calculated, smaller versions of your texture that OpenGL will automatically use when the object is far away. This prevents visual artifacts (moiré patterns) and improves performance.

```c++
glGenerateMipmap(GL_TEXTURE_2D);
```
This automatically generates all the smaller mipmap levels from the base image you just uploaded. For this to work best, you should set your GL_TEXTURE_MIN_FILTER to one of the mipmap options, like GL_LINEAR_MIPMAP_LINEAR.

#### Step 6: Free the Image Data from CPU Memory
Once the data is on the GPU, you no longer need the copy in your application's memory.
```c++
stbi_image_free(data);
```


full code :
```c++
#include "stb_image.h" // Don't forget to include this

// A helper function to load a texture from a file
unsigned int loadTexture(const char* path) {
    unsigned int textureID;
    glGenTextures(1, &textureID);

    int width, height, nrChannels;
    // Tell stb_image.h to flip loaded textures on the y-axis (common in OpenGL)
    stbi_set_flip_vertically_on_load(true);
    unsigned char *data = stbi_load(path, &width, &height, &nrChannels, 0);

    if (data) {
        GLenum format;
        if (nrChannels == 1) format = GL_RED;
        else if (nrChannels == 3) format = GL_RGB;
        else if (nrChannels == 4) format = GL_RGBA;

        glBindTexture(GL_TEXTURE_2D, textureID);
        glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);

        // Set texture wrapping and filtering options
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    } else {
        std::cout << "Failed to load texture: " << path << std::endl;
    }

    stbi_image_free(data); // Free the CPU-side image memory
    return textureID;
}
```
### 3. How to Use the Texture in Shaders

Now that the texture is on the GPU, you need to tell your shader how to access it. This involves **Texture Units** and a special uniform type called a **Sampler**.

A GPU has a limited number of "texture slots" or **Texture Units** (e.g., 16 or 32). You need to:

1. Activate a texture unit.
2. Bind your texture to that unit.
3. Tell the shader which unit to look at.

**In the Shader (GLSL):**  
You need two things:

1. The texture coordinates from the vertex shader.
2. A sampler2D uniform in the fragment shader.

**Vertex Shader:**

```glsl
#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoord; // Comes from a VBO

out vec2 TexCoord; // Pass texture coords to the fragment shader

void main()
{
    gl_Position = vec4(aPos, 1.0);
    TexCoord = aTexCoord;
}
```
**Fragment Shader:**

```glsl
#version 330 core
out vec4 FragColor;

in vec2 TexCoord; // Received from the vertex shader

// The texture sampler uniform.
// This will get its data from a specific texture unit.
uniform sampler2D ourTexture;

void main()
{
    // The texture() function looks up the color from the texture
    // at the given texture coordinates.
    FragColor = texture(ourTexture, TexCoord);
}
```
**In your Render Loop (C++):**  
Before you draw, you must bind the texture to a texture unit and tell the sampler uniform which unit to use.

```c++
// In the render loop...

glUseProgram(shaderProgramID);

// 1. Activate texture unit 0
glActiveTexture(GL_TEXTURE0);

// 2. Bind your texture to the active unit
glBindTexture(GL_TEXTURE_2D, textureID);

// 3. Tell the 'ourTexture' sampler to use texture unit 0
// glGetUniformLocation is used to get the location of "ourTexture"
glUniform1i(glGetUniformLocation(shaderProgramID, "ourTexture"), 0);

// 4. Draw your object
glBindVertexArray(VAO);
glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
```
The magic is in the `glUniform1i(..., 0)` call. You are setting the integer value of the sampler2D uniform to 0, which corresponds to `GL_TEXTURE0`, the unit you just bound your texture to. If you were using a second texture, you would bind it to `GL_TEXTURE1` and set its corresponding sampler uniform to 1.
## references
https://www.opengl-tutorial.org/beginners-tutorials/tutorial-2-the-first-triangle/