% 1. Define vertices corner cube w/r/t unit cube
py = [eye(3), zeros(3, 1)]';

% vertices to solid shape
shp_original = alphaShape(py(:, 1), py(:, 2), py(:, 3));


% 2. What is the orientation of this corner cube?
% 2a. Equation of base x + y + z = 1
[x1, y1] = meshgrid(-0.4:0.1:1.2);
z1 = 1 - x1 - y1;

% 2b. Normal of base
n = cross(py(3, :) - py(2, :), py(3, :) - py(1, :));
n = n / norm(n);

% 2c. Center of base is the intersection of medians
p0 = [0 1 0]'; p1 = [1/2 0 1/2]';
vp = p0 - p1;

q0 = [1 0 0]'; q1 = [0 1/2 1/2]';
vq = q0 - q1;

A = [vp -vq];  % intersetion at p0 + t * dp = q0 + u * dq
L = q0 - p0;
X = A\L;

XCell = num2cell(X);
[t, u] = XCell{:};

pt = p0 + t * vp;  % p(t)
qu = q0 + u * vq;  % q(u) = p(t)

% plot fodder, figure 1
fig1 = figure(1);
fig1.Position = [100 100 800 850];

h_py_orig = plot(shp_original);
h_py_orig.FaceColor = 'k';
h_py_orig.FaceAlpha = 0.2;
h_py_orig.LineWidth = 2;

hold on;

h_surf_orig = surf(x1, y1, z1);
h_surf_orig.FaceAlpha = 0.7;

h_quiv_orig = quiver3(pt(1), pt(2), pt(3), n(1), n(2), n(3));
h_quiv_orig.LineWidth = 2;

anno1 = annotation(fig1, 'textbox');
anno1.Position = [0.60 0.55 0.16 0.05];
anno1.String = {'x + y + z = 1'};
anno1.HorizontalAlignment = 'center';
anno1.VerticalAlignment = 'middle';
anno1.FontSize = 14;
anno1.EdgeColor = [0.6 0.6 0.6];
anno1.BackgroundColor =  [1 1 1];

title1 = title('Unit pyramid');
title1.FontSize = 18;

xlabel('x'); ylabel('y'); zlabel('z');
daspect([1 1 1])
xlim([-0.4 1.2])
ylim([-0.4 1.2])
zlim([-0.4 1.2])
colormap(fig1, pink)

ax1 = gca;
ax1.FontSize = 13;
ax1.LineWidth = 1;
ax1.Projection = 'perspective';
ax1.View = [5 15];

hold off;


% 3. Rotation of corner cube via quaternion, and scale
up = [0 0 1];
scale = 30 / 12 * 0.3048;  % 30" = length of side from apex to base

theta = acos(dot(n, up));
v = cross(n, up); v = v / norm(v);

quat = [cos(theta / 2), sin(theta / 2) * v];

% rotation by inverse of quaternion; quatrotate() is meant to rotate space,
% and our objective is to rotate vectors
py_rot = quatrotate(quatinv(quat), scale * py);

% vertices to solid shape
shp_rotated = alphaShape(py_rot(:, 1), py_rot(:, 2), py_rot(:, 3));

% 3a. Equation of base
[x2, y2] = meshgrid(-1:0.1:1);

% z = height; scale * p(t) = height of pyramid (apex @ origin)
height = scale * norm(pt);
z2 = 0 * x2 - 0 * y2 - height;

% plot fodder, figure 2
fig2 = figure(2);
fig2.Position = [910 100 800 625];

h_py_rot = plot(shp_rotated);
h_py_rot.FaceColor = 'k';
h_py_rot.FaceAlpha = 0.2;
h_py_rot.LineWidth = 2;

hold on;

h_surf_rot = surf(x2, y2, z2);
h_surf_rot.FaceAlpha = 0.7;

h_quiv_rot = quiver3(0, 0, -height, up(1), up(2), up(3));
h_quiv_rot.LineWidth = 2;

anno2 = annotation(fig2, 'textbox');
anno2.Position = [0.60 0.45 0.16 0.05];
anno2.String = {'h = 0.4399 m'};
anno2.HorizontalAlignment = 'center';
anno2.VerticalAlignment = 'middle';
anno2.FontSize = 14;
anno2.EdgeColor = [0.6 0.6 0.6];
anno2.BackgroundColor =  [1 1 1];

title2 = title('Scaled and rotated pyramid');
title2.FontSize = 18;

xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
daspect([1 1 1])
xlim([-1 1])
ylim([-1 0.8])
zlim([-0.8 0.8])
colormap(fig2, pink)

ax2 = gca;
ax2.FontSize = 13;
ax2.LineWidth = 1;
ax2.Projection = 'perspective';
ax2.View = [-30 10];

hold off;
