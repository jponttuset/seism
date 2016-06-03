
database = 'SBD';
measure = 'fb';
name = 'Bharath';
cat_ids = 1:20;

if strcmp(database,'SBD'),
    for i=3:3,%length(cat_ids),
        system(['source /home/sgeadmin/BIWICELL/common/settings.sh && qsub -N evalFb'...
           name '_' num2str(cat_ids(i)) ' -t 1-130 /scratch_net/reinhold/Kevis/Software/seism/src/scripts/eval_in_cluster.py ' name ' ' database ' read_one_cont_png fb 1 101 ' num2str(cat_ids(i))])
    end
else
    system(['source /home/sgeadmin/BIWICELL/common/settings.sh && qsub -N evalFb'...
        name ' -t 1-130 /scratch_net/reinhold/Kevis/Software/seism/src/scripts/eval_in_cluster.py ' name ' ' database ' read_one_cont_png fb 1 101'])
end