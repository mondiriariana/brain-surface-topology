%%  Load and Downsample Mesh 
[vertices, faces] = read_obj('brain_surface.obj');
max_faces = 20000;

if size(faces,1) > max_faces
    reduction_ratio = max_faces / size(faces,1);
    [faces, vertices] = reducepatch(faces, vertices, reduction_ratio);
end

%%  Apply Deformation 
rng(42);
noise_strength = [3, 3, 3];
noisy_vertices = vertices + randn(size(vertices)) .* noise_strength;
noisy_vertices(:,3) = noisy_vertices(:,3) + 10 * sin(0.05 * noisy_vertices(:,1)) ...
                                          + 5 * cos(0.03 * noisy_vertices(:,2));

%% Compute Metrics 
[V1,E1,F1] = compute_topology(vertices, faces);
chi1 = V1 - E1 + F1; g1 = 1 - chi1/2;
area1 = compute_area(vertices, faces);
volume1 = abs(compute_volume(vertices, faces));
curvature1 = estimate_vertex_curvature(vertices, faces);

[V2,E2,F2] = compute_topology(noisy_vertices, faces);
chi2 = V2 - E2 + F2; g2 = 1 - chi2/2;
area2 = compute_area(noisy_vertices, faces);
volume2 = abs(compute_volume(noisy_vertices, faces));
curvature2 = estimate_vertex_curvature(noisy_vertices, faces);

%%  Setup Figure and VideoWriter 
video_fig = figure('Position',[100 100 1200 600]);
v = VideoWriter('rotating_comparison.avi'); v.FrameRate = 30;
open(v);

%%  Main Loop: Rotate & Display Internally + Save 
for angle = 1:360
    clf;

    subplot(1,2,1);
    trisurf(faces, vertices(:,1), vertices(:,2), vertices(:,3), curvature1, ...
        'EdgeColor','none');
    axis equal off;
    view(angle, 30); lighting gouraud; camlight;
    colormap(gca, gray); title('Original brain');

    infoStr1 = sprintf('V: %d  E: %d  F: %d\nArea: %.1f  Vol: %.1f\n\\chi: %d  g: %.1f', ...
        V1,E1,F1,area1,volume1,chi1,g1);
    text(0,0,max(vertices(:,3)), infoStr1, 'FontSize',10, ...
         'BackgroundColor','w','EdgeColor','k');

    subplot(1,2,2);
    trisurf(faces, noisy_vertices(:,1), noisy_vertices(:,2), noisy_vertices(:,3), curvature2, ...
        'EdgeColor','none');
    axis equal off;
    view(angle, 30); lighting gouraud; camlight;
    colormap(gca, parula); title('Noisy deformed brain');

    infoStr2 = sprintf('V: %d  E: %d  F: %d\nArea: %.1f  Vol: %.1f\n\\chi: %d  g: %.1f', ...
        V2,E2,F2,area2,volume2,chi2,g2);
    text(0,0,max(noisy_vertices(:,3)), infoStr2, 'FontSize',10, ...
         'BackgroundColor','w','EdgeColor','k');

    drawnow;                  % This shows the current frame on screen
    frame = getframe(video_fig); % This captures it for the video
    writeVideo(v, frame);     % Save to video file
end

close(v);
fprintf('Saved video: rotating_comparison.avi\n');
%% Functions 
function [vertices, faces] = read_obj(filename)
    fid = fopen(filename);
    vertices = [];
    faces = [];
    while ~feof(fid)
        line = fgetl(fid);
        if startsWith(line, 'v ')
            vertices(end+1,:) = sscanf(line(3:end), '%f %f %f');
        elseif startsWith(line, 'f ')
            f = sscanf(line(3:end), '%d %d %d');
            if numel(f)==3, faces(end+1,:) = f'; end
        end
    end
    fclose(fid);
end

function [V,E,F] = compute_topology(vertices, faces)
    V = size(vertices,1);
    F = size(faces,1);
    edges = sort([faces(:,[1 2]); faces(:,[2 3]); faces(:,[3 1])], 2);
    E = size(unique(edges, 'rows'), 1);
end

function area = compute_area(vertices, faces)
    v1 = vertices(faces(:,1),:);
    v2 = vertices(faces(:,2),:);
    v3 = vertices(faces(:,3),:);
    area = sum(0.5 * vecnorm(cross(v2-v1, v3-v1, 2), 2, 2));
end

function volume = compute_volume(vertices, faces)
    v1 = vertices(faces(:,1),:);
    v2 = vertices(faces(:,2),:);
    v3 = vertices(faces(:,3),:);
    volume = (1/6) * sum(dot(v1, cross(v2,v3,2), 2));
end

function curvature = estimate_vertex_curvature(vertices, faces)
    curvature = accumarray(faces(:), repmat(1/3, numel(faces), 1), [size(vertices,1),1]);
end

