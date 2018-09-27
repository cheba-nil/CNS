% Detection and Outline Error Estimates (DOEE)
%
% Reference: David S Wack et al., 2012

function DOEE_calculation (rater1_result, rater2_result, N_conn, outputDir, spm12path, ID)

	CNSP_path = fileparts ( fileparts (fileparts (mfilename ('fullpath'))));

	addpath ([CNSP_path '/downloaded_scipts/NIfTI_tools']);

	rater1_result_nii_vol = spm_vol (rater1_result);
	rater2_result_nii_vol = spm_vol (rater2_result);

	rater1_result_nii_data = spm_read_vols (rater1_result_nii_vol);
	rater2_result_nii_data = spm_read_vols (rater2_result_nii_vol);

	rater12_result_img_sum = rater1_result_nii_data + rater2_result_nii_data;

	rater12_result_img_sum_bin = rater12_result_img_sum;
	rater12_result_img_sum_bin (rater12_result_img_sum_bin > 0) = 1;
	rater12_result_img_sum_bin (rater12_result_img_sum_bin <= 0) = 0;

	% clusterise (rater1 + rater2)
	rater12_result_img_sum_bin_conn = bwconncomp (rater12_result_img_sum_bin, N_conn);
	% clusterise rater1
	rater1_result_img_conn = bwconncomp (rater1_result_nii_data, N_conn);
	% clusterise rater2
	rater2_result_img_conn = bwconncomp (rater2_result_nii_data, N_conn);

	% label (rater1 + rater2) matrix
	rater12_result_img_sum_bin_conn_label = labelmatrix (rater12_result_img_sum_bin_conn);

	% hist (cast (rater12_result_img_sum_bin_conn_label, 'double'), double (a))

	% display
	% [x y z] = ind2sub(size(rater12_result_img_sum_bin_conn_label), ...
	% 					find(rater12_result_img_sum_bin_conn_label));

	% plot3(x, y, z, 'k.');
	
	% label rater1 matrix
	% rater1_result_img_conn_label = labelmatrix (rater1_result_img_conn);
	% % label rater2 matrix
	% rater2_result_img_conn_label = labelmatrix (rater2_result_img_conn);


	% % rater1 and rater2 total
	% rater1_total = rater1_result_img_conn.NumObjects
	% rater2_total = rater2_result_img_conn.NumObjects


	% number of labels
	N_sum_labels = rater12_result_img_sum_bin_conn.NumObjects;
	% max(max(max(rater12_result_img_sum_bin_conn_label)))

	rater1_total = cell (N_sum_labels, 1);
	rater2_total = cell (N_sum_labels, 1);
	intersection_rater12 = cell (N_sum_labels, 1);
	union_rater12 = cell (N_sum_labels, 1);
	DE = cell (N_sum_labels, 1);
	OE = cell (N_sum_labels, 1);
	MTA = cell (N_sum_labels, 1);
	SI = cell (N_sum_labels, 1);

	for i = 1:N_sum_labels
		temp_matrix = rater12_result_img_sum_bin_conn_label;

		% temp_matrix (temp_matrix == i) = 1;
		% temp_matrix (temp_matrix ~= i) = 0;
		temp_matrix = temp_matrix == i;

		fprintf ('Combined cluster Number %d has %d voxels.\n', i, nnz(temp_matrix));

		%%% rater total in combined cluster %%% 
		rater1_within_sumLabel = cast (temp_matrix, 'double') ...
									.* ...
								cast (rater1_result_nii_data, 'double');

		rater2_within_sumLabel = cast (temp_matrix, 'double') ...
									.* ...
								cast (rater2_result_nii_data, 'double');

		rater1_total{i,1} = nnz (rater1_within_sumLabel);
		rater2_total{i,1} = nnz (rater2_within_sumLabel);


		%%% intersection %%%
		intersection_rater12_mx = rater1_within_sumLabel .* rater2_within_sumLabel;
		intersection_rater12{i,1} = nnz (intersection_rater12_mx);


		%%% union %%%
		union_rater12_mx = rater1_within_sumLabel + rater2_within_sumLabel;
		union_rater12_mx = union_rater12_mx > 0;
		union_rater12{i,1} = nnz (union_rater12_mx);


		%%% DE %%%
		if (rater1_total{i,1} == 0) || (rater2_total{i,1} == 0)
			DE{i,1} = rater1_total{i,1} + rater2_total{i,1};
		else
			DE{i,1} = 0;
		end


		%%% OE %%%
		if (rater1_total{i,1} ~= 0) & (rater2_total{i,1} ~= 0)
			OE_mx = union_rater12_mx - intersection_rater12_mx;
			OE{i,1} = nnz (OE_mx);
		else
			OE{i,1} = 0;
		end		

	end


	%%% MTA - mean total area %%%
	rater1_total_sum = 0;
	rater2_total_sum = 0;

	for j = 1:N_sum_labels
		rater1_total_sum = rater1_total_sum + rater1_total{j,1};
		rater2_total_sum = rater2_total_sum + rater2_total{j,1};
	end

	for m = 1: N_sum_labels
		MTA{m,1} = (rater1_total_sum + rater2_total_sum) / 2; % same value for the whole column
	end


	%%% DER and OER %%%
	totalDE = 0;
	totalOE = 0;

	for k = 1:N_sum_labels
		totalDE = totalDE + DE{k,1};
		totalOE = totalOE + OE{k,1};
	end

	DER = totalDE / MTA{1};
	OER = totalOE / MTA{1};

	fprintf ('DER = %.3f; OER = %.3f\n', DER, OER);

	%%% Similarity Index (SI) %%%
	% according to Wack 2012, SI = total_intersection / MTA
	total_intersection = sum ([intersection_rater12{:,1}]);
	for n = 1 : N_sum_labels
		SI{n,1} = total_intersection / MTA{1}; % same value for the whole column
	end
	fprintf ('SI = %.3f\n', SI{1});


	outputCELL = horzcat (rater1_total, ...
							rater2_total, ...
							intersection_rater12, ...
							union_rater12, ...
							DE, ...
							OE, ...
							MTA, ...
							SI);

	% write to text file
	outputTBL = cell2table (outputCELL);
	outputTBL.Properties.VariableNames = {'rater1_total' ...
											'rater2_total' ...
											'intersection' ...
											'union' ...
											'DE' ...
											'OE' ...
											'MTA' ...
											'SI'};

	writetable (outputTBL, [outputDir '/detailed_output.txt']);


	if exist ([outputDir '/summary_output.txt'], 'file') == 2
		system (['rm -f ' outputDir '/summary_output.txt']);
	end


	fid = fopen ([outputDir '/summary_output.txt'], 'w');
	fprintf (fid, 'ID = %s\n', ID);
	fprintf (fid, 'DER = %.3f\n', DER);
	fprintf (fid, 'OER = %.3f\n', OER);
	fprintf (fid, 'MTA = %d\n', MTA{1});
	fprintf (fid, 'SI = %.3f\n', SI{1});
	fclose (fid);
