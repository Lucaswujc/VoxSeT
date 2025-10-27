1. installation may take a couple of tries. The main complication here is that the newer version of pytorch is not compabiel with this code. Hence there is a diff file provided which modified about 10 cpp files to resolve the cuda version difference
2. dynamic voxel allocation is buggy in the spconv, data_processor.py file is modified to resolve the spconv2 issue. 
3. spconv2 also introdce error in voxet.py file, this is also resolved 
4. evaluation result is pasted in 100_epoc_eval.txt
5. tools/cfgs/dataset_configs/kitti_dataset.yaml is modified to reflect the data path. 
