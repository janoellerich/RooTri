%..........................................................................
%                               RooTri
%                                v1.0
%
%        by Jan Oellerich & Keno Jann Buescher & Jan Philip Degel
%                                2023
%..........................................................................

function [ipmat] = RooTri(arg1, arg2, arg3, arg4, arg5)
    
    % INPUTS
    %   arg1   point cloud as n x 3 matrix
    %   arg2   a of parameter plane equation, default = 0
    %   arg3   b of parameter plane equation, default = 0
    %   arg4   c of parameter plane equation, default = 1
    %   arg5   d of parameter plane equation, default = 0
    
    % perform delaunay triangulation
    T = delaunay(arg1(:,1),arg1(:,2));

    a_vec = arg2 * ones(length(T(:,1)),1);
    b_vec = arg3 * ones(length(T(:,1)),1);
    c_vec = arg4 * ones(length(T(:,1)),1);
    d_vec = arg5 * ones(length(T(:,1)),1);

    p1_mat = [arg1(T(:,1),1) arg1(T(:,1),2) arg1(T(:,1),3)];
    p2_mat = [arg1(T(:,2),1) arg1(T(:,2),2) arg1(T(:,2),3)];
    p3_mat = [arg1(T(:,3),1) arg1(T(:,3),2) arg1(T(:,3),3)];
    
    vec_1 = p2_mat - p1_mat;            % main vector 1: p1 --> p2   
    vec_2 = p3_mat - p2_mat;            % main vector 2: p2 --> p3    
    vec_3 = p1_mat - p3_mat;            % main vector 3: p3 --> p1
     
    aux_p12 = p1_mat + 0.5 * vec_1;     % aux vec 12: 0.5 vector 1 + p1    
    aux_p23 = p2_mat + 0.5 * vec_2;     % aux vec 23: 0.5 vector 2 + p2    
    aux_p31 = p3_mat + 0.5 * vec_3;     % aux vec 31: 0.5 vector 3 + p3 

    aux_vec_12_3 = p3_mat - aux_p12;
    aux_vec_23_1 = p1_mat - aux_p23;
    aux_vec_31_2 = p2_mat - aux_p31;

    aux_vec_12_23 =  aux_p23 - aux_p12;
    aux_vec_23_31 =  aux_p31 - aux_p23;
    aux_vec_31_12 =  aux_p12 - aux_p31;

    lambda_mat(:,1) = (d_vec - (p1_mat(:,1).* a_vec + p1_mat(:,2).* ... 
        b_vec + p1_mat(:,3).* c_vec)) ./ (vec_1(:,1).* a_vec + ...
        vec_1(:,2).* b_vec + vec_1(:,3).* c_vec);

    lambda_mat(:,2) = (d_vec - (p2_mat(:,1).* a_vec + p2_mat(:,2).* ...
        b_vec + p2_mat(:,3).* c_vec)) ./ (vec_2(:,1).* a_vec + ...
        vec_2(:,2).* b_vec + vec_2(:,3).* c_vec);

    lambda_mat(:,3) = (d_vec - (p3_mat(:,1).* a_vec + p3_mat(:,2).* ...
        b_vec + p3_mat(:,3).* c_vec)) ./ (vec_3(:,1).* a_vec + ...
        vec_3(:,2).* b_vec + vec_3(:,3).* c_vec);

    lambda_mat(:,4) = (d_vec - (aux_p12(:,1).* a_vec + aux_p12(:,2).* ... 
        b_vec + aux_p12(:,3).* c_vec)) ./ (aux_vec_12_3(:,1).* a_vec + ...
        aux_vec_12_3(:,2).* b_vec + aux_vec_12_3(:,3).* c_vec);

    lambda_mat(:,5) = (d_vec - (aux_p23(:,1).* a_vec + aux_p23(:,2).* ...
        b_vec + aux_p23(:,3).* c_vec)) ./ (aux_vec_23_1(:,1).* a_vec + ...
        aux_vec_23_1(:,2).* b_vec + aux_vec_23_1(:,3).* c_vec);

    lambda_mat(:,6) = (d_vec - (aux_p31(:,1).* a_vec + aux_p31(:,2).* ...
        b_vec + aux_p31(:,3).* c_vec)) ./ (aux_vec_31_2(:,1).* a_vec + ...
        aux_vec_31_2(:,2).* b_vec + aux_vec_31_2(:,3).* c_vec);

    lambda_mat(:,7) = (d_vec - (aux_p12(:,1).* a_vec + aux_p12(:,2).* ...
        b_vec + aux_p12(:,3).* c_vec)) ./ (aux_vec_12_23(:,1).* a_vec + ...
        aux_vec_12_23(:,2).* b_vec + aux_vec_12_23(:,3).* c_vec);

    lambda_mat(:,8) = (d_vec - (aux_p23(:,1).* a_vec + aux_p23(:,2).* ...
        b_vec + aux_p23(:,3).* c_vec)) ./ (aux_vec_23_31(:,1).* a_vec + ...
        aux_vec_23_31(:,2).* b_vec + aux_vec_23_31(:,3).* c_vec);

    lambda_mat(:,9) = (d_vec - (aux_p31(:,1).* a_vec + aux_p31(:,2).* ...
        b_vec + aux_p31(:,3).* c_vec)) ./ (aux_vec_31_12(:,1).* a_vec + ...
        aux_vec_31_12(:,2).* b_vec + aux_vec_31_12(:,3).* c_vec);

    % compute intersection matrices
    intersec_mat_1 = p1_mat + lambda_mat(:,1).* vec_1;
    intersec_mat_2 = p2_mat + lambda_mat(:,2).* vec_2;  
    intersec_mat_3 = p3_mat + lambda_mat(:,3).* vec_3;     
    intersec_mat_4 = aux_p12 + lambda_mat(:,4).* aux_vec_12_3; 
    intersec_mat_5 = aux_p23 + lambda_mat(:,5).* aux_vec_23_1;
    intersec_mat_6 = aux_p31 + lambda_mat(:,6).* aux_vec_31_2;
    intersec_mat_7 = aux_p12 + lambda_mat(:,7).* aux_vec_12_23; 
    intersec_mat_8 = aux_p23 + lambda_mat(:,8).* aux_vec_23_31;
    intersec_mat_9 = aux_p31 + lambda_mat(:,9).* aux_vec_31_12;

    ipmat = intersec_mat_1(...
        lambda_mat(:,1) <=1 & lambda_mat(:,1) >= 0,:,:);
    ipmat = [ipmat; ...
        intersec_mat_2(...
        lambda_mat(:,2) <=1 & lambda_mat(:,2) >= 0,:,:)];
    ipmat = [ipmat; ...
        intersec_mat_3(...
        lambda_mat(:,3) <=1 & lambda_mat(:,3) >= 0,:,:)];
    ipmat = [ipmat; ...
        intersec_mat_4(...
        lambda_mat(:,4) <=1 & lambda_mat(:,4) >= 0,:,:)];
    ipmat = [ipmat; ...
        intersec_mat_5(...
        lambda_mat(:,5) <=1 & lambda_mat(:,5) >= 0,:,:)];
    ipmat = [ipmat; ...
        intersec_mat_6(...
        lambda_mat(:,6) <=1 & lambda_mat(:,6) >= 0,:,:)];
    ipmat = [ipmat; ...
        intersec_mat_7(...
        lambda_mat(:,7) <=1 & lambda_mat(:,7) >= 0,:,:)];
    ipmat = [ipmat; ...
        intersec_mat_8(...
        lambda_mat(:,8) <=1 & lambda_mat(:,8) >= 0,:,:)];
    ipmat = [ipmat; ...
        intersec_mat_9(...
        lambda_mat(:,9) <=1 & lambda_mat(:,9) >= 0,:,:)];
    
    if isempty(ipmat)
        ipmat = [];
        disp('ERROR: no intersection points founds')
    else
        % clean matrix
        ipmat = unique(ipmat,'rows');  
    end

end
