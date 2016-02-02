database = 'BSDS500';
im_ids = db_ids(database,'val');

% Check extreme case, where we know that recall is almost 1
part = read_one_ucm(fullfile(seism_root,'datasets',database,'MCG'), '0.01', im_ids{1});
gt = db_gt(database,im_ids{1});
value = eval_segm(part,gt,'fb') %#ok<NOPTS,NASGU>

% Check extreme case, where we know that recall is almost 1
cont = read_one_cont_png(fullfile(seism_root,'datasets',database,'HED'), '0.01', im_ids{1});
gt = db_gt(database,im_ids{1});
value = eval_cont(cont,gt) %#ok<NOPTS>
