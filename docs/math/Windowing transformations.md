
Often in graphics we need to create a transform matrix that takes points in the rectangle $[x_l,x_h] × [y_l,y_h] × [z_l,z_h]$ to the rectangle  $[x_l′, x_h′] × [y_l′, y_h′ ]× [z_l′, z_h′ ]$. This can be accomplished with a single scale and translate in sequence. However, it is more intuitive to create the transform from a sequence of three operations:
1. Move the point$(x_l,y_l,z_l)$ to the origin.  
2. Scale the rectangle to be the same size as the target rectangle. 
3. Move the origin to point $(x_l′,y_l′,z_l′)$.

Remembering that the right-hand matrix is applied first, we can write

$$
\begin{align}
window &= translate (x_l',y_l',z_l') * scale\left(\frac{x_h'-x_l'}{x_h-x_l}, \frac{y_h'-y_l'}{y_h-y_l}, \frac{z_h'-z_l'}{z_h-z_l}\right) * translate(−x_l,−y_l,−z_l) \\
&= \left[
  \begin{matrix}
    1 & 0 & 0 & x_l' \\
    0 & 1 & 0 & y_l' \\
    0 & 0 & 1 & z_l' \\
    0 & 0 & 0 & 1    \\
  \end{matrix}
  \right]
  \left[
  \begin{matrix}
    \frac{x_h'-x_l'}{x_h-x_l} & 0 & 0 & 0 \\
    0 & \frac{y_h'-y_l'}{y_h-y_l} & 0 & 0 \\
    0 & 0 & \frac{z_h'-z_l'}{z_h-z_l} & 0 \\
    0 & 0 & 0 & 1    \\
  \end{matrix}
  \right]
  \left[
  \begin{matrix}
    1 & 0 & 0 & -x_l \\
    0 & 1 & 0 & -y_l \\
    0 & 0 & 1 & -z_l \\
    0 & 0 & 0 & 1    \\
  \end{matrix}
  \right] \\
&= \left[
  \begin{matrix}
    \frac{x_h'-x_l'}{x_h-x_l} & 0 & 0 & \frac{x_l'x_h-x_h'x_l}{x_h-x_l} \\
    0 & \frac{y_h'-y_l'}{y_h-y_l} & 0 & \frac{y_l'y_h-y_h'x_l}{y_h-y_l} \\
    0 & 0 & \frac{z_h'-z_l'}{z_h-z_l} & \frac{z_l'z_h-z_h'z_l}{z_h-z_l} \\
    0 & 0 & 0 & 1    \\
  \end{matrix}
  \right]
\end{align}
$$