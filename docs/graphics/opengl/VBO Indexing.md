## Indexed VBO in OpenGL
when building your VBO, we always duplicated our vertices whenever two triangles shared an edge, hence the emergence of index VBOs, which enables to reuse the same vertex over and over again. This is done with an _index buffer_.

Using indexing is very simple. First, you need to create an additional buffer, which you fill with the right indices. The code is the same as before, but now it’s an ELEMENT_ARRAY_BUFFER, not an ARRAY_BUFFER.

```c++
std::vector<unsigned int> indices;

// fill "indices" as needed

// Generate a buffer for the indices
 GLuint elementbuffer;
 glGenBuffers(1, &elementbuffer);
 glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, elementbuffer);
 glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.size() * sizeof(unsigned int), &indices[0], GL_STATIC_DRAW);
```

and to draw the mesh, simply replace glDrawArrays by this :

```c++
// Index buffer
 glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, elementbuffer);

 // Draw the triangles !
 glDrawElements(
     GL_TRIANGLES,      // mode
     indices.size(),    // count
     GL_UNSIGNED_INT,   // type
     (void*)0           // element array buffer offset
 );
```

