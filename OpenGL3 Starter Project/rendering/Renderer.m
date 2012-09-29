#import <OpenGL/OpenGL.h>
#import "MissingGLDeclarations.h"
#import "Shader.h"

static const float vertexPositions[] = {
    0.75f, 0.75f, 0.0f, 1.0f,
    0.75f, -0.75f, 0.0f, 1.0f,
    -0.75f, -0.75f, 0.0f, 1.0f,
};

static GLuint position_buffer_object, vertex_array_object, shader_program;

const char * vertex_shader =
"#version 330\n"
"layout(location = 0) in vec4 position;\n"
"void main()\n"
"{\n"
"    gl_Position = position;\n"
"}\n";

const char * fragment_shader =
"#version 330\n"
"out vec4 outputColor;\n"
"void main()\n"
"{\n"
"    outputColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);\n"
"}\n";

static void InitializeVertexBuffer(void)
{
    glGenBuffers(1, &position_buffer_object);
    glBindBuffer(GL_ARRAY_BUFFER, position_buffer_object);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float)*12,
                 vertexPositions, GL_STATIC_DRAW);
//    ￼￼￼glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void InitializeProgram() {
    size_t shaders_number = 2, i = 0;
    GLuint *shaders_list = malloc(sizeof(GLuint) * shaders_number);
    shaders_list[i++] = CreateShader(GL_VERTEX_SHADER, vertex_shader);
    shaders_list[i++] = CreateShader(GL_FRAGMENT_SHADER, fragment_shader);
    shader_program = CreateProgram(shaders_number, shaders_list);
    for (size_t i = 0; i < shaders_number; i++) glDeleteShader(shaders_list[i]);
    free(shaders_list);
}

void initialize_opengl(CGLContextObj cgl_ctx) {
    InitializeVertexBuffer();
    InitializeProgram();

	glGenVertexArrays(1, &vertex_array_object);
	glBindVertexArray(vertex_array_object);
}

void uninitialize_opengl(CGLContextObj cgl_ctx) {
    NSLog(@"OpenGL un-initialization function");
}

void reshape (CGLContextObj cgl_ctx, int w, int h) {
    glViewport(0, 0, (GLsizei) w, (GLsizei) h);
}

void render(CGLContextObj cgl_ctx) {
    glClearColor(0.0f, 1.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(shader_program);
    glBindBuffer(GL_ARRAY_BUFFER, position_buffer_object);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(0);
    glUseProgram(0);
    
    CGLFlushDrawable(cgl_ctx);
}