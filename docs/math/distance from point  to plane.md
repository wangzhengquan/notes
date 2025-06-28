 The  distance  from a point $P(x_0,y_0,z_0)$ to a plane $Ax+By+Cz+D=0$ is, $$d=\frac{|Ax_0+By_0+Cz_0+D)|}{\sqrt{A^2+B^2+C^2}}$$

To derive this formula, we can use **vector projection**. Here's a step-by-step derivation:

### Step 1: Rewrite the Plane Equation

The general equation of a plane is:
$$Ax+By+Cz+D=0$$

We can express it in **normal vector form**:
$$\vec{N}⋅\vec{X}=-D$$
where:
- $N=(A,B,C)$ is the **normal vector** to the plane,
- $X=(x,y,z)$ is any point on the plane,
So, the plane equation becomes:
$$\vec{N}⋅\vec{X}+D=0$$
### Step 2: Find a Reference Point on the Plane

Let $Q(x_1,y_1,z_1)$ be any point on the plane. Then:
$$Ax_1+By_1+Cz_1+D=0$$
We can solve for D:

$$D=−(Ax_1+By_1+Cz_1)$$
### Step 3: Express the Distance as a Projection

The shortest distance from $P(x_0,y_0,z_0)$ to the plane is the length of the perpendicular dropped from P to the plane. This is equivalent to the **projection** of the vector $\vec{PQ}$ (where Q is any point on the plane) onto the normal vector $\vec{N}$

The vector $\vec{PQ}$ is:

$$\vec{PQ}=(x_1−x_0,y_1−y_0,z_1−z_0)$$

The distance d is the magnitude of the projection of $\vec{PQ}$ onto $\vec{N}$
$$d=|proj_\vec{N}\vec{PQ}| = \frac{\left|\vec{PQ}.\vec{N}\right|}{\|\vec{N}\|} $$


Substituting $\vec{PQ}$ and $\vec{N}$

$$d=\frac{|A(x_1-x_0)+B(y_1-y_0)+C(z_1-z_0)|}{\sqrt{A^2+B^2+C^2}}$$

But since Q lies on the plane, we have $Ax_1+By_1+Cz_1=−D$, so:

$$d=\frac{|-D-Ax_0-By_0-Cz_0)|}{\sqrt{A^2+B^2+C^2}}$$

This simplifies to:

$$d=\frac{|Ax_0+By_0+Cz_0+D)|}{\sqrt{A^2+B^2+C^2}}$$