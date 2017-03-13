clear;
clc;

fixationPath='/home/sc/sc/saliency/data/GroundTruth_Judd1_120/origfixdata.mat';
jitter = 1;
toPlot=0;


tic 
saliencyPath1='/home/sc/sc/saliency/data/Result_Judd1_120_0.6_objectness' ; 
s1=0;

saveText = fopen([saliencyPath1,'/results.txt'],'wt');

for img_idx = 1:120
    disp(img_idx)
    saliencyName = sprintf('/%d.jpg',img_idx);
    saliencyName1 = [saliencyPath1 , saliencyName];
    saliencyMap1 = double(imread(saliencyName1));

    if  1
        fixationMat = load(fixationPath);
        fixationMap = fixationMat.white{img_idx};
    else
        fixationId = sprintf('/%d.jpg',img_idx);
        fixationName = [fixationPath , fixationId];
        fixationMap = double(imread(fixationName));
    end
    [score1,tp,fp,allthreshes] = AUC_Judd(saliencyMap1, fixationMap, jitter, toPlot);
    
    fprintf(saveText,'%d\t%f\n',img_idx,score1);
    s1 =s1+score1;
end
s1 = s1 /120
fprintf(saveText,'%s\t%f\n','average',s1);
fclose(saveText);
toc
