% interactive image segmentation
function [seeds obj_names seg action cmap seeds_ucm_img bndry_img] = ...
    interactive_segmentation(obj_names, im, ucm, seeds, filename, fh)

% get image size
[sx sy sz] = size(im);

% get number of objects
data.image.n_objects = get_num_objects(seeds);

% initialize empty seeds if not specified
if ((nargin < 4) || (isempty(seeds)))
    seeds = zeros([sx sy]);
end

% set filename to 'unknown' if not specified
if ((nargin < 5) || (isempty(filename)))
    filename = 'unknown';
end

% use default figures if not specified
if ((nargin < 6) || (isempty(fh)))
    fh = 1;
end

% set other figure handles
fh_seg  = fh + 1; % figure for displaying segmentation results
fh_ui   = fh + 2; % figure for displaying the user interface

% clear figures
figure(fh); clf;
figure(fh_seg); clf;
figure(fh_ui); clf;

labels = [];
boundary = [];

ratio = size(im,1) / size(ucm,1);
% store image segmentation data
data.image.im        = im;
data.image.ucm       = ucm;
data.image.seeds     = seeds;
data.image.labels    = labels;
data.image.boundary  = boundary;
data.image.obj_names = obj_names;
data.image.ratio     = ratio;

% compute initial segmentation
[boundary labels] = compute_uvt(ucm, seeds);
data.image.labels    = labels;
data.image.boundary  = boundary;


% store backup of image data
data.image_store = data.image;

% store figure data
data.figures.fh      = fh;
data.figures.fh_seg  = fh_seg;
data.figures.fh_ui   = fh_ui;

% store current state
data.state.obj_id = 0;
data.state.cmap = cmap_n(length(obj_names)); %cmap_n(data.image.n_objects);
data.state.final_action = 'none';

% update figures
disp_update(data);

% create ui - resize primary figure
fh_ui_pos = get(fh_ui, 'Position');
fh_ui_pos([3 4]) = [275 750];
if (isempty(get(fh_ui,'UserData')))
    set(fh_ui, 'Position', fh_ui_pos);
    set(fh_ui, 'UserData', 1);
end

% create ui - object selection
figure(fh_ui);
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Object/Region Selection', ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 730 200 20] ...
    );
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Total segments defined:', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 700 170 20] ...
    );
data.ui.obj_total = uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', num2str(data.image.n_objects), ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [180 700 50 20] ...
    );
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Current Object:', ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 680 200 20] ...
    );
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'ID:', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 660 50 20] ...
    );
data.ui.obj_id = uicontrol(fh_ui, ...
    'Style',    'text', ...
    'String',   '', ... 
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [80 660 150 20] ... %'Callback', @ui_obj_id, ...
    );
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Label:', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 638 50 20] ...
    );
data.ui.obj_label = uicontrol(fh_ui, ...
    'Style',    'text', ...
    'String',   '', ... get_obj_name(data, data.state.obj_id)
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [80 640 150 20] ... 'Callback', @ui_obj_label, ...
    );
data.ui.obj_label_list = uicontrol(fh_ui, ...
    'Style',    'listbox', ...
    'String',   obj_names, ...
    'Callback', @ui_obj_label_list, ...
    'Position', [30 410 200 220] ...
    );
% data.ui.obj_new = uicontrol(fh_ui, ...
%     'Style',    'pushbutton', ...
%     'String',   'New', ...
%     'Callback', @ui_obj_new, ...
%     'Position', [30 370 50 30] ...
%     );
data.ui.obj_select = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Select in image', ...
    'Callback', @ui_obj_select, ...
    'Position', [30 370 200 30], ...
    'Enable', 'on' ...
    );
% data.ui.obj_label_apply = uicontrol(fh, ...
%    'Style',    'pushbutton', ...
%    'String',   'Apply Label', ...
%    'Callback', @ui_obj_label_apply, ...
%    'Position', [148 370 82 30] ...
% );
% create ui - editing
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Editing', ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 340 200 20] ...
    );
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Mode and Tool', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 315 200 20] ...
    );
data.ui.mode_draw = uicontrol(fh_ui, ...
    'Style',    'togglebutton', ...
    'String',   'Draw', ...
    'Value',    true, ...
    'Callback', @ui_mode_draw, ...
    'Position', [30 280 100 30] ...
    );
data.ui.mode_erase = uicontrol(fh_ui, ...
    'Style',    'togglebutton', ...
    'String',   'Erase', ...
    'Value',    false, ...
    'Callback', @ui_mode_erase, ...
    'Position', [130 280 100 30] ...
    );
data.ui.tool_pencil = uicontrol(fh_ui, ...
    'Style',    'togglebutton', ...
    'String',   'Pencil', ...
    'Value',    false, ...
    'Callback', @ui_tool_pencil, ...
    'Position', [30 240 66 30] ...
    );
data.ui.tool_brush = uicontrol(fh_ui, ...
    'Style',    'togglebutton', ...
    'String',   'Brush', ...
    'Value',    false, ...
    'Callback', @ui_tool_brush, ...
    'Position', [97 240 66 30] ...
    );
data.ui.tool_line = uicontrol(fh_ui, ...
    'Style',    'togglebutton', ...
    'String',   'Line', ...
    'Value',    false, ...
    'Callback', @ui_tool_line, ...
    'Position', [164 240 66 30] ...
    );
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'View', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 215 200 20] ...
    );
data.ui.view_zoom = uicontrol(fh_ui, ...
    'Style',    'togglebutton', ...
    'String',   'Zoom', ...
    'Value',    false, ...
    'Callback', @ui_view_zoom, ...
    'Position', [30 180 100 30] ...
    );
data.ui.view_reset = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Reset', ...
    'Callback', @ui_view_reset, ...
    'Position', [130 180 100 30] ...
    );
% create ui - image control
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Image', ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 140 200 20] ...
    );
uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', 'Current File:', ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 110 200 20] ...
    );
data.ui.file_curr = uicontrol(fh_ui, ...
    'Style',  'text', ...
    'String', filename, ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Position', [30 90 170 20] ...
    );
data.ui.image_revert = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Revert', ...
    'Callback', @ui_image_revert, ...
    'Position', [30 55 100 30] ...
    );
data.ui.image_save = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Save As', ...
    'Callback', @ui_image_save, ...
    'Position', [130 55 100 30] ...
    );

data.ui.file_save_prev = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Save & Prev', ...
    'Callback', @ui_file_save_prev, ...
    'Position', [30 30 100 30] ...
    );
data.ui.file_save_next = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Save & Next', ...
    'Callback', @ui_file_save_next, ...
    'Position', [130 30 100 30] ...
    );
data.ui.file_save_exit = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Save & Exit', ...
    'Callback', @ui_file_save_exit, ...
    'Position', [30 5 100 30] ...
    );
data.ui.file_exit = uicontrol(fh_ui, ...
    'Style',    'pushbutton', ...
    'String',   'Discard & Exit', ...
    'Callback', @ui_file_exit, ...
    'Position', [130 5 100 30] ...
    );

% display initial status message
disp_ui_status(data,'Edit the segmentation using controls on the left');

% wait for editing
waitfor(data.ui.file_curr,'String','Exiting');

% return seeds, object names, and last action (prev or next)
seeds = data.image.seeds;
obj_names = data.image.obj_names;
seg = data.image.labels;%seg = resize_labels(data.image.labels);
action = data.state.final_action;
cmap = data.state.cmap;
seeds_ucm_img = seeds_ucm_overlay_inv(ucm, seeds);
bndry_img = boundary_overlay(im, data.image.labels);

%% ----------------------------------------------------
% Helper functions

%% compute constrained segmentation
    function [boundary labels] = compute_uvt(ucm, seeds)
        % resize seeds
        seeds_n = imresize(seeds, [size(ucm,1) size(ucm,2)], 'nearest');
        % compute segmentation 
        [boundary labels] = uvt(ucm, seeds_n);
        % resize labels + boundary
        labels   = imresize(labels, [size(seeds,1) size(seeds,2)], 'nearest');
        boundary = imresize(boundary, [size(seeds,1) size(seeds,2)], 'nearest');
    end

%% resize segmentation labels to original image size
    function labels_sm = resize_labels(labels)
        labels_sm = labels(2:2:end,2:2:end);
    end

%% compute (thick) boundary from labels
    function boundary = boundary_from_labels(labels)
        [sx sy] = size(labels);
        % compute vertical, horizontal, diagonal differences
        dx  = (labels(1:end-1,:) ~= labels(2:end,:));
        dy  = (labels(:,1:end-1) ~= labels(:,2:end));
        dxy = (labels(1:end-1,1:end-1) ~= labels(2:end,2:end));
        dyx = (labels(2:end,1:end-1) ~= labels(1:end-1,2:end));
        % mark thick boundaries along each direction
        bx  = ([dx; zeros([1 sy])] | [zeros([1 sy]); dx]);
        by  = ([dy  zeros([sx 1])] | [zeros([sx 1])  dy]);
        bxy = zeros(size(labels));
        bxy(1:end-1,1:end-1) = bxy(1:end-1,1:end-1) | dxy;
        bxy(2:end,2:end)     = bxy(2:end,2:end)     | dxy;
        byx = zeros(size(labels));
        byx(2:end,1:end-1) = byx(2:end,1:end-1) | dyx;
        byx(1:end-1,2:end) = byx(1:end-1,2:end) | dyx;
        % combine boundaries
        boundary = bx | by | bxy | byx;
    end

%% return reordered color map
% (maximize distance between successive colors)
    function cmap = cmap_reorder(cmap)
        % initialize
        N = size(cmap,1);
        order = zeros([N 1]);
        used = zeros([N 1]);
        % fill color map
        order([1 2]) = [1 N];
        used([1 N]) = 1;
        pos = 3;
        step_size = N/2;
        while (step_size >= 1)
            for curr = step_size:step_size:N
                if (~used(curr))
                    used(curr) = 1;
                    order(pos) = curr;
                    pos = pos + 1;
                end
            end
            step_size = step_size/2;
        end
        cmap = cmap(order,:);
    end

% return color to use for a given number of labels
    function cmap = cmap_n(n_labels)
        n_colors = 2^ceil(log2(n_labels)); %64;
        while (n_colors < n_labels), n_colors = n_colors*2; end
        cmap = cmap_reorder(jet(n_colors));
    end

% return colormap to use for given set of labels
    function cmap = cmap_labels(labels)
        n_labels = max(labels(:));
        cmap = cmap_n(n_labels);
    end

%% return color of the given object id
    function c = get_obj_color(data, n)
        if n == 0
            c = [0.8 0.8 0.8];
        else
            c = data.state.cmap(n,:);
        end
    end

%% return name of the given object id
    function name = get_obj_name(data, n)
        if n == 0
            name = '';
        else
            name = data.image.obj_names{n};
        end
    end

%% get object name from object id
    function o_name = get_label_from_id(id)
        o_name = '';
        if id <= 0 || id > length(data.image.obj_names), return; end
        
        o_name = data.image.obj_names{id};
        i = strfind(o_name, ' ');
        if i > 0, o_name = o_name(i(end)+1:end); end
    end
%% get number of objects
    function num = get_num_objects(seeds)
        num = sum(unique(seeds(:)) > 0);
    end
%% compute pixel membership and centroids of each region
    function [pixel_ids centroids] = compute_membership(rmap)
        % compute pixel ids
        n_regions = max(rmap(:));
        pixel_ids = cell([1 n_regions]);
        pix_labels = reshape(rmap, [1 numel(rmap)]); %prod(size(rmap))]);
        [~, inds] = sort(rmap(:)); %[rmap_sorted inds] = sort(rmap(:));
        pix_labels = pix_labels(inds);
        pix_starts = find(pix_labels ~= [-1 pix_labels(1:end-1)]);
        pix_ends   = find(pix_labels ~= [pix_labels(2:end) (n_regions+1)]);
        for n = 1:length(pix_starts);
            ps = pix_starts(n);
            pe = pix_ends(n);
            pixel_ids{pix_labels(ps)} = inds(ps:pe);
        end
        % compute centroids
        centroids = zeros([n_regions 2]);
        [sx sy] = size(rmap);
        for n = 1:n_regions
            [xs ys] = ind2sub([sx sy], pixel_ids{n});
            centroids(n,1) = mean(xs);
            centroids(n,2) = mean(ys);
        end
    end

%% compute the centroid of each segment
    function [pixel_ids centroids] = compute_segment_centroids(rmap)
        % 1) find the region with the smallest value
        % 2) run flood-fill
        % 3) get the indices of the region
        % 4) calculate centroid
        % 5) repeat for all regions
        
        pixel_ids = [];
        centroids = [];
        
        rmap = uint8(rmap);
        wmap = rmap;
        
        maxVal = max(rmap(:));
        
        %figure(3); clf; imagesc(rmap); hold on
        while true
            minVal = min(wmap(:));
            if minVal > maxVal
                break;
            end
            
            % 1)
            floodImg = ones(size(rmap));
            floodImg( wmap == minVal ) = 0;
            [minR, minC] = find( wmap == minVal, 1 );
            fgIdx = floodImg == true;
            %figure(4); imagesc(floodImg);
            % 2)
            floodImg = imfill( logical(floodImg), [minR minC], 4 );
            floodImg = uint8(floodImg);
            %figure(4); imagesc(floodImg);
            % 3)
            floodImg(fgIdx) = 2;
            [regIdxY, regIdxX] = find( floodImg == 1 );
            %figure(4); imagesc(floodImg);
            % 4)
            centX = median(regIdxX);
            centY = median(regIdxY);
            pixel_ids(end+1) = minVal;
            centroids(end+1,:) = [centX, centY];
            %figure(3);text(centX,centY, int2str(minVal), 'color', [1, 1, 1]);
            
            wmap( floodImg == 1 ) = maxVal+1;
            %figure(5); imagesc(wmap)
            
            %pause
        end
        
    end
% ----------------------------------------------------
% Display functions

%% create seeds-ucm overlay
    function img = seeds_ucm_overlay(ucm, seeds, img)
        % if ucm is quadruple size, scale it down
%         if (size(ucm,1) >= 4. * size(seeds,1))
%             ucm = ucm(1:2:end,1:2:end);
%         end
%         % resize ucm to original image size
%         xs = 3:2:size(ucm,1);
%         ys = 3:2:size(ucm,2);
%         ucm = ...
%             max(max(ucm(xs,ys),ucm(xs-1,ys)),max(ucm(xs,ys-1),ucm(xs-1,ys-1)));
        ucm = imresize(ucm, [size(img,1), size(img,2)], 'nearest');
        % get colormap
        cmap = data.state.cmap; %cmap_labels(seeds);
        % assemble ucm + seeds overlay
        seed_inds = find(seeds > 0);
        seed_vals = seeds(seed_inds);
        img_r = img(:,:,1);
        img_g = img(:,:,2);
        img_b = img(:,:,3);
        img_r(seed_inds) = cmap(seed_vals,1);
        img_g(seed_inds) = cmap(seed_vals,2);
        img_b(seed_inds) = cmap(seed_vals,3);
        img = cat(3,img_r,img_g,img_b);
    end

%% create seeds-ucm overlay (inverted)
    function img = seeds_ucm_overlay_inv(ucm, seeds)
%         % if ucm is quadruple size, scale it down
%         if (size(ucm,1) >= 4.*size(seeds,1))
%             ucm = ucm(1:2:end,1:2:end);
%         end
%         % resize ucm to original image size
%         xs = 3:2:size(ucm,1);
%         ys = 3:2:size(ucm,2);
%         ucm = ...
%             max(max(ucm(xs,ys),ucm(xs-1,ys)),max(ucm(xs,ys-1),ucm(xs-1,ys-1)));
%         ucm = 1 - ucm;
        ucm = imresize(ucm, [size(seeds,1), size(seeds,2)], 'nearest');
        % get colormap
        cmap = data.state.cmap; %cmap_labels(seeds);
        % assemble ucm + seeds overlay
        seed_inds = find(seeds > 0);
        seed_vals = seeds(seed_inds);
        img_r = ucm;
        img_g = ucm;
        img_b = ucm;
        img_r(seed_inds) = cmap(seed_vals,1);
        img_g(seed_inds) = cmap(seed_vals,2);
        img_b(seed_inds) = cmap(seed_vals,3);
        img = cat(3,img_r,img_g,img_b);
    end

%% create boundary-image overlay
    function im = boundary_overlay(im, labels)
        % resize labels to original image size
        %labels_sm = resize_labels(labels);
        labels_sm = labels;
        % compute boundary from labels
        boundary = logical(boundary_from_labels(labels_sm));
        % create image + boundary overlay
        %im = (im + repmat(boundary,[1 1 3]));
        rIm = im(:,:,1);
        gIm = im(:,:,2);
        bIm = im(:,:,3);
        rIm(boundary) = 1.;
        gIm(boundary) = 1.;
        bIm(boundary) = 1.;
        im(:,:,1) = rIm;
        im(:,:,2) = gIm;
        im(:,:,3) = bIm;
    end

%% update main ui figure
    function disp_update_ui(ucm, seeds, img, fh)
        
        % create overlay
        img = seeds_ucm_overlay(ucm, seeds, img);
        % display overlay
        f = gcf;
        figure(fh);
        image(img);
        axis image;
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        colormap(cmap);
        %title('Groundtruth')
        figure(f);
    end

%% update segmentation results figure
    function disp_update_seg(labels, obj_names, fh)
        % resize labels to original image size
        labels_sm = resize_labels(labels);
        % get colormap
        cmap = data.state.cmap; %cmap_labels(labels_sm);
        % find centroids
        %[pixel_ids centroids] = compute_membership(labels_sm);
        [pixel_ids centroids] = compute_segment_centroids(labels_sm);
        % display labels
        f = gcf;
        figure(fh);
        image(labels_sm);
        axis image;
        axis off;
        title('Segmentation');
        colormap(cmap);
        % display object names
        hold on;
        for n = 1:length(pixel_ids)
            if isempty(centroids(n)), continue; end
            if pixel_ids(n) == 0, continue; end
            x = centroids(n,1);
            y = centroids(n,2);
            o_name = get_label_from_id(pixel_ids(n));
            if (~isempty(o_name))
                text(x,y,o_name, 'Color',[0,0,0]);
            end
        end
        hold off;
        figure(f);
    end

%% update boundary results figure
%    function disp_update_boundary(im, labels, fh)
%       % create image + boundary overlay
%       im = boundary_overlay(im, labels);
%       % display overlay
%       f = gcf;
%       figure(fh);
%       image(im);
%       axis image;
%       axis off;
%       title('Boundary Map');
%       figure(f);
%    end

%% update all figure content
    function disp_update(data)
        dimg = data.image;
        
        % create image + boundary overlay
        img = boundary_overlay(dimg.im, dimg.labels);
        disp_update_ui(dimg.ucm, dimg.seeds, img, data.figures.fh);
        
        disp_update_seg(dimg.labels, dimg.obj_names, data.figures.fh_seg);
        %disp_update_boundary(dimg.im, dimg.labels, data.figures.fh);
    end

% ----------------------------------------------------
% UI functions

%% get n clicks within the image limits
    function [xs ys buttons] = ginput_range(im_size, n)
        if (nargin < 2), n = 1; end
        curr = 1;
        xs = zeros([n 1]);
        ys = zeros([n 1]);
        buttons = zeros([n 1]);
        figure(data.figures.fh)
        while (curr <= n)
            [y x b] = ginput(1);
            x = round(x);
            y = round(y);
            if (~((x < 1) || (x > im_size(1)) || ...
                    (y < 1) || (y > im_size(2))))
                xs(curr) = x;
                ys(curr) = y;
                buttons(curr) = b;
                curr = curr + 1;
            end
        end
    end

%% get the current ui mode (false for erase, true for draw)
    function [mode mode_str] = get_ui_mode(data)
        mode = get(data.ui.mode_draw, 'Value');
        if (mode), mode_str = 'draw'; else mode_str = 'erase'; end
    end

%% display a status string
    function disp_ui_status(data, str)
        f = gcf;
        figure(data.figures.fh);
        xlabel(str, 'FontSize', 16);
        figure(f);
    end

%% refresh the ui object information display
    function disp_ui_obj_info(data)
        id   = data.state.obj_id;
        c    = get_obj_color(data, id);
        name = get_label_from_id(id);
        
        set(data.ui.obj_total, 'String', num2str(data.image.n_objects));
        set(data.ui.obj_id, 'String', num2str(id));
        set(data.ui.obj_id, 'BackgroundColor', c);
        set(data.ui.obj_id, 'ForegroundColor', 1-c);
        set(data.ui.obj_label, 'String', name);
        set(data.ui.obj_label, 'BackgroundColor', c);
        set(data.ui.obj_label, 'ForegroundColor', 1-c);
        set(data.ui.obj_label_list, 'Value', id );
        
    end

% ----------------------------------------------------
% UI callbacks

%% current object id changed
%     function ui_obj_id(h, event_data)
%         % get the new object id
%         val = get(h,'String');
%         id = round(str2num(val));
%         % check validity
%         if (isempty(id) || (id < 1) || (id > data.image.n_objects))
%             disp_ui_status(data,'Invalid id, use new to create a new object');
%         else
%             % update state
%             data.state.obj_id = id;
%             disp_ui_status(data,['Switched to object ' num2str(id)]);
%         end
%         % refresh ui
%         disp_ui_obj_info(data);
%     end

%% current object label changed
%     function ui_obj_label(h, event_data)
%         % get the new object label
%         str = get(h,'String');
%         % update data
%         data.image.obj_names{data.state.obj_id} = str;
%         % refresh ui
%         disp_update_seg( ...
%             data.image.labels, data.image.obj_names, data.figures.fh_seg);
%         disp_ui_obj_info(data);
%         disp_ui_status( ...
%             data, ['Object ' num2str(data.state.obj_id) ' labeled ' str] ...
%             );
%     end

%% label selection changed
    function ui_obj_label_list(h, event_data)
        % update state
        val  = get(data.ui.obj_label_list,'Value');
        str = get_label_from_id( val );

        data.state.obj_id = val;

        % update data
        %data.image.obj_names{data.state.obj_id} = str;
        % refresh ui
        %disp_update_seg( ...
        %    data.image.labels, data.image.obj_names, data.figures.fh_seg);
        disp_ui_obj_info(data);
        disp_ui_status( ...
            data, ['Object ' num2str(data.state.obj_id) ' labeled ' str] ...
            );
    end

%% create a new object
%     function ui_obj_new(h, event_data)
%         % increment number of objects
%         data.image.n_objects = data.image.n_objects + 1;
%         data.image.obj_names = [data.image.obj_names; {''}];
%         % update state
%         val  = get(data.ui.obj_label_list,'Value');
%         data.state.obj_id = val; %data.image.n_objects;
%         %data.state.cmap = cmap_n(data.image.n_objects);
%         % refresh ui
%         disp_ui_obj_info(data);
%         disp_ui_status( ...
%             data, ['Created new object with id ' num2str(data.state.obj_id) ...
%             ]);
%         % apply label to object
%         ui_obj_label_apply();
%         
%         %enable the select button
%         set( data.ui.obj_select, 'Enable', 'on' )
%     end

%% interactively select an object from the groundtruth
    function ui_obj_select(~, ~)
        % select a pixel
        disp_ui_status(data,'Selected a marked object in the image');
        [sx sy] = size(data.image.im);
        [x y] = ginput_range([sx sy]);
        labels_sm = resize_labels(data.image.labels);
        id = labels_sm(x,y);
        % check validity
        if (id > 0)
            % update state
            data.state.obj_id = id;
            name = get_label_from_id(id); %data.image.obj_names{id};
            disp_ui_status(data,['Switched to object ', num2str(id), ': ', name]);
        else
            disp_ui_status(data,'No object selected');
        end
        % refresh ui
        disp_ui_obj_info(data);
    end

%% draw mode toggle button pushed
    function ui_mode_draw(h, ~)
        % get value
        val = get(h,'Value');
        % check if toggled on
        if (val)
            % toggled on -> set erase to false
            set(data.ui.mode_erase, 'Value', false);
            disp_ui_status(data, 'Draw mode selected');
        else
            % cannot toggle off
            set(data.ui.mode_draw, 'Value', true);
        end
    end

%% erase mode toggle button pushed
    function ui_mode_erase(h, ~)
        % get value
        val = get(h,'Value');
        % check if toggled on
        if (val)
            % toggled on -> set draw to false
            set(data.ui.mode_draw, 'Value', false);
            disp_ui_status(data, 'Erase mode selected');
        else
            % cannot toggle off
            set(data.ui.mode_erase, 'Value', true);
        end
    end


%% draw/erase with pencil
    function ui_tool_pencil(~, ~)
        % get current mode (draw or erase)
        [mode mode_str] = get_ui_mode(data);
        % select points and update display
        [sx sy] = size(data.image.im);
        while (true)
            disp_ui_status(data, ['Click points to ' mode_str '; Right click to stop']);
            [x y button] = ginput_range([sx sy]);
            %x = round(x / data.image.ratio);
            %y = round(y / data.image.ratio);
            
            % left click 
            if (button == 1)
                if (mode)
                    data.image.seeds(x,y) = data.state.obj_id;
                else
                    data.image.seeds(x,y) = 0;
                end
                disp_update_ui(data.image.ucm, data.image.seeds, data.image.im, data.figures.fh);
            
                disp_ui_status(data, 'Computing segmentation ...');
                [boundary labels] = compute_uvt(data.image.ucm, data.image.seeds);
                data.image.boundary = boundary;
                data.image.labels = labels;
                data.image.n_objects = get_num_objects(labels);
                set(data.ui.obj_total, 'String', num2str(data.image.n_objects));
                disp_update(data);
            else
                set(data.ui.tool_pencil, 'Value', false);
                break;
            end
        end
        disp_ui_status(data, 'Done');
    end

%% draw/erase with brush
    function ui_tool_brush(~, ~)
        % brush size
        bsz = 1;
        % get current mode (draw or erase)
        [mode mode_str] = get_ui_mode(data);
        % select points and update display
        [sx sy] = size(data.image.im);
        while (true)
            disp_ui_status(data, ['Click points to ' mode_str '; Right click to stop']);
            [x y button] = ginput_range([sx sy]);
            %x = round(x / data.image.ratio);
            %y = round(y / data.image.ratio);
            
            if (button == 1)
                x_min = max(x-bsz,1); x_max = min(x+bsz,sx);
                y_min = max(y-bsz,1); y_max = min(y+bsz,sy);
                if (mode)
                    data.image.seeds(x_min:x_max,y_min:y_max) = data.state.obj_id;
                else
                    data.image.seeds(x_min:x_max,y_min:y_max) = 0;
                end
                disp_update_ui(data.image.ucm, data.image.seeds, data.image.im, data.figures.fh);
            
                disp_ui_status(data, 'Computing segmentation ...');
                [boundary labels] = compute_uvt(data.image.ucm, data.image.seeds);
                data.image.boundary = boundary;
                data.image.labels = labels;
                data.image.n_objects = get_num_objects(labels);
                set(data.ui.obj_total, 'String', num2str(data.image.n_objects));
                
                disp_update(data);
            else
                set(data.ui.tool_brush, 'Value', false);
                break;
            end
        end
        disp_ui_status(data, 'Done');
    end

%% draw/erase with line
    function ui_tool_line(~, ~)
        % get current mode (draw or erase)
        [mode mode_str] = get_ui_mode(data);
        % get image size
        [sx sy] = size(data.image.seeds);
        % check mode
        if (mode)
            % drawing line - select initial point
            disp_ui_status( ...
                data, ['Click initial point to ' mode_str '; Right click to stop']);
            [x_prev y_prev button] = ginput_range([sx sy]);
            % drawing line - select sequence of points on line
            while (button == 1)
                disp_ui_status( ...
                    data, ['Click points to ' mode_str '; Right click to stop']);
                [x y button] = ginput_range([sx sy]);
                if (button == 1)
                    % draw line
                    inds = mex_line_inds(x_prev, y_prev, x, y, [sx sy]);
                    data.image.seeds(inds) = data.state.obj_id;
                    % store previous coords
                    x_prev = x;
                    y_prev = y;
                    % update display
                    disp_update_ui(data.image.ucm, data.image.seeds, data.image.im, data.figures.fh);
                end
            end
        else
            % erasing components
            while (true)
                disp_ui_status( ...
                    data, ['Click component to ' mode_str '; Right click to stop']);
                [x y button] = ginput_range([sx sy]);
                if (button == 1)
                    % erase selected component
                    L = bwlabel(data.image.seeds > 0);
                    %inds = find(L == L(x,y));
                    data.image.seeds(L == L(x,y)) = 0;
                    % update display
                    disp_update_ui(data.image.ucm, data.image.seeds, data.image.im, data.figures.fh);
                else
                    break;
                end
            end
        end
        % recompute segmentation
        disp_ui_status(data, 'Computing segmentation ...');
        [boundary labels] = compute_uvt(data.image.ucm, data.image.seeds);
        data.image.boundary = boundary;
        data.image.labels = labels;
        data.image.n_objects = get_num_objects(labels);
        set(data.ui.obj_total, 'String', num2str(data.image.n_objects));
                
        % update display
        disp_update(data);
        set(data.ui.tool_line, 'Value', false);
    end

%% zoom button toggled
    function ui_view_zoom(h, event_data)
        val = get(h,'Value');
        if (val), figure(fh); zoom('on'); else zoom('off'); end
    end

%% zoom reset pushed
    function ui_view_reset(h, event_data)
        figure(fh); zoom('out');
    end

%% image revert
    function ui_image_revert(~, ~)
        % revert to previous image data
        data.image = data.image_store;
        % reset state
        %data.state.obj_id = 0;
        %data.state.cmap = cmap_n(data.image.n_objects);
        % refresh display
        disp_update(data);
        disp_ui_obj_info(data);
        disp_ui_status(data, 'Reverted to last stored groundtruth');
    end
%% image save
    function ui_image_save(~, ~)
        seeds = data.image.seeds;
        uisave('seeds', [filename, '_seeds.mat']);
    end

%% file save and move to previous
    function ui_file_save_prev(~, ~)
        data.state.final_action = 'prev';
        set(data.ui.file_curr,'String','Exiting');
    end

%% file save and move to next
    function ui_file_save_next(~, ~)
        data.state.final_action = 'next';
        set(data.ui.file_curr,'String','Exiting');
    end
%% file save and exit
    function ui_file_save_exit(~, ~)
        data.state.final_action = 'save';
        set(data.ui.file_curr,'String','Exiting');
    end

%% file discard and exit
    function ui_file_exit(~, ~)
        data.state.final_action = 'exit';
        set(data.ui.file_curr,'String','Exiting');
    end
end
