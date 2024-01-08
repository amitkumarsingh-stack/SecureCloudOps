## ArgoCD
### What is GitOps?
GitOps is a methodology for managing and deploying applications in Kubernetes using Git as the single source of truth for the desired state of the system. ArgoCD is one of the popular tools that implements the GitOps workflow in Kubernetes.

### Features
Here's how GitOps works with ArgoCD:

1. **Declarative Configuration**: With GitOps, the desired state of the applications, including configurations, manifests, and other resources, is stored in a Git repository. This repository serves as the source of truth.

2. **Continuous Synchronization**: ArgoCD continuously monitors the Git repository for changes. When changes are detected (such as updates to configuration files or manifests), ArgoCD automatically reconciles the actual cluster state with the desired state defined in the repository.

3. **Automated Deployment**: Any changes made to the Git repository trigger an automated deployment process by ArgoCD. It ensures that the applications running in the Kubernetes cluster match the desired state described in the Git repository.

4. **Observability and Rollbacks**: ArgoCD provides visibility into the state of applications deployed in the cluster through its user interface. Additionally, it supports rollback capabilities, allowing users to revert to a previously known good state in case of issues or errors.

5. **Multi-Environment Support**: GitOps with ArgoCD enables managing multiple environments (e.g., development, staging, production) using Git branches or directories within the repository, allowing for consistent deployments across different environments.

Overall, GitOps using ArgoCD streamlines and automates the deployment and management of Kubernetes applications by leveraging Git as the central control plane, enabling teams to maintain a consistent and auditable deployment process while promoting collaboration through version control.

## Architecture Overview
![Alt text](/_Docs/ArgoCD/images/ArgoCD_Architecture.png)

## Installation

### Prerequisites

- Kubernetes cluster (minikube, AKS, EKS, GKE, etc.)
- `kubectl` CLI installed and configured to connect to your Kubernetes cluster.

### Install ArgoCD using kubectl

1. Apply ArgoCD manifests to your cluster:

    ```bash
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/<VERSION>/manifests/install.yaml
    ```

    Replace `<VERSION>` with the desired ArgoCD version.

2. Access the ArgoCD web UI using port forwarding:

    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```

    Open your browser and navigate to `https://localhost:8080`. Login with the default credentials (`admin`/`password`).

## Usage

### Adding Applications

1. Log in to the ArgoCD UI.
2. Click on `New App` and provide the Git repository URL and other application details.
3. Configure the sync policy, including the sync strategy, automated sync frequency, and destination cluster details.
4. ArgoCD will start syncing the application state as per the defined configuration in the Git repository.

### Monitoring Applications

- View the deployed applications and their statuses in the ArgoCD UI.
- Check sync status, health, and history of applications.

### Continuous Deployment

- Make changes to the application manifests in the Git repository.
- ArgoCD will automatically detect changes and trigger the sync process to apply the updates to the Kubernetes cluster.

## Contributing

We welcome contributions! Please feel free to raise issues or submit pull requests for any enhancements or bug fixes.

## Resources

- [ArgoCD Documentation](https://argoproj.github.io/argo-cd/)
- [GitHub Repository](https://github.com/argoproj/argo-cd)

## License

This project is licensed under the [Apache License 2.0](LICENSE).
