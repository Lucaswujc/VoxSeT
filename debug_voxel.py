#!/usr/bin/env python3
"""
Debug script to isolate the VoxelGenerator issue
"""

import numpy as np

def test_point2voxel_cpu3d():
    """Test Point2VoxelCPU3d with different parameter combinations"""
    
    try:
        from spconv.utils import Point2VoxelCPU3d
        print("✓ Successfully imported Point2VoxelCPU3d")
    except Exception as e:
        print(f"✗ Failed to import Point2VoxelCPU3d: {e}")
        return
    
    # Test parameters
    vsize_xyz = [0.32, 0.32, 4.0]
    coors_range_xyz = [0.0, -39.68, -3.0, 69.12, 39.68, 1.0]
    num_point_features = 4
    
    # Test different parameter combinations
    test_cases = [
        {"max_num_points_per_voxel": 5, "max_num_voxels": 1000, "name": "Small safe"},
        {"max_num_points_per_voxel": 32, "max_num_voxels": 8000, "name": "Medium"},
        {"max_num_points_per_voxel": 64, "max_num_voxels": 16000, "name": "Large"},
        {"max_num_points_per_voxel": -1, "max_num_voxels": 16000, "name": "Dynamic (-1)"},
    ]
    
    for i, case in enumerate(test_cases):
        print(f"\n{i+1}. Testing {case['name']}:")
        print(f"   max_num_points_per_voxel: {case['max_num_points_per_voxel']}")
        print(f"   max_num_voxels: {case['max_num_voxels']}")
        
        try:
            voxel_gen = Point2VoxelCPU3d(
                vsize_xyz=vsize_xyz,
                coors_range_xyz=coors_range_xyz,
                num_point_features=num_point_features,
                max_num_points_per_voxel=case['max_num_points_per_voxel'],
                max_num_voxels=case['max_num_voxels']
            )
            print(f"   ✓ SUCCESS - VoxelGenerator created")
            
            # Test with small point cloud
            test_points = np.random.rand(100, 4).astype(np.float32)
            test_points[:, :3] = test_points[:, :3] * [69.12, 79.36, 4.0] + [0, -39.68, -3]
            
            result = voxel_gen.point_to_voxel(test_points)
            print(f"   ✓ point_to_voxel() worked")
            
        except Exception as e:
            print(f"   ✗ FAILED - {type(e).__name__}: {e}")
            if "bad_alloc" in str(e):
                print(f"   → This is the std::bad_alloc error!")

def test_parameter_types():
    """Test if parameter types matter"""
    from spconv.utils import Point2VoxelCPU3d
    
    print("\nTesting parameter types:")
    
    # Test with different types
    vsize_xyz_list = [0.32, 0.32, 4.0]  # list
    vsize_xyz_array = np.array([0.32, 0.32, 4.0], dtype=np.float32)  # numpy array
    
    coors_range_list = [0.0, -39.68, -3.0, 69.12, 39.68, 1.0]  # list  
    coors_range_array = np.array([0.0, -39.68, -3.0, 69.12, 39.68, 1.0], dtype=np.float32)  # numpy array
    
    combinations = [
        ("list, list", vsize_xyz_list, coors_range_list),
        ("array, array", vsize_xyz_array, coors_range_array),
        ("list, array", vsize_xyz_list, coors_range_array),
        ("array, list", vsize_xyz_array, coors_range_list),
    ]
    
    for name, vsize, crange in combinations:
        try:
            print(f"  {name}: ", end="")
            voxel_gen = Point2VoxelCPU3d(
                vsize_xyz=vsize,
                coors_range_xyz=crange,
                num_point_features=4,
                max_num_points_per_voxel=32,
                max_num_voxels=1000
            )
            print("✓ SUCCESS")
        except Exception as e:
            print(f"✗ FAILED - {e}")

if __name__ == "__main__":
    print("=== Debugging Point2VoxelCPU3d ===")
    test_point2voxel_cpu3d()
    test_parameter_types()
