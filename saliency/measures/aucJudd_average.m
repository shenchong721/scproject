clear;
clc;

fixationPath='/home/sc/sc/saliency/data/GroundTruth_Judd1_120/origfixdata.mat';
jitter = 1;
toPlot=0;



tic 
saliencyPath1 ='/home/sc/sc/saliency/data/objectness/Judd1_120_10000c' ; 
saliencyPath2='/home/sc/sc/saliency/data/Result_Judd1_120_0.6_objectness' ; 


saveText = fopen([saliencyPath1,'.results.txt'],'wt');

ob = 0.0;
sa = 1 - ob;
while ob <=1
    sa = 1 - ob;
    s1=0;
    for img_idx = 1:120
        disp(img_idx)
        saliencyName1 = sprintf('/%d.jpg',img_idx);
        saliencyName1 = [saliencyPath1 , saliencyName1];
        saliencyMap1 = double(imread(saliencyName1));
    
        saliencyName2 = sprintf('/%d.jpg',img_idx);
        saliencyName2 = [saliencyPath2 , saliencyName2];
        saliencyMap2 = double(imread(saliencyName2));
    
        saliencyMap = ob * saliencyMap1 + sa * saliencyMap2;

        if  1
            fixationMat = load(fixationPath);
            fixationMap = fixationMat.white{img_idx};
        else
            fixationId = sprintf('/%d.jpg',img_idx);
            fixationName = [fixationPath , fixationId];
            fixationMap = double(imread(fixationName));
        end
        [score1,tp,fp,allthreshes] = AUC_Judd(saliencyMap, fixationMap, jitter, toPlot);
    
        
        s1 =s1+score1;
    end
    s1 = s1 /120
    
    fprintf(saveText,'%s%f%s%f\t%f\n','ob=',ob,'  sa=',1-ob,s1);
    ob = ob + 0.1
end

fclose(saveText);
toc
