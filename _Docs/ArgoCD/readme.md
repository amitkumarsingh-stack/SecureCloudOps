# ArgoCD

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes applications. It helps in managing and automating the deployment of applications within Kubernetes clusters.

## Features

- **Declarative Configuration**: Define the desired application state declaratively in Git.
- **Automated Sync**: Automatically monitors and syncs application state with the defined configuration in Git repositories.
- **Multi-Environment Support**: Manages multiple environments (dev, staging, production) using the same workflow.
- **Rollback Capability**: Provides the ability to rollback to a previous version or state of an application.
- **RBAC Integration**: Integrates with Kubernetes RBAC for access control and security.

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

