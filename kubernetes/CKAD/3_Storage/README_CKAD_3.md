- [1. K8s Persistent Volume system](#1-k8s-persistent-volume-system)
- [2. Container Storage Interface (CSI)](#2-container-storage-interface-csi)
- [3. Other notes](#3-other-notes)
- [Dynamic provisioning](#dynamic-provisioning)

[Training repository](https://github.com/nigelpoulton/ps-vols-and-pods)

# 1. K8s Persistent Volume system

- K8s has plugin for storage
  - Every storage system that wants to get used by K8s needs a plugin for K8s
- K8s uses objects to manage storage
  - Persistent volume is used to map external storage to K8s storage 
  - PV is used by pod via PVC
  - Once a pod claims a PV using a PVC, no other pod can use the PV.
    - All contains within the pod can use the PV
    - Also see `accessMode`
- PV: 1-to-1 mapping to actual storage 
- PCV: Gets you the PV
- StorageClass: 

# 2. Container Storage Interface (CSI)

- Storage used to be "in-tree" (storage system access was inside K8s code base)
  - Pro: easy at beginning
  - Cons: shitty, because K8s people has to maintain storage code
- Solution: CSI
  - Not specific to K8s
    - See [K8s CSI implementation](https://github.com/kubernetes-csi)
  - CSI is a definition how to create plugins for ANY container orchestrator


# 3. Other notes

- If do not need a PV anymore, you can delete the PVC. Depending on your `persistentVolumeReclaimPolicy` the data in the PV will be `retain`ed or `delete`ed.


# Dynamic provisioning

- Create volumes automatically 
- Create different types/classes of volumes
- The Storage class (sc) operator will create volumes on demand
- SC are immutable objects. If you want to change them you have to delete and recreate them


