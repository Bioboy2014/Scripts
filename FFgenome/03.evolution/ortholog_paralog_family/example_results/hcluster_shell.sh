perl /share/raid6/fanw/GACP/GACP-5.0/software/solar/solar.pl -a prot2prot -f m8 -z ./all_vs_all.blast.m8 > ./all_vs_all.blast.m8.solar; perl /share/raid6/fanw/GACP/GACP-7.0/06.evolution_analysis/ortholog_paralog_family/bin/bitScore_to_hclusterScore.pl  ./all_vs_all.blast.m8.solar > ./all_vs_all.blast.m8.solar.forHC 2> ./all_vs_all.blast.m8.solar.forHC.warn; perl /share/raid6/fanw/GACP/GACP-7.0/06.evolution_analysis/ortholog_paralog_family/bin/draw_score_distribution.pl ./all_vs_all.blast.m8.solar.forHC; /share/raid6/fanw/GACP/GACP-5.0/software/hcluster_sg/hcluster_sg -w 0 -s 0.34 -m 500 -b 0.1 -C ./category.txt.genes ./all_vs_all.blast.m8.solar.forHC > ./all_vs_all.blast.m8.solar.forHC.hcluster ; 
