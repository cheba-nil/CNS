% https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;9196f5f5.1006

% other = ref space src, or ref space XXX that want to map back to src

% varargout{1} = other in src space

function varargout = CNSP_reverse_registration_wMx (src, ref, other, varargin)

% 	copyfile (src, [src '_backup'], 'f');

	src_vol = spm_vol (src);
	ref_vol = spm_vol (ref);
    other_vol = spm_vol (other);

    coregFlags = struct ('graphics', 'False' ...
                        );
    
	rot_par_src2ref = spm_coreg (ref_vol, src_vol, coregFlags);
    
	trans_mx_src2ref = spm_matrix (rot_par_src2ref);

    % equivalent to reorient
	% spm_get_space (src, trans_mx_src2ref * src_vol.mat);
	spm_get_space (other, trans_mx_src2ref * spm_get_space (other)); % Ref: https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;f71e11b9.0710
																	 % spm_coreg returns a transformation from
																	 % reference to source, which is then inverted in spm_config_coreg
																	 % therefore, reverse transformation is inv(inv(Mx)), which equals Mx

	% other_space = spm_get_space (other);
	% spm_get_space (other, trans_mx_src2ref \ other_space); % a\b is equivalent to inv(a)*b
    
    
%     CNSP_reorientImg (ref, inv(trans_mx_src2ref), '');
%     CNSP_reorientImg (other, inv(trans_mx_src2ref), '');

    if nargin == 4 && strcmp (varargin{1}, 'Tri')
        interp = 1;
    elseif nargin == 3
        interp = 0; % nearest neighbour (default)
    end
    
	resliceFlags= struct('interp',interp,... % Nearest Neighbour
					'mask',1,...
					'mean',0,...
					'which',1,...
					'wrap',[0 0 0]);
	

	files = {src;other};
    
%     [srcPath, srcFilename, srcExt] = fileparts (src);
%     [otherPath, otherFilename, otherExt] = fileparts (other);
%     files = {ref;
%             [srcPath '/ro_' srcFilename srcExt];
%             [otherPath '/ro_' otherFilename otherExt]};
% 
	spm_reslice(files, resliceFlags);

	[other_dir, other_filename, other_ext] = fileparts (other);

	varargout{1} = [other_dir '/r' other_filename other_ext];


	fprintf ('\n');
	fprintf ('CNSP_reverse_registration_wMx: finished\n');