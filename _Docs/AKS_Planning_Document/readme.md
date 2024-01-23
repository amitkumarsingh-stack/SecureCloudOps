## Kubernetes Planning Document: Navigating the Path to Scalable and Resilient Container Orchestration

### Introduction
This guide, the Kubernetes Planning Document, functions as your guiding tool, navigating you through the complexities of managing applications in containers using Kubernetes. Whether you're starting a new Kubernetes setup or aiming to enhance your current deployment, this document equips you to make well-informed choices, tackle challenges effectively, and unleash the complete capabilities of container orchestration.

### What is Azure Kubernetes Service
Azure Kubernetes Service (AKS) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance. When you create an AKS cluster, a control plane is automatically created and configured. This control plane is provided at no cost as a managed Azure resource abstracted from the user. You only pay for and manage the nodes attached to the AKS cluster.

## Design checklist

### 1. Networking
#### Choose the best CNI network plugin for your requirment
Kubernetes networking enables you to configure communication within your k8s network. When deploying a AKS cluster, there are three networking models to consider:

* **Kubenet networking**
* **Azure Container Networking Interface (CNI) networking**
* **Azure Container Networking Interface (CNI)- Overlay networking**

A. **Kubenet Networking**
![Alt text](/_Docs/AKS_Planning_Document/images/kubenet.png)
* Kubenet is a very basic, simple network plugin, on Linux only.
* Nodes receive an IP address from the Azure virtual network subnet.
* Pods receive an IP address from a logically different address space than the nodes’ Azure virtual network subnet.
* Network address translation (NAT) is then configured so that the pods can reach resources on the Azure virtual network.
* The source IP address of the traffic is translated to the node’s primary IP address.

This approach reduces the number of IP addresses you need to reserve in your network space for pods to use.
![image](https://github.com/amitkumarsingh-stack/SecureCloudOps/assets/152581728/71f0da4a-9bb4-47e0-b3bb-d178a3dd5e78)


```
By default, AKS clusters use kubenet, and an Azure virtual network and subnet are created for you.
```
* Azure automatically provisions and configures virtual network resources for AKS clusters. The VNet and subnet are created in a dedicated resource group, automatically generated in your subscription by the Azure resource provider. By default, the AKS node resource group is named ```MC_resourcegroupname_clustername_location```.
* We can manually create and configure the virtual network resources and attach to those resources when we create our AKS cluster. We can configure our Vnet and subnet at the time of the AKS creation.

### 2. Resource Management
#### Sizing of Nodes: 
what type of worker nodes should I use, and how many of them is a critical question which requires the analysis of the workloads deployed on your cluster to get the best values of it

Choosing the right worker node size for your Kubernetes cluster is a crucial decision that depends on various factors such as workload characteristics, performance requirements, and budget constraints. Here are some considerations to help you determine the appropriate worker node size:

1. **Workload Characteristics**:

* **CPU Intensive**: If your applications are CPU-intensive (e.g., data processing, analytics), choose worker nodes with higher CPU resources.
* **Memory Intensive**: For memory-intensive workloads (e.g., in-memory databases), prioritize worker nodes with more RAM.

2. **Pod Resource Requirements**:

* Understand the resource requirements of your pods. If your pods have specific CPU or memory constraints, make sure the worker nodes can meet those requirements.

3. **Horizontal Pod Autoscaling (HPA)**:

* If you plan to use Horizontal Pod Autoscaling, consider smaller-sized nodes, as the cluster can dynamically scale by adding more nodes when needed.

4. **Node Pools**:

* Consider creating multiple node pools with different sizes to accommodate diverse workloads. You can have smaller nodes for certain tasks and larger nodes for others.

5. **Budget Constraints**:

* Your budget is a significant factor. Larger nodes may offer better performance but could be more expensive. Choose a balance between performance and cost that aligns with your financial constraints.

6. **Node Overhead**:

* Factor in the overhead associated with each node (e.g., operating system, Kubernetes components). Smaller nodes may have a higher overhead per unit of resources.

7. **Scalability**:

* Consider the scalability requirements of your application. If you anticipate rapid growth, choose a node size that allows easy scaling by adding more nodes.

8. **Node Customization**:

* Some cloud providers allow you to customize the configuration of your worker nodes. Take advantage of this feature to tailor nodes to your specific requirements.

9. **Reserved Instances or Spot Instances**:

* Depending on your workload's sensitivity to node termination, consider using reserved instances for stability or spot instances for cost savings (if your cloud provider supports them).

10. **Monitoring and Optimization**:

* Regularly monitor your cluster's performance and adjust node sizes accordingly. Kubernetes provides tools like Prometheus for monitoring.

11. **Networking Considerations**:

* Consider the networking capabilities of your worker nodes, especially if your application relies heavily on network communication. Ensure that the chosen nodes have adequate bandwidth.

12. **Storage Requirements**:

* If your application requires significant storage, choose nodes with appropriate storage capacity and performance characteristics.

Let's summarize the pros and cons of the two options for sizing Kubernetes worker nodes and provide some guidance:

**Option 1**: Fewer, Larger Nodes

**Pros**:

- Suitable for CPU or RAM-intensive applications, ensuring each application has sufficient resources.
- Simplifies resource management and maintenance with fewer nodes.
**Cons**:

- High availability is challenging to achieve with a minimal set of nodes.
- If a node goes down, a significant portion of the service capacity is lost.
Larger increment size when autoscaling, potentially leading to over-provisioning.

**Guidance**:

- Ideal for applications with high resource demands.
- Consider the trade-off between high resource availability and potential service impact during node failures.

**Option 2**: More, Smaller Nodes

**Pros**:

- Easier to maintain high availability as there are more nodes.
- Service capacity impact is lower if a node goes down.
- Allows for finer-grained scaling, reducing the risk of over-provisioning.

**Cons**:

- More system overhead to manage and maintain multiple nodes.
- Possibility of under-utilization if nodes are too small for certain services.

**Guidance**:

- Preferable for production deployments where high availability is crucial.
- Consider the trade-off between system overhead and better resource utilization.

**Example Service using 3 Pods per Node**
* Each pod requires 2 CPU and 4GB RAM.
* Minimum node requirement: 6 CPU, 12 GB RAM (for 3 pods).
* Add 10% for system overhead.
* Select Azure VM SKU which provides 8 CPU / 16 GB RAM that might be suitable.

**To Determine Base Number of Nodes**:

* Divide the total number of pods by 3 (number of pods per node) to determine the minimum cluster size.
* Implement horizontal auto-scaling to dynamically adjust the cluster size based on demand.
Guidance:

* Tailor your node sizing to the specific resource requirements of your pods.
* Follow cloud provider guidelines and best practices for optimal performance.

